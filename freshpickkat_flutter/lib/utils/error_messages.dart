class ErrorMessages {
  ErrorMessages._();

  // ── Network ──
  static const String network =
      'No internet connection. Please check your network.';
  static const String timeout = 'Request timed out. Please try again.';
  static const String serverError =
      'Something went wrong. Please try again later.';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';

  // ── Auth ──
  static const String loginRequired = 'Please login to continue.';
  static const String invalidPhone = 'Invalid phone number format.';
  static const String tooManyRequests =
      'Too many requests. Please try again later.';
  static const String quotaExceeded = 'SMS quota exceeded. Try again tomorrow.';
  static const String otpExpired = 'OTP expired. Please request a new code.';
  static const String invalidOtp =
      'Invalid OTP code. Please check and try again.';
  static const String networkError =
      'Network error. Please check your internet connection.';
  static const String sessionExpired = 'Session expired. Please login again.';
  static const String invalidSession = 'Invalid login session.';
  static const String signInNotEnabled =
      'Phone sign-in is not enabled. Please contact support.';

  // ── Payment ──
  static const String paymentFailed = 'Payment failed. Please try again.';
  static const String paymentCancelled = 'Payment was cancelled.';
  static const String paymentVerifying = 'Verifying your payment...';
  static const String emptyCart = 'Your basket is empty.';
  static const String phoneRequired = 'Phone number is required for payment.';
  static const String paymentConfigError =
      'Payment configuration error. Please contact support.';
  static const String paymentOrderFailed =
      'Payment order failed. Please try again.';
  static const String invalidAmount =
      'Invalid payment amount. Please try again.';
  static const String paymentResponseIncomplete =
      'Payment response incomplete. Please check your orders.';
  static const String paymentRecoveryFailed =
      'Payment recovery failed. Please contact support.';

  // ── Location ──
  static const String locationOff = 'Please turn on GPS to find your location.';
  static const String permissionBlocked =
      'Location permission is blocked. Please enable it from App Settings.';
  static const String locationFailed =
      'Unable to get location. Please try again.';
  static const String addressSaveFailed =
      'Failed to save address. Please try again.';
  static const String addressDetailsFailed =
      'Could not get address details. Please try again.';
  static const String locationUpdated = 'Location updated successfully.';

  // ── Coupon ──
  static const String couponLoadFailed =
      'Unable to load coupons. Pull to refresh.';
  static const String couponInvalid = 'This coupon is not valid for your cart.';
  static const String couponApplyError =
      'Error applying coupon. Please try again.';
  static const String couponRemoved = 'Coupon has been removed.';

  // ── Orders ──
  static const String cancelFailed =
      'Failed to cancel order. Please try again.';
  static const String orderNotFound = 'Order not found.';
  static const String orderCancelledSuccess =
      'Order cancelled successfully. Refund will be tracked automatically.';
  static const String loginToCancel = 'Please login to cancel the order.';

  // Cancel button disabled messages
  static const String cancelPaymentPending =
      'Payment is not completed yet.\nYou cannot cancel this order until the payment process is completed.';
  static const String cancelPaymentFailed =
      'Payment was not successful.\nThis order cannot be cancelled because no successful payment was received.';
  static const String cancelPaymentCancelled =
      'Payment was cancelled.\nThis order is no longer eligible for cancellation.';

  // Post-cancellation status messages
  static const String cancellationRequestSubmitted =
      'Your cancellation request has been submitted successfully.\nOur team will review your request and notify you once a decision is made.';
  static const String cancellationApproved =
      'Your cancellation request has been approved.\nRefund processing has been started.';
  static const String cancellationRejected =
      'Your cancellation request was not approved.\nThe order will continue through the normal delivery process.';
  static const String refundInitiated =
      'Refund has been initiated successfully.\nDepending on your payment method and bank processing time, the amount may take up to 2–5 business days to reflect in your account.';
  static const String refundProcessing =
      'Your refund is currently being processed.\nMost refunds are completed within 2–5 business days depending on your bank and payment method.';
  static const String refundCompleted =
      'Your refund has been completed successfully.\nThe refunded amount should now be available in your original payment method.';
  static const String complaintNotFound = 'Complaint not found.';
  static const String loadComplaintsFailed =
      'Unable to load complaints. Please try again.';
  static const String complaintPeriodExpired =
      'You can only report product issues within 1 day of delivery.';

  // ── Profile ──
  static const String profileSaveFailed =
      'Failed to save profile. Please try again.';
  static const String profileUpdateSuccess = 'Profile updated successfully!';
  static const String profileSavedSuccess = 'Profile saved successfully!';

  // ── Report / Support ──
  static const String unableToSubmit = 'Unable to submit. Please try again.';
  static const String unableToOpen = 'Unable to open. Please try again.';
  static const String deliveryAddressUpdated =
      'Delivery address updated successfully.';
  static const String deliveryNoteSaved = 'Delivery note saved successfully.';
  static const String supportContact =
      'Please contact us at support@freshpickkat.com';

  // ── Validation ──
  static const String submissionInProgress = 'Already processing. Please wait.';
  static const String descriptionTooShort =
      'Description must be at least 20 characters.';
  static const String descriptionTooLong =
      'Description must be 2000 characters or less.';
  static const String selectDeliveryAddress =
      'Please select a delivery address.';
  static const String selectProduct = 'Select at least one affected product.';
  static const String attachImage = 'Please attach at least one image.';
  static const String maxImages = 'You can attach up to 3 images.';
  static const String enterPhoneNumber = 'Please enter your phone number';
  static const String enterValidPhone = 'Please enter a valid phone number';
  static const String enterCompleteOtp = 'Please enter complete OTP';

  // ── Banner ──
  static const String couldNotOpenLink = 'Could not open link';

  // ── Generic ──
  static String operationFailed(String op) =>
      'Failed to $op. Please try again.';
  static String loadFailed(String entity) =>
      'Unable to load $entity. Pull to refresh.';
  static String copied(String code) => '"$code" copied!';
  static String paymentError(String message) =>
      'Payment failed: $message. Please try again.';
}
