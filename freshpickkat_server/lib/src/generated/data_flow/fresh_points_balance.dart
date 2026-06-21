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
import '../data_flow/fresh_points_transaction.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class FreshPointsBalance
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FreshPointsBalance._({
    required this.balance,
    required this.totalEarned,
    required this.totalRedeemed,
    required this.transactions,
  });

  factory FreshPointsBalance({
    required int balance,
    required int totalEarned,
    required int totalRedeemed,
    required List<_i2.FreshPointsTransaction> transactions,
  }) = _FreshPointsBalanceImpl;

  factory FreshPointsBalance.fromJson(Map<String, dynamic> jsonSerialization) {
    return FreshPointsBalance(
      balance: jsonSerialization['balance'] as int,
      totalEarned: jsonSerialization['totalEarned'] as int,
      totalRedeemed: jsonSerialization['totalRedeemed'] as int,
      transactions: _i3.Protocol()
          .deserialize<List<_i2.FreshPointsTransaction>>(
            jsonSerialization['transactions'],
          ),
    );
  }

  int balance;

  int totalEarned;

  int totalRedeemed;

  List<_i2.FreshPointsTransaction> transactions;

  /// Returns a shallow copy of this [FreshPointsBalance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreshPointsBalance copyWith({
    int? balance,
    int? totalEarned,
    int? totalRedeemed,
    List<_i2.FreshPointsTransaction>? transactions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FreshPointsBalance',
      'balance': balance,
      'totalEarned': totalEarned,
      'totalRedeemed': totalRedeemed,
      'transactions': transactions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FreshPointsBalance',
      'balance': balance,
      'totalEarned': totalEarned,
      'totalRedeemed': totalRedeemed,
      'transactions': transactions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FreshPointsBalanceImpl extends FreshPointsBalance {
  _FreshPointsBalanceImpl({
    required int balance,
    required int totalEarned,
    required int totalRedeemed,
    required List<_i2.FreshPointsTransaction> transactions,
  }) : super._(
         balance: balance,
         totalEarned: totalEarned,
         totalRedeemed: totalRedeemed,
         transactions: transactions,
       );

  /// Returns a shallow copy of this [FreshPointsBalance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreshPointsBalance copyWith({
    int? balance,
    int? totalEarned,
    int? totalRedeemed,
    List<_i2.FreshPointsTransaction>? transactions,
  }) {
    return FreshPointsBalance(
      balance: balance ?? this.balance,
      totalEarned: totalEarned ?? this.totalEarned,
      totalRedeemed: totalRedeemed ?? this.totalRedeemed,
      transactions:
          transactions ?? this.transactions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
