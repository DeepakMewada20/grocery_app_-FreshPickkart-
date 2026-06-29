import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/admin_referral_controller.dart';
import '../services/admin_snackbar_service.dart';
import '../theme/admin_app_theme.dart';
import '../widgets/admin_app_bar.dart';
import '../utils/admin_responsive.dart';
import 'user_picker_screen.dart';

class ReferralDashboardScreen extends StatefulWidget {
  const ReferralDashboardScreen({super.key});
  @override
  State<ReferralDashboardScreen> createState() => _ReferralDashboardScreenState();
}

class _ReferralDashboardScreenState extends State<ReferralDashboardScreen> {
  final _controller = AdminReferralController.instance;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    _controller.loadAnalytics();
    _controller.loadReferrals();
  }

  Future<void> _approve(String id) async {
    final ok = await _controller.approveReward(id);
    if (mounted) {
      AdminSnackbarService.show(
        context,
        ok ? 'Reward approved successfully.' : 'Failed to approve reward.',
      );
      if (ok) {
        _controller.loadAnalytics();
        _controller.loadReferrals(statusFilter: _statusFilter);
      }
    }
  }

  Future<void> _reject(String id) async {
    final reasonCtrl = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Referral Reward'),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(
            labelText: 'Reason',
            hintText: 'e.g. Self-referral, Fraudulent order',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, reasonCtrl.text), child: const Text('Reject')),
        ],
      ),
    );
    if (reason == null || reason.trim().isEmpty) return;

    final ok = await _controller.rejectReward(id, reason.trim());
    if (mounted) {
      AdminSnackbarService.show(
        context,
        ok ? 'Reward rejected.' : 'Failed to reject reward.',
      );
      if (ok) {
        _controller.loadAnalytics();
        _controller.loadReferrals(statusFilter: _statusFilter);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: Text('Referral Dashboard')),
      body: AdminResponsive.constrainContent(
        context: context,
        child: Obx(() {
          final analytics = _controller.analytics.value;

          if (_controller.isLoadingAnalytics.value && analytics == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: AdminResponsive.pagePadding(context),
            children: [
              if (analytics != null) ...[
                _buildStatsGrid(context, analytics),
                const SizedBox(height: 16),
                _buildFunnelCard(context, analytics),
                const SizedBox(height: 16),
                if (analytics.topReferrers.isNotEmpty)
                  _buildTopReferrersCard(context, analytics),
                const SizedBox(height: 16),
                _buildFreshPointsCard(context),
              ],
              const SizedBox(height: 24),
              _buildReferralsSection(context),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, dynamic analytics) {
    final stats = [
      _StatCardData('Total', analytics.totalReferrals, Colors.blue, Icons.people_outline),
      _StatCardData('Qualified', analytics.qualifiedReferrals, Colors.teal, Icons.check_circle_outline),
      _StatCardData('Rewarded', analytics.rewardedReferrals, Colors.green, Icons.emoji_events_outlined),
      _StatCardData('Pending', analytics.pendingReferrals, Colors.orange, Icons.schedule_outlined),
      _StatCardData('Rejected', analytics.rejectedReferrals, Colors.red, Icons.cancel_outlined),
      _StatCardData('Expired', analytics.expiredReferrals, Colors.grey, Icons.timer_off_outlined),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: stats.map((s) => SizedBox(
        width: (MediaQuery.of(context).size.width - 48) / 3 - 8,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(s.icon, color: s.color, size: 20),
                const SizedBox(height: 8),
                Text('${s.value}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text(s.title, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildFunnelCard(BuildContext context, dynamic analytics) {
    final maxVal = [
      analytics.funnelShared,
      analytics.funnelSignedUp,
      analytics.funnelQualified,
      analytics.funnelRewarded,
    ].fold<int>(1, (a, b) => a > b ? a : b);

    final steps = [
      _FunnelStep('Shared', analytics.funnelShared),
      _FunnelStep('Signed Up', analytics.funnelSignedUp),
      _FunnelStep('Qualified', analytics.funnelQualified),
      _FunnelStep('Rewarded', analytics.funnelRewarded),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Referral Funnel', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ...steps.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s.label, style: Theme.of(context).textTheme.bodyMedium),
                      Text('${s.count}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: s.count / maxVal,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTopReferrersCard(BuildContext context, dynamic analytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top Referrers', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...analytics.topReferrers.take(5).map((r) => ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 16,
                child: Text((r.name as String).isNotEmpty ? r.name[0].toUpperCase() : '?'),
              ),
              title: Text(r.name as String),
              subtitle: Text('${r.referralCount} referred - ${r.rewardPointsIssued} pts'),
              trailing: Text('${(r.qualificationRate * 100).toStringAsFixed(0)}%'),
            )),
          ],
        ),
      ),
    );
  }

  void _openFreshPointsAdjust() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserPickerScreen()),
    );
  }

  Widget _buildFreshPointsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AdminAppTheme.getWarningContainerColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.monetization_on_outlined,
                color: AdminAppTheme.getWarningColor(context),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FreshPoints Adjustment',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Manually credit or deduct points for any user',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: _openFreshPointsAdjust,
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Adjust'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Referral List', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            DropdownButton<String?>(
              value: _statusFilter,
              hint: const Text('All'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                const DropdownMenuItem(value: 'SIGNED_UP', child: Text('Signed Up')),
                const DropdownMenuItem(value: 'REWARDED', child: Text('Rewarded')),
                const DropdownMenuItem(value: 'REJECTED', child: Text('Rejected')),
                const DropdownMenuItem(value: 'EXPIRED', child: Text('Expired')),
              ],
              onChanged: (v) {
                setState(() => _statusFilter = v);
                _controller.loadReferrals(statusFilter: v);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_controller.isLoadingReferrals.value && _controller.referrals.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
        else if (_controller.referrals.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('No referrals found')))
        else
          ..._controller.referrals.map((r) => _buildReferralCard(context, r)),
        if (_controller.hasMore)
          TextButton(
            onPressed: () => _controller.loadReferrals(loadMore: true, statusFilter: _statusFilter),
            child: const Text('Load More'),
          ),
      ],
    );
  }

  Widget _buildReferralCard(BuildContext context, Map<String, dynamic> r) {
    final status = r['status'] as String? ?? '';

    Color statusColor;
    switch (status) {
      case 'REWARDED':
        statusColor = Colors.green;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        break;
      case 'EXPIRED':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${r['referrerName'] ?? 'Unknown'} → ${r['inviteeName'] ?? r['inviteePhone']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(status, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Referrer: ${r['referrerPhone'] ?? ''}', style: Theme.of(context).textTheme.bodySmall),
            Text('Invitee: ${r['inviteePhone'] ?? ''}', style: Theme.of(context).textTheme.bodySmall),
            if ((r['rewardPointsIssued'] as int? ?? 0) > 0)
              Text('Points Issued: ${r['rewardPointsIssued']}', style: Theme.of(context).textTheme.bodySmall),
            if (status == 'SIGNED_UP')
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: _controller.isApproving.value ? null : () => _approve(r['id'] as String),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Approve'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade50,
                        foregroundColor: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _controller.isApproving.value ? null : () => _reject(r['id'] as String),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCardData {
  final String title;
  final int value;
  final Color color;
  final IconData icon;
  _StatCardData(this.title, this.value, this.color, this.icon);
}

class _FunnelStep {
  final String label;
  final int count;
  _FunnelStep(this.label, this.count);
}
