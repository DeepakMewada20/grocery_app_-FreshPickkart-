import 'package:serverpod/serverpod.dart';

class PaySuccessRoute extends Route {
  PaySuccessRoute() : super(methods: {Method.get});

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final html = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment Successful - FreshPickKat</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
      background: #f0faf0;
      color: #172019;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .success-page { text-align: center; padding: 32px; max-width: 420px; }
    .icon { font-size: 72px; margin-bottom: 16px; }
    h2 { font-size: 24px; color: #1b8a4c; margin-bottom: 8px; }
    p { font-size: 14px; color: #4a5a50; line-height: 1.5; margin-bottom: 24px; }
    .btn {
      display: inline-block;
      background: #1b8a4c;
      color: #fff;
      text-decoration: none;
      padding: 12px 32px;
      border-radius: 8px;
      font-size: 15px;
      font-weight: 600;
    }
    .btn:hover { background: #15703e; }
  </style>
</head>
<body>
  <div class="success-page">
    <div class="icon">&#9989;</div>
    <h2>Payment Successful!</h2>
    <p>Your payment has been confirmed. The order will be processed shortly.</p>
    <a href="/" class="btn">Go to Home</a>
  </div>
</body>
</html>
''';

    return Response.ok(
      body: Body.fromString(html, mimeType: MimeType.html),
    );
  }
}
