import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';

extension CouponDisplayExtension on CouponDisplay {
  String get displayDiscount {
    if (isDeliveryDiscount) {
      if (maxDiscount != null) {
        return 'Free delivery up to ₹${maxDiscount!.formatPrice}';
      }
      return 'Free delivery';
    }

    if (discountType == 'flat') {
      return '₹${discountValue!.formatPrice} off';
    } else if (discountType == 'percentage') {
      return '${discountValue!.formatPrice}% off${maxDiscount != null ? ' (max ₹${maxDiscount!.formatPrice})' : ''}';
    }
    return '';
  }
}
