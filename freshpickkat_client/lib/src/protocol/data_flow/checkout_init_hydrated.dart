/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../data_flow/cart_hydrated_data.dart' as _i2;
import '../data_flow/banner.dart' as _i3;
import '../data_flow/pending_order_info.dart' as _i4;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i5;

abstract class CheckoutInitHydrated implements _i1.SerializableModel {
  CheckoutInitHydrated._({
    required this.cartData,
    required this.checkoutBanners,
    this.activePendingOrder,
  });

  factory CheckoutInitHydrated({
    required _i2.CartHydratedData cartData,
    required List<_i3.Banner> checkoutBanners,
    _i4.PendingOrderInfo? activePendingOrder,
  }) = _CheckoutInitHydratedImpl;

  factory CheckoutInitHydrated.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CheckoutInitHydrated(
      cartData: _i5.Protocol().deserialize<_i2.CartHydratedData>(
        jsonSerialization['cartData'],
      ),
      checkoutBanners: _i5.Protocol().deserialize<List<_i3.Banner>>(
        jsonSerialization['checkoutBanners'],
      ),
      activePendingOrder: jsonSerialization['activePendingOrder'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.PendingOrderInfo>(
              jsonSerialization['activePendingOrder'],
            ),
    );
  }

  _i2.CartHydratedData cartData;

  List<_i3.Banner> checkoutBanners;

  _i4.PendingOrderInfo? activePendingOrder;

  /// Returns a shallow copy of this [CheckoutInitHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckoutInitHydrated copyWith({
    _i2.CartHydratedData? cartData,
    List<_i3.Banner>? checkoutBanners,
    _i4.PendingOrderInfo? activePendingOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckoutInitHydrated',
      'cartData': cartData.toJson(),
      'checkoutBanners': checkoutBanners.toJson(valueToJson: (v) => v.toJson()),
      if (activePendingOrder != null)
        'activePendingOrder': activePendingOrder?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CheckoutInitHydratedImpl extends CheckoutInitHydrated {
  _CheckoutInitHydratedImpl({
    required _i2.CartHydratedData cartData,
    required List<_i3.Banner> checkoutBanners,
    _i4.PendingOrderInfo? activePendingOrder,
  }) : super._(
         cartData: cartData,
         checkoutBanners: checkoutBanners,
         activePendingOrder: activePendingOrder,
       );

  /// Returns a shallow copy of this [CheckoutInitHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckoutInitHydrated copyWith({
    _i2.CartHydratedData? cartData,
    List<_i3.Banner>? checkoutBanners,
    Object? activePendingOrder = _Undefined,
  }) {
    return CheckoutInitHydrated(
      cartData: cartData ?? this.cartData.copyWith(),
      checkoutBanners:
          checkoutBanners ??
          this.checkoutBanners.map((e0) => e0.copyWith()).toList(),
      activePendingOrder: activePendingOrder is _i4.PendingOrderInfo?
          ? activePendingOrder
          : this.activePendingOrder?.copyWith(),
    );
  }
}
