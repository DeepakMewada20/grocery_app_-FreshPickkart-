import 'package:serverpod/serverpod.dart';

class DeepLinkFallbackRoute extends Route {
  DeepLinkFallbackRoute() : super(methods: {Method.get});

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final id = request.pathParameters.raw[#id] ?? '';
    final segments = request.url.pathSegments
        .where((s) => s.trim().isNotEmpty)
        .toList();
    final routeType = segments.isNotEmpty ? segments.first : 'product';

    return _landingPage(routeType, id);
  }

  Result _landingPage(String routeType, String id) {
    final appStoreUrl = 'https://apps.apple.com/app/freshpickkart/idXXXXXXXXXX';
    final playStoreUrl = 'https://play.google.com/store/apps/details?id=com.freshpickkart.customer';
    final deepLink = 'https://freshpickkart.com/$routeType/$id';

    final (icon, title, subtitle) = switch (routeType) {
      'offer' => ('🏷️', 'Special Offer!', 'Someone shared an exclusive offer with you.'),
      'category' => ('📂', 'Explore Products', 'Check out this category on FreshPickKat.'),
      _ => ('🛍️', 'Check this out!', 'Someone shared a product from FreshPickKat with you.'),
    };

    return Response.ok(
      body: Body.fromString(
        _buildHtml(icon, title, subtitle, deepLink, id, appStoreUrl, playStoreUrl),
        mimeType: MimeType.html,
      ),
    );
  }

  String _buildHtml(
    String icon,
    String title,
    String subtitle,
    String deepLink,
    String id,
    String appStoreUrl,
    String playStoreUrl,
  ) {
    return '''
<!DOCTYPE html>
<html lang="en-IN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
  <meta name="theme-color" content="#0f7a3b">
  <meta name="color-scheme" content="light dark">
  <meta name="robots" content="noindex">
  <title>FreshPickKat</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: linear-gradient(135deg, #f6f8f5 0%, #eaf6ee 100%);
      color: #142018;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
    }
    .card {
      background: #fff;
      border-radius: 24px;
      padding: 40px 32px;
      max-width: 420px;
      width: 100%;
      box-shadow: 0 20px 60px rgba(15, 51, 31, 0.12);
      text-align: center;
    }
    .icon { font-size: 56px; margin-bottom: 16px; }
    h1 { font-size: 24px; font-weight: 800; color: #0f7a3b; margin-bottom: 8px; }
    p { font-size: 15px; color: #5f6f65; line-height: 1.6; margin-bottom: 24px; }
    .btn {
      display: block; width: 100%; padding: 16px; border: none; border-radius: 14px;
      font-size: 16px; font-weight: 600; cursor: pointer; text-decoration: none;
      transition: transform 180ms ease, box-shadow 180ms ease;
    }
    .btn:active { transform: scale(0.98); }
    .btn-primary { background: #0f7a3b; color: #fff; box-shadow: 0 4px 16px rgba(15, 122, 59, 0.25); margin-bottom: 12px; }
    .btn-primary:hover { background: #09622d; }
    .btn-secondary { background: #eef5ef; color: #142018; border: 1px solid #dce7de; }
    .btn-secondary:hover { background: #dce7de; }
    .divider { display: flex; align-items: center; gap: 12px; margin: 20px 0; color: #b7c7bb; font-size: 13px; }
    .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: #dce7de; }
    .footer-text { font-size: 12px; color: #b7c7bb; margin-top: 20px; }
    .loader { display: none; width: 20px; height: 20px; border: 2px solid #fff; border-top-color: transparent; border-radius: 50%; animation: spin 0.6s linear infinite; margin: 0 auto; }
    @keyframes spin { to { transform: rotate(360deg); } }
  </style>
</head>
<body>
  <div class="card">
    <div class="icon">$icon</div>
    <h1>$title</h1>
    <p>$subtitle</p>
    <button class="btn btn-primary" onclick="openApp()" id="openBtn">
      <span id="btnText">Open App</span>
      <div class="loader" id="btnLoader"></div>
    </button>
    <div class="divider">or</div>
    <a class="btn btn-secondary" href="$playStoreUrl" id="installBtn">Get it on Play Store</a>
    <p class="footer-text">By continuing, you agree to FreshPickKat's Terms &amp; Conditions.</p>
  </div>

  <script>
    function openApp() {
      var btn = document.getElementById('openBtn');
      var btnText = document.getElementById('btnText');
      var btnLoader = document.getElementById('btnLoader');
      btn.disabled = true;
      btnText.style.display = 'none';
      btnLoader.style.display = 'block';
      window.location.href = '${_escapeJs(deepLink)}';
      var start = Date.now();
      setTimeout(function() {
        if (Date.now() - start < 2500) {
          var ua = navigator.userAgent.toLowerCase();
          if (/android/.test(ua)) window.location.href = '${_escapeJs(playStoreUrl)}';
          else if (/iphone|ipad|ipod/.test(ua)) window.location.href = '${_escapeJs(appStoreUrl)}';
          else {
            btnText.style.display = 'inline';
            btnLoader.style.display = 'none';
            btn.disabled = false;
            btnText.textContent = 'Continue to Website';
            document.getElementById('installBtn').style.display = 'none';
          }
        }
      }, 2000);
    }
    setTimeout(openApp, 500);
  </script>
</body>
</html>
''';
  }

  String _escapeJs(String s) {
    return s.replaceAll("'", "\\'").replaceAll('\n', '\\n').replaceAll('\r', '\\r');
  }
}
