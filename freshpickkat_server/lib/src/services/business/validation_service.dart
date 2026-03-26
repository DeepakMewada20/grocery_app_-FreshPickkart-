import 'package:serverpod/serverpod.dart';
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
      throw InvalidParametersException('Product name is required');
    }
    if (product.category.trim().isEmpty) {
      throw InvalidParametersException('Category is required');
    }
    if (product.imageUrl.trim().isEmpty) {
      throw InvalidParametersException('Product image URL is required');
    }
    if (product.subcategory.isEmpty) {
      throw InvalidParametersException('At least one subcategory is required');
    }
    final variants = product.variants ?? const <protocol.ProductVariant>[];
    if (variants.isEmpty && product.quantity.trim().isEmpty) {
      throw InvalidParametersException('At least one variant is required');
    }
    if (product.price < 0 || product.realPrice < 0) {
      throw InvalidParametersException('Price values cannot be negative');
    }
    for (final variant in variants) {
      if (variant.quantityValue <= 0) {
        throw InvalidParametersException(
          'Variant quantity must be greater than 0',
        );
      }
      if (variant.quantityUnit.trim().isEmpty) {
        throw InvalidParametersException('Variant unit is required');
      }
      if (variant.price < 0 || variant.realPrice < 0) {
        throw InvalidParametersException(
          'Variant price values cannot be negative',
        );
      }
    }
    final type = product.discountType?.toLowerCase().trim() ?? 'percentage';
    if (type == 'bogo') {
      if (product.bogoFreeProductIds == null ||
          product.bogoFreeProductIds!.isEmpty) {
        throw InvalidParametersException(
          'At least one free product is required for BOGO offer',
        );
      }
    } else {
      if (product.discountValue != null && product.discountValue! < 0) {
        throw InvalidParametersException('Discount value cannot be negative');
      }
      if (type == 'percentage' &&
          product.discountValue != null &&
          product.discountValue! > 100) {
        throw InvalidParametersException(
          'Percentage discount cannot exceed 100',
        );
      }
    }
  }

  static void validateCoupon(protocol.Coupon coupon) {
    if (coupon.code.trim().isEmpty) {
      throw InvalidParametersException('Coupon code is required');
    }
    if (coupon.description.trim().isEmpty) {
      throw InvalidParametersException('Coupon description is required');
    }
    if (coupon.minOrderAmount < 0) {
      throw InvalidParametersException(
        'Minimum order amount cannot be negative',
      );
    }
    if (coupon.endDate.isBefore(coupon.startDate)) {
      throw InvalidParametersException(
        'Coupon end date must be after start date',
      );
    }
    if (coupon.maxDiscount != null && coupon.maxDiscount! < 0) {
      throw InvalidParametersException('Max discount cannot be negative');
    }
    if (coupon.usageLimit != null && coupon.usageLimit! < 0) {
      throw InvalidParametersException('Usage limit cannot be negative');
    }

    final category = coupon.couponCategory.toLowerCase().trim();
    if (category != 'all' && category != 'delivery') {
      throw InvalidParametersException(
        'Coupon category must be All or delivery',
      );
    }

    if (category == 'delivery') return;

    final type = coupon.discountType?.toLowerCase().trim();
    if (type != 'flat' && type != 'percentage') {
      throw InvalidParametersException(
        'Discount type must be flat or percentage',
      );
    }
    if (coupon.discountValue == null || coupon.discountValue! <= 0) {
      throw InvalidParametersException('Discount value must be greater than 0');
    }
    if (type == 'percentage' && coupon.discountValue! > 100) {
      throw InvalidParametersException('Percentage discount cannot exceed 100');
    }
  }

  static void validateOrderStatusTransition({
    required String currentStatus,
    required String newStatus,
    String? cancellationReason,
  }) {
    final current = currentStatus.toLowerCase().trim();
    final next = newStatus.toLowerCase().trim();

    if (current == next) return;

    const allowed = <String, Set<String>>{
      statusPending: {statusConfirmed, statusCancelled},
      statusConfirmed: {statusOutForDelivery, statusCancelled},
      statusOutForDelivery: {statusDelivered, statusCancelled},
      statusDelivered: {},
      statusCancelled: {},
    };

    final nextAllowed = allowed[current];
    if (nextAllowed == null || !nextAllowed.contains(next)) {
      final currentLabel = _getStatusLabel(current);
      final nextLabel = _getStatusLabel(next);
      throw InvalidParametersException(
        'Cannot change status from "$currentLabel" to "$nextLabel". Please follow the correct order: Pending → Confirmed → Out for Delivery → Delivered',
      );
    }

    if (next == statusCancelled &&
        (cancellationReason == null || cancellationReason.trim().isEmpty)) {
      throw InvalidParametersException(
        'Cancellation reason is required when cancelling an order',
      );
    }
  }

  static String _getStatusLabel(String status) {
    const labels = {
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'out_for_delivery': 'Out for Delivery',
      'delivered': 'Delivered',
      'cancelled': 'Cancelled',
    };
    return labels[status.toLowerCase()] ?? status;
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
      throw InvalidParametersException(
        'Invalid payment status: $paymentStatus',
      );
    }
  }

  static void validateComboOffer(protocol.ComboOffer combo) {
    if (combo.name.trim().isEmpty) {
      throw InvalidParametersException('Combo offer name is required');
    }
    if (combo.comboProducts.isEmpty) {
      throw InvalidParametersException(
        'At least one product is required for combo offer',
      );
    }
    for (final product in combo.comboProducts) {
      if (product.productId.trim().isEmpty) {
        throw InvalidParametersException('Product ID is required in combo');
      }
      if (product.quantity <= 0) {
        throw InvalidParametersException(
          'Product quantity must be greater than 0',
        );
      }
    }
    if (combo.discountType != 'flat' && combo.discountType != 'percentage') {
      throw InvalidParametersException(
        'Discount type must be flat or percentage',
      );
    }
    if (combo.discountValue <= 0) {
      throw InvalidParametersException('Discount value must be greater than 0');
    }
    if (combo.discountType == 'percentage' && combo.discountValue > 100) {
      throw InvalidParametersException('Percentage discount cannot exceed 100');
    }
    if (combo.endDate.isBefore(combo.startDate)) {
      throw InvalidParametersException('End date must be after start date');
    }
  }

  static void validateCategoryOffer(protocol.CategoryOffer offer) {
    if (offer.name.trim().isEmpty) {
      throw InvalidParametersException('Offer name is required');
    }
    if (offer.categoryId.trim().isEmpty) {
      throw InvalidParametersException('Category ID is required');
    }
    if (offer.discountType != 'flat' && offer.discountType != 'percentage') {
      throw InvalidParametersException(
        'Discount type must be flat or percentage',
      );
    }
    if (offer.discountValue <= 0) {
      throw InvalidParametersException('Discount value must be greater than 0');
    }
    if (offer.discountType == 'percentage' && offer.discountValue > 100) {
      throw InvalidParametersException('Percentage discount cannot exceed 100');
    }
    if (offer.maxDiscount != null && offer.maxDiscount! < 0) {
      throw InvalidParametersException('Max discount cannot be negative');
    }
    if (offer.minOrderAmount != null && offer.minOrderAmount! < 0) {
      throw InvalidParametersException('Min order amount cannot be negative');
    }
    if (offer.endDate.isBefore(offer.startDate)) {
      throw InvalidParametersException('End date must be after start date');
    }
  }

  static void validateFreeDeliveryRule(protocol.FreeDeliveryRule rule) {
    if (rule.name.trim().isEmpty) {
      throw InvalidParametersException('Rule name is required');
    }
    if (rule.ruleType != 'min_order_amount' &&
        rule.ruleType != 'min_items' &&
        rule.ruleType != 'coupon' &&
        rule.ruleType != 'user_specific') {
      throw InvalidParametersException('Invalid rule type');
    }
    if (rule.ruleType == 'min_order_amount' &&
        (rule.minOrderAmount == null || rule.minOrderAmount! <= 0)) {
      throw InvalidParametersException(
        'Min order amount is required for min_order_amount type',
      );
    }
    if (rule.ruleType == 'min_items' &&
        (rule.minItemsCount == null || rule.minItemsCount! <= 0)) {
      throw InvalidParametersException(
        'Min items count is required for min_items type',
      );
    }
    if (rule.deliveryFeeWaived < 0) {
      throw InvalidParametersException(
        'Delivery fee waived cannot be negative',
      );
    }
    if (rule.endDate.isBefore(rule.startDate)) {
      throw InvalidParametersException('End date must be after start date');
    }
  }
}
