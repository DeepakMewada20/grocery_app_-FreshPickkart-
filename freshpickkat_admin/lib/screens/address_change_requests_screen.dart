import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/controller/admin_complaint_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';
import 'package:freshpickkat_admin/widgets/admin_state_view.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressChangeRequestsScreen extends StatefulWidget {
  const AddressChangeRequestsScreen({super.key});

  @override
  State<AddressChangeRequestsScreen> createState() =>
      _AddressChangeRequestsScreenState();
}

class _AddressChangeRequestsScreenState extends State<AddressChangeRequestsScreen> {
  late final AdminComplaintController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<AdminComplaintController>(tag: 'address_change_requests')
        ? Get.find<AdminComplaintController>(tag: 'address_change_requests')
        : Get.put(AdminComplaintController(), tag: 'address_change_requests');
    _controller.load(
      status: 'Pending',
      issueType: 'Delivery Location Issue',
      selectedField: 'address_change',
      complaintType: 'delivery',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: const Text('Address Change Requests')),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final error = _controller.error.value;
        if (error != null) {
          return AdminStateView.error(
            message: error,
            onRetry: () => _controller.load(
              status: 'Pending',
              issueType: 'Delivery Location Issue',
              selectedField: 'address_change',
              complaintType: 'delivery',
            ),
          );
        }
        if (_controller.complaints.isEmpty) {
          return AdminStateView.empty(
            title: 'No address change requests',
            message: 'Pending requests will appear here.',
            onRefresh: () => _controller.load(
              status: 'Pending',
              issueType: 'Delivery Location Issue',
              selectedField: 'address_change',
              complaintType: 'delivery',
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => _controller.load(
            status: 'Pending',
            issueType: 'Delivery Location Issue',
            selectedField: 'address_change',
            complaintType: 'delivery',
          ),
          child: ListView.separated(
            padding: AdminResponsive.pagePadding(context).copyWith(
              bottom: 24.h + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: _controller.complaints.length +
                (_controller.hasMore.value ? 1 : 0),
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
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
              return _AddressChangeCard(
                complaint: complaint,
                controller: _controller,
              );
            },
          ),
        );
      }),
    );
  }
}

class _AddressChangeCard extends StatelessWidget {
  const _AddressChangeCard({required this.complaint, required this.controller});

  final Complaint complaint;
  final AdminComplaintController controller;

  @override
  Widget build(BuildContext context) {
    final extra = complaint.extraData ?? const {};
    final oldAddress = _parseAddress(extra['currentAddressJson']);
    final newAddress = _parseAddress(extra['requestedAddressJson']);
    final reason = complaint.description;
    final requestTime = _formatDate(complaint.createdAt);
    final distance = _distanceLabel(oldAddress, newAddress);
    final phone = complaint.userPhone.trim();
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${complaint.orderNumber}',
                        style: AdminTextStyles.cardTitle(context),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Requested at $requestTime',
                        style: AdminTextStyles.caption(context),
                      ),
                    ],
                  ),
                ),
                _StatusPill(status: complaint.status),
              ],
            ),
            SizedBox(height: 14.h),
            _InfoRow('Old address', oldAddress != null ? _addressText(oldAddress) : 'Unavailable'),
            _InfoRow('New address', newAddress != null ? _addressText(newAddress) : 'Unavailable'),
            if (distance != null) _InfoRow('Distance', distance),
            _InfoRow('Reason', reason),
            if (complaint.adminNote?.trim().isNotEmpty == true)
              _InfoRow('Admin note', complaint.adminNote!),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _approve(context),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Approve'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _reject(context),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Reject'),
                ),
                OutlinedButton.icon(
                  onPressed: phone.isEmpty
                      ? null
                      : () async {
                          try {
                            await _callCustomer(phone);
                          } catch (error) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())),
                            );
                          }
                        },
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Call Customer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _approve(BuildContext context) async {
    final note = await _askNote(
      context,
      title: 'Approve request',
      label: 'Optional admin note',
    );
    if (note == null) return;
    try {
      await controller.updateStatus(
        complaint,
        'Resolved',
        adminNote: note.trim().isEmpty ? null : note.trim(),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request approved')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _reject(BuildContext context) async {
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
    if (!context.mounted) return;
    final note = await _askNote(
      context,
      title: 'Rejection note',
      label: 'Optional details',
      initialValue: selected,
    );
    if (note == null) return;
    try {
      await controller.rejectComplaint(
        complaint,
        adminNote: note.trim().isEmpty ? selected : note.trim(),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request rejected')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<String?> _askNote(
    BuildContext context, {
    required String title,
    required String label,
    String? initialValue,
  }) async {
    final controller = TextEditingController(text: initialValue ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _callCustomer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch dialer');
    }
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

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}-${local.year}';
  }


}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: AdminTextStyles.caption(context).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Resolved' => Colors.green,
      'Rejected' => Colors.red,
      'Under Review' => Colors.blue,
      _ => Colors.orange,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
