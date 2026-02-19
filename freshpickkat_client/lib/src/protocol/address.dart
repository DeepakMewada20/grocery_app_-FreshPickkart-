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

abstract class Address implements _i1.SerializableModel {
  Address._({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.latitude,
    this.longitude,
  });

  factory Address({
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    double? latitude,
    double? longitude,
  }) = _AddressImpl;

  factory Address.fromJson(Map<String, dynamic> jsonSerialization) {
    return Address(
      street: jsonSerialization['street'] as String,
      city: jsonSerialization['city'] as String,
      state: jsonSerialization['state'] as String,
      zipCode: jsonSerialization['zipCode'] as String,
      country: jsonSerialization['country'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
    );
  }

  String street;

  String city;

  String state;

  String zipCode;

  String country;

  double? latitude;

  double? longitude;

  /// Returns a shallow copy of this [Address]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Address copyWith({
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    double? latitude,
    double? longitude,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Address',
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AddressImpl extends Address {
  _AddressImpl({
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    double? latitude,
    double? longitude,
  }) : super._(
         street: street,
         city: city,
         state: state,
         zipCode: zipCode,
         country: country,
         latitude: latitude,
         longitude: longitude,
       );

  /// Returns a shallow copy of this [Address]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Address copyWith({
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
    );
  }
}
