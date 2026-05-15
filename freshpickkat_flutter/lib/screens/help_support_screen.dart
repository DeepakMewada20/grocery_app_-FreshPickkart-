import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/screens/legal_webview_screen.dart';
import 'package:freshpickkat_flutter/screens/report_issue_screen.dart';
import 'package:freshpickkat_flutter/services/support_issue_service.dart';
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
          padding: EdgeInsets.only(
            bottom: 24.h + MediaQuery.paddingOf(context).bottom,
          ),
          child: AppResponsive.constrainContent(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                _sectionHeader('CONTACT US', cs),
                _menuItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Chat on WhatsApp',
                  subtitle: 'Fastest way to reach FreshPickKat support',
                  onTap: _openWhatsapp,
                  cs: cs,
                ),
                _menuItem(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email Support',
                  subtitle: _supportEmail,
                  onTap: _openEmail,
                  cs: cs,
                ),
                _menuItem(
                  icon: Icons.call_outlined,
                  title: 'Call Support',
                  subtitle: _supportPhone,
                  onTap: _openCall,
                  cs: cs,
                  showBorder: false,
                ),
                SizedBox(height: 16.h),
                _sectionHeader('REPORTS', cs),
                _menuItem(
                  icon: Icons.edit_note_rounded,
                  title: 'Report App Issue',
                  subtitle: 'Login, payment, crash, notification or UI bug',
                  onTap: () => Get.to(() => const ReportIssueScreen()),
                  cs: cs,
                  showBorder: false,
                ),
                SizedBox(height: 16.h),
                _sectionHeader('HELP CENTER', cs),
                _menuItem(
                  icon: Icons.help_outline_rounded,
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
                  cs: cs,
                  showBorder: false,
                ),
                SizedBox(height: 16.h),
                _sectionHeader('APP INFO', cs),
                FutureBuilder<PackageInfo>(
                  future: _appInfoFuture,
                  builder: (context, snapshot) {
                    final packageInfo = snapshot.data;
                    final version = packageInfo == null
                        ? 'Loading...'
                        : 'v${packageInfo.version}';
                    final buildNumber = packageInfo?.buildNumber ?? '--';
                    return _appInfoItem(
                      version: version,
                      buildNumber: buildNumber,
                      cs: cs,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.6),
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ColorScheme cs,
    bool showBorder = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(bottom: BorderSide(color: cs.outlineVariant))
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: cs.onSurface, size: 22.r),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontSize: 13.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: cs.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appInfoItem({
    required String version,
    required String buildNumber,
    required ColorScheme cs,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.info_outline_rounded, color: cs.onSurface, size: 22.r),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$version ',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '(Build $buildNumber)',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
