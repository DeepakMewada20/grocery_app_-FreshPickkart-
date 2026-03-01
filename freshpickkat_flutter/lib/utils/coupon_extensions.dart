import 'package:freshpickkat_client/freshpickkat_client.dart';

extension CouponDisplayExtension on CouponDisplay {
  String get displayDiscount {
    if (isDeliveryDiscount) {
      if (maxDiscount != null) {
        return 'Free delivery up to ₹${maxDiscount!.toStringAsFixed(0)}';
      }
      return 'Free delivery';
    }

    if (discountType == 'flat') {
      return '₹${discountValue!.toStringAsFixed(0)} off';
    } else if (discountType == 'percentage') {
      return '${discountValue!.toStringAsFixed(0)}% off${maxDiscount != null ? ' (max ₹${maxDiscount!.toStringAsFixed(0)})' : ''}';
    }
    return '';
  }
}
