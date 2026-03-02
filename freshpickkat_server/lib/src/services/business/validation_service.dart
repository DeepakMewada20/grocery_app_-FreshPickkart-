import '../../generated/protocol.dart' as protocol;

class ValidationService {
  static const statusPending = 'pending';
  static const statusConfirmed = 'confirmed';
  static const statusOutForDelivery = 'out_for_delivery';
  static const statusDelivered = 'delivered';
  static const statusCancelled = 'cancelled';

  static const paymentPending = 'pending';
  static const paymentPaid = 'paid';
  static const paymentFailed = 'failed';
  static const paymentRefunded = 'refunded';

  static void validateProduct(protocol.Product product) {
    if (product.productName.trim().isEmpty) {
      throw ArgumentError('Product name is required');
    }
    if (product.category.trim().isEmpty) {
      throw ArgumentError('Category is required');
    }
    if (product.imageUrl.trim().isEmpty) {
      throw ArgumentError('Product image URL is required');
    }
    if (product.quantity.trim().isEmpty) {
      throw ArgumentError('Quantity is required');
    }
    if (product.subcategory.isEmpty) {
      throw ArgumentError('At least one subcategory is required');
    }
    if (product.price < 0 || product.realPrice < 0) {
      throw ArgumentError('Price values cannot be negative');
    }
  }

  static void validateCoupon(protocol.Coupon coupon) {
    if (coupon.code.trim().isEmpty) {
      throw ArgumentError('Coupon code is required');
    }
    if (coupon.description.trim().isEmpty) {
      throw ArgumentError('Coupon description is required');
    }
    if (coupon.minOrderAmount < 0) {
      throw ArgumentError('Minimum order amount cannot be negative');
    }
    if (coupon.endDate.isBefore(coupon.startDate)) {
      throw ArgumentError('Coupon end date must be after start date');
    }
    if (coupon.maxDiscount != null && coupon.maxDiscount! < 0) {
      throw ArgumentError('Max discount cannot be negative');
    }
    if (coupon.usageLimit != null && coupon.usageLimit! < 0) {
      throw ArgumentError('Usage limit cannot be negative');
    }

    final category = coupon.couponCategory.toLowerCase().trim();
    if (category != 'all' && category != 'delivery') {
      throw ArgumentError('Coupon category must be All or delivery');
    }

    if (category == 'delivery') return;

    final type = coupon.discountType?.toLowerCase().trim();
    if (type != 'flat' && type != 'percentage') {
      throw ArgumentError('Discount type must be flat or percentage');
    }
    if (coupon.discountValue == null || coupon.discountValue! <= 0) {
      throw ArgumentError('Discount value must be greater than 0');
    }
    if (type == 'percentage' && coupon.discountValue! > 100) {
      throw ArgumentError('Percentage discount cannot exceed 100');
    }
  }

  static void validateOrderStatusTransition({
    required String currentStatus,
    required String newStatus,
    String? cancellationReason,
  }) {
    final current = currentStatus.toLowerCase().trim();
    final next = newStatus.toLowerCase().trim();

    const allowed = <String, Set<String>>{
      statusPending: {statusConfirmed, statusCancelled},
      statusConfirmed: {statusOutForDelivery, statusCancelled},
      statusOutForDelivery: {statusDelivered, statusCancelled},
      statusDelivered: {},
      statusCancelled: {},
    };

    if (current == next) return;

    final nextAllowed = allowed[current];
    if (nextAllowed == null || !nextAllowed.contains(next)) {
      throw ArgumentError(
        'Invalid order status transition: $currentStatus -> $newStatus',
      );
    }

    if (next == statusCancelled &&
        (cancellationReason == null || cancellationReason.trim().isEmpty)) {
      throw ArgumentError(
        'Cancellation reason is required for cancelled status',
      );
    }
  }

  static void validatePaymentStatus(String paymentStatus) {
    final value = paymentStatus.toLowerCase().trim();
    const allowed = {
      paymentPending,
      paymentPaid,
      paymentFailed,
      paymentRefunded,
    };
    if (!allowed.contains(value)) {
      throw ArgumentError('Invalid payment status: $paymentStatus');
    }
  }
}
