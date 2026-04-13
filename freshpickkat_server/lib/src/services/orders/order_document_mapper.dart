import 'dart:convert';

import 'package:googleapis/firestore/v1.dart' as firestore_api;

import '../../generated/protocol.dart' as protocol;

class OrderDocumentMapper {
  protocol.Order fromFirestore(
    Map<String, firestore_api.Value> fields,
    String orderId,
  ) {
    return protocol.Order(
      orderId: orderId,
      userId: fields['userId']?.stringValue ?? '',
      userName: fields['userName']?.stringValue,
      userPhone: fields['userPhone']?.stringValue ?? '',
      items:
          fields['items']?.arrayValue?.values
              ?.map(
                (value) =>
                    _orderItemFromFirestore(value.mapValue?.fields ?? {}),
              )
              .toList() ??
          [],
      itemCount: int.tryParse(fields['itemCount']?.integerValue ?? '0') ?? 0,
      totalAmount: getDoubleValue(fields, 'totalAmount'),
      discountAmount: getDoubleValue(fields, 'discountAmount'),
      deliveryFee: getDoubleValue(fields, 'deliveryFee'),
      finalAmount: getDoubleValue(fields, 'finalAmount'),
      status: _normalizeStatus(fields['status']?.stringValue ?? 'placed'),
      paymentStatus: fields['paymentStatus']?.stringValue ?? 'pending',
      refundStatus: fields['refundStatus']?.stringValue ?? 'none',
      razorpayOrderId: fields['razorpayOrderId']?.stringValue,
      razorpayPaymentId: fields['razorpayPaymentId']?.stringValue,
      deliveryAddress: _addressFromFirestore(
        fields['deliveryAddress']?.mapValue?.fields ?? {},
      ),
      orderedAt:
          DateTime.tryParse(fields['orderedAt']?.timestampValue ?? '') ??
          DateTime.now(),
      confirmedAt: fields['confirmedAt']?.timestampValue != null
          ? DateTime.tryParse(fields['confirmedAt']!.timestampValue!)
          : null,
      outForDeliveryAt: fields['outForDeliveryAt']?.timestampValue != null
          ? DateTime.tryParse(fields['outForDeliveryAt']!.timestampValue!)
          : null,
      deliveredAt: fields['deliveredAt']?.timestampValue != null
          ? DateTime.tryParse(fields['deliveredAt']!.timestampValue!)
          : null,
      cancelledAt: fields['cancelledAt']?.timestampValue != null
          ? DateTime.tryParse(fields['cancelledAt']!.timestampValue!)
          : null,
      cancellationReason: fields['cancellationReason']?.stringValue,
      deliveryPersonName: fields['deliveryPersonName']?.stringValue,
      deliveryPersonPhone: fields['deliveryPersonPhone']?.stringValue,
      deliveryOtp: fields['deliveryOtp']?.stringValue,
      couponApplied: fields['couponApplied']?.stringValue,
    );
  }

