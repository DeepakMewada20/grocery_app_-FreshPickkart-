import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_complaint_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_admin/widgets/order_details_card.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintManagementScreen extends StatefulWidget {
  const ComplaintManagementScreen({super.key});

  @override
  State<ComplaintManagementScreen> createState() =>
      _ComplaintManagementScreenState();
}

class _ComplaintManagementScreenState extends State<ComplaintManagementScreen>
    with SingleTickerProviderStateMixin {
  static const _statuses = ['Pending', 'Under Review', 'Resolved', 'Rejected'];

  late final TabController _tabController;
  late final AdminComplaintController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<AdminComplaintController>(tag: 'complaint_management')
        ? Get.find<AdminComplaintController>(tag: 'complaint_management')
        : Get.put(AdminComplaintController(), tag: 'complaint_management');
    _tabController = TabController(length: _statuses.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.load(status: _statuses[_tabController.index]);
      }
    });
    _controller.load(status: _statuses.first);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Complaint Management'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(
            context,
          ).colorScheme.onPrimary.withValues(alpha: 0.6),
          tabs: _statuses.map((status) => Tab(text: status)).toList(),
        ),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = _controller.error.value;
        if (error != null) {
          return AdminStateView.error(
            message: error,
            onRetry: () => _controller.load(status: _controller.statusFilter),
          );
        }
        if (_controller.complaints.isEmpty) {
          return AdminStateView.empty(
            title: 'No complaints',
            message: 'No ${(_controller.statusFilter ?? 'pending').toLowerCase()} complaints.',
            onRefresh: () => _controller.load(status: _controller.statusFilter),
          );
        }
        return RefreshIndicator(
          onRefresh: () => _controller.load(status: _controller.statusFilter),
          child: ListView.separated(
            padding: AdminResponsive.pagePadding(context),
            itemCount: _controller.complaints.length +
                (_controller.hasMore.value ? 1 : 0),
            separatorBuilder: (_, _) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              if (index >= _controller.complaints.length) {
                return Center(
                  child: OutlinedButton(
                    onPressed: _controller.isLoadingMore.value
                        ? null
                        : _controller.loadMore,
                    child: Text(
                      _controller.isLoadingMore.value ? 'Loading...' : 'Load more',
                    ),
                  ),
                );
              }
              final complaint = _controller.complaints[index];
              return _ComplaintCard(
                complaint: complaint,
                onTap: () async {
                      await Get.to(
                        () => _ComplaintDetailAdminScreen(
                          complaint: complaint,
                          controller: _controller,
                        ),
                  );
                  if (mounted) _controller.load(status: _controller.statusFilter);
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class _ComplaintDetailAdminScreen extends StatefulWidget {
  const _ComplaintDetailAdminScreen({
    required this.complaint,
    required this.controller,
  });

  final Complaint complaint;
  final AdminComplaintController controller;

  @override
  State<_ComplaintDetailAdminScreen> createState() =>
      _ComplaintDetailAdminScreenState();
}

class _ComplaintDetailAdminScreenState
    extends State<_ComplaintDetailAdminScreen> {
  late Complaint _complaint;
  final _noteController = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _complaint = widget.complaint;
    _noteController.text = _complaint.adminNote ?? '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isProduct = _complaint.complaintType == 'product';
    final isAddressChange = _complaint.selectedField == 'address_change';
    return Scaffold(
      appBar: AdminAppBar(
        title: Text('Complaint #${_shortId(_complaint.complaintId)}'),
      ),
      body: ListView(
        padding: AdminResponsive.pagePadding(context).copyWith(bottom: 28.h),
        children: [
          AdminResponsive.constrainContent(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoPanel(
                  children: [
                    _InfoRow('Complaint ID', _complaint.complaintId),
                    _InfoRow('Order ID', _complaint.orderNumber),
                    _InfoRow('Type', _complaint.complaintType.toUpperCase()),
                    _InfoRow('Status', _complaint.status),
                    _InfoRow('Resolution', _complaint.resolutionType ?? 'None'),
                    if (_complaint.userPhone.trim().isNotEmpty)
                      _InfoRow('Customer phone', _complaint.userPhone),
                  ],
                ),
                SizedBox(height: 12.h),
                OrderDetailsCard(complaint: _complaint),
                SizedBox(height: 12.h),
                _InfoPanel(
                  title: _complaint.title,
                  children: [
                    Text(_complaint.description),
                    if (_complaint.adminNote?.trim().isNotEmpty == true) ...[
                      SizedBox(height: 12.h),
                      Text(
                        'Admin note',
                        style: AdminTextStyles.sectionTitle(context),
                      ),
                      SizedBox(height: 6.h),
                      Text(_complaint.adminNote!),
                    ],
                  ],
                ),
                SizedBox(height: 12.h),
                if (isAddressChange)
                  _AddressChangeDetails(complaint: _complaint),
                if (isAddressChange) SizedBox(height: 12.h),
                if (isProduct)
                  _AffectedProducts(products: _complaint.selectedProducts),
                if (isProduct) SizedBox(height: 12.h),
                _ImageGrid(urls: _complaint.imageUrls),
                SizedBox(height: 12.h),
                _InfoPanel(
                  title: 'Quick Actions',
                  children: [
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _complaint.userPhone.trim().isEmpty
                              ? null
                              : () => _callCustomer(_complaint.userPhone),
                          icon: const Icon(Icons.call_outlined),
                          label: const Text('Call'),
                        ),
                        OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('WhatsApp'),
                        ),
                        OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.email_outlined),
                          label: const Text('Email'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: _complaint.orderNumber),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Order ID copied')),
                            );
                          },
                          icon: const Icon(Icons.copy_outlined),
                          label: const Text('Copy Order'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _InfoPanel(
                  title: 'Admin Note',
                  children: [
                    TextField(
                      controller: _noteController,
                      minLines: 3,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                if (_complaint.status != 'Resolved' &&
                    _complaint.status != 'Rejected')
                  _InfoPanel(
                    title: 'Resolution Actions',
                    children: [
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: isAddressChange
                            ? [
                                ElevatedButton(
                                  onPressed: _busy ? null : _approveAddressChange,
                                  child: const Text('Approve'),
                                ),
                                OutlinedButton(
                                  onPressed: _busy ? null : _rejectAddressChange,
                                  child: const Text('Reject'),
                                ),
                              ]
                            : isProduct
                            ? [
                                ElevatedButton(
                                  onPressed: _busy
                                      ? null
                                      : () => _refund(partial: false),
                                  child: const Text('Refund'),
                                ),
                                OutlinedButton(
                                  onPressed: _busy
                                      ? null
                                      : () => _refund(partial: true),
                                  child: const Text('Partial Refund'),
                                ),
                                OutlinedButton(
                                  onPressed: _busy ? null : _replacement,
                                  child: const Text('Replacement'),
                                ),
                                OutlinedButton(
                                  onPressed: _busy ? null : _reject,
                                  child: const Text('Reject'),
                                ),
                              ]
                            : [
                                ElevatedButton(
                                  onPressed: _busy ? null : _retryDelivery,
                                  child: const Text('Retry Delivery'),
                                ),
                                OutlinedButton(
                                  onPressed: _busy ? null : _reassignRider,
                                  child: const Text('Reassign Rider'),
                                ),
                                OutlinedButton(
                                  onPressed: _busy
                                      ? null
                                      : () => _refund(partial: true),
                                  child: const Text('Refund'),
                                ),
                                OutlinedButton(
                                  onPressed: _busy ? null : _reject,
                                  child: const Text('Reject'),
                                ),
                              ],
                      ),
                      if (_busy) ...[
                        SizedBox(height: 12.h),
                        LinearProgressIndicator(color: cs.primary),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _run(Future<Complaint> Function() action) async {
    setState(() => _busy = true);
    try {
      final updated = await action();
      if (mounted) setState(() => _complaint = updated);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _refund({required bool partial}) async {
    final cap = await widget.controller.calculateRefundCap(_complaint);
    final amount = partial ? await _askAmount(cap) : cap;
    if (amount == null || amount <= 0) return;
    await _run(
      () => widget.controller.refundComplaint(
        _complaint,
        amount: amount,
        adminNote: _noteController.text,
      ),
    );
  }

  Future<double?> _askAmount(double cap) async {
    final controller = TextEditingController(text: cap.toStringAsFixed(2));
    final value = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refund Amount'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Max INR ${cap.toStringAsFixed(2)}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final parsed = double.tryParse(controller.text.trim());
              Navigator.pop(context, parsed?.clamp(0, cap).toDouble());
            },
            child: const Text('Refund'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (!mounted) return null;
    return value;
  }

  Future<void> _replacement() => _run(
    () => widget.controller.createReplacementOrder(
      _complaint,
      adminNote: _noteController.text,
    ),
  );

  Future<void> _retryDelivery() => _run(
    () => widget.controller.retryDelivery(
      _complaint,
      adminNote: _noteController.text,
    ),
  );

  Future<void> _reject() => _run(
    () => widget.controller.rejectComplaint(
      _complaint,
      adminNote: _noteController.text,
    ),
  );

  Future<void> _approveAddressChange() => _run(
    () => widget.controller.updateStatus(
      _complaint,
      'Resolved',
      adminNote: _noteController.text,
    ),
  );

  Future<void> _callCustomer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch dialer');
    }
  }

  Future<void> _rejectAddressChange() async {
    const reasons = [
      'Too far',
      'Rider already nearby',
      'Delivery not possible',
      'Other',
    ];
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Reject request'),
        children: [
          for (final reason in reasons)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, reason),
              child: Text(reason),
            ),
        ],
      ),
    );
    if (selected == null) return;
    await _run(
      () => widget.controller.rejectComplaint(
        _complaint,
        adminNote: _noteController.text.trim().isEmpty
            ? selected
            : '$selected: ${_noteController.text.trim()}',
      ),
    );
  }

  Future<void> _reassignRider() async {
    final name = TextEditingController();
    final phone = TextEditingController();
    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reassign Rider'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Rider name'),
              ),
              TextField(
                controller: phone,
                decoration: const InputDecoration(labelText: 'Rider phone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Assign'),
            ),
          ],
        ),
      );
      if (result == true && mounted) {
        await _run(
          () => widget.controller.reassignRider(
            _complaint,
            riderName: name.text,
            riderPhone: phone.text,
            adminNote: _noteController.text,
          ),
        );
      }
    } finally {
      name.dispose();
      phone.dispose();
    }
  }

  String _shortId(String id) => id.length <= 8 ? id : id.substring(0, 8);
}

class _AddressChangeDetails extends StatelessWidget {
  const _AddressChangeDetails({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final extra = complaint.extraData ?? const {};
    final oldAddress = _parseAddress(extra['currentAddressJson']);
    final newAddress = _parseAddress(extra['requestedAddressJson']);
    final distance = _distanceLabel(oldAddress, newAddress);
    return _InfoPanel(
      title: 'Address Change Details',
      children: [
        _InfoRow('Selected field', complaint.selectedField ?? 'delivery_location_issue'),
        _InfoRow('Old address', oldAddress != null ? _addressText(oldAddress) : 'Unavailable'),
        _InfoRow('New address', newAddress != null ? _addressText(newAddress) : 'Unavailable'),
        if (distance != null) _InfoRow('Distance', distance),
        if (extra['requestedNote']?.trim().isNotEmpty == true)
          _InfoRow('Requested note', extra['requestedNote']!),
      ],
    );
  }

  Address? _parseAddress(String? encoded) {
    if (encoded == null || encoded.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is Map<String, dynamic>) {
        return Address.fromJson(decoded);
      }
      if (decoded is Map) {
        return Address.fromJson(decoded.map((k, v) => MapEntry('$k', v)));
      }
    } catch (_) {}
    return null;
  }

  String _addressText(Address address) => [
        address.street,
        address.city,
        address.state,
        address.zipCode,
        address.country,
      ].where((part) => part.trim().isNotEmpty).join(', ');

  String? _distanceLabel(Address? oldAddress, Address? newAddress) {
    if (oldAddress == null || newAddress == null) return null;
    final oldLat = oldAddress.latitude;
    final oldLng = oldAddress.longitude;
    final newLat = newAddress.latitude;
    final newLng = newAddress.longitude;
    if (oldLat == null || oldLng == null || newLat == null || newLng == null) {
      return null;
    }
    final meters = Geolocator.distanceBetween(oldLat, oldLng, newLat, newLng);
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}

class _ComplaintCard extends StatelessWidget {
  const _ComplaintCard({required this.complaint, required this.onTap});

  final Complaint complaint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                complaint.imageUrls.isNotEmpty
                    ? complaint.imageUrls.first
                    : (complaint.productImage ?? ''),
                width: 58.r,
                height: 58.r,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    complaint.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Order #${complaint.orderNumber} • ${complaint.complaintType} • ${complaint.issueType}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.caption(context),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Chip(label: Text(complaint.status)),
          ],
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: AdminTextStyles.sectionTitle(context)),
            SizedBox(height: 10.h),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          SizedBox(
            width: 130.w,
            child: Text(label, style: AdminTextStyles.caption(context)),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}

class _AffectedProducts extends StatelessWidget {
  const _AffectedProducts({required this.products});

  final List<ComplaintProductItem> products;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      title: 'Affected Products',
      children: [
        for (final product in products)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    product.productImage,
                    width: 36.r,
                    height: 36.r,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        Icon(Icons.image_not_supported_outlined, size: 36.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    '${product.productName} x${product.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return _InfoPanel(
      title: 'Images',
      children: urls.isEmpty
          ? [const Text('No images attached')]
          : [
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: urls
                    .map(
                      (url) => GestureDetector(
                        onTap: () => _openImagePreview(context, url),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            url,
                            width: 88.r,
                            height: 88.r,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 88.r,
                              height: 88.r,
                              color: Colors.grey.shade200,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
    );
  }

  void _openImagePreview(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: InteractiveViewer(
            minScale: 0.5,
            maxScale: 5.0,
            child: Center(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                errorBuilder: (_, _, _) => const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64),
                    SizedBox(height: 8),
                    Text('Failed to load image', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
