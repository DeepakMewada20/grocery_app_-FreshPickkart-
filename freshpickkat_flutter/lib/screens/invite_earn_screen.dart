import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart' show Share;
import 'package:url_launcher/url_launcher.dart';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import '../controller/auth_controller.dart';
import '../utils/serverpod_client.dart';
import '../routes/route_manager.dart';
import 'fresh_points_history_screen.dart';

class InviteEarnScreen extends StatefulWidget {
  const InviteEarnScreen({super.key});
  @override
  State<InviteEarnScreen> createState() => _InviteEarnScreenState();
}

class _InviteEarnScreenState extends State<InviteEarnScreen> {
  final _client = ServerpodClient().client;
  final _auth = AuthController.instance;

  bool _isLoading = true;
  // bool _termsAccepted = false;
  // bool _termsLoading = true;
  ReferralCodeInfo? _info;
  ReferralSettings? _settings;
  List<ReferralActivity> _activities = [];
  FreshPointsBalance? _fpBalance;

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
        _client.referral.getSettings(),
        _client.freshPoints.getMyBalance(uid),
      ]);
      setState(() {
        _info = results[0] as ReferralCodeInfo;
        _activities = results[1] as List<ReferralActivity>;
        _settings = results[2] as ReferralSettings;
        _fpBalance = results[3] as FreshPointsBalance;
      });
    } catch (_) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Future<void> _toggleTerms() async {
  //   if (_termsAccepted) return;
  //   try {
  //     final uid = _auth.currentUser?.uid;
  //     if (uid == null) return;
  //     await _client.referral.acceptTerms(uid);
  //     setState(() => _termsAccepted = true);
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Terms accepted!'), duration: Duration(seconds: 2)),
  //       );
  //     }
  //   } catch (_) {}
  // }

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
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      _client.referral.recordShare(uid).catchError((_) => <String, dynamic>{});
    }
    Share.share('${_info!.shareMessage}\n\n${_info!.shareLink}');
  }

  Future<void> _openTermsDocs() async {
    final uid = _auth.currentUser?.uid ?? '';
    final url =
        'https://${RouteManager.primaryHost}/referral/terms${uid.isNotEmpty ? '?uid=$uid' : ''}';
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open terms')),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open terms')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite & Earn'),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined),
            tooltip: 'Terms & Conditions',
            onPressed: _openTermsDocs,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCodeCard(cs),
                  const SizedBox(height: 12),
                  _buildRewardInfo(cs),
                  const SizedBox(height: 12),
                  _buildStatsCard(cs),
                  const SizedBox(height: 12),
                  if (_fpBalance != null) ...[
                    _buildFpBalanceCard(cs),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 4),
                  _buildPointsHistorySection(cs),
                  const SizedBox(height: 16),
                  // Terms section hidden — terms are served via /referral/terms web page
                  // if (_settings?.termsText != null && _settings!.termsText!.isNotEmpty && !_termsLoading)
                  //   _buildTermsSection(cs),
                  const SizedBox(height: 24),
                  _buildActivitySection(cs),
                ],
              ),
            ),
    );
  }

  Widget _buildCodeCard(ColorScheme cs) {
    final code = _info?.referralCode ?? '------';
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.extraLarge),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, cs.primary.withValues(alpha: 0.75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: const Icon(Icons.card_giftcard, color: Colors.white, size: 22),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.extraLarge),
                  ),
                  child: Text('REFERRAL',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10, letterSpacing: 1.5)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(code, style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            )),
            const SizedBox(height: 6),
            Text('Your Referral Code', style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              letterSpacing: 0.5,
            )),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: OutlinedButton.icon(
                      onPressed: _copyCode,
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy Code', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: FilledButton.icon(
                      onPressed: _share,
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('Share', style: TextStyle(fontSize: 13)),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: cs.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardInfo(ColorScheme cs) {
    final points = _settings?.referrerRewardPoints ?? 50;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Icon(Icons.monetization_on, color: Colors.amber.shade700, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Earn ',
                      style: TextStyle(fontSize: 14, color: cs.onSurface),
                      children: [
                        TextSpan(
                          text: '$points FreshPoints',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade700,
                          ),
                        ),
                        TextSpan(
                          text: ' per referral',
                          style: TextStyle(fontSize: 14, color: cs.onSurface),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '1 FreshPoint = ₹1 Rupee',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
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
            _buildStat('Qualified', _info?.totalQualified ?? 0, Icons.check_circle_outline, cs.primary),
            Container(height: 40, width: 1, color: cs.outlineVariant),
            _buildStat('Earned', _info?.totalRewardsEarned ?? 0, Icons.monetization_on_outlined, cs.primary),
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

  Widget _buildFpBalanceCard(ColorScheme cs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: const Icon(Icons.monetization_on_outlined, size: 20),
                ),
                const SizedBox(width: 10),
                const Text('FreshPoints',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFpStat('Balance', '${_fpBalance!.balance}', cs.primary),
                Container(height: 30, width: 1, color: cs.outlineVariant),
                _buildFpStat('Earned', '${_fpBalance!.totalEarned}', cs.primary),
                Container(height: 30, width: 1, color: cs.outlineVariant),
                _buildFpStat('Redeemed', '${_fpBalance!.totalRedeemed}', cs.error),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFpStat(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPointsHistorySection(ColorScheme cs) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            settings: const RouteSettings(name: '/FreshPointsHistoryScreen'),
            builder: (_) => const FreshPointsHistoryScreen(),
          ),
        ),
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(Icons.monetization_on_outlined, color: cs.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Points History',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('View your FreshPoints earned & redeemed',
                      style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurface.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTermsSection(ColorScheme cs) {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text('Terms & Conditions', style: Theme.of(context).textTheme.titleMedium),
  //           const SizedBox(height: 8),
  //           Text(_settings?.termsText ?? '', style: Theme.of(context).textTheme.bodySmall),
  //           const SizedBox(height: 12),
  //           Row(
  //             children: [
  //               Icon(
  //                 _termsAccepted ? Icons.check_circle : Icons.radio_button_unchecked,
  //                 color: _termsAccepted ? cs.primary : cs.onSurface,
  //                 size: 20,
  //               ),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 child: Text('I accept the referral terms and conditions',
  //                   style: TextStyle(color: _termsAccepted ? cs.primary : cs.onSurface)),
  //               ),
  //             ],
  //           ),
  //           if (!_termsAccepted) ...[
  //             const SizedBox(height: 12),
  //             SizedBox(
  //               width: double.infinity,
  //               child: FilledButton(
  //                 onPressed: _toggleTerms,
  //                 child: const Text('Accept Terms'),
  //               ),
  //             ),
  //           ],
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
        color = cs.primary;
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
        title: Text(a.inviteeName ?? a.inviteePhone),
        subtitle: Text(a.description, style: Theme.of(context).textTheme.bodySmall),
        trailing: a.pointsEarned != null
            ? Text('+${a.pointsEarned}', style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold))
            : null,
      ),
    );
  }
}
