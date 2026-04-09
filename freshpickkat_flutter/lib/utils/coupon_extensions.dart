import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';

extension CouponDisplayExtension on CouponDisplay {
  String get displayDiscount {
    if (discountAmount != null && discountAmount! > 0) {
      return 'Save ₹${discountAmount!.formatPrice}';
    }

    if (type == 'PERCENTAGE_DISCOUNT') {
      final maxValue = maxDiscountAmount ?? maxDiscount;
      return '${(discountValue ?? 0).formatPrice}% off${maxValue != null ? ' (max ₹${maxValue.formatPrice})' : ''}';
    }
    return '₹${(discountValue ?? 0).formatPrice} off';
  }
}
