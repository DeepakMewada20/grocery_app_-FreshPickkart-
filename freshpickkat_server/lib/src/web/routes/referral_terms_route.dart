import 'package:serverpod/serverpod.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_referral_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_support.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;

class ReferralTermsRoute extends Route {
  ReferralTermsRoute() : super(methods: {Method.get, Method.post});

  final PostgresReferralService _referral = PostgresReferralService();

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

    final html = _buildTermsPage(termsText, uid: uid);
    return Response.ok(
      body: Body.fromString(html, mimeType: MimeType.html),
    );
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

  String _buildTermsPage(String termsText, {String uid = ''}) {
    final termsContent = _renderTermsContent(termsText);

    return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>Referral Terms - FreshPickKat</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
      background: #f5f7f5;
      color: #172019;
      min-height: 100vh;
    }
    .container {
      max-width: 720px;
      margin: 0 auto;
      padding: 16px;
    }
    .header {
      text-align: center;
      padding: 24px 0 16px;
    }
    .header h1 {
      font-size: 22px;
      font-weight: 700;
      color: #1b8a4c;
    }
    .header p {
      font-size: 14px;
      color: #6b7b72;
      margin-top: 4px;
    }
    .card {
      background: #fff;
      border-radius: 12px;
      padding: 24px;
      margin-bottom: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
    }
    .terms-content {
      font-size: 15px;
      line-height: 1.7;
      color: #2d3a31;
      white-space: pre-wrap;
      word-wrap: break-word;
    }
    .terms-content p {
      margin-bottom: 12px;
    }
    .terms-content h2, .terms-content h3 {
      margin-top: 20px;
      margin-bottom: 8px;
      color: #172019;
    }
    .terms-content ul, .terms-content ol {
      margin: 8px 0 12px 20px;
    }
    .terms-content li {
      margin-bottom: 4px;
    }
    .accept-section {
      text-align: center;
      padding: 16px 0;
    }
    .accept-btn {
      display: inline-block;
      padding: 14px 48px;
      background: #1b8a4c;
      color: #fff;
      border: none;
      border-radius: 12px;
      font-size: 17px;
      font-weight: 700;
      cursor: pointer;
      transition: background 0.2s;
    }
    .accept-btn:hover { background: #16733e; }
    .accept-btn:disabled {
      background: #a3c4b2;
      cursor: not-allowed;
    }
    .accept-btn.accepted {
      background: #a3c4b2;
      cursor: default;
    }
    .info-note {
      text-align: center;
      font-size: 13px;
      color: #6b7b72;
      margin-top: 12px;
    }
    .empty-state {
      text-align: center;
      padding: 48px 16px;
      color: #6b7b72;
    }
    .empty-state .icon { font-size: 48px; margin-bottom: 12px; }
    .empty-state h2 { font-size: 18px; color: #2d3a31; margin-bottom: 8px; }
    @media (max-width: 480px) {
      .container { padding: 12px; }
      .card { padding: 16px; }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>FreshPickKat</h1>
      <p>Referral Program Terms & Conditions</p>
    </div>
    <div class="card">
      ${termsContent.isNotEmpty ? '<div class="terms-content">$termsContent</div>' : _buildEmptyState()}
    </div>
    ${_buildAcceptSection(uid)}
  </div>
</body>
</html>
''';
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
<div class="info-note">
  <p>To accept these terms, please open the Invite & Earn section in the FreshPickKat app.</p>
</div>
''';
    }
    return '''
<div class="accept-section">
  <form method="post" onsubmit="return confirmAccept()">
    <input type="hidden" name="uid" value="${_escapeHtml(uid)}">
    <button type="submit" id="acceptBtn" class="accept-btn">I Accept the Terms</button>
  </form>
  <div class="info-note">
    By accepting, you agree to the FreshPickKat Referral Program terms.
  </div>
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

  String _buildEmptyState() {
    return '''
<div class="empty-state">
  <div class="icon">&#128221;</div>
  <h2>Terms Not Available</h2>
  <p>The referral program terms have not been configured yet. Please check back later.</p>
</div>
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
    <a href="https://freshpickkat.com" class="back-link">Go to App</a>
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

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }
}
