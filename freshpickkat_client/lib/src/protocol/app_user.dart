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
import 'cart_item.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class AppUser implements _i1.SerializableModel {
  AppUser._({
    this.id,
    required this.firebaseUid,
    required this.phoneNumber,
    this.name,
    this.address,
    this.cart,
  });

  factory AppUser({
    int? id,
    required String firebaseUid,
    required String phoneNumber,
    String? name,
    String? address,
    List<_i2.CartItem>? cart,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      firebaseUid: jsonSerialization['firebaseUid'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      name: jsonSerialization['name'] as String?,
      address: jsonSerialization['address'] as String?,
      cart: jsonSerialization['cart'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.CartItem>>(
              jsonSerialization['cart'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String firebaseUid;

  String phoneNumber;

  String? name;

  String? address;

  List<_i2.CartItem>? cart;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUser copyWith({
    int? id,
    String? firebaseUid,
    String? phoneNumber,
    String? name,
    String? address,
    List<_i2.CartItem>? cart,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
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
    int? id,
    required String firebaseUid,
    required String phoneNumber,
    String? name,
    String? address,
    List<_i2.CartItem>? cart,
  }) : super._(
         id: id,
         firebaseUid: firebaseUid,
         phoneNumber: phoneNumber,
         name: name,
         address: address,
         cart: cart,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    String? firebaseUid,
    String? phoneNumber,
    Object? name = _Undefined,
    Object? address = _Undefined,
    Object? cart = _Undefined,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name is String? ? name : this.name,
      address: address is String? ? address : this.address,
      cart: cart is List<_i2.CartItem>?
          ? cart
          : this.cart?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
