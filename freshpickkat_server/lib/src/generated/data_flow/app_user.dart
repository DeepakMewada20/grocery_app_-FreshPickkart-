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
import '../data_flow/address.dart' as _i2;
import '../data_flow/cart_item.dart' as _i3;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i4;

abstract class AppUser
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AppUser._({
    required this.firebaseUid,
    required this.phoneNumber,
    this.name,
    this.email,
    this.shippingAddress,
    this.cart,
    required this.role,
    this.fcmToken,
    this.completedOrdersCount,
    required this.currentFreshPoints,
    required this.totalEarned,
    required this.totalRedeemed,
    this.referralCode,
    this.referralCodeApplied,
    this.referralSource,
    this.referralAppliedAt,
    this.referralWindowExpiresAt,
    this.referralOnboardingDismissedAt,
  });

  factory AppUser({
    required String firebaseUid,
    required String phoneNumber,
    String? name,
    String? email,
    _i2.Address? shippingAddress,
    List<_i3.CartItem>? cart,
    required String role,
    String? fcmToken,
    int? completedOrdersCount,
    required int currentFreshPoints,
    required int totalEarned,
    required int totalRedeemed,
    String? referralCode,
    String? referralCodeApplied,
    String? referralSource,
    DateTime? referralAppliedAt,
    DateTime? referralWindowExpiresAt,
    DateTime? referralOnboardingDismissedAt,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      firebaseUid: jsonSerialization['firebaseUid'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      name: jsonSerialization['name'] as String?,
      email: jsonSerialization['email'] as String?,
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
      role: jsonSerialization['role'] as String,
      fcmToken: jsonSerialization['fcmToken'] as String?,
      completedOrdersCount: jsonSerialization['completedOrdersCount'] as int?,
      currentFreshPoints: jsonSerialization['currentFreshPoints'] as int,
      totalEarned: jsonSerialization['totalEarned'] as int,
      totalRedeemed: jsonSerialization['totalRedeemed'] as int,
      referralCode: jsonSerialization['referralCode'] as String?,
      referralCodeApplied: jsonSerialization['referralCodeApplied'] as String?,
      referralSource: jsonSerialization['referralSource'] as String?,
      referralAppliedAt: jsonSerialization['referralAppliedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['referralAppliedAt'],
            ),
      referralWindowExpiresAt:
          jsonSerialization['referralWindowExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['referralWindowExpiresAt'],
            ),
      referralOnboardingDismissedAt:
          jsonSerialization['referralOnboardingDismissedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['referralOnboardingDismissedAt'],
            ),
    );
  }

  String firebaseUid;

  String phoneNumber;

  String? name;

  String? email;

  _i2.Address? shippingAddress;

  List<_i3.CartItem>? cart;

  String role;

  String? fcmToken;

  int? completedOrdersCount;

  int currentFreshPoints;

  int totalEarned;

  int totalRedeemed;

  String? referralCode;

  String? referralCodeApplied;

  String? referralSource;

  DateTime? referralAppliedAt;

  DateTime? referralWindowExpiresAt;

  DateTime? referralOnboardingDismissedAt;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUser copyWith({
    String? firebaseUid,
    String? phoneNumber,
    String? name,
    String? email,
    _i2.Address? shippingAddress,
    List<_i3.CartItem>? cart,
    String? role,
    String? fcmToken,
    int? completedOrdersCount,
    int? currentFreshPoints,
    int? totalEarned,
    int? totalRedeemed,
    String? referralCode,
    String? referralCodeApplied,
    String? referralSource,
    DateTime? referralAppliedAt,
    DateTime? referralWindowExpiresAt,
    DateTime? referralOnboardingDismissedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (shippingAddress != null) 'shippingAddress': shippingAddress?.toJson(),
      if (cart != null) 'cart': cart?.toJson(valueToJson: (v) => v.toJson()),
      'role': role,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (completedOrdersCount != null)
        'completedOrdersCount': completedOrdersCount,
      'currentFreshPoints': currentFreshPoints,
      'totalEarned': totalEarned,
      'totalRedeemed': totalRedeemed,
      if (referralCode != null) 'referralCode': referralCode,
      if (referralCodeApplied != null)
        'referralCodeApplied': referralCodeApplied,
      if (referralSource != null) 'referralSource': referralSource,
      if (referralAppliedAt != null)
        'referralAppliedAt': referralAppliedAt?.toJson(),
      if (referralWindowExpiresAt != null)
        'referralWindowExpiresAt': referralWindowExpiresAt?.toJson(),
      if (referralOnboardingDismissedAt != null)
        'referralOnboardingDismissedAt': referralOnboardingDismissedAt
            ?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppUser',
      'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (shippingAddress != null)
        'shippingAddress': shippingAddress?.toJsonForProtocol(),
      if (cart != null)
        'cart': cart?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'role': role,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (completedOrdersCount != null)
        'completedOrdersCount': completedOrdersCount,
      'currentFreshPoints': currentFreshPoints,
      'totalEarned': totalEarned,
      'totalRedeemed': totalRedeemed,
      if (referralCode != null) 'referralCode': referralCode,
      if (referralCodeApplied != null)
        'referralCodeApplied': referralCodeApplied,
      if (referralSource != null) 'referralSource': referralSource,
      if (referralAppliedAt != null)
        'referralAppliedAt': referralAppliedAt?.toJson(),
      if (referralWindowExpiresAt != null)
        'referralWindowExpiresAt': referralWindowExpiresAt?.toJson(),
      if (referralOnboardingDismissedAt != null)
        'referralOnboardingDismissedAt': referralOnboardingDismissedAt
            ?.toJson(),
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
    String? email,
    _i2.Address? shippingAddress,
    List<_i3.CartItem>? cart,
    required String role,
    String? fcmToken,
    int? completedOrdersCount,
    required int currentFreshPoints,
    required int totalEarned,
    required int totalRedeemed,
    String? referralCode,
    String? referralCodeApplied,
    String? referralSource,
    DateTime? referralAppliedAt,
    DateTime? referralWindowExpiresAt,
    DateTime? referralOnboardingDismissedAt,
  }) : super._(
         firebaseUid: firebaseUid,
         phoneNumber: phoneNumber,
         name: name,
         email: email,
         shippingAddress: shippingAddress,
         cart: cart,
         role: role,
         fcmToken: fcmToken,
         completedOrdersCount: completedOrdersCount,
         currentFreshPoints: currentFreshPoints,
         totalEarned: totalEarned,
         totalRedeemed: totalRedeemed,
         referralCode: referralCode,
         referralCodeApplied: referralCodeApplied,
         referralSource: referralSource,
         referralAppliedAt: referralAppliedAt,
         referralWindowExpiresAt: referralWindowExpiresAt,
         referralOnboardingDismissedAt: referralOnboardingDismissedAt,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUser copyWith({
    String? firebaseUid,
    String? phoneNumber,
    Object? name = _Undefined,
    Object? email = _Undefined,
    Object? shippingAddress = _Undefined,
    Object? cart = _Undefined,
    String? role,
    Object? fcmToken = _Undefined,
    Object? completedOrdersCount = _Undefined,
    int? currentFreshPoints,
    int? totalEarned,
    int? totalRedeemed,
    Object? referralCode = _Undefined,
    Object? referralCodeApplied = _Undefined,
    Object? referralSource = _Undefined,
    Object? referralAppliedAt = _Undefined,
    Object? referralWindowExpiresAt = _Undefined,
    Object? referralOnboardingDismissedAt = _Undefined,
  }) {
    return AppUser(
      firebaseUid: firebaseUid ?? this.firebaseUid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name is String? ? name : this.name,
      email: email is String? ? email : this.email,
      shippingAddress: shippingAddress is _i2.Address?
          ? shippingAddress
          : this.shippingAddress?.copyWith(),
      cart: cart is List<_i3.CartItem>?
          ? cart
          : this.cart?.map((e0) => e0.copyWith()).toList(),
      role: role ?? this.role,
      fcmToken: fcmToken is String? ? fcmToken : this.fcmToken,
      completedOrdersCount: completedOrdersCount is int?
          ? completedOrdersCount
          : this.completedOrdersCount,
      currentFreshPoints: currentFreshPoints ?? this.currentFreshPoints,
      totalEarned: totalEarned ?? this.totalEarned,
      totalRedeemed: totalRedeemed ?? this.totalRedeemed,
      referralCode: referralCode is String? ? referralCode : this.referralCode,
      referralCodeApplied: referralCodeApplied is String?
          ? referralCodeApplied
          : this.referralCodeApplied,
      referralSource: referralSource is String?
          ? referralSource
          : this.referralSource,
      referralAppliedAt: referralAppliedAt is DateTime?
          ? referralAppliedAt
          : this.referralAppliedAt,
      referralWindowExpiresAt: referralWindowExpiresAt is DateTime?
          ? referralWindowExpiresAt
          : this.referralWindowExpiresAt,
      referralOnboardingDismissedAt: referralOnboardingDismissedAt is DateTime?
          ? referralOnboardingDismissedAt
          : this.referralOnboardingDismissedAt,
    );
  }
}
