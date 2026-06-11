import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/services/product_complaint_service.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';

class ComplaintDetailScreen extends StatefulWidget {
  const ComplaintDetailScreen({
    super.key,
    this.complaint,
    this.complaintId,
  });

  final Complaint? complaint;
  final String? complaintId;

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  Complaint? _complaint;
  bool _isLoading = false;
  String? _error;
  RefundRecord? _complaintRefund;

  @override
  void initState() {
    super.initState();
    _complaint = widget.complaint;
    if (_complaint != null) {
      _loadHydrated(_complaint!.complaintId);
    }
    if (_complaint == null && widget.complaintId != null) {
      _fetch();
    }
  }

  Future<void> _loadHydrated(String complaintId) async {
    try {
      final client = ServerpodClient().client;
      final user = AuthController.instance.currentUser;
      if (user == null) return;
      final idToken = await AuthController.instance.requireIdToken();
      final hydrated = await client.complaint.getUserComplaintDetailHydrated(
        firebaseUid: user.uid,
        idToken: idToken,
        complaintId: complaintId,
      );
      if (mounted) {
        setState(() {
          _complaint = hydrated.complaint;
          _complaintRefund = hydrated.refund;
        });
      }
    } catch (e) {
      AppLogger.error('ComplaintDetail', 'Hydrated: $e');
      _maybeLoadRefund(_complaint!);
    }
  }

  void _maybeLoadRefund(Complaint c) {
    // kept as fallback — no longer needed for hydrated path
  }

