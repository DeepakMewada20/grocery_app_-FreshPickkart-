import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';

extension CouponDisplayExtension on CouponDisplay {
  String get displayDiscount {
    if (discountAmount != null && discountAmount! > 0) {
      return 'Save ₹${discountAmount!.formatPrice}';
    }

    if (discountType == 'flat') {
      return '₹${(discountValue ?? 0).formatPrice} off';
    } else if (discountType == 'percentage') {
      final maxValue = maxDiscountAmount ?? maxDiscount;
      return '${(discountValue ?? 0).formatPrice}% off${maxValue != null ? ' (max ₹${maxValue.formatPrice})' : ''}';
    }
    return 'Save on subtotal';
  }
}
