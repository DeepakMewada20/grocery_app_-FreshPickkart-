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
import 'package:serverpod/serverpod.dart' as _i1;
import '../data_flow/cart_hydrated_data.dart' as _i2;
import '../data_flow/banner.dart' as _i3;
import '../data_flow/pending_order_info.dart' as _i4;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i5;

abstract class CheckoutInitHydrated
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CheckoutInitHydrated._({
    required this.cartData,
    required this.checkoutBanners,
    this.activePendingOrder,
    bool? codAvailable,
    this.codDisabledReason,
  }) : codAvailable = codAvailable ?? true;

  factory CheckoutInitHydrated({
    required _i2.CartHydratedData cartData,
    required List<_i3.Banner> checkoutBanners,
    _i4.PendingOrderInfo? activePendingOrder,
    bool? codAvailable,
    String? codDisabledReason,
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
      codAvailable: jsonSerialization['codAvailable'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['codAvailable']),
      codDisabledReason: jsonSerialization['codDisabledReason'] as String?,
    );
  }

  _i2.CartHydratedData cartData;

  List<_i3.Banner> checkoutBanners;

  _i4.PendingOrderInfo? activePendingOrder;

  bool codAvailable;

  String? codDisabledReason;

  /// Returns a shallow copy of this [CheckoutInitHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckoutInitHydrated copyWith({
    _i2.CartHydratedData? cartData,
    List<_i3.Banner>? checkoutBanners,
    _i4.PendingOrderInfo? activePendingOrder,
    bool? codAvailable,
    String? codDisabledReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckoutInitHydrated',
      'cartData': cartData.toJson(),
      'checkoutBanners': checkoutBanners.toJson(valueToJson: (v) => v.toJson()),
      if (activePendingOrder != null)
        'activePendingOrder': activePendingOrder?.toJson(),
      'codAvailable': codAvailable,
      if (codDisabledReason != null) 'codDisabledReason': codDisabledReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CheckoutInitHydrated',
      'cartData': cartData.toJsonForProtocol(),
      'checkoutBanners': checkoutBanners.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (activePendingOrder != null)
        'activePendingOrder': activePendingOrder?.toJsonForProtocol(),
      'codAvailable': codAvailable,
      if (codDisabledReason != null) 'codDisabledReason': codDisabledReason,
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
    bool? codAvailable,
    String? codDisabledReason,
  }) : super._(
         cartData: cartData,
         checkoutBanners: checkoutBanners,
         activePendingOrder: activePendingOrder,
         codAvailable: codAvailable,
         codDisabledReason: codDisabledReason,
       );

  /// Returns a shallow copy of this [CheckoutInitHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckoutInitHydrated copyWith({
    _i2.CartHydratedData? cartData,
    List<_i3.Banner>? checkoutBanners,
    Object? activePendingOrder = _Undefined,
    bool? codAvailable,
    Object? codDisabledReason = _Undefined,
  }) {
    return CheckoutInitHydrated(
      cartData: cartData ?? this.cartData.copyWith(),
      checkoutBanners:
          checkoutBanners ??
          this.checkoutBanners.map((e0) => e0.copyWith()).toList(),
      activePendingOrder: activePendingOrder is _i4.PendingOrderInfo?
          ? activePendingOrder
          : this.activePendingOrder?.copyWith(),
      codAvailable: codAvailable ?? this.codAvailable,
      codDisabledReason: codDisabledReason is String?
          ? codDisabledReason
          : this.codDisabledReason,
    );
  }
}
