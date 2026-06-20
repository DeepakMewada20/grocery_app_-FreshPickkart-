import 'package:serverpod/serverpod.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_link_service.dart';
import 'package:freshpickkat_server/src/services/env_service.dart';

class PaymentPageRoute extends Route {
  PaymentPageRoute() : super(methods: {Method.get, Method.post});

  final PostgresPaymentLinkService _paymentLinks = PostgresPaymentLinkService();

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final enableWebCheckout = EnvService.get('ENABLE_WEB_CHECKOUT') == 'true';
    if (!enableWebCheckout) {
      return _invalidLinkPage(
        'Online payments through this link are currently unavailable. '
        'Please request a new payment link from the customer.',
      );
    }

    final token = request.pathParameters.raw[#token] ?? '';

    if (token.isEmpty) {
      return _invalidLinkPage('Missing token.');
    }

    final data = await _paymentLinks.validateToken(session, token);

    if (data['valid'] != true) {
      return _invalidLinkPage(
        data['errorMessage'] as String? ??
            'This payment link is no longer valid.',
      );
    }

    final razorpayKeyId = EnvService.get('RAZORPAY_KEY_ID') ?? '';
    final orderNumber = data['orderNumber'] as String? ?? '';
    final finalAmount = data['finalAmount'] as double? ?? 0.0;
    final itemCount = data['itemCount'] as int? ?? 0;
    final deliveryAddress = data['deliveryAddress'] as String? ?? '';
    final items = data['items'] as List<dynamic>? ?? [];
    final razorpayOrderId = data['razorpayOrderId'] as String? ?? '';
    final amountPaise = data['amountPaise'] as int? ?? 0;
    final currency = data['currency'] as String? ?? 'INR';
    final expiresAt = data['expiresAt'] as String? ?? '';

    return _paymentPage(
      token: token,
      razorpayKeyId: razorpayKeyId,
      orderNumber: orderNumber,
      finalAmount: finalAmount,
      itemCount: itemCount,
      deliveryAddress: deliveryAddress,
      items: items,
      razorpayOrderId: razorpayOrderId,
      amountPaise: amountPaise,
      currency: currency,
      expiresAt: expiresAt,
    );
  }

