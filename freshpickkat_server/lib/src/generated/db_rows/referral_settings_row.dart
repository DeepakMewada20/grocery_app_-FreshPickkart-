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

abstract class ReferralSettingsRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ReferralSettingsRow._({
    this.id,
    bool? isEnabled,
    bool? inviteeCouponEnabled,
    double? inviteeCouponAmount,
    String? inviteeCouponCodeTemplate,
    bool? referrerPointsEnabled,
    int? referrerRewardPoints,
    String? rewardTriggerStatus,
    int? maxRewardedPerMonth,
    bool? enableFraudProtection,
    double? inviteeCouponMinOrderAmount,
    int? inviteeCouponValidityDays,
    bool? enableReferralExpiry,
    int? referralExpiryDays,
    String? shareMessageTemplate,
    this.lastUpdatedBy,
    bool? enableFraudScoring,
    int? autoApproveThreshold,
    int? manualReviewThreshold,
    int? autoRejectThreshold,
    bool? enableRewardHold,
    int? holdDurationHours,
    bool? enableAutoReject,
    double? minimumActualPaymentForQualification,
    int? maxRewardedPerDay,
    int? maxPendingReferrals,
    int? maxSharesPerDay,
    int? maxSharesPerMonth,
    int? referralVelocityScore,
    int? velocityTimeWindowHours,
    int? velocityThreshold,
    int? autoReversalWindowDays,
    this.termsText,
    DateTime? updatedAt,
  }) : isEnabled = isEnabled ?? true,
       inviteeCouponEnabled = inviteeCouponEnabled ?? true,
       inviteeCouponAmount = inviteeCouponAmount ?? 50.0,
       inviteeCouponCodeTemplate = inviteeCouponCodeTemplate ?? 'WELCOME{CODE}',
       referrerPointsEnabled = referrerPointsEnabled ?? true,
       referrerRewardPoints = referrerRewardPoints ?? 50,
       rewardTriggerStatus = rewardTriggerStatus ?? 'DELIVERED',
       maxRewardedPerMonth = maxRewardedPerMonth ?? 20,
       enableFraudProtection = enableFraudProtection ?? true,
       inviteeCouponMinOrderAmount = inviteeCouponMinOrderAmount ?? 199.0,
       inviteeCouponValidityDays = inviteeCouponValidityDays ?? 15,
       enableReferralExpiry = enableReferralExpiry ?? false,
       referralExpiryDays = referralExpiryDays ?? 90,
       shareMessageTemplate =
           shareMessageTemplate ??
           'Join FreshPickKat using my referral code {CODE}. Get ₹50 OFF on your first order!',
       enableFraudScoring = enableFraudScoring ?? true,
       autoApproveThreshold = autoApproveThreshold ?? 40,
       manualReviewThreshold = manualReviewThreshold ?? 69,
       autoRejectThreshold = autoRejectThreshold ?? 90,
       enableRewardHold = enableRewardHold ?? true,
       holdDurationHours = holdDurationHours ?? 72,
       enableAutoReject = enableAutoReject ?? true,
       minimumActualPaymentForQualification =
           minimumActualPaymentForQualification ?? 0.0,
       maxRewardedPerDay = maxRewardedPerDay ?? 3,
       maxPendingReferrals = maxPendingReferrals ?? 50,
       maxSharesPerDay = maxSharesPerDay ?? 100,
       maxSharesPerMonth = maxSharesPerMonth ?? 1000,
       referralVelocityScore = referralVelocityScore ?? 30,
       velocityTimeWindowHours = velocityTimeWindowHours ?? 24,
       velocityThreshold = velocityThreshold ?? 3,
       autoReversalWindowDays = autoReversalWindowDays ?? 30,
       updatedAt = updatedAt ?? DateTime.now();

  factory ReferralSettingsRow({
    _i1.UuidValue? id,
    bool? isEnabled,
    bool? inviteeCouponEnabled,
    double? inviteeCouponAmount,
    String? inviteeCouponCodeTemplate,
    bool? referrerPointsEnabled,
    int? referrerRewardPoints,
    String? rewardTriggerStatus,
    int? maxRewardedPerMonth,
    bool? enableFraudProtection,
    double? inviteeCouponMinOrderAmount,
    int? inviteeCouponValidityDays,
    bool? enableReferralExpiry,
    int? referralExpiryDays,
    String? shareMessageTemplate,
    _i1.UuidValue? lastUpdatedBy,
    bool? enableFraudScoring,
    int? autoApproveThreshold,
    int? manualReviewThreshold,
    int? autoRejectThreshold,
    bool? enableRewardHold,
    int? holdDurationHours,
    bool? enableAutoReject,
    double? minimumActualPaymentForQualification,
    int? maxRewardedPerDay,
    int? maxPendingReferrals,
    int? maxSharesPerDay,
    int? maxSharesPerMonth,
    int? referralVelocityScore,
    int? velocityTimeWindowHours,
    int? velocityThreshold,
    int? autoReversalWindowDays,
    String? termsText,
    DateTime? updatedAt,
  }) = _ReferralSettingsRowImpl;

  factory ReferralSettingsRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferralSettingsRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      isEnabled: jsonSerialization['isEnabled'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isEnabled']),
      inviteeCouponEnabled: jsonSerialization['inviteeCouponEnabled'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['inviteeCouponEnabled'],
            ),
      inviteeCouponAmount: (jsonSerialization['inviteeCouponAmount'] as num?)
          ?.toDouble(),
      inviteeCouponCodeTemplate:
          jsonSerialization['inviteeCouponCodeTemplate'] as String?,
      referrerPointsEnabled: jsonSerialization['referrerPointsEnabled'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['referrerPointsEnabled'],
            ),
      referrerRewardPoints: jsonSerialization['referrerRewardPoints'] as int?,
      rewardTriggerStatus: jsonSerialization['rewardTriggerStatus'] as String?,
      maxRewardedPerMonth: jsonSerialization['maxRewardedPerMonth'] as int?,
      enableFraudProtection: jsonSerialization['enableFraudProtection'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['enableFraudProtection'],
            ),
      inviteeCouponMinOrderAmount:
          (jsonSerialization['inviteeCouponMinOrderAmount'] as num?)
              ?.toDouble(),
      inviteeCouponValidityDays:
          jsonSerialization['inviteeCouponValidityDays'] as int?,
      enableReferralExpiry: jsonSerialization['enableReferralExpiry'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['enableReferralExpiry'],
            ),
      referralExpiryDays: jsonSerialization['referralExpiryDays'] as int?,
      shareMessageTemplate:
          jsonSerialization['shareMessageTemplate'] as String?,
      lastUpdatedBy: jsonSerialization['lastUpdatedBy'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['lastUpdatedBy'],
            ),
      enableFraudScoring: jsonSerialization['enableFraudScoring'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['enableFraudScoring'],
            ),
      autoApproveThreshold: jsonSerialization['autoApproveThreshold'] as int?,
      manualReviewThreshold: jsonSerialization['manualReviewThreshold'] as int?,
      autoRejectThreshold: jsonSerialization['autoRejectThreshold'] as int?,
      enableRewardHold: jsonSerialization['enableRewardHold'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['enableRewardHold'],
            ),
      holdDurationHours: jsonSerialization['holdDurationHours'] as int?,
      enableAutoReject: jsonSerialization['enableAutoReject'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['enableAutoReject'],
            ),
      minimumActualPaymentForQualification:
          (jsonSerialization['minimumActualPaymentForQualification'] as num?)
              ?.toDouble(),
      maxRewardedPerDay: jsonSerialization['maxRewardedPerDay'] as int?,
      maxPendingReferrals: jsonSerialization['maxPendingReferrals'] as int?,
      maxSharesPerDay: jsonSerialization['maxSharesPerDay'] as int?,
      maxSharesPerMonth: jsonSerialization['maxSharesPerMonth'] as int?,
      referralVelocityScore: jsonSerialization['referralVelocityScore'] as int?,
      velocityTimeWindowHours:
          jsonSerialization['velocityTimeWindowHours'] as int?,
      velocityThreshold: jsonSerialization['velocityThreshold'] as int?,
      autoReversalWindowDays:
          jsonSerialization['autoReversalWindowDays'] as int?,
      termsText: jsonSerialization['termsText'] as String?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ReferralSettingsRowTable();

  static const db = ReferralSettingsRowRepository._();

  @override
  _i1.UuidValue? id;

  bool isEnabled;

  bool inviteeCouponEnabled;

  double inviteeCouponAmount;

  String inviteeCouponCodeTemplate;

  bool referrerPointsEnabled;

  int referrerRewardPoints;

  String rewardTriggerStatus;

  int maxRewardedPerMonth;

  bool enableFraudProtection;

  double inviteeCouponMinOrderAmount;

  int inviteeCouponValidityDays;

  bool enableReferralExpiry;

  int referralExpiryDays;

  String shareMessageTemplate;

  _i1.UuidValue? lastUpdatedBy;

  bool enableFraudScoring;

  int autoApproveThreshold;

  int manualReviewThreshold;

  int autoRejectThreshold;

  bool enableRewardHold;

  int holdDurationHours;

  bool enableAutoReject;

  double minimumActualPaymentForQualification;

  int maxRewardedPerDay;

  int maxPendingReferrals;

  int maxSharesPerDay;

  int maxSharesPerMonth;

  int referralVelocityScore;

  int velocityTimeWindowHours;

  int velocityThreshold;

  int autoReversalWindowDays;

  String? termsText;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ReferralSettingsRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralSettingsRow copyWith({
    _i1.UuidValue? id,
    bool? isEnabled,
    bool? inviteeCouponEnabled,
    double? inviteeCouponAmount,
    String? inviteeCouponCodeTemplate,
    bool? referrerPointsEnabled,
    int? referrerRewardPoints,
    String? rewardTriggerStatus,
    int? maxRewardedPerMonth,
    bool? enableFraudProtection,
    double? inviteeCouponMinOrderAmount,
    int? inviteeCouponValidityDays,
    bool? enableReferralExpiry,
    int? referralExpiryDays,
    String? shareMessageTemplate,
    _i1.UuidValue? lastUpdatedBy,
    bool? enableFraudScoring,
    int? autoApproveThreshold,
    int? manualReviewThreshold,
    int? autoRejectThreshold,
    bool? enableRewardHold,
    int? holdDurationHours,
    bool? enableAutoReject,
    double? minimumActualPaymentForQualification,
    int? maxRewardedPerDay,
    int? maxPendingReferrals,
    int? maxSharesPerDay,
    int? maxSharesPerMonth,
    int? referralVelocityScore,
    int? velocityTimeWindowHours,
    int? velocityThreshold,
    int? autoReversalWindowDays,
    String? termsText,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralSettingsRow',
      if (id != null) 'id': id?.toJson(),
      'isEnabled': isEnabled,
      'inviteeCouponEnabled': inviteeCouponEnabled,
      'inviteeCouponAmount': inviteeCouponAmount,
      'inviteeCouponCodeTemplate': inviteeCouponCodeTemplate,
      'referrerPointsEnabled': referrerPointsEnabled,
      'referrerRewardPoints': referrerRewardPoints,
      'rewardTriggerStatus': rewardTriggerStatus,
      'maxRewardedPerMonth': maxRewardedPerMonth,
      'enableFraudProtection': enableFraudProtection,
      'inviteeCouponMinOrderAmount': inviteeCouponMinOrderAmount,
      'inviteeCouponValidityDays': inviteeCouponValidityDays,
      'enableReferralExpiry': enableReferralExpiry,
      'referralExpiryDays': referralExpiryDays,
      'shareMessageTemplate': shareMessageTemplate,
      if (lastUpdatedBy != null) 'lastUpdatedBy': lastUpdatedBy?.toJson(),
      'enableFraudScoring': enableFraudScoring,
      'autoApproveThreshold': autoApproveThreshold,
      'manualReviewThreshold': manualReviewThreshold,
      'autoRejectThreshold': autoRejectThreshold,
      'enableRewardHold': enableRewardHold,
      'holdDurationHours': holdDurationHours,
      'enableAutoReject': enableAutoReject,
      'minimumActualPaymentForQualification':
          minimumActualPaymentForQualification,
      'maxRewardedPerDay': maxRewardedPerDay,
      'maxPendingReferrals': maxPendingReferrals,
      'maxSharesPerDay': maxSharesPerDay,
      'maxSharesPerMonth': maxSharesPerMonth,
      'referralVelocityScore': referralVelocityScore,
      'velocityTimeWindowHours': velocityTimeWindowHours,
      'velocityThreshold': velocityThreshold,
      'autoReversalWindowDays': autoReversalWindowDays,
      if (termsText != null) 'termsText': termsText,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ReferralSettingsRowInclude include() {
    return ReferralSettingsRowInclude._();
  }

  static ReferralSettingsRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ReferralSettingsRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReferralSettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReferralSettingsRowTable>? orderByList,
    ReferralSettingsRowInclude? include,
  }) {
    return ReferralSettingsRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReferralSettingsRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReferralSettingsRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReferralSettingsRowImpl extends ReferralSettingsRow {
  _ReferralSettingsRowImpl({
    _i1.UuidValue? id,
    bool? isEnabled,
    bool? inviteeCouponEnabled,
    double? inviteeCouponAmount,
    String? inviteeCouponCodeTemplate,
    bool? referrerPointsEnabled,
    int? referrerRewardPoints,
    String? rewardTriggerStatus,
    int? maxRewardedPerMonth,
    bool? enableFraudProtection,
    double? inviteeCouponMinOrderAmount,
    int? inviteeCouponValidityDays,
    bool? enableReferralExpiry,
    int? referralExpiryDays,
    String? shareMessageTemplate,
    _i1.UuidValue? lastUpdatedBy,
    bool? enableFraudScoring,
    int? autoApproveThreshold,
    int? manualReviewThreshold,
    int? autoRejectThreshold,
    bool? enableRewardHold,
    int? holdDurationHours,
    bool? enableAutoReject,
    double? minimumActualPaymentForQualification,
    int? maxRewardedPerDay,
    int? maxPendingReferrals,
    int? maxSharesPerDay,
    int? maxSharesPerMonth,
    int? referralVelocityScore,
    int? velocityTimeWindowHours,
    int? velocityThreshold,
    int? autoReversalWindowDays,
    String? termsText,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         isEnabled: isEnabled,
         inviteeCouponEnabled: inviteeCouponEnabled,
         inviteeCouponAmount: inviteeCouponAmount,
         inviteeCouponCodeTemplate: inviteeCouponCodeTemplate,
         referrerPointsEnabled: referrerPointsEnabled,
         referrerRewardPoints: referrerRewardPoints,
         rewardTriggerStatus: rewardTriggerStatus,
         maxRewardedPerMonth: maxRewardedPerMonth,
         enableFraudProtection: enableFraudProtection,
         inviteeCouponMinOrderAmount: inviteeCouponMinOrderAmount,
         inviteeCouponValidityDays: inviteeCouponValidityDays,
         enableReferralExpiry: enableReferralExpiry,
         referralExpiryDays: referralExpiryDays,
         shareMessageTemplate: shareMessageTemplate,
         lastUpdatedBy: lastUpdatedBy,
         enableFraudScoring: enableFraudScoring,
         autoApproveThreshold: autoApproveThreshold,
         manualReviewThreshold: manualReviewThreshold,
         autoRejectThreshold: autoRejectThreshold,
         enableRewardHold: enableRewardHold,
         holdDurationHours: holdDurationHours,
         enableAutoReject: enableAutoReject,
         minimumActualPaymentForQualification:
             minimumActualPaymentForQualification,
         maxRewardedPerDay: maxRewardedPerDay,
         maxPendingReferrals: maxPendingReferrals,
         maxSharesPerDay: maxSharesPerDay,
         maxSharesPerMonth: maxSharesPerMonth,
         referralVelocityScore: referralVelocityScore,
         velocityTimeWindowHours: velocityTimeWindowHours,
         velocityThreshold: velocityThreshold,
         autoReversalWindowDays: autoReversalWindowDays,
         termsText: termsText,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ReferralSettingsRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralSettingsRow copyWith({
    Object? id = _Undefined,
    bool? isEnabled,
    bool? inviteeCouponEnabled,
    double? inviteeCouponAmount,
    String? inviteeCouponCodeTemplate,
    bool? referrerPointsEnabled,
    int? referrerRewardPoints,
    String? rewardTriggerStatus,
    int? maxRewardedPerMonth,
    bool? enableFraudProtection,
    double? inviteeCouponMinOrderAmount,
    int? inviteeCouponValidityDays,
    bool? enableReferralExpiry,
    int? referralExpiryDays,
    String? shareMessageTemplate,
    Object? lastUpdatedBy = _Undefined,
    bool? enableFraudScoring,
    int? autoApproveThreshold,
    int? manualReviewThreshold,
    int? autoRejectThreshold,
    bool? enableRewardHold,
    int? holdDurationHours,
    bool? enableAutoReject,
    double? minimumActualPaymentForQualification,
    int? maxRewardedPerDay,
    int? maxPendingReferrals,
    int? maxSharesPerDay,
    int? maxSharesPerMonth,
    int? referralVelocityScore,
    int? velocityTimeWindowHours,
    int? velocityThreshold,
    int? autoReversalWindowDays,
    Object? termsText = _Undefined,
    DateTime? updatedAt,
  }) {
    return ReferralSettingsRow(
      id: id is _i1.UuidValue? ? id : this.id,
      isEnabled: isEnabled ?? this.isEnabled,
      inviteeCouponEnabled: inviteeCouponEnabled ?? this.inviteeCouponEnabled,
      inviteeCouponAmount: inviteeCouponAmount ?? this.inviteeCouponAmount,
      inviteeCouponCodeTemplate:
          inviteeCouponCodeTemplate ?? this.inviteeCouponCodeTemplate,
      referrerPointsEnabled:
          referrerPointsEnabled ?? this.referrerPointsEnabled,
      referrerRewardPoints: referrerRewardPoints ?? this.referrerRewardPoints,
      rewardTriggerStatus: rewardTriggerStatus ?? this.rewardTriggerStatus,
      maxRewardedPerMonth: maxRewardedPerMonth ?? this.maxRewardedPerMonth,
      enableFraudProtection:
          enableFraudProtection ?? this.enableFraudProtection,
      inviteeCouponMinOrderAmount:
          inviteeCouponMinOrderAmount ?? this.inviteeCouponMinOrderAmount,
      inviteeCouponValidityDays:
          inviteeCouponValidityDays ?? this.inviteeCouponValidityDays,
      enableReferralExpiry: enableReferralExpiry ?? this.enableReferralExpiry,
      referralExpiryDays: referralExpiryDays ?? this.referralExpiryDays,
      shareMessageTemplate: shareMessageTemplate ?? this.shareMessageTemplate,
      lastUpdatedBy: lastUpdatedBy is _i1.UuidValue?
          ? lastUpdatedBy
          : this.lastUpdatedBy,
      enableFraudScoring: enableFraudScoring ?? this.enableFraudScoring,
      autoApproveThreshold: autoApproveThreshold ?? this.autoApproveThreshold,
      manualReviewThreshold:
          manualReviewThreshold ?? this.manualReviewThreshold,
      autoRejectThreshold: autoRejectThreshold ?? this.autoRejectThreshold,
      enableRewardHold: enableRewardHold ?? this.enableRewardHold,
      holdDurationHours: holdDurationHours ?? this.holdDurationHours,
      enableAutoReject: enableAutoReject ?? this.enableAutoReject,
      minimumActualPaymentForQualification:
          minimumActualPaymentForQualification ??
          this.minimumActualPaymentForQualification,
      maxRewardedPerDay: maxRewardedPerDay ?? this.maxRewardedPerDay,
      maxPendingReferrals: maxPendingReferrals ?? this.maxPendingReferrals,
      maxSharesPerDay: maxSharesPerDay ?? this.maxSharesPerDay,
      maxSharesPerMonth: maxSharesPerMonth ?? this.maxSharesPerMonth,
      referralVelocityScore:
          referralVelocityScore ?? this.referralVelocityScore,
      velocityTimeWindowHours:
          velocityTimeWindowHours ?? this.velocityTimeWindowHours,
      velocityThreshold: velocityThreshold ?? this.velocityThreshold,
      autoReversalWindowDays:
          autoReversalWindowDays ?? this.autoReversalWindowDays,
      termsText: termsText is String? ? termsText : this.termsText,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ReferralSettingsRowUpdateTable
    extends _i1.UpdateTable<ReferralSettingsRowTable> {
  ReferralSettingsRowUpdateTable(super.table);

  _i1.ColumnValue<bool, bool> isEnabled(bool value) => _i1.ColumnValue(
    table.isEnabled,
    value,
  );

  _i1.ColumnValue<bool, bool> inviteeCouponEnabled(bool value) =>
      _i1.ColumnValue(
        table.inviteeCouponEnabled,
        value,
      );

  _i1.ColumnValue<double, double> inviteeCouponAmount(double value) =>
      _i1.ColumnValue(
        table.inviteeCouponAmount,
        value,
      );

  _i1.ColumnValue<String, String> inviteeCouponCodeTemplate(String value) =>
      _i1.ColumnValue(
        table.inviteeCouponCodeTemplate,
        value,
      );

  _i1.ColumnValue<bool, bool> referrerPointsEnabled(bool value) =>
      _i1.ColumnValue(
        table.referrerPointsEnabled,
        value,
      );

  _i1.ColumnValue<int, int> referrerRewardPoints(int value) => _i1.ColumnValue(
    table.referrerRewardPoints,
    value,
  );

  _i1.ColumnValue<String, String> rewardTriggerStatus(String value) =>
      _i1.ColumnValue(
        table.rewardTriggerStatus,
        value,
      );

  _i1.ColumnValue<int, int> maxRewardedPerMonth(int value) => _i1.ColumnValue(
    table.maxRewardedPerMonth,
    value,
  );

  _i1.ColumnValue<bool, bool> enableFraudProtection(bool value) =>
      _i1.ColumnValue(
        table.enableFraudProtection,
        value,
      );

  _i1.ColumnValue<double, double> inviteeCouponMinOrderAmount(double value) =>
      _i1.ColumnValue(
        table.inviteeCouponMinOrderAmount,
        value,
      );

  _i1.ColumnValue<int, int> inviteeCouponValidityDays(int value) =>
      _i1.ColumnValue(
        table.inviteeCouponValidityDays,
        value,
      );

  _i1.ColumnValue<bool, bool> enableReferralExpiry(bool value) =>
      _i1.ColumnValue(
        table.enableReferralExpiry,
        value,
      );

  _i1.ColumnValue<int, int> referralExpiryDays(int value) => _i1.ColumnValue(
    table.referralExpiryDays,
    value,
  );

  _i1.ColumnValue<String, String> shareMessageTemplate(String value) =>
      _i1.ColumnValue(
        table.shareMessageTemplate,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> lastUpdatedBy(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.lastUpdatedBy,
    value,
  );

  _i1.ColumnValue<bool, bool> enableFraudScoring(bool value) => _i1.ColumnValue(
    table.enableFraudScoring,
    value,
  );

  _i1.ColumnValue<int, int> autoApproveThreshold(int value) => _i1.ColumnValue(
    table.autoApproveThreshold,
    value,
  );

  _i1.ColumnValue<int, int> manualReviewThreshold(int value) => _i1.ColumnValue(
    table.manualReviewThreshold,
    value,
  );

  _i1.ColumnValue<int, int> autoRejectThreshold(int value) => _i1.ColumnValue(
    table.autoRejectThreshold,
    value,
  );

  _i1.ColumnValue<bool, bool> enableRewardHold(bool value) => _i1.ColumnValue(
    table.enableRewardHold,
    value,
  );

  _i1.ColumnValue<int, int> holdDurationHours(int value) => _i1.ColumnValue(
    table.holdDurationHours,
    value,
  );

  _i1.ColumnValue<bool, bool> enableAutoReject(bool value) => _i1.ColumnValue(
    table.enableAutoReject,
    value,
  );

  _i1.ColumnValue<double, double> minimumActualPaymentForQualification(
    double value,
  ) => _i1.ColumnValue(
    table.minimumActualPaymentForQualification,
    value,
  );

  _i1.ColumnValue<int, int> maxRewardedPerDay(int value) => _i1.ColumnValue(
    table.maxRewardedPerDay,
    value,
  );

  _i1.ColumnValue<int, int> maxPendingReferrals(int value) => _i1.ColumnValue(
    table.maxPendingReferrals,
    value,
  );

  _i1.ColumnValue<int, int> maxSharesPerDay(int value) => _i1.ColumnValue(
    table.maxSharesPerDay,
    value,
  );

  _i1.ColumnValue<int, int> maxSharesPerMonth(int value) => _i1.ColumnValue(
    table.maxSharesPerMonth,
    value,
  );

  _i1.ColumnValue<int, int> referralVelocityScore(int value) => _i1.ColumnValue(
    table.referralVelocityScore,
    value,
  );

  _i1.ColumnValue<int, int> velocityTimeWindowHours(int value) =>
      _i1.ColumnValue(
        table.velocityTimeWindowHours,
        value,
      );

  _i1.ColumnValue<int, int> velocityThreshold(int value) => _i1.ColumnValue(
    table.velocityThreshold,
    value,
  );

  _i1.ColumnValue<int, int> autoReversalWindowDays(int value) =>
      _i1.ColumnValue(
        table.autoReversalWindowDays,
        value,
      );

  _i1.ColumnValue<String, String> termsText(String? value) => _i1.ColumnValue(
    table.termsText,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ReferralSettingsRowTable extends _i1.Table<_i1.UuidValue?> {
  ReferralSettingsRowTable({super.tableRelation})
    : super(tableName: 'referral_settings') {
    updateTable = ReferralSettingsRowUpdateTable(this);
    isEnabled = _i1.ColumnBool(
      'isEnabled',
      this,
      hasDefault: true,
    );
    inviteeCouponEnabled = _i1.ColumnBool(
      'inviteeCouponEnabled',
      this,
      hasDefault: true,
    );
    inviteeCouponAmount = _i1.ColumnDouble(
      'inviteeCouponAmount',
      this,
      hasDefault: true,
    );
    inviteeCouponCodeTemplate = _i1.ColumnString(
      'inviteeCouponCodeTemplate',
      this,
      hasDefault: true,
    );
    referrerPointsEnabled = _i1.ColumnBool(
      'referrerPointsEnabled',
      this,
      hasDefault: true,
    );
    referrerRewardPoints = _i1.ColumnInt(
      'referrerRewardPoints',
      this,
      hasDefault: true,
    );
    rewardTriggerStatus = _i1.ColumnString(
      'rewardTriggerStatus',
      this,
      hasDefault: true,
    );
    maxRewardedPerMonth = _i1.ColumnInt(
      'maxRewardedPerMonth',
      this,
      hasDefault: true,
    );
    enableFraudProtection = _i1.ColumnBool(
      'enableFraudProtection',
      this,
      hasDefault: true,
    );
    inviteeCouponMinOrderAmount = _i1.ColumnDouble(
      'inviteeCouponMinOrderAmount',
      this,
      hasDefault: true,
    );
    inviteeCouponValidityDays = _i1.ColumnInt(
      'inviteeCouponValidityDays',
      this,
      hasDefault: true,
    );
    enableReferralExpiry = _i1.ColumnBool(
      'enableReferralExpiry',
      this,
      hasDefault: true,
    );
    referralExpiryDays = _i1.ColumnInt(
      'referralExpiryDays',
      this,
      hasDefault: true,
    );
    shareMessageTemplate = _i1.ColumnString(
      'shareMessageTemplate',
      this,
      hasDefault: true,
    );
    lastUpdatedBy = _i1.ColumnUuid(
      'lastUpdatedBy',
      this,
    );
    enableFraudScoring = _i1.ColumnBool(
      'enableFraudScoring',
      this,
      hasDefault: true,
    );
    autoApproveThreshold = _i1.ColumnInt(
      'autoApproveThreshold',
      this,
      hasDefault: true,
    );
    manualReviewThreshold = _i1.ColumnInt(
      'manualReviewThreshold',
      this,
      hasDefault: true,
    );
    autoRejectThreshold = _i1.ColumnInt(
      'autoRejectThreshold',
      this,
      hasDefault: true,
    );
    enableRewardHold = _i1.ColumnBool(
      'enableRewardHold',
      this,
      hasDefault: true,
    );
    holdDurationHours = _i1.ColumnInt(
      'holdDurationHours',
      this,
      hasDefault: true,
    );
    enableAutoReject = _i1.ColumnBool(
      'enableAutoReject',
      this,
      hasDefault: true,
    );
    minimumActualPaymentForQualification = _i1.ColumnDouble(
      'minimumActualPaymentForQualification',
      this,
      hasDefault: true,
    );
    maxRewardedPerDay = _i1.ColumnInt(
      'maxRewardedPerDay',
      this,
      hasDefault: true,
    );
    maxPendingReferrals = _i1.ColumnInt(
      'maxPendingReferrals',
      this,
      hasDefault: true,
    );
    maxSharesPerDay = _i1.ColumnInt(
      'maxSharesPerDay',
      this,
      hasDefault: true,
    );
    maxSharesPerMonth = _i1.ColumnInt(
      'maxSharesPerMonth',
      this,
      hasDefault: true,
    );
    referralVelocityScore = _i1.ColumnInt(
      'referralVelocityScore',
      this,
      hasDefault: true,
    );
    velocityTimeWindowHours = _i1.ColumnInt(
      'velocityTimeWindowHours',
      this,
      hasDefault: true,
    );
    velocityThreshold = _i1.ColumnInt(
      'velocityThreshold',
      this,
      hasDefault: true,
    );
    autoReversalWindowDays = _i1.ColumnInt(
      'autoReversalWindowDays',
      this,
      hasDefault: true,
    );
    termsText = _i1.ColumnString(
      'termsText',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final ReferralSettingsRowUpdateTable updateTable;

  late final _i1.ColumnBool isEnabled;

  late final _i1.ColumnBool inviteeCouponEnabled;

  late final _i1.ColumnDouble inviteeCouponAmount;

  late final _i1.ColumnString inviteeCouponCodeTemplate;

  late final _i1.ColumnBool referrerPointsEnabled;

  late final _i1.ColumnInt referrerRewardPoints;

  late final _i1.ColumnString rewardTriggerStatus;

  late final _i1.ColumnInt maxRewardedPerMonth;

  late final _i1.ColumnBool enableFraudProtection;

  late final _i1.ColumnDouble inviteeCouponMinOrderAmount;

  late final _i1.ColumnInt inviteeCouponValidityDays;

  late final _i1.ColumnBool enableReferralExpiry;

  late final _i1.ColumnInt referralExpiryDays;

  late final _i1.ColumnString shareMessageTemplate;

  late final _i1.ColumnUuid lastUpdatedBy;

  late final _i1.ColumnBool enableFraudScoring;

  late final _i1.ColumnInt autoApproveThreshold;

  late final _i1.ColumnInt manualReviewThreshold;

  late final _i1.ColumnInt autoRejectThreshold;

  late final _i1.ColumnBool enableRewardHold;

  late final _i1.ColumnInt holdDurationHours;

  late final _i1.ColumnBool enableAutoReject;

  late final _i1.ColumnDouble minimumActualPaymentForQualification;

  late final _i1.ColumnInt maxRewardedPerDay;

  late final _i1.ColumnInt maxPendingReferrals;

  late final _i1.ColumnInt maxSharesPerDay;

  late final _i1.ColumnInt maxSharesPerMonth;

  late final _i1.ColumnInt referralVelocityScore;

  late final _i1.ColumnInt velocityTimeWindowHours;

  late final _i1.ColumnInt velocityThreshold;

  late final _i1.ColumnInt autoReversalWindowDays;

  late final _i1.ColumnString termsText;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    isEnabled,
    inviteeCouponEnabled,
    inviteeCouponAmount,
    inviteeCouponCodeTemplate,
    referrerPointsEnabled,
    referrerRewardPoints,
    rewardTriggerStatus,
    maxRewardedPerMonth,
    enableFraudProtection,
    inviteeCouponMinOrderAmount,
    inviteeCouponValidityDays,
    enableReferralExpiry,
    referralExpiryDays,
    shareMessageTemplate,
    lastUpdatedBy,
    enableFraudScoring,
    autoApproveThreshold,
    manualReviewThreshold,
    autoRejectThreshold,
    enableRewardHold,
    holdDurationHours,
    enableAutoReject,
    minimumActualPaymentForQualification,
    maxRewardedPerDay,
    maxPendingReferrals,
    maxSharesPerDay,
    maxSharesPerMonth,
    referralVelocityScore,
    velocityTimeWindowHours,
    velocityThreshold,
    autoReversalWindowDays,
    termsText,
    updatedAt,
  ];
}

class ReferralSettingsRowInclude extends _i1.IncludeObject {
  ReferralSettingsRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ReferralSettingsRow.t;
}

class ReferralSettingsRowIncludeList extends _i1.IncludeList {
  ReferralSettingsRowIncludeList._({
    _i1.WhereExpressionBuilder<ReferralSettingsRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReferralSettingsRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ReferralSettingsRow.t;
}

class ReferralSettingsRowRepository {
  const ReferralSettingsRowRepository._();

  /// Returns a list of [ReferralSettingsRow]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ReferralSettingsRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReferralSettingsRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReferralSettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReferralSettingsRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReferralSettingsRow>(
      where: where?.call(ReferralSettingsRow.t),
      orderBy: orderBy?.call(ReferralSettingsRow.t),
      orderByList: orderByList?.call(ReferralSettingsRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReferralSettingsRow] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ReferralSettingsRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReferralSettingsRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReferralSettingsRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReferralSettingsRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReferralSettingsRow>(
      where: where?.call(ReferralSettingsRow.t),
      orderBy: orderBy?.call(ReferralSettingsRow.t),
      orderByList: orderByList?.call(ReferralSettingsRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReferralSettingsRow] by its [id] or null if no such row exists.
  Future<ReferralSettingsRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReferralSettingsRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReferralSettingsRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ReferralSettingsRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ReferralSettingsRow>> insert(
    _i1.DatabaseSession session,
    List<ReferralSettingsRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ReferralSettingsRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ReferralSettingsRow] and returns the inserted row.
  ///
  /// The returned [ReferralSettingsRow] will have its `id` field set.
  Future<ReferralSettingsRow> insertRow(
    _i1.DatabaseSession session,
    ReferralSettingsRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReferralSettingsRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReferralSettingsRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReferralSettingsRow>> update(
    _i1.DatabaseSession session,
    List<ReferralSettingsRow> rows, {
    _i1.ColumnSelections<ReferralSettingsRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReferralSettingsRow>(
      rows,
      columns: columns?.call(ReferralSettingsRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReferralSettingsRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReferralSettingsRow> updateRow(
    _i1.DatabaseSession session,
    ReferralSettingsRow row, {
    _i1.ColumnSelections<ReferralSettingsRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReferralSettingsRow>(
      row,
      columns: columns?.call(ReferralSettingsRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReferralSettingsRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReferralSettingsRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ReferralSettingsRowUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReferralSettingsRow>(
      id,
      columnValues: columnValues(ReferralSettingsRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReferralSettingsRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReferralSettingsRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ReferralSettingsRowUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ReferralSettingsRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReferralSettingsRowTable>? orderBy,
    _i1.OrderByListBuilder<ReferralSettingsRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReferralSettingsRow>(
      columnValues: columnValues(ReferralSettingsRow.t.updateTable),
      where: where(ReferralSettingsRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReferralSettingsRow.t),
      orderByList: orderByList?.call(ReferralSettingsRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReferralSettingsRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReferralSettingsRow>> delete(
    _i1.DatabaseSession session,
    List<ReferralSettingsRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReferralSettingsRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReferralSettingsRow].
  Future<ReferralSettingsRow> deleteRow(
    _i1.DatabaseSession session,
    ReferralSettingsRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReferralSettingsRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReferralSettingsRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReferralSettingsRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReferralSettingsRow>(
      where: where(ReferralSettingsRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReferralSettingsRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReferralSettingsRow>(
      where: where?.call(ReferralSettingsRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReferralSettingsRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReferralSettingsRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReferralSettingsRow>(
      where: where(ReferralSettingsRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
