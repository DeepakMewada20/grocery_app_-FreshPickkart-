import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

class LegalWebViewScreen extends StatefulWidget {
  const LegalWebViewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  static const String _defaultDocsBaseUrl =
      'https://freshpickkart.com/docs';

  static const String docsBaseUrl = String.fromEnvironment(
    'LEGAL_DOCS_BASE_URL',
    defaultValue: _defaultDocsBaseUrl,
  );

  static String docsUrl(String fileName) {
    final base = docsBaseUrl.endsWith('/')
        ? docsBaseUrl.substring(0, docsBaseUrl.length - 1)
        : docsBaseUrl;
    return '$base/$fileName';
  }

  @override
  State<LegalWebViewScreen> createState() => _LegalWebViewScreenState();
}

class _LegalWebViewScreenState extends State<LegalWebViewScreen> {
  WebViewController? _controller;
  int _loadingProgress = 0;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) return;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (!mounted) return;
            setState(() {
              _loadingProgress = progress;
              _loadError = null;
            });
          },
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _loadingProgress = 0;
              _loadError = null;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _loadingProgress = 100);
          },
          onWebResourceError: (error) {
            if (!mounted || error.isForMainFrame == false) return;
            setState(() {
              _loadError =
                  'Unable to load this page. Please check your internet connection and try again.';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final nav = Navigator.of(context);
        await launchUrl(
          Uri.parse(widget.url),
          mode: LaunchMode.externalApplication,
        );
        if (mounted) nav.pop();
      });
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final cs = Theme.of(context).colorScheme;
    final isLoading = _loadingProgress < 100 && _loadError == null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: ScreenScale.sp(18),
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: isLoading
            ? PreferredSize(
                preferredSize: Size.fromHeight(ScreenScale.h(3)),
                child: LinearProgressIndicator(
                  value: _loadingProgress <= 0 ? null : _loadingProgress / 100,
                  minHeight: ScreenScale.h(3),
                  color: AppTheme.primaryGreen,
                  backgroundColor: cs.surfaceContainerHighest,
                ),
              )
            : null,
      ),
      body: SafeArea(
        top: false,
        child: _loadError == null
            ? WebViewWidget(controller: _controller!)
            : _LegalPageError(
                message: _loadError!,
                onRetry: () {
                  setState(() => _loadError = null);
                  _controller!.loadRequest(Uri.parse(widget.url));
                },
              ),
      ),
    );
  }
}

class _LegalPageError extends StatelessWidget {
  const _LegalPageError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: AppSpacing.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: ScreenScale.r(46),
              color: cs.onSurface.withValues(alpha: 0.55),
            ),
            SizedBox(height: ScreenScale.h(14)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.75),
                fontSize: ScreenScale.sp(15),
                height: 1.4,
              ),
            ),
            SizedBox(height: ScreenScale.h(18)),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: AppSpacing.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