  Response _paymentPage({
    required String token,
    required String razorpayKeyId,
    required String orderNumber,
    required double finalAmount,
    required int itemCount,
    required String deliveryAddress,
    required List<dynamic> items,
    required String razorpayOrderId,
    required int amountPaise,
    required String currency,
    required String expiresAt,
  }) {
    final itemsHtml = StringBuffer();
    for (final item in items) {
      final name = item['productName'] as String? ?? '';
      final variant = item['variantLabel'] as String?;
      final qty = item['quantity'] as int? ?? 1;
      final price = item['totalPrice'] as double? ?? 0.0;
      final image = item['productImage'] as String? ?? '';

      itemsHtml.write('<div class="item-row">');
      if (image.isNotEmpty) {
        itemsHtml.write(
          '<img src="$image" alt="$name" class="item-img" '
          'onerror="this.style.display=\'none\'">',
        );
      }
      itemsHtml.write('<div class="item-details">');
      itemsHtml.write('<div class="item-name">${_escapeHtml(name)}</div>');
      if (variant != null && variant.isNotEmpty) {
        itemsHtml.write(
          '<div class="item-variant">${_escapeHtml(variant)}</div>',
        );
      }
      itemsHtml.write('</div>');
      itemsHtml.write(
        '<div class="item-qty">x$qty</div>',
      );
      itemsHtml.write(
        '<div class="item-price">₹${price.toStringAsFixed(2)}</div>',
      );
      itemsHtml.write('</div>');
    }

    final html =
        '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>Complete Payment - FreshPickKat</title>
  <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
      background: #f5f7f5;
      color: #172019;
      min-height: 100vh;
    }
    .container {
      max-width: 480px;
      margin: 0 auto;
      padding: 16px;
    }
    .header {
      text-align: center;
      padding: 24px 0 16px;
    }
    .header img {
      width: 56px;
      height: 56px;
      margin-bottom: 8px;
    }
    .header h1 {
      font-size: 22px;
      font-weight: 700;
      color: #1b8a4c;
    }
    .card {
      background: #fff;
      border-radius: 12px;
      padding: 16px;
      margin-bottom: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
    }
    .card h2 {
      font-size: 16px;
      font-weight: 600;
      margin-bottom: 12px;
      color: #2d3a31;
    }
    .order-number {
      font-size: 18px;
      font-weight: 700;
      color: #1b8a4c;
      margin-bottom: 4px;
    }
    .order-meta {
      font-size: 14px;
      color: #6b7b72;
    }
    .amount {
      font-size: 28px;
      font-weight: 700;
      color: #172019;
      text-align: center;
      padding: 8px 0;
    }
    .amount-label {
      font-size: 13px;
      color: #6b7b72;
      text-align: center;
    }
    .address-text {
      font-size: 14px;
      line-height: 1.5;
      color: #2d3a31;
    }
    .items-list { max-height: 300px; overflow-y: auto; }
    .item-row {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 8px 0;
      border-bottom: 1px solid #edf0ed;
    }
    .item-row:last-child { border-bottom: none; }
    .item-img {
      width: 48px;
      height: 48px;
      border-radius: 8px;
      object-fit: cover;
      background: #f5f7f5;
      flex-shrink: 0;
    }
    .item-details { flex: 1; min-width: 0; }
    .item-name { font-size: 14px; font-weight: 500; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .item-variant { font-size: 12px; color: #6b7b72; }
    .item-qty { font-size: 14px; color: #6b7b72; flex-shrink: 0; }
    .item-price { font-size: 14px; font-weight: 600; flex-shrink: 0; }
    .countdown {
      text-align: center;
      padding: 12px;
      background: #fff8e1;
      border-radius: 12px;
      margin-bottom: 12px;
      font-size: 14px;
      color: #8d6e00;
    }
    .countdown.expired {
      background: #ffebee;
      color: #c62828;
    }
    .countdown .timer {
      font-size: 20px;
      font-weight: 700;
    }
    .form-group {
      margin-bottom: 12px;
    }
    .form-group label {
      display: block;
      font-size: 13px;
      font-weight: 500;
      color: #2d3a31;
      margin-bottom: 4px;
    }
    .form-group input {
      width: 100%;
      padding: 12px;
      border: 1px solid #d4dbd6;
      border-radius: 8px;
      font-size: 15px;
      outline: none;
      transition: border-color 0.2s;
    }
    .form-group input:focus {
      border-color: #1b8a4c;
    }
    .pay-btn {
      width: 100%;
      padding: 16px;
      background: #1b8a4c;
      color: #fff;
      border: none;
      border-radius: 12px;
      font-size: 18px;
      font-weight: 700;
      cursor: pointer;
      transition: background 0.2s, opacity 0.2s;
    }
    .pay-btn:hover { background: #16733e; }
    .pay-btn:disabled {
      background: #a3c4b2;
      cursor: not-allowed;
      opacity: 0.7;
    }
    .error-page {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 80vh;
      text-align: center;
      padding: 32px;
    }
    .error-page .icon {
      font-size: 64px;
      margin-bottom: 16px;
    }
    .error-page h2 {
      font-size: 20px;
      color: #2d3a31;
      margin-bottom: 8px;
    }
    .error-page p {
      font-size: 14px;
      color: #6b7b72;
      max-width: 320px;
    }
    .status-msg {
      text-align: center;
      padding: 12px;
      border-radius: 8px;
      margin-top: 12px;
      font-size: 14px;
      display: none;
    }
    .status-msg.success { background: #e8f5e9; color: #2e7d32; display: block; }
    .status-msg.error { background: #ffebee; color: #c62828; display: block; }
    @media (max-width: 480px) {
      .container { padding: 12px; }
      .card { padding: 12px; }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>FreshPickKat</h1>
      <p style="color:#6b7b72;font-size:14px;">Secure Payment</p>
    </div>

    <div id="countdown" class="countdown">
      Link expires in <span id="timer" class="timer">--:--</span>
    </div>

    <div class="card">
      <div class="order-number">Order #$orderNumber</div>
      <div class="order-meta">$itemCount item(s)</div>
      <div class="amount-label">Total Amount</div>
      <div class="amount">₹${finalAmount.toStringAsFixed(2)}</div>
    </div>

    <div class="card">
      <h2>Delivery Address</h2>
      <div class="address-text">${_escapeHtml(deliveryAddress)}</div>
    </div>

    <div class="card">
      <h2>Items ($itemCount)</h2>
      <div class="items-list">
        $itemsHtml
      </div>
    </div>

    <div class="card">
      <h2>Payer Details (Optional)</h2>
      <div class="form-group">
        <label for="payerName">Name</label>
        <input type="text" id="payerName" placeholder="Enter your name" maxlength="100">
      </div>
      <div class="form-group">
        <label for="payerPhone">Phone Number</label>
        <input type="tel" id="payerPhone" placeholder="Enter your phone number" maxlength="15">
      </div>
      <div class="form-group">
        <label for="payerEmail">Email</label>
        <input type="email" id="payerEmail" placeholder="Enter your email" maxlength="100">
      </div>
    </div>

    <button id="payBtn" class="pay-btn" onclick="startPayment()">
      Pay Now - ₹${finalAmount.toStringAsFixed(2)}
    </button>

    <div id="statusMsg" class="status-msg"></div>
  </div>

  <script>
    var token = '${_escapeJs(token)}';
    var razorpayKeyId = '${_escapeJs(razorpayKeyId)}';
    var razorpayOrderId = '${_escapeJs(razorpayOrderId)}';
    var amountPaise = $amountPaise;
    var currency = '${_escapeJs(currency)}';
    var expiresAtStr = '${_escapeJs(expiresAt)}';

    // Countdown timer
    function updateCountdown() {
      var timerEl = document.getElementById('timer');
      var countdownEl = document.getElementById('countdown');
      if (!expiresAtStr) { timerEl.textContent = '--:--'; return; }
      var expiresAt = new Date(expiresAtStr);
      var now = new Date();
      var diff = expiresAt - now;
      if (diff <= 0) {
        timerEl.textContent = 'Expired';
        countdownEl.classList.add('expired');
        document.getElementById('payBtn').disabled = true;
        return;
      }
      var minutes = Math.floor(diff / 60000);
      var seconds = Math.floor((diff % 60000) / 1000);
      timerEl.textContent =
        minutes.toString().padStart(2, '0') + ':' +
        seconds.toString().padStart(2, '0');
    }
    updateCountdown();
    setInterval(updateCountdown, 1000);

    // Razorpay payment
    function startPayment() {
      var payerName = document.getElementById('payerName').value.trim();
      var payerPhone = document.getElementById('payerPhone').value.trim();
      var payerEmail = document.getElementById('payerEmail').value.trim();
      var payBtn = document.getElementById('payBtn');
      var statusMsg = document.getElementById('statusMsg');

      payBtn.disabled = true;
      payBtn.textContent = 'Processing...';
      statusMsg.className = 'status-msg';
      statusMsg.style.display = 'none';

      var options = {
        key: razorpayKeyId,
        amount: amountPaise,
        currency: currency,
        name: 'FreshPickKat',
        description: 'Payment for Order',
        order_id: razorpayOrderId,
        handler: function (response) {
          // Send payment confirmation to server
          var xhr = new XMLHttpRequest();
          xhr.open('POST', window.location.origin + '/pay/confirm', true);
          xhr.setRequestHeader('Content-Type', 'application/json');
          xhr.onload = function () {
            if (xhr.status === 200) {
              var result = JSON.parse(xhr.responseText);
              if (result.success) {
                statusMsg.className = 'status-msg success';
                statusMsg.textContent = 'Payment successful! Redirecting...';
                statusMsg.style.display = 'block';
                payBtn.textContent = 'Payment Complete';
                setTimeout(function () {
                  window.location.href = window.location.origin + '/pay/success/' + encodeURIComponent(token);
                }, 2000);
              } else {
                statusMsg.className = 'status-msg error';
                statusMsg.textContent = result.message || 'Payment verification failed. Please contact support.';
                statusMsg.style.display = 'block';
                payBtn.disabled = false;
                payBtn.textContent = 'Pay Again - ₹${finalAmount.toStringAsFixed(2)}';
              }
            } else {
              statusMsg.className = 'status-msg error';
              statusMsg.textContent = 'Payment verification failed. Please try again.';
              statusMsg.style.display = 'block';
              payBtn.disabled = false;
              payBtn.textContent = 'Pay Again - ₹${finalAmount.toStringAsFixed(2)}';
            }
          };
          xhr.onerror = function () {
            statusMsg.className = 'status-msg error';
            statusMsg.textContent = 'Network error. Please check your connection.';
            statusMsg.style.display = 'block';
            payBtn.disabled = false;
            payBtn.textContent = 'Pay Again - ₹${finalAmount.toStringAsFixed(2)}';
          };
          xhr.send(JSON.stringify({
            token: token,
            razorpay_payment_id: response.razorpay_payment_id,
            razorpay_order_id: response.razorpay_order_id,
            razorpay_signature: response.razorpay_signature,
            paidByName: payerName || null,
            paidByPhone: payerPhone || null,
            paidByEmail: payerEmail || null
          }));
        },
        modal: {
          ondismiss: function () {
            payBtn.disabled = false;
            payBtn.textContent = 'Pay Now - ₹${finalAmount.toStringAsFixed(2)}';
          }
        },
        prefill: {
          name: payerName || undefined,
          contact: payerPhone || undefined,
          email: payerEmail || undefined
        },
        theme: {
          color: '#1b8a4c'
        }
      };

      var rzp = new Razorpay(options);
      rzp.on('payment.failed', function (response) {
        statusMsg.className = 'status-msg error';
        statusMsg.textContent = 'Payment failed: ' + (response.error.description || 'Please try again.');
        statusMsg.style.display = 'block';
        payBtn.disabled = false;
        payBtn.textContent = 'Retry - ₹${finalAmount.toStringAsFixed(2)}';
      });
      rzp.open();
    }
  </script>
</body>
</html>
''';

    return Response.ok(
      body: Body.fromString(html, mimeType: MimeType.html),
    );
  }

  Response _invalidLinkPage(String message) {
    final html =
        '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment Link - FreshPickKat</title>
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
    .error-page h2 { font-size: 20px; color: #2d3a31; margin-bottom: 8px; }
    .error-page p { font-size: 14px; color: #6b7b72; }
  </style>
</head>
<body>
  <div class="error-page">
    <div class="icon">&#128274;</div>
    <h2>Payment Link Invalid</h2>
    <p>${_escapeHtml(message)}</p>
  </div>
</body>
</html>
''';
    return Response.ok(
      body: Body.fromString(html, mimeType: MimeType.html),
    );
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  String _escapeJs(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "\\'")
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r');
  }
}
