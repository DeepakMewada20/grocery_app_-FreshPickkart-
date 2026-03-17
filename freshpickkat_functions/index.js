const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.getRazorpayKeyId = functions.https.onRequest((req, res) => {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  const keyId =
    functions.config()?.razorpay?.key_id || process.env.RAZORPAY_KEY_ID;

  if (!keyId) {
    res.status(500).json({
      ok: false,
      error: 'RAZORPAY_KEY_ID is not configured',
    });
    return;
  }

  res.status(200).json({
    ok: true,
    keyId,
  });
});
