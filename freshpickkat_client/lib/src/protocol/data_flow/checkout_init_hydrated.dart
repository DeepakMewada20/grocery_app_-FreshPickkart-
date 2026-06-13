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
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i4;

abstract class CheckoutInitHydrated implements _i1.SerializableModel {
  CheckoutInitHydrated._({
    required this.cartData,
    required this.checkoutBanners,
  });

  factory CheckoutInitHydrated({
    required _i2.CartHydratedData cartData,
    required List<_i3.Banner> checkoutBanners,
  }) = _CheckoutInitHydratedImpl;

  factory CheckoutInitHydrated.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CheckoutInitHydrated(
      cartData: _i4.Protocol().deserialize<_i2.CartHydratedData>(
        jsonSerialization['cartData'],
      ),
      checkoutBanners: _i4.Protocol().deserialize<List<_i3.Banner>>(
        jsonSerialization['checkoutBanners'],
      ),
    );
  }

  _i2.CartHydratedData cartData;

  List<_i3.Banner> checkoutBanners;

  /// Returns a shallow copy of this [CheckoutInitHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckoutInitHydrated copyWith({
    _i2.CartHydratedData? cartData,
    List<_i3.Banner>? checkoutBanners,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckoutInitHydrated',
      'cartData': cartData.toJson(),
      'checkoutBanners': checkoutBanners.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CheckoutInitHydratedImpl extends CheckoutInitHydrated {
  _CheckoutInitHydratedImpl({
    required _i2.CartHydratedData cartData,
    required List<_i3.Banner> checkoutBanners,
  }) : super._(
         cartData: cartData,
         checkoutBanners: checkoutBanners,
       );

  /// Returns a shallow copy of this [CheckoutInitHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckoutInitHydrated copyWith({
    _i2.CartHydratedData? cartData,
    List<_i3.Banner>? checkoutBanners,
  }) {
    return CheckoutInitHydrated(
      cartData: cartData ?? this.cartData.copyWith(),
      checkoutBanners:
          checkoutBanners ??
          this.checkoutBanners.map((e0) => e0.copyWith()).toList(),
    );
  }
}
