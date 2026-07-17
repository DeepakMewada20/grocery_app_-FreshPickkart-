window.razorpayCheckout = function(options) {
  return new Promise(function(resolve, reject) {
    function loadScript() {
      return new Promise(function(scriptResolve, scriptReject) {
        if (typeof Razorpay !== 'undefined') {
          scriptResolve();
          return;
        }
        var script = document.createElement('script');
        script.src = 'https://checkout.razorpay.com/v1/checkout.js';
        script.async = true;
        script.onload = scriptResolve;
        script.onerror = function() {
          scriptReject(new Error('Failed to load Razorpay SDK'));
        };
        document.body.appendChild(script);
      });
    }

    loadScript().then(function() {
      options.handler = function(response) {
        resolve({
          status: 'success',
          razorpay_payment_id: response.razorpay_payment_id,
          razorpay_order_id: response.razorpay_order_id,
          razorpay_signature: response.razorpay_signature
        });
      };

      if (!options.modal) {
        options.modal = {};
      }
      options.modal.ondismiss = function() {
        resolve({ status: 'cancelled' });
      };

      var rzp = new Razorpay(options);
      rzp.on('payment.failed', function(response) {
        resolve({
          status: 'failed',
          error: response.error || {}
        });
      });
      rzp.open();
    }).catch(function(err) {
      reject(err.message || 'Failed to initialize payment');
    });
  });
};