  Future<void> _fetch() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final complaint = await ProductComplaintService.instance.getMyComplaint(
        widget.complaintId!,
      );
      setState(() {
        _complaint = complaint;
        _error = complaint == null ? ErrorMessages.complaintNotFound : null;
      });
      if (complaint != null) _maybeLoadRefund(complaint);
    } catch (error) {
      AppLogger.error('ComplaintDetail', error);
      setState(() => _error = ErrorMessages.loadComplaintsFailed);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Complaint Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _complaint == null
          ? const Center(child: Text('Complaint not found'))
          : RefreshIndicator(
              onRefresh: _fetch,
              child: ListView(
                padding: AppResponsive.pagePadding(context).copyWith(
                  bottom: 24.h + MediaQuery.paddingOf(context).bottom,
                ),
                children: [
                  AppResponsive.constrainContent(
                    context: context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProductSummary(complaint: _complaint!),
                        SizedBox(height: 12.h),
                        _Section(
                          title: 'Issue',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _StatusBadge(status: _complaint!.status),
                              SizedBox(height: 10.h),
                              Text(
                                _complaint!.issueType,
                                style: TextStyle(
                                  color: cs.onSurface,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(_complaint!.description),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (_complaint!.resolutionType != null &&
                            _complaint!.status == 'Resolved') ...[
                          _Section(
                            title: 'Resolution',
                            child: Text(_complaint!.resolutionType!),
                          ),
                          SizedBox(height: 12.h),
                        ],
                        if (_complaint!.selectedField != null ||
                            (_complaint!.extraData?.isNotEmpty ?? false))
                          ...[
                            _AddressChangeSection(complaint: _complaint!),
                            SizedBox(height: 12.h),
                          ],
                        _ImageSection(urls: _complaint!.imageUrls),
                        SizedBox(height: 12.h),
                        _Section(
                          title: 'Reply',
                          child: Text(
                            _complaint!.adminReply?.trim().isNotEmpty == true
                                ? _complaint!.adminReply!
                                : _complaint!.adminNote?.trim().isNotEmpty == true
                                    ? _complaint!.adminNote!
                                    : 'No reply yet.',
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _Timeline(status: _complaint!.status),
                        if (_complaintRefund != null) ...[
                          SizedBox(height: 12.h),
                          _RefundInfoCard(refund: _complaintRefund!),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ProductSummary extends StatelessWidget {
  const _ProductSummary({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Order #${complaint.orderNumber}',
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              (complaint.productImage ?? ''),
              width: 58.r,
              height: 58.r,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              (complaint.productName ?? complaint.title),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressChangeSection extends StatelessWidget {
  const _AddressChangeSection({required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    final extra = complaint.extraData ?? const {};
    final requestedAddress = _parseAddress(extra['requestedAddressJson']);
    final currentAddress = _parseAddress(extra['currentAddressJson']);
    final requestedNote = extra['requestedNote']?.trim();
    final selectedField = complaint.selectedField ?? 'delivery_location_issue';

    return _Section(
      title: 'Delivery Change Request',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoLine('Selected field', selectedField),
          if (currentAddress != null) ...[
            SizedBox(height: 8.h),
            _AddressBlock(title: 'Current address', address: currentAddress),
          ],
          if (requestedAddress != null) ...[
            SizedBox(height: 8.h),
            _AddressBlock(title: 'Requested address', address: requestedAddress),
          ],
          if (requestedNote != null && requestedNote.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _InfoLine('Requested note', requestedNote),
          ],
          if (extra['reason']?.trim().isNotEmpty == true) ...[
            SizedBox(height: 8.h),
            _InfoLine('Reason', extra['reason']!),
          ],
        ],
      ),
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
    } catch (e) {
      AppLogger.warning('ComplaintDetail', 'JSON decode error: $e');
    }
    return null;
  }
}

class _AddressBlock extends StatelessWidget {
  const _AddressBlock({required this.title, required this.address});

  final String title;
  final Address address;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          SizedBox(height: 6.h),
          Text(_addressText(address)),
        ],
      ),
    );
  }

  String _addressText(Address address) {
    return [
      address.street,
      address.city,
      address.state,
      address.zipCode,
      address.country,
    ].where((part) => part.trim().isNotEmpty).join(', ');
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Images',
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: urls
            .map(
              (url) => ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(
                  url,
                  width: 86.r,
                  height: 86.r,
                  fit: BoxFit.cover,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Complaint Created',
      'Under Review',
      if (status == 'Rejected') 'Rejected' else 'Resolved',
    ];
    final active = status == 'Pending'
        ? 0
        : status == 'Under Review'
        ? 1
        : 2;
    return _Section(
      title: 'Timeline',
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                i <= active ? Icons.check_circle : Icons.radio_button_unchecked,
                color: i <= active ? Colors.green : Colors.grey,
              ),
              title: Text(steps[i]),
            ),
        ],
      ),
    );
  }
}

class _RefundInfoCard extends StatelessWidget {
  const _RefundInfoCard({required this.refund});

  final RefundRecord refund;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processed':
      case 'refunded':
        return Colors.green;
      case 'pending':
      case 'initiated':
        return Colors.orange;
      case 'failed':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'processed':
      case 'refunded':
        return 'Completed';
      case 'pending':
      case 'initiated':
        return 'Initiated';
      case 'failed':
        return 'Failed';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusColor = _statusColor(refund.status);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Refund Information',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _refundRow('Status', _statusLabel(refund.status), statusColor, context),
          SizedBox(height: 8.h),
          _refundRow('Amount', '₹${refund.amount.toStringAsFixed(2)}', null, context),
          SizedBox(height: 8.h),
          _refundRow('Refund ID', refund.refundId, null, context),
          SizedBox(height: 8.h),
          _refundRow('Initiated', _formatDate(refund.createdAt), null, context),
          SizedBox(height: 8.h),
          _refundRow('Expected', '2–5 Business Days', null, context),
        ],
      ),
    );
  }

  Widget _refundRow(String label, String value, Color? valueColor, BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.62),
              fontSize: 12.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor ?? cs.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day.toString().padLeft(2, '0')}-${local.month.toString().padLeft(2, '0')}-${local.year}';
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Resolved' => Colors.green,
      'Rejected' => Colors.redAccent,
      'Under Review' => Colors.blue,
      _ => Colors.orange,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
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
