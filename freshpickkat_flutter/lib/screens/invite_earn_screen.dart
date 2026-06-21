import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart' show launchUrl, LaunchMode;

import 'package:freshpickkat_client/freshpickkat_client.dart';
import '../controller/auth_controller.dart';
import '../utils/serverpod_client.dart';

class InviteEarnScreen extends StatefulWidget {
  const InviteEarnScreen({super.key});
  @override
  State<InviteEarnScreen> createState() => _InviteEarnScreenState();
}

class _InviteEarnScreenState extends State<InviteEarnScreen> {
  final _client = ServerpodClient().client;
  final _auth = AuthController.instance;

  bool _isLoading = true;
  ReferralCodeInfo? _info;
  List<ReferralActivity> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;
      final results = await Future.wait([
        _client.referral.getMyReferralCodeInfo(uid),
        _client.referral.getMyReferralActivity(uid),
      ]);
      setState(() {
        _info = results[0] as ReferralCodeInfo;
        _activities = results[1] as List<ReferralActivity>;
      });
    } catch (_) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _copyCode() {
    if (_info == null) return;
    Clipboard.setData(ClipboardData(text: _info!.referralCode));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Referral code copied!'), duration: Duration(seconds: 2)),
      );
    }
  }

  void _share() {
    if (_info == null) return;
    Share.share('${_info!.shareMessage}\n\n${_info!.shareLink}');
  }

  void _shareWhatsApp() {
    if (_info == null) return;
    final text = Uri.encodeComponent('${_info!.shareMessage}\n\n${_info!.shareLink}');
    _openUrl('https://wa.me/?text=$text');
  }

  void _openUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Invite & Earn')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCodeCard(cs),
                  const SizedBox(height: 16),
                  _buildStatsCard(cs),
                  const SizedBox(height: 16),
                  _buildShareButtons(cs),
                  const SizedBox(height: 24),
                  _buildActivitySection(cs),
                ],
              ),
            ),
    );
  }

  Widget _buildCodeCard(ColorScheme cs) {
    final code = _info?.referralCode ?? '------';
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              cs.primary.withValues(alpha: 0.8),
              cs.primary.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.card_giftcard, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            Text('Your Referral Code', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
            const SizedBox(height: 8),
            Text(code, style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            )),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _copyCode,
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copy Code'),
              style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: cs.primary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(ColorScheme cs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat('Invited', _info?.totalReferred ?? 0, Icons.people_outline, cs.primary),
            Container(height: 40, width: 1, color: cs.outlineVariant),
            _buildStat('Qualified', _info?.totalQualified ?? 0, Icons.check_circle_outline, Colors.green),
            Container(height: 40, width: 1, color: cs.outlineVariant),
            _buildStat('Earned', _info?.totalRewardsEarned ?? 0, Icons.monetization_on_outlined, Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildShareButtons(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Share your code', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            _shareButton(Icons.share, 'Share', Colors.blue, _share),
            const SizedBox(width: 12),
            _shareButton(Icons.chat, 'WhatsApp', Colors.green, _shareWhatsApp),
            const SizedBox(width: 12),
            _shareButton(Icons.copy, 'Copy', Colors.grey, _copyCode),
          ],
        ),
      ],
    );
  }

  Widget _shareButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(foregroundColor: color),
      ),
    );
  }

  Widget _buildActivitySection(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Activity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (_activities.isEmpty)
          Card(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Text('No activity yet. Share your code to get started!',
              style: TextStyle(color: cs.onSurfaceVariant), textAlign: TextAlign.center)),
          ))
        else
          ..._activities.map((a) => _buildActivityRow(cs, a)),
      ],
    );
  }

  Widget _buildActivityRow(ColorScheme cs, ReferralActivity a) {
    IconData icon;
    Color color;
    switch (a.type) {
      case 'REWARDED':
        icon = Icons.emoji_events;
        color = Colors.amber;
        break;
      case 'REJECTED':
        icon = Icons.cancel_outlined;
        color = Colors.red;
        break;
      default:
        icon = Icons.person_add_outlined;
        color = cs.primary;
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(a.inviteePhone),
        subtitle: Text(a.description, style: Theme.of(context).textTheme.bodySmall),
        trailing: a.pointsEarned != null
            ? Text('+${a.pointsEarned}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold))
            : null,
      ),
    );
  }
}
