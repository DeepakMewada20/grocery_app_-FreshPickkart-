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
import 'address.dart' as _i2;
import 'cart_item.dart' as _i3;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i4;

abstract class AppUser implements _i1.SerializableModel {
  AppUser._({
    required this.firebaseUid,
    required this.phoneNumber,
    this.name,
    this.shippingAddress,
    this.cart,
  });

  factory AppUser({
    required String firebaseUid,
    required String phoneNumber,
    String? name,
    _i2.Address? shippingAddress,
    List<_i3.CartItem>? cart,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      firebaseUid: jsonSerialization['firebaseUid'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      name: jsonSerialization['name'] as String?,
      shippingAddress: jsonSerialization['shippingAddress'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Address>(
              jsonSerialization['shippingAddress'],
            ),
      cart: jsonSerialization['cart'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i3.CartItem>>(
              jsonSerialization['cart'],
            ),
    );
  }

  String firebaseUid;

  String phoneNumber;

  String? name;

  _i2.Address? shippingAddress;

  List<_i3.CartItem>? cart;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUser copyWith({
    String? firebaseUid,
    String? phoneNumber,
    String? name,
    _i2.Address? shippingAddress,
    List<_i3.CartItem>? cart,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      if (name != null) 'name': name,
      if (shippingAddress != null) 'shippingAddress': shippingAddress?.toJson(),
      if (cart != null) 'cart': cart?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    required String firebaseUid,
    required String phoneNumber,
    String? name,
    _i2.Address? shippingAddress,
    List<_i3.CartItem>? cart,
  }) : super._(
         firebaseUid: firebaseUid,
         phoneNumber: phoneNumber,
         name: name,
         shippingAddress: shippingAddress,
         cart: cart,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUser copyWith({
    String? firebaseUid,
    String? phoneNumber,
    Object? name = _Undefined,
    Object? shippingAddress = _Undefined,
    Object? cart = _Undefined,
  }) {
    return AppUser(
      firebaseUid: firebaseUid ?? this.firebaseUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name is String? ? name : this.name,
      shippingAddress: shippingAddress is _i2.Address?
          ? shippingAddress
          : this.shippingAddress?.copyWith(),
      cart: cart is List<_i3.CartItem>?
          ? cart
          : this.cart?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