  Map<String, firestore_api.Value> toFirestore(protocol.Order order) {
    return {
      'orderId': firestore_api.Value(stringValue: order.orderId),
      'userId': firestore_api.Value(stringValue: order.userId),
      'userPhone': firestore_api.Value(stringValue: order.userPhone),
      'items': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: order.items.map(_orderItemToFirestore).toList(),
        ),
      ),
      'itemCount': firestore_api.Value(
        integerValue: order.itemCount.toString(),
      ),
      'totalAmount': firestore_api.Value(doubleValue: order.totalAmount),
      'discountAmount': firestore_api.Value(doubleValue: order.discountAmount),
      'deliveryFee': firestore_api.Value(doubleValue: order.deliveryFee),
      'finalAmount': firestore_api.Value(doubleValue: order.finalAmount),
      'status': firestore_api.Value(stringValue: order.status),
      'paymentStatus': firestore_api.Value(stringValue: order.paymentStatus),
      'refundStatus': firestore_api.Value(stringValue: order.refundStatus),
      'deliveryAddress': firestore_api.Value(
        mapValue: firestore_api.MapValue(
          fields: _addressToFirestore(order.deliveryAddress),
        ),
      ),
      'orderedAt': firestore_api.Value(
        timestampValue: order.orderedAt.toUtc().toIso8601String(),
      ),
      if (order.razorpayOrderId != null)
        'razorpayOrderId': firestore_api.Value(
          stringValue: order.razorpayOrderId!,
        ),
      if (order.razorpayPaymentId != null)
        'razorpayPaymentId': firestore_api.Value(
          stringValue: order.razorpayPaymentId!,
        ),
      if (order.userName != null)
        'userName': firestore_api.Value(stringValue: order.userName!),
      if (order.confirmedAt != null)
        'confirmedAt': firestore_api.Value(
          timestampValue: order.confirmedAt!.toUtc().toIso8601String(),
        ),
      if (order.outForDeliveryAt != null)
        'outForDeliveryAt': firestore_api.Value(
          timestampValue: order.outForDeliveryAt!.toUtc().toIso8601String(),
        ),
      if (order.deliveredAt != null)
        'deliveredAt': firestore_api.Value(
          timestampValue: order.deliveredAt!.toUtc().toIso8601String(),
        ),
      if (order.cancelledAt != null)
        'cancelledAt': firestore_api.Value(
          timestampValue: order.cancelledAt!.toUtc().toIso8601String(),
        ),
      if (order.cancellationReason != null)
        'cancellationReason': firestore_api.Value(
          stringValue: order.cancellationReason!,
        ),
      if (order.deliveryPersonName != null)
        'deliveryPersonName': firestore_api.Value(
          stringValue: order.deliveryPersonName!,
        ),
      if (order.deliveryPersonPhone != null)
        'deliveryPersonPhone': firestore_api.Value(
          stringValue: order.deliveryPersonPhone!,
        ),
      if (order.deliveryOtp != null)
        'deliveryOtp': firestore_api.Value(stringValue: order.deliveryOtp!),
      if (order.couponApplied != null)
        'couponApplied': firestore_api.Value(stringValue: order.couponApplied!),
    };
  }

  String _normalizeStatus(String status) {
    final value = status.toLowerCase().trim();
    if (value.isEmpty || value == 'pending') return 'placed';
    return value;
  }

  String toJsonString(protocol.Order order) => jsonEncode(order.toJson());

  protocol.Order? fromJsonString(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        return protocol.Order.fromJson(decoded);
      }
      if (decoded is Map) {
        return protocol.Order.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return null;
  }

  double getDoubleValue(Map<String, firestore_api.Value> fields, String key) {
    final value = fields[key];
    if (value == null) return 0.0;
    if (value.doubleValue != null) return value.doubleValue!;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return double.tryParse(value.integerValue!) ?? 0.0;
    }
    return 0.0;
  }

  int getIntValue(Map<String, firestore_api.Value> fields, String key) {
    final value = fields[key];
    if (value == null) return 0;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return int.tryParse(value.integerValue!) ?? 0;
    }
    if (value.doubleValue != null) return value.doubleValue!.round();
    return 0;
  }

  protocol.OrderItem _orderItemFromFirestore(
    Map<String, firestore_api.Value> fields,
  ) {
    return protocol.OrderItem(
      productId: fields['productId']?.stringValue ?? '',
      variantId: fields['variantId']?.stringValue,
      variantLabel: fields['variantLabel']?.stringValue,
      productName: fields['productName']?.stringValue ?? '',
      productImage: fields['productImage']?.stringValue ?? '',
      quantity: int.tryParse(fields['quantity']?.integerValue ?? '0') ?? 0,
      unitPrice: getDoubleValue(fields, 'unitPrice'),
      totalPrice: getDoubleValue(fields, 'totalPrice'),
      isFreeItem: fields['isFreeItem']?.booleanValue ?? false,
      triggerProductId: fields['triggerProductId']?.stringValue,
      comboId: fields['comboId']?.stringValue,
      comboName: fields['comboName']?.stringValue,
      comboDiscountType: fields['comboDiscountType']?.stringValue,
      comboDiscountValue: getNullableDoubleValue(fields, 'comboDiscountValue'),
      comboItemQuantity: int.tryParse(
        fields['comboItemQuantity']?.integerValue ?? '',
      ),
    );
  }

  firestore_api.Value _orderItemToFirestore(protocol.OrderItem item) {
    return firestore_api.Value(
      mapValue: firestore_api.MapValue(
        fields: {
          'productId': firestore_api.Value(stringValue: item.productId),
          if (item.variantId != null)
            'variantId': firestore_api.Value(stringValue: item.variantId!),
          if (item.variantLabel != null)
            'variantLabel': firestore_api.Value(
              stringValue: item.variantLabel!,
            ),
          'productName': firestore_api.Value(stringValue: item.productName),
          'productImage': firestore_api.Value(stringValue: item.productImage),
          'quantity': firestore_api.Value(
            integerValue: item.quantity.toString(),
          ),
          'unitPrice': firestore_api.Value(doubleValue: item.unitPrice),
          'totalPrice': firestore_api.Value(doubleValue: item.totalPrice),
          'isFreeItem': firestore_api.Value(booleanValue: item.isFreeItem),
          if (item.triggerProductId != null)
            'triggerProductId': firestore_api.Value(
              stringValue: item.triggerProductId!,
            ),
          if (item.comboId != null)
            'comboId': firestore_api.Value(stringValue: item.comboId!),
          if (item.comboName != null)
            'comboName': firestore_api.Value(stringValue: item.comboName!),
          if (item.comboDiscountType != null)
            'comboDiscountType': firestore_api.Value(
              stringValue: item.comboDiscountType!,
            ),
          if (item.comboDiscountValue != null)
            'comboDiscountValue': firestore_api.Value(
              doubleValue: item.comboDiscountValue!,
            ),
          if (item.comboItemQuantity != null)
            'comboItemQuantity': firestore_api.Value(
              integerValue: item.comboItemQuantity!.toString(),
            ),
        },
      ),
    );
  }

  protocol.Address _addressFromFirestore(
    Map<String, firestore_api.Value> fields,
  ) {
    return protocol.Address(
      street: fields['street']?.stringValue ?? '',
      city: fields['city']?.stringValue ?? '',
      state: fields['state']?.stringValue ?? '',
      zipCode: fields['zipCode']?.stringValue ?? '',
      country: fields['country']?.stringValue ?? '',
      latitude: fields['latitude']?.doubleValue,
      longitude: fields['longitude']?.doubleValue,
    );
  }

  Map<String, firestore_api.Value> _addressToFirestore(
    protocol.Address address,
  ) {
    final map = <String, firestore_api.Value>{
      'street': firestore_api.Value(stringValue: address.street),
      'city': firestore_api.Value(stringValue: address.city),
      'state': firestore_api.Value(stringValue: address.state),
      'zipCode': firestore_api.Value(stringValue: address.zipCode),
      'country': firestore_api.Value(stringValue: address.country),
    };
    if (address.latitude != null) {
      map['latitude'] = firestore_api.Value(doubleValue: address.latitude);
    }
    if (address.longitude != null) {
      map['longitude'] = firestore_api.Value(doubleValue: address.longitude);
    }
    return map;
  }

  double? getNullableDoubleValue(
    Map<String, firestore_api.Value> fields,
    String key,
  ) {
    final value = fields[key];
    if (value == null) return null;
    if (value.doubleValue != null) return value.doubleValue!;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return double.tryParse(value.integerValue!);
    }
    return null;
  }
}
