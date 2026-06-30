import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_referral_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_support.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;

class ReferralTermsRoute extends Route {
  ReferralTermsRoute() : super(methods: {Method.get, Method.post});

  final PostgresReferralService _referral = PostgresReferralService();
  String? _templateCache;

  Future<String> _readTemplate() async {
    if (_templateCache != null) return _templateCache!;
    final path = '${Directory.current.path}/web/static/docs/referral-terms-user.html';
    try {
      _templateCache = await File(path).readAsString();
      return _templateCache!;
    } catch (e) {
      return _buildFallbackPage();
    }
  }

  @override
  Future<Result> handleCall(Session session, Request request) async {
    if (request.method == Method.post) {
      return _handleAccept(session, request);
    }
    return _handleView(session, request);
  }

  Future<Result> _handleView(Session session, Request request) async {
    final settings = await _referral.getSettings(session);
    final termsText = settings?.termsText ?? '';
    final uid = request.url.queryParameters['uid'] ?? '';

    var html = await _readTemplate();

    final adminSection = termsText.trim().isNotEmpty
        ? _buildAdminTermsSection(termsText)
        : '';
    html = html.replaceFirst('<!-- ADMIN_TERMS_SECTION -->', adminSection);

    final acceptSection = _buildAcceptSection(uid);
    html = html.replaceFirst('<!-- ACCEPT_SECTION -->', acceptSection);

    return Response.ok(
      body: Body.fromString(html, mimeType: MimeType.html),
    );
  }

  String _buildAdminTermsSection(String termsText) {
    final content = _renderTermsContent(termsText);
    return '''
<div class="card" style="border-left: 4px solid var(--primary); margin-bottom: 24px;">
  <h2 style="margin-top:0;">Additional Program Terms</h2>
  <div class="terms-content">$content</div>
</div>
''';
  }

  Future<Result> _handleAccept(Session session, Request request) async {
    final body = await request.readAsString();
    final params = Uri.splitQueryString(body);
    final uid = params['uid'] ?? '';

    if (uid.isEmpty) {
      return Response.ok(
        body: Body.fromString(
          _buildErrorPage('Missing user ID.'),
          mimeType: MimeType.html,
        ),
      );
    }

    try {
      final parsedId = await _resolveUserId(session, uid);
      await _referral.acceptTerms(session, parsedId);
      final html = _buildSuccessPage();
      return Response.ok(
        body: Body.fromString(html, mimeType: MimeType.html),
      );
    } catch (e) {
      return Response.ok(
        body: Body.fromString(
          _buildErrorPage('Failed to accept terms. Please try again in the app.'),
          mimeType: MimeType.html,
        ),
      );
    }
  }

  Future<UuidValue> _resolveUserId(Session session, String userId) async {
    final parsed = tryParseUuid(userId);
    if (parsed != null) return parsed;
    final user = await protocol.AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(userId),
    );
    if (user == null) throw Exception('Invalid user ID');
    return user.id!;
  }

  String _renderTermsContent(String text) {
    if (text.isEmpty) return '';
    final trimmed = text.trim();
    if (trimmed.contains('<') && trimmed.contains('>')) {
      return trimmed;
    }
    final escaped = _escapeHtml(trimmed);
    final paragraphs = escaped.split('\n\n');
    return paragraphs.map((p) {
      final cleaned = p.trim();
      if (cleaned.isEmpty) return '';
      if (cleaned.startsWith('# ')) {
        return '<h2>${_escapeHtml(cleaned.substring(2))}</h2>';
      }
      if (cleaned.startsWith('## ')) {
        return '<h3>${_escapeHtml(cleaned.substring(3))}</h3>';
      }
      if (cleaned.startsWith('- ') || cleaned.startsWith('* ')) {
        final items = cleaned.split('\n').map((line) {
          final l = line.trim();
          if (l.startsWith('- ') || l.startsWith('* ')) {
            return '<li>${_escapeHtml(l.substring(2))}</li>';
          }
          return '';
        }).join('');
        return '<ul>$items</ul>';
      }
      final withBreaks = cleaned.replaceAll('\n', '<br>');
      return '<p>$withBreaks</p>';
    }).join('\n');
  }

  String _buildAcceptSection(String uid) {
    if (uid.isEmpty) {
      return '''
<div class="accept-section">
  <p style="color:var(--muted);font-size:14px;">
    To accept these terms, please open the <strong>Invite &amp; Earn</strong> section in the FreshPickKat app.
  </p>
</div>
''';
    }
    return '''
<div class="accept-section" style="margin-top:24px;padding-top:20px;border-top:1px solid var(--border);">
  <form method="post" onsubmit="return confirmAccept()">
    <input type="hidden" name="uid" value="${_escapeHtml(uid)}">
    <button type="submit" id="acceptBtn" class="accept-btn">I Accept the Terms</button>
  </form>
  <p style="color:var(--muted);font-size:13px;margin-top:10px;">
    By clicking Accept, you agree to the FreshPickKat Referral Program terms above.
  </p>
</div>
<script>
function confirmAccept() {
  var btn = document.getElementById('acceptBtn');
  btn.disabled = true;
  btn.textContent = 'Accepting...';
  return true;
}
</script>
''';
  }

  String _buildSuccessPage() {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Terms Accepted - FreshPickKat</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
      background: #f5f7f5;
      color: #172019;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .success-page { text-align: center; padding: 32px; max-width: 400px; }
    .success-page .icon { font-size: 64px; margin-bottom: 16px; }
    .success-page h2 { font-size: 20px; color: #1b8a4c; margin-bottom: 8px; }
    .success-page p { font-size: 14px; color: #6b7b72; margin-bottom: 16px; }
    .back-link {
      display: inline-block;
      padding: 12px 32px;
      background: #1b8a4c;
      color: #fff;
      text-decoration: none;
      border-radius: 12px;
      font-weight: 600;
    }
    .back-link:hover { background: #16733e; }
  </style>
</head>
<body>
  <div class="success-page">
    <div class="icon">&#10003;</div>
    <h2>Terms Accepted!</h2>
    <p>Thank you for accepting the FreshPickKat Referral Program terms. You can now participate in the referral program.</p>
    <a href="https://freshpickkart.com" class="back-link">Go to App</a>
  </div>
</body>
</html>
''';
  }

  String _buildErrorPage(String message) {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Error - FreshPickKat</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
      background: #f5f7f5;
      color: #172019;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .error-page { text-align: center; padding: 32px; max-width: 400px; }
    .error-page .icon { font-size: 64px; margin-bottom: 16px; }
    .error-page h2 { font-size: 20px; color: #c62828; margin-bottom: 8px; }
    .error-page p { font-size: 14px; color: #6b7b72; }
  </style>
</head>
<body>
  <div class="error-page">
    <div class="icon">&#10060;</div>
    <h2>Something went wrong</h2>
    <p>${_escapeHtml(message)}</p>
  </div>
</body>
</html>
''';
  }

  String _buildFallbackPage() {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Terms & Conditions - FreshPickKat</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
      background: #f5f7f5;
      color: #172019;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 24px;
    }
    .card {
      background: #fff;
      border-radius: 12px;
      padding: 32px;
      max-width: 500px;
      text-align: center;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
    }
    h2 { color: #1b8a4c; margin-bottom: 8px; }
    p { color: #6b7b72; font-size: 14px; }
  </style>
</head>
<body>
  <div class="card">
    <h2>Referral Program Terms</h2>
    <p>Please open the Invite & Earn section in the FreshPickKat app to view and accept the referral terms.</p>
  </div>
</body>
</html>
''';
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }
}
