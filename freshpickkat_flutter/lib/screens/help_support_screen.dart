import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/screens/legal_webview_screen.dart';
import 'package:freshpickkat_flutter/screens/report_issue_screen.dart';
import 'package:freshpickkat_flutter/services/support_issue_service.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  static const _supportPhone = '+918815086850';
  static const _supportEmail = 'support@freshpickkat.com';

  late final Future<PackageInfo> _appInfoFuture;

  @override
  void initState() {
    super.initState();
    _appInfoFuture = SupportIssueService.instance.getAppInfo();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16.w,
            8.h,
            16.w,
            26.h + MediaQuery.paddingOf(context).bottom,
          ),
          child: AppResponsive.constrainContent(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroSupportCard(
                  onWhatsapp: _openWhatsapp,
                  onCall: _openCall,
                ),
                SizedBox(height: 20.h),
                _SectionGroup(
                  title: 'CONTACT US',
                  children: [
                    _SupportTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: const Color(0xFF1FAF61),
                      title: 'Chat on WhatsApp',
                      subtitle: 'Fastest way to reach FreshPickKat support',
                      onTap: _openWhatsapp,
                    ),
                    _SupportTile(
                      icon: Icons.mail_outline_rounded,
                      iconColor: const Color(0xFF2D6CDF),
                      title: 'Email Support',
                      subtitle: _supportEmail,
                      onTap: _openEmail,
                    ),
                    _SupportTile(
                      icon: Icons.call_outlined,
                      iconColor: const Color(0xFFEF7B2D),
                      title: 'Call Support',
                      subtitle: _supportPhone,
                      onTap: _openCall,
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                _SectionGroup(
                  title: 'REPORTS',
                  children: [
                    _SupportTile(
                      icon: Icons.edit_note_rounded,
                      iconColor: const Color(0xFF8A5CF6),
                      title: 'Report App Issue',
                      subtitle: 'Login, payment, crash, notification or UI bug',
                      onTap: () => Get.to(() => const ReportIssueScreen()),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                _SectionGroup(
                  title: 'HELP CENTER',
                  children: [
                    _SupportTile(
                      icon: Icons.help_outline_rounded,
                      iconColor: AppTheme.primaryGreen,
                      title: 'Frequently Asked Questions',
                      subtitle: 'Orders, payments, refunds and delivery help',
                      onTap: () => Get.to(
                        () => LegalWebViewScreen(
                          title: 'FAQ',
                          url: LegalWebViewScreen.docsUrl(
                            'frequently-asked-questions.html',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                _SectionGroup(
                  title: 'APP INFO',
                  children: [
                    FutureBuilder<PackageInfo>(
                      future: _appInfoFuture,
                      builder: (context, snapshot) {
                        final packageInfo = snapshot.data;
                        final version = packageInfo == null
                            ? 'Loading...'
                            : 'v${packageInfo.version}';
                        final buildNumber = packageInfo?.buildNumber ?? '--';
                        return _AppInfoTile(
                          version: version,
                          buildNumber: buildNumber,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openWhatsapp() async {
    final text = Uri.encodeComponent(
      'Hi FreshPickKat Support, I need help.',
    );
    await _launchExternal(
      Uri.parse('https://wa.me/918815086850?text=$text'),
      fallbackMessage: 'WhatsApp is not available on this device.',
    );
  }

  Future<void> _openEmail() async {
    await _launchExternal(
      Uri(
        scheme: 'mailto',
        path: _supportEmail,
        queryParameters: const {'subject': 'Support Request'},
      ),
      fallbackMessage: 'No email app is available on this device.',
    );
  }

  Future<void> _openCall() async {
    await _launchExternal(
      Uri(scheme: 'tel', path: _supportPhone),
      fallbackMessage: 'Calling is not available on this device.',
    );
  }

  Future<void> _launchExternal(
    Uri uri, {
    required String fallbackMessage,
  }) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return;
    } catch (_) {
      // Fall through to the user-facing message below.
    }

    if (mounted) {
      Get.snackbar(
        'Unable to open',
        fallbackMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class _HeroSupportCard extends StatelessWidget {
  const _HeroSupportCard({
    required this.onWhatsapp,
    required this.onCall,
  });

  final VoidCallback onWhatsapp;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.22),
            blurRadius: 24.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 28.r,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'FreshPickKat Support',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Get help with orders, payments, refunds, delivery and app issues.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 14.sp,
              height: 1.35,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _HeroButton(
                  label: 'WhatsApp',
                  icon: Icons.chat_rounded,
                  onTap: onWhatsapp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _HeroButton(
                  label: 'Call',
                  icon: Icons.call_rounded,
                  onTap: onCall,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Usually best for urgent order or payment help.',
            style: TextStyle(
              color: cs.onPrimary.withValues(alpha: 0.78),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.primaryGreen, size: 18.r),
              SizedBox(width: 7.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionGroup extends StatelessWidget {
  const _SectionGroup({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            title,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.58),
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  Divider(
                    height: 1,
                    indent: 72.w,
                    color: cs.outlineVariant,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SupportTile extends StatelessWidget {
  const _SupportTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: iconColor, size: 23.r),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.58),
                        fontSize: 12.5.sp,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: 0.38),
                size: 24.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppInfoTile extends StatelessWidget {
  const _AppInfoTile({
    required this.version,
    required this.buildNumber,
  });

  final String version;
  final String buildNumber;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: AppTheme.primaryGreen,
              size: 23.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Version: $version',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Build Number: $buildNumber',
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.58),
                    fontSize: 12.5.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
