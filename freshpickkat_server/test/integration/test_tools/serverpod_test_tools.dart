/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_test/serverpod_test.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'dart:async' as _i3;
import 'package:freshpickkat_server/src/generated/admin_auth_result.dart'
    as _i4;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i5;
import 'package:freshpickkat_server/src/generated/admin_dashboard_stats.dart'
    as _i6;
import 'package:freshpickkat_server/src/generated/admin_analytics.dart' as _i7;
import 'package:freshpickkat_server/src/generated/admin_audit_log_entry.dart'
    as _i8;
import 'package:freshpickkat_server/src/generated/active_user_statistics.dart'
    as _i9;
import 'package:freshpickkat_server/src/generated/banner.dart' as _i10;
import 'package:freshpickkat_server/src/generated/banner_page.dart' as _i11;
import 'package:freshpickkat_server/src/generated/offer_mutation_result.dart'
    as _i12;
import 'package:freshpickkat_server/src/generated/bogo_offer.dart' as _i13;
import 'package:freshpickkat_server/src/generated/notification_draft.dart'
    as _i14;
import 'package:freshpickkat_server/src/generated/bogo_offer_page.dart' as _i15;
import 'package:freshpickkat_server/src/generated/category.dart' as _i16;
import 'package:freshpickkat_server/src/generated/category_offer.dart' as _i17;
import 'package:freshpickkat_server/src/generated/category_offer_page.dart'
    as _i18;
import 'package:freshpickkat_server/src/generated/checkout_result.dart' as _i19;
import 'package:freshpickkat_server/src/generated/order.dart' as _i20;
import 'package:freshpickkat_server/src/generated/combo_offer.dart' as _i21;
import 'package:freshpickkat_server/src/generated/combo_offer_page.dart'
    as _i22;
import 'package:freshpickkat_server/src/generated/cart_item_input.dart' as _i23;
import 'package:freshpickkat_server/src/generated/complaint.dart' as _i24;
import 'package:freshpickkat_server/src/generated/address.dart' as _i25;
import 'package:freshpickkat_server/src/generated/complaint_page.dart' as _i26;
import 'package:freshpickkat_server/src/generated/refund_record.dart' as _i27;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i28;
import 'package:freshpickkat_server/src/generated/coupon_display.dart' as _i29;
import 'package:freshpickkat_server/src/generated/coupon_validation_result.dart'
    as _i30;
import 'package:freshpickkat_server/src/generated/best_coupon_result.dart'
    as _i31;
import 'package:freshpickkat_server/src/generated/delivery_config.dart' as _i32;
import 'package:freshpickkat_server/src/generated/delivery_pricing_result.dart'
    as _i33;
import 'package:freshpickkat_server/src/generated/delivery_rule.dart' as _i34;
import 'package:freshpickkat_server/src/generated/delivery_rule_page.dart'
    as _i35;
import 'package:freshpickkat_server/src/generated/notification_preference.dart'
    as _i36;
import 'package:freshpickkat_server/src/generated/notification_history_page.dart'
    as _i37;
import 'package:freshpickkat_server/src/generated/admin_notification_preference.dart'
    as _i38;
import 'package:freshpickkat_server/src/generated/broadcast_summary.dart'
    as _i39;
import 'package:freshpickkat_server/src/generated/broadcast_request.dart'
    as _i40;
import 'package:freshpickkat_server/src/generated/broadcast_page.dart' as _i41;
import 'package:freshpickkat_server/src/generated/order_page.dart' as _i42;
import 'package:freshpickkat_server/src/generated/payment_action_result.dart'
    as _i43;
import 'package:freshpickkat_server/src/generated/order_realtime_event.dart'
    as _i44;
import 'package:freshpickkat_server/src/generated/order_tracking_data.dart'
    as _i45;
import 'package:freshpickkat_server/src/generated/payment_order_result.dart'
    as _i46;
import 'package:freshpickkat_server/src/generated/payment_verify_result.dart'
    as _i47;
import 'package:freshpickkat_server/src/generated/cart_pricing_result.dart'
    as _i48;
import 'package:freshpickkat_server/src/generated/applied_offer_info.dart'
    as _i49;
import 'package:freshpickkat_server/src/generated/basket_suggestion_result.dart'
    as _i50;
import 'package:freshpickkat_server/src/generated/product.dart' as _i51;
import 'package:freshpickkat_server/src/generated/product_page.dart' as _i52;
import 'package:freshpickkat_server/src/generated/offer_search_page.dart'
    as _i53;
import 'package:freshpickkat_server/src/generated/product_ranking_item.dart'
    as _i54;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i55;
import 'package:freshpickkat_server/src/generated/support_issue.dart' as _i56;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i57;
import 'package:freshpickkat_server/src/generated/protocol.dart';
import 'package:freshpickkat_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

/// Creates a new test group that takes a callback that can be used to write tests.
/// The callback has two parameters: `sessionBuilder` and `endpoints`.
/// `sessionBuilder` is used to build a `Session` object that represents the server state during an endpoint call and is used to set up scenarios.
/// `endpoints` contains all your Serverpod endpoints and lets you call them:
/// ```dart
/// withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
///   test('when calling `hello` then should return greeting', () async {
///     final greeting = await endpoints.example.hello(sessionBuilder, 'Michael');
///     expect(greeting, 'Hello Michael');
///   });
/// });
/// ```
///
/// **Configuration options**
///
/// [applyMigrations] Whether pending migrations should be applied when starting Serverpod. Defaults to `true`
///
/// [enableSessionLogging] Whether session logging should be enabled. Defaults to `false`
///
/// [rollbackDatabase] Options for when to rollback the database during the test lifecycle.
/// By default `withServerpod` does all database operations inside a transaction that is rolled back after each `test` case.
/// Just like the following enum describes, the behavior of the automatic rollbacks can be configured:
/// ```dart
/// /// Options for when to rollback the database during the test lifecycle.
/// enum RollbackDatabase {
///   /// After each test. This is the default.
///   afterEach,
///
///   /// After all tests.
///   afterAll,
///
///   /// Disable rolling back the database.
///   disabled,
/// }
/// ```
///
/// [runMode] The run mode that Serverpod should be running in. Defaults to `test`.
///
/// [serverpodLoggingMode] The logging mode used when creating Serverpod. Defaults to `ServerpodLoggingMode.normal`
///
/// [serverpodStartTimeout] The timeout to use when starting Serverpod, which connects to the database among other things. Defaults to `Duration(seconds: 30)`.
///
/// [testServerOutputMode] Options for controlling test server output during test execution. Defaults to `TestServerOutputMode.normal`.
/// ```dart
/// /// Options for controlling test server output during test execution.
/// enum TestServerOutputMode {
///   /// Default mode - only stderr is printed (stdout suppressed).
///   /// This hides normal startup/shutdown logs while preserving error messages.
///   normal,
///
///   /// All logging - both stdout and stderr are printed.
///   /// Useful for debugging when you need to see all server output.
///   verbose,
///
///   /// No logging - both stdout and stderr are suppressed.
///   /// Completely silent mode, useful when you don't want any server output.
///   silent,
/// }
/// ```
///
/// [configOverride] A function to override the server configuration. This function is called with
/// the default server configuration after it is loaded from the config/ directory
/// and before it is used to start the server. Use this to override particular
/// settings in the server configuration.
///
/// [testGroupTagsOverride] By default Serverpod test tools tags the `withServerpod` test group with `"integration"`.
/// This is to provide a simple way to only run unit or integration tests.
/// This property allows this tag to be overridden to something else. Defaults to `['integration']`.
///
/// [experimentalFeatures] Optionally specify experimental features. See [Serverpod] for more information.
@_i1.isTestGroup
void withServerpod(
  String testGroupName,
  _i1.TestClosure<TestEndpoints> testClosure, {
  bool? applyMigrations,
  _i2.ServerpodConfig Function(_i2.ServerpodConfig)? configOverride,
  bool? enableSessionLogging,
  _i2.ExperimentalFeatures? experimentalFeatures,
  _i1.RollbackDatabase? rollbackDatabase,
  String? runMode,
  _i2.RuntimeParametersListBuilder? runtimeParametersBuilder,
  _i2.ServerpodLoggingMode? serverpodLoggingMode,
  Duration? serverpodStartTimeout,
  List<String>? testGroupTagsOverride,
  _i1.TestServerOutputMode? testServerOutputMode,
}) {
  _i1.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    _i1.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: applyMigrations,
      isDatabaseEnabled: true,
      serverpodLoggingMode: serverpodLoggingMode,
      testServerOutputMode: testServerOutputMode,
      experimentalFeatures: experimentalFeatures,
      configOverride: configOverride,
      runtimeParametersBuilder: runtimeParametersBuilder,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
    maybeTestServerOutputMode: testServerOutputMode,
  )(testClosure);
}

class TestEndpoints {
  late final _AdminEndpoint admin;

  late final _AuthEndpoint auth;

  late final _BannerEndpoint banner;

  late final _BogoEndpoint bogo;

  late final _CategoryEndpoint category;

  late final _CategoryOfferEndpoint categoryOffer;

  late final _CheckoutEndpoint checkout;

  late final _ComboOfferEndpoint comboOffer;

  late final _ComplaintEndpoint complaint;

  late final _CouponEndpoint coupon;

  late final _FreeDeliveryEndpoint freeDelivery;

  late final _NotificationEndpoint notification;

  late final _OrderEndpoint order;

  late final _OrderPgEndpoint orderPg;

  late final _OrderRealtimeEndpoint orderRealtime;

  late final _OrderTrackingEndpoint orderTracking;

  late final _PaymentEndpoint payment;

  late final _PricingEndpoint pricing;

  late final _ProductEndpoint product;

  late final _ProductPgEndpoint productPg;

  late final _ProductRankingEndpoint productRanking;

  late final _RefundEndpoint refund;

  late final _SubCategoryEndpoint subCategory;

  late final _SupportEndpoint support;

  late final _UserEndpoint user;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _i1.InternalTestEndpoints {
  @override
  void initialize(
    _i2.SerializationManager serializationManager,
    _i2.EndpointDispatch endpoints,
  ) {
    admin = _AdminEndpoint(
      endpoints,
      serializationManager,
    );
    auth = _AuthEndpoint(
      endpoints,
      serializationManager,
    );
    banner = _BannerEndpoint(
      endpoints,
      serializationManager,
    );
    bogo = _BogoEndpoint(
      endpoints,
      serializationManager,
    );
    category = _CategoryEndpoint(
      endpoints,
      serializationManager,
    );
    categoryOffer = _CategoryOfferEndpoint(
      endpoints,
      serializationManager,
    );
    checkout = _CheckoutEndpoint(
      endpoints,
      serializationManager,
    );
    comboOffer = _ComboOfferEndpoint(
      endpoints,
      serializationManager,
    );
    complaint = _ComplaintEndpoint(
      endpoints,
      serializationManager,
    );
    coupon = _CouponEndpoint(
      endpoints,
      serializationManager,
    );
    freeDelivery = _FreeDeliveryEndpoint(
      endpoints,
      serializationManager,
    );
    notification = _NotificationEndpoint(
      endpoints,
      serializationManager,
    );
    order = _OrderEndpoint(
      endpoints,
      serializationManager,
    );
    orderPg = _OrderPgEndpoint(
      endpoints,
      serializationManager,
    );
    orderRealtime = _OrderRealtimeEndpoint(
      endpoints,
      serializationManager,
    );
    orderTracking = _OrderTrackingEndpoint(
      endpoints,
      serializationManager,
    );
    payment = _PaymentEndpoint(
      endpoints,
      serializationManager,
    );
    pricing = _PricingEndpoint(
      endpoints,
      serializationManager,
    );
    product = _ProductEndpoint(
      endpoints,
      serializationManager,
    );
    productPg = _ProductPgEndpoint(
      endpoints,
      serializationManager,
    );
    productRanking = _ProductRankingEndpoint(
      endpoints,
      serializationManager,
    );
    refund = _RefundEndpoint(
      endpoints,
      serializationManager,
    );
    subCategory = _SubCategoryEndpoint(
      endpoints,
      serializationManager,
    );
    support = _SupportEndpoint(
      endpoints,
      serializationManager,
    );
    user = _UserEndpoint(
      endpoints,
      serializationManager,
    );
  }
}

class _AdminEndpoint {
  _AdminEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> isAdminSetupCompleted(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'admin',
            method: 'isAdminSetupCompleted',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'isAdminSetupCompleted',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> resolveAdminLoginEmail(
    _i1.TestSessionBuilder sessionBuilder,
    String usernameOrEmail,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'admin',
            method: 'resolveAdminLoginEmail',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'resolveAdminLoginEmail',
          parameters: _i1.testObjectToJson({
            'usernameOrEmail': usernameOrEmail,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i4.AdminAuthResult> firebaseLogin(
    _i1.TestSessionBuilder sessionBuilder,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'admin',
            method: 'firebaseLogin',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'firebaseLogin',
          parameters: _i1.testObjectToJson({'idToken': idToken}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i4.AdminAuthResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i4.AdminAuthResult> completeFirebaseSetup(
    _i1.TestSessionBuilder sessionBuilder,
    String idToken,
    String username,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'admin',
            method: 'completeFirebaseSetup',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'completeFirebaseSetup',
          parameters: _i1.testObjectToJson({
            'idToken': idToken,
            'username': username,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i4.AdminAuthResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i5.AppUser>> getAllUsers(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'admin',
            method: 'getAllUsers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getAllUsers',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i5.AppUser>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i6.AdminDashboardStats> getDashboardStats(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'admin',
            method: 'getDashboardStats',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getDashboardStats',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i6.AdminDashboardStats>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i7.AdminAnalytics> getAnalytics(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'admin',
            method: 'getAnalytics',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getAnalytics',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i7.AdminAnalytics>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i8.AdminAuditLogEntry>> getAuditLogs(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken, {
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'admin',
            method: 'getAuditLogs',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getAuditLogs',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i8.AdminAuditLogEntry>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i9.ActiveUserStatistics>> getActiveUsersWithStats(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken, {
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'admin',
            method: 'getActiveUsersWithStats',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'admin',
          methodName: 'getActiveUsersWithStats',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i9.ActiveUserStatistics>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _AuthEndpoint {
  _AuthEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> signOut(
    _i1.TestSessionBuilder sessionBuilder,
    String uid,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'auth',
            method: 'signOut',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'auth',
          methodName: 'signOut',
          parameters: _i1.testObjectToJson({'uid': uid}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _BannerEndpoint {
  _BannerEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i10.Banner>> getBanners(
    _i1.TestSessionBuilder sessionBuilder, {
    String? screen,
    required bool activeOnly,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'banner',
            method: 'getBanners',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'banner',
          methodName: 'getBanners',
          parameters: _i1.testObjectToJson({
            'screen': screen,
            'activeOnly': activeOnly,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i10.Banner>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i11.BannerPage> getBannersPage(
    _i1.TestSessionBuilder sessionBuilder, {
    required int limit,
    String? pageToken,
    required bool activeOnly,
    String? screen,
    String? firebaseUid,
    String? idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'banner',
            method: 'getBannersPage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'banner',
          methodName: 'getBannersPage',
          parameters: _i1.testObjectToJson({
            'limit': limit,
            'pageToken': pageToken,
            'activeOnly': activeOnly,
            'screen': screen,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i11.BannerPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i10.Banner?> getBannerById(
    _i1.TestSessionBuilder sessionBuilder,
    String bannerId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'banner',
            method: 'getBannerById',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'banner',
          methodName: 'getBannerById',
          parameters: _i1.testObjectToJson({'bannerId': bannerId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i10.Banner?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i10.Banner> createBanner(
    _i1.TestSessionBuilder sessionBuilder,
    _i10.Banner banner,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'banner',
            method: 'createBanner',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'banner',
          methodName: 'createBanner',
          parameters: _i1.testObjectToJson({
            'banner': banner,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i10.Banner>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i10.Banner> updateBanner(
    _i1.TestSessionBuilder sessionBuilder,
    _i10.Banner banner,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'banner',
            method: 'updateBanner',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'banner',
          methodName: 'updateBanner',
          parameters: _i1.testObjectToJson({
            'banner': banner,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i10.Banner>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<void> deleteBanner(
    _i1.TestSessionBuilder sessionBuilder,
    String bannerId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'banner',
            method: 'deleteBanner',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'banner',
          methodName: 'deleteBanner',
          parameters: _i1.testObjectToJson({
            'bannerId': bannerId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<void> toggleBannerActive(
    _i1.TestSessionBuilder sessionBuilder,
    String bannerId,
    bool active,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'banner',
            method: 'toggleBannerActive',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'banner',
          methodName: 'toggleBannerActive',
          parameters: _i1.testObjectToJson({
            'bannerId': bannerId,
            'active': active,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<void> updateBannerPriority(
    _i1.TestSessionBuilder sessionBuilder,
    String bannerId,
    int priority,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'banner',
            method: 'updateBannerPriority',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'banner',
          methodName: 'updateBannerPriority',
          parameters: _i1.testObjectToJson({
            'bannerId': bannerId,
            'priority': priority,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _BogoEndpoint {
  _BogoEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i12.OfferMutationResult> upsertOfferWithConflicts(
    _i1.TestSessionBuilder sessionBuilder,
    _i13.BogoOffer offer,
    String firebaseUid,
    String idToken, {
    _i14.NotificationDraft? notificationDraft,
    required bool confirmDisableConflictingCombo,
    required bool forceDisableFreeDelivery,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'upsertOfferWithConflicts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'upsertOfferWithConflicts',
          parameters: _i1.testObjectToJson({
            'offer': offer,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'notificationDraft': notificationDraft,
            'confirmDisableConflictingCombo': confirmDisableConflictingCombo,
            'forceDisableFreeDelivery': forceDisableFreeDelivery,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i12.OfferMutationResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> upsertOffer(
    _i1.TestSessionBuilder sessionBuilder,
    _i13.BogoOffer offer,
    String firebaseUid,
    String idToken, {
    _i14.NotificationDraft? notificationDraft,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'upsertOffer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'upsertOffer',
          parameters: _i1.testObjectToJson({
            'offer': offer,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'notificationDraft': notificationDraft,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> deleteOffer(
    _i1.TestSessionBuilder sessionBuilder,
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'deleteOffer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'deleteOffer',
          parameters: _i1.testObjectToJson({
            'triggerProductId': triggerProductId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> setBogoOfferActive(
    _i1.TestSessionBuilder sessionBuilder,
    String triggerProductId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'setBogoOfferActive',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'setBogoOfferActive',
          parameters: _i1.testObjectToJson({
            'triggerProductId': triggerProductId,
            'isActive': isActive,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i13.BogoOffer>> getAllOffers(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'getAllOffers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'getAllOffers',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i13.BogoOffer>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i15.BogoOfferPage> getOffersPage(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'getOffersPage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'getOffersPage',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i15.BogoOfferPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i13.BogoOffer>> getActiveOffers(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'getActiveOffers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'getActiveOffers',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i13.BogoOffer>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i13.BogoOffer?> getActiveOfferForProduct(
    _i1.TestSessionBuilder sessionBuilder,
    String productId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'getActiveOfferForProduct',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'getActiveOfferForProduct',
          parameters: _i1.testObjectToJson({'productId': productId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i13.BogoOffer?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i13.BogoOffer>> getActiveBogoOffersForProducts(
    _i1.TestSessionBuilder sessionBuilder,
    List<String> productIds,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'getActiveBogoOffersForProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'getActiveBogoOffersForProducts',
          parameters: _i1.testObjectToJson({'productIds': productIds}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i13.BogoOffer>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i13.BogoOffer?> getOfferForProduct(
    _i1.TestSessionBuilder sessionBuilder,
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'bogo',
            method: 'getOfferForProduct',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'bogo',
          methodName: 'getOfferForProduct',
          parameters: _i1.testObjectToJson({
            'triggerProductId': triggerProductId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i13.BogoOffer?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CategoryEndpoint {
  _CategoryEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i16.Category>> getCategories(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'category',
            method: 'getCategories',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'category',
          methodName: 'getCategories',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i16.Category>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> uploadCategory(
    _i1.TestSessionBuilder sessionBuilder,
    _i16.Category category,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'category',
            method: 'uploadCategory',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'category',
          methodName: 'uploadCategory',
          parameters: _i1.testObjectToJson({
            'category': category,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> updateCategory(
    _i1.TestSessionBuilder sessionBuilder,
    String oldName,
    _i16.Category category,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'category',
            method: 'updateCategory',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'category',
          methodName: 'updateCategory',
          parameters: _i1.testObjectToJson({
            'oldName': oldName,
            'category': category,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteCategory(
    _i1.TestSessionBuilder sessionBuilder,
    String categoryName,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'category',
            method: 'deleteCategory',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'category',
          methodName: 'deleteCategory',
          parameters: _i1.testObjectToJson({
            'categoryName': categoryName,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CategoryOfferEndpoint {
  _CategoryOfferEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> upsertCategoryOffer(
    _i1.TestSessionBuilder sessionBuilder,
    _i17.CategoryOffer offer,
    String firebaseUid,
    String idToken, {
    _i14.NotificationDraft? notificationDraft,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'categoryOffer',
            method: 'upsertCategoryOffer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'categoryOffer',
          methodName: 'upsertCategoryOffer',
          parameters: _i1.testObjectToJson({
            'offer': offer,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'notificationDraft': notificationDraft,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> deleteCategoryOffer(
    _i1.TestSessionBuilder sessionBuilder,
    String offerId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'categoryOffer',
            method: 'deleteCategoryOffer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'categoryOffer',
          methodName: 'deleteCategoryOffer',
          parameters: _i1.testObjectToJson({
            'offerId': offerId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i17.CategoryOffer>> getActiveCategoryOffers(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'categoryOffer',
            method: 'getActiveCategoryOffers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'categoryOffer',
          methodName: 'getActiveCategoryOffers',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i17.CategoryOffer>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i17.CategoryOffer>> getAllCategoryOffers(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'categoryOffer',
            method: 'getAllCategoryOffers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'categoryOffer',
          methodName: 'getAllCategoryOffers',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i17.CategoryOffer>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i18.CategoryOfferPage> getCategoryOffersPage(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'categoryOffer',
            method: 'getCategoryOffersPage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'categoryOffer',
          methodName: 'getCategoryOffersPage',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i18.CategoryOfferPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> setCategoryOfferActive(
    _i1.TestSessionBuilder sessionBuilder,
    String offerId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'categoryOffer',
            method: 'setCategoryOfferActive',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'categoryOffer',
          methodName: 'setCategoryOfferActive',
          parameters: _i1.testObjectToJson({
            'offerId': offerId,
            'isActive': isActive,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CheckoutEndpoint {
  _CheckoutEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i19.CheckoutResult> createOrderAndPayment(
    _i1.TestSessionBuilder sessionBuilder,
    _i20.Order order,
    String idempotencyKey,
    double amount,
    String customerPhone,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'checkout',
            method: 'createOrderAndPayment',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'checkout',
          methodName: 'createOrderAndPayment',
          parameters: _i1.testObjectToJson({
            'order': order,
            'idempotencyKey': idempotencyKey,
            'amount': amount,
            'customerPhone': customerPhone,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i19.CheckoutResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ComboOfferEndpoint {
  _ComboOfferEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i12.OfferMutationResult> upsertComboOfferWithConflicts(
    _i1.TestSessionBuilder sessionBuilder,
    _i21.ComboOffer offer,
    String firebaseUid,
    String idToken, {
    _i14.NotificationDraft? notificationDraft,
    required bool force,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'comboOffer',
            method: 'upsertComboOfferWithConflicts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'comboOffer',
          methodName: 'upsertComboOfferWithConflicts',
          parameters: _i1.testObjectToJson({
            'offer': offer,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'notificationDraft': notificationDraft,
            'force': force,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i12.OfferMutationResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> upsertComboOffer(
    _i1.TestSessionBuilder sessionBuilder,
    _i21.ComboOffer offer,
    String firebaseUid,
    String idToken, {
    _i14.NotificationDraft? notificationDraft,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'comboOffer',
            method: 'upsertComboOffer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'comboOffer',
          methodName: 'upsertComboOffer',
          parameters: _i1.testObjectToJson({
            'offer': offer,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'notificationDraft': notificationDraft,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> deleteComboOffer(
    _i1.TestSessionBuilder sessionBuilder,
    String comboId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'comboOffer',
            method: 'deleteComboOffer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'comboOffer',
          methodName: 'deleteComboOffer',
          parameters: _i1.testObjectToJson({
            'comboId': comboId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i21.ComboOffer>> getActiveComboOffers(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'comboOffer',
            method: 'getActiveComboOffers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'comboOffer',
          methodName: 'getActiveComboOffers',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i21.ComboOffer>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i21.ComboOffer>> getActiveComboOffersForProducts(
    _i1.TestSessionBuilder sessionBuilder,
    List<String> productIds,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'comboOffer',
            method: 'getActiveComboOffersForProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'comboOffer',
          methodName: 'getActiveComboOffersForProducts',
          parameters: _i1.testObjectToJson({'productIds': productIds}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i21.ComboOffer>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i21.ComboOffer>> getAllComboOffers(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'comboOffer',
            method: 'getAllComboOffers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'comboOffer',
          methodName: 'getAllComboOffers',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i21.ComboOffer>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i22.ComboOfferPage> getComboOffersPage(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'comboOffer',
            method: 'getComboOffersPage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'comboOffer',
          methodName: 'getComboOffersPage',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i22.ComboOfferPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> setComboOfferActive(
    _i1.TestSessionBuilder sessionBuilder,
    String comboId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'comboOffer',
            method: 'setComboOfferActive',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'comboOffer',
          methodName: 'setComboOfferActive',
          parameters: _i1.testObjectToJson({
            'comboId': comboId,
            'isActive': isActive,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i21.ComboOffer>> checkApplicableCombos(
    _i1.TestSessionBuilder sessionBuilder,
    List<_i23.CartItemInput> cartItems,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'comboOffer',
            method: 'checkApplicableCombos',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'comboOffer',
          methodName: 'checkApplicableCombos',
          parameters: _i1.testObjectToJson({'cartItems': cartItems}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i21.ComboOffer>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ComplaintEndpoint {
  _ComplaintEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i24.Complaint> createComplaint(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required String orderItemId,
    required String issueType,
    required String description,
    required List<String> imageUrls,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'createComplaint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'createComplaint',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'orderNumber': orderNumber,
            'orderItemId': orderItemId,
            'issueType': issueType,
            'description': description,
            'imageUrls': imageUrls,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint> createProductComplaint(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required List<String> selectedOrderItemIds,
    required String issueType,
    String? title,
    required String description,
    required List<String> imageUrls,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'createProductComplaint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'createProductComplaint',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'orderNumber': orderNumber,
            'selectedOrderItemIds': selectedOrderItemIds,
            'issueType': issueType,
            'title': title,
            'description': description,
            'imageUrls': imageUrls,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint> createDeliveryComplaint(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required String issueType,
    String? title,
    required String description,
    required List<String> imageUrls,
    String? selectedField,
    _i25.Address? requestedAddress,
    String? requestedNote,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'createDeliveryComplaint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'createDeliveryComplaint',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'orderNumber': orderNumber,
            'issueType': issueType,
            'title': title,
            'description': description,
            'imageUrls': imageUrls,
            'selectedField': selectedField,
            'requestedAddress': requestedAddress,
            'requestedNote': requestedNote,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint?> getActiveComplaintForOrder(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required String complaintType,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'getActiveComplaintForOrder',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'getActiveComplaintForOrder',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'orderNumber': orderNumber,
            'complaintType': complaintType,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i26.ComplaintPage> listMyComplaints(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'listMyComplaints',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'listMyComplaints',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'status': status,
            'issueType': issueType,
            'selectedField': selectedField,
            'complaintType': complaintType,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i26.ComplaintPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint?> getMyComplaint(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'getMyComplaint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'getMyComplaint',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint?> getComplaintForOrderItem(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String orderItemId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'getComplaintForOrderItem',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'getComplaintForOrderItem',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'orderItemId': orderItemId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i26.ComplaintPage> listComplaints(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'listComplaints',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'listComplaints',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'status': status,
            'issueType': issueType,
            'selectedField': selectedField,
            'complaintType': complaintType,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i26.ComplaintPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint?> getComplaintAdmin(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'getComplaintAdmin',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'getComplaintAdmin',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint> updateComplaintStatus(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required String status,
    String? adminReply,
    String? adminNote,
    String? resolutionType,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'updateComplaintStatus',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'updateComplaintStatus',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
            'status': status,
            'adminReply': adminReply,
            'adminNote': adminNote,
            'resolutionType': resolutionType,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<double> calculateRefundCap(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'calculateRefundCap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'calculateRefundCap',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<double>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint> refundComplaint(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required double amount,
    String? adminReply,
    String? adminNote,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'refundComplaint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'refundComplaint',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
            'amount': amount,
            'adminReply': adminReply,
            'adminNote': adminNote,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint> createReplacementOrder(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    String? adminReply,
    String? adminNote,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'createReplacementOrder',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'createReplacementOrder',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
            'adminReply': adminReply,
            'adminNote': adminNote,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint> retryDelivery(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    String? adminReply,
    String? adminNote,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'retryDelivery',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'retryDelivery',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
            'adminReply': adminReply,
            'adminNote': adminNote,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint> reassignRider(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required String riderName,
    required String riderPhone,
    String? adminReply,
    String? adminNote,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'reassignRider',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'reassignRider',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
            'riderName': riderName,
            'riderPhone': riderPhone,
            'adminReply': adminReply,
            'adminNote': adminNote,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint> rejectComplaint(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    String? adminReply,
    String? adminNote,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'rejectComplaint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'rejectComplaint',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
            'adminReply': adminReply,
            'adminNote': adminNote,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i24.Complaint> replyToComplaint(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required String adminReply,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'replyToComplaint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'replyToComplaint',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
            'adminReply': adminReply,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i24.Complaint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i27.RefundRecord?> getRefundForComplaint(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'getRefundForComplaint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'getRefundForComplaint',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i27.RefundRecord?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i27.RefundRecord?> getUserRefundForComplaint(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'complaint',
            method: 'getUserRefundForComplaint',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'complaint',
          methodName: 'getUserRefundForComplaint',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'complaintId': complaintId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i27.RefundRecord?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CouponEndpoint {
  _CouponEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i28.Coupon>> fetchCoupons(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'fetchCoupons',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'fetchCoupons',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i28.Coupon>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> uploadCoupon(
    _i1.TestSessionBuilder sessionBuilder,
    _i28.Coupon coupon,
    String firebaseUid,
    String idToken, {
    _i14.NotificationDraft? notificationDraft,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'uploadCoupon',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'uploadCoupon',
          parameters: _i1.testObjectToJson({
            'coupon': coupon,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'notificationDraft': notificationDraft,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> setCouponActive(
    _i1.TestSessionBuilder sessionBuilder,
    String code,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'setCouponActive',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'setCouponActive',
          parameters: _i1.testObjectToJson({
            'code': code,
            'isActive': isActive,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> updateCoupon(
    _i1.TestSessionBuilder sessionBuilder,
    _i28.Coupon coupon,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'updateCoupon',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'updateCoupon',
          parameters: _i1.testObjectToJson({
            'coupon': coupon,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteCoupon(
    _i1.TestSessionBuilder sessionBuilder,
    String code,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'deleteCoupon',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'deleteCoupon',
          parameters: _i1.testObjectToJson({
            'code': code,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i29.CouponDisplay>> fetchApplicableCoupons(
    _i1.TestSessionBuilder sessionBuilder,
    double orderAmount,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'fetchApplicableCoupons',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'fetchApplicableCoupons',
          parameters: _i1.testObjectToJson({'orderAmount': orderAmount}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i29.CouponDisplay>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i30.CouponValidationResult> validateCoupon(
    _i1.TestSessionBuilder sessionBuilder,
    String couponCode,
    double orderAmount,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'validateCoupon',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'validateCoupon',
          parameters: _i1.testObjectToJson({
            'couponCode': couponCode,
            'orderAmount': orderAmount,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i30.CouponValidationResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i30.CouponValidationResult> applyCoupon(
    _i1.TestSessionBuilder sessionBuilder,
    String userId,
    String couponCode,
    double cartSubtotal,
    List<_i23.CartItemInput> cartItems,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'applyCoupon',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'applyCoupon',
          parameters: _i1.testObjectToJson({
            'userId': userId,
            'couponCode': couponCode,
            'cartSubtotal': cartSubtotal,
            'cartItems': cartItems,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i30.CouponValidationResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i29.CouponDisplay>> getAvailableCoupons(
    _i1.TestSessionBuilder sessionBuilder,
    String userId,
    double cartSubtotal,
    List<_i23.CartItemInput> cartItems,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'getAvailableCoupons',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'getAvailableCoupons',
          parameters: _i1.testObjectToJson({
            'userId': userId,
            'cartSubtotal': cartSubtotal,
            'cartItems': cartItems,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i29.CouponDisplay>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i31.BestCouponResult> getBestCoupon(
    _i1.TestSessionBuilder sessionBuilder,
    String userId,
    double cartSubtotal,
    List<_i23.CartItemInput> cartItems,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'coupon',
            method: 'getBestCoupon',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'coupon',
          methodName: 'getBestCoupon',
          parameters: _i1.testObjectToJson({
            'userId': userId,
            'cartSubtotal': cartSubtotal,
            'cartItems': cartItems,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i31.BestCouponResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _FreeDeliveryEndpoint {
  _FreeDeliveryEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i32.DeliveryConfig> getDeliveryConfig(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'getDeliveryConfig',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'getDeliveryConfig',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i32.DeliveryConfig>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i33.DeliveryPricingResult> getUserDeliveryOffer(
    _i1.TestSessionBuilder sessionBuilder,
    String userId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'getUserDeliveryOffer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'getUserDeliveryOffer',
          parameters: _i1.testObjectToJson({'userId': userId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i33.DeliveryPricingResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i12.OfferMutationResult> setProductFreeDelivery(
    _i1.TestSessionBuilder sessionBuilder,
    String productId,
    bool isFreeDelivery,
    String firebaseUid,
    String idToken, {
    required bool confirmDisableConflictingCombo,
    required bool forceDisableBogo,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'setProductFreeDelivery',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'setProductFreeDelivery',
          parameters: _i1.testObjectToJson({
            'productId': productId,
            'isFreeDelivery': isFreeDelivery,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'confirmDisableConflictingCombo': confirmDisableConflictingCombo,
            'forceDisableBogo': forceDisableBogo,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i12.OfferMutationResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i12.OfferMutationResult> setCategoryFreeDelivery(
    _i1.TestSessionBuilder sessionBuilder,
    String categoryName,
    bool isFreeDelivery,
    String firebaseUid,
    String idToken, {
    required bool confirmDisableConflictingCombo,
    required bool forceDisableBogo,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'setCategoryFreeDelivery',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'setCategoryFreeDelivery',
          parameters: _i1.testObjectToJson({
            'categoryName': categoryName,
            'isFreeDelivery': isFreeDelivery,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'confirmDisableConflictingCombo': confirmDisableConflictingCombo,
            'forceDisableBogo': forceDisableBogo,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i12.OfferMutationResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> upsertDeliveryConfig(
    _i1.TestSessionBuilder sessionBuilder,
    _i32.DeliveryConfig config,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'upsertDeliveryConfig',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'upsertDeliveryConfig',
          parameters: _i1.testObjectToJson({
            'config': config,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i34.DeliveryRule>> getAllDeliveryRules(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'getAllDeliveryRules',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'getAllDeliveryRules',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i34.DeliveryRule>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i35.DeliveryRulePage> getDeliveryRulesPage(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken, {
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'getDeliveryRulesPage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'getDeliveryRulesPage',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i35.DeliveryRulePage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> upsertDeliveryRule(
    _i1.TestSessionBuilder sessionBuilder,
    _i34.DeliveryRule rule,
    String firebaseUid,
    String idToken, {
    _i14.NotificationDraft? notificationDraft,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'upsertDeliveryRule',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'upsertDeliveryRule',
          parameters: _i1.testObjectToJson({
            'rule': rule,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'notificationDraft': notificationDraft,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteDeliveryRule(
    _i1.TestSessionBuilder sessionBuilder,
    String ruleId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'deleteDeliveryRule',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'deleteDeliveryRule',
          parameters: _i1.testObjectToJson({
            'ruleId': ruleId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> setDeliveryRuleActive(
    _i1.TestSessionBuilder sessionBuilder,
    String ruleId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'setDeliveryRuleActive',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'setDeliveryRuleActive',
          parameters: _i1.testObjectToJson({
            'ruleId': ruleId,
            'isActive': isActive,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i33.DeliveryPricingResult> calculateDeliveryPricing(
    _i1.TestSessionBuilder sessionBuilder,
    double cartTotal, {
    String? userId,
    String? location,
    List<_i23.CartItemInput>? cartItems,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'freeDelivery',
            method: 'calculateDeliveryPricing',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'freeDelivery',
          methodName: 'calculateDeliveryPricing',
          parameters: _i1.testObjectToJson({
            'cartTotal': cartTotal,
            'userId': userId,
            'location': location,
            'cartItems': cartItems,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i33.DeliveryPricingResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _NotificationEndpoint {
  _NotificationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> registerFcmToken(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String token,
    String deviceId,
    String platform,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'registerFcmToken',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'registerFcmToken',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'token': token,
            'deviceId': deviceId,
            'platform': platform,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> unregisterFcmToken(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String deviceId, {
    String? token,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'unregisterFcmToken',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'unregisterFcmToken',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'deviceId': deviceId,
            'token': token,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i36.NotificationPreference> getPreferences(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'getPreferences',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'getPreferences',
          parameters: _i1.testObjectToJson({'firebaseUid': firebaseUid}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i36.NotificationPreference>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i36.NotificationPreference> updatePreferences(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    _i36.NotificationPreference preferences,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'updatePreferences',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'updatePreferences',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'preferences': preferences,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i36.NotificationPreference>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i37.NotificationHistoryPage> listNotifications(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid, {
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'listNotifications',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'listNotifications',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i37.NotificationHistoryPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> markNotificationRead(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String campaignId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'markNotificationRead',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'markNotificationRead',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'campaignId': campaignId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteNotification(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String campaignId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'deleteNotification',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'deleteNotification',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'campaignId': campaignId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> createAnnouncement(
    _i1.TestSessionBuilder sessionBuilder,
    _i14.NotificationDraft draft,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'createAnnouncement',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'createAnnouncement',
          parameters: _i1.testObjectToJson({
            'draft': draft,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i38.AdminNotificationPreference>>
  getAdminNotificationPreferences(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'getAdminNotificationPreferences',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'getAdminNotificationPreferences',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i38.AdminNotificationPreference>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i38.AdminNotificationPreference>
  updateAdminNotificationPreference(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
    String key,
    bool pushEnabled,
    bool soundEnabled,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'updateAdminNotificationPreference',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'updateAdminNotificationPreference',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'key': key,
            'pushEnabled': pushEnabled,
            'soundEnabled': soundEnabled,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i38.AdminNotificationPreference>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> registerAdminFcmToken(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
    String token,
    String deviceId,
    String platform,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'registerAdminFcmToken',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'registerAdminFcmToken',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'token': token,
            'deviceId': deviceId,
            'platform': platform,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> unregisterAdminFcmToken(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
    String deviceId, {
    String? token,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'unregisterAdminFcmToken',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'unregisterAdminFcmToken',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'deviceId': deviceId,
            'token': token,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i39.BroadcastSummary> createBroadcast(
    _i1.TestSessionBuilder sessionBuilder,
    _i40.BroadcastRequest request,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'createBroadcast',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'createBroadcast',
          parameters: _i1.testObjectToJson({
            'request': request,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i39.BroadcastSummary>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i39.BroadcastSummary> saveBroadcastDraft(
    _i1.TestSessionBuilder sessionBuilder,
    _i40.BroadcastRequest request,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'saveBroadcastDraft',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'saveBroadcastDraft',
          parameters: _i1.testObjectToJson({
            'request': request,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i39.BroadcastSummary>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i39.BroadcastSummary> sendBroadcastDraft(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
    String broadcastId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'sendBroadcastDraft',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'sendBroadcastDraft',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'broadcastId': broadcastId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i39.BroadcastSummary>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i41.BroadcastPage> listBroadcasts(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken, {
    String? status,
    String? query,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'listBroadcasts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'listBroadcasts',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'status': status,
            'query': query,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i41.BroadcastPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteBroadcastDraft(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
    String broadcastId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'deleteBroadcastDraft',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'deleteBroadcastDraft',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'broadcastId': broadcastId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _OrderEndpoint {
  _OrderEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> createOrder(
    _i1.TestSessionBuilder sessionBuilder,
    _i20.Order order,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'createOrder',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'createOrder',
          parameters: _i1.testObjectToJson({'order': order}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> createPendingOrder(
    _i1.TestSessionBuilder sessionBuilder,
    _i20.Order order,
    String idempotencyKey,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'createPendingOrder',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'createPendingOrder',
          parameters: _i1.testObjectToJson({
            'order': order,
            'idempotencyKey': idempotencyKey,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i20.Order>> getOrders(
    _i1.TestSessionBuilder sessionBuilder, {
    String? status,
    required String firebaseUid,
    required String idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'getOrders',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'getOrders',
          parameters: _i1.testObjectToJson({
            'status': status,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i20.Order>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i42.OrderPage> getOrdersPage(
    _i1.TestSessionBuilder sessionBuilder, {
    String? status,
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'getOrdersPage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'getOrdersPage',
          parameters: _i1.testObjectToJson({
            'status': status,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i42.OrderPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<int> getOrdersCount(
    _i1.TestSessionBuilder sessionBuilder, {
    String? status,
    required String firebaseUid,
    required String idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'getOrdersCount',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'getOrdersCount',
          parameters: _i1.testObjectToJson({
            'status': status,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i20.Order>> getTodayOrders(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'getTodayOrders',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'getTodayOrders',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i20.Order>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i20.Order>> getUserOrders(
    _i1.TestSessionBuilder sessionBuilder,
    String userId,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'getUserOrders',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'getUserOrders',
          parameters: _i1.testObjectToJson({
            'userId': userId,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i20.Order>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i20.Order?> getOrderById(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'getOrderById',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'getOrderById',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i20.Order?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> updateOrderStatus(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String newStatus, {
    String? cancellationReason,
    required String firebaseUid,
    required String idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'updateOrderStatus',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'updateOrderStatus',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'newStatus': newStatus,
            'cancellationReason': cancellationReason,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> updatePaymentStatus(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String paymentStatus, {
    String? razorpayPaymentId,
    required String firebaseUid,
    required String idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'updatePaymentStatus',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'updatePaymentStatus',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'paymentStatus': paymentStatus,
            'razorpayPaymentId': razorpayPaymentId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i20.Order?> updateDeliveryAddress(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    _i25.Address deliveryAddress,
    String firebaseUid,
    String idToken, {
    String? deliveryNote,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'updateDeliveryAddress',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'updateDeliveryAddress',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'deliveryAddress': deliveryAddress,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'deliveryNote': deliveryNote,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i20.Order?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> confirmOrder(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'confirmOrder',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'confirmOrder',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> cancelOrder(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String userId, {
    required String idToken,
    required String reason,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'cancelOrder',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'cancelOrder',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'userId': userId,
            'idToken': idToken,
            'reason': reason,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> requestCancellation(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String userId, {
    required String idToken,
    required String reason,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'requestCancellation',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'requestCancellation',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'userId': userId,
            'idToken': idToken,
            'reason': reason,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i42.OrderPage> listCancellationRequests(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'listCancellationRequests',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'listCancellationRequests',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i42.OrderPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> approveCancellationRequest(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId, {
    required String firebaseUid,
    required String idToken,
    double? fixedRefundAmount,
    required String adminNote,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'approveCancellationRequest',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'approveCancellationRequest',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'fixedRefundAmount': fixedRefundAmount,
            'adminNote': adminNote,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> rejectCancellationRequest(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId, {
    required String firebaseUid,
    required String idToken,
    required String adminNote,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'rejectCancellationRequest',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'rejectCancellationRequest',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'adminNote': adminNote,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> assignDeliveryPerson(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String deliveryPersonName,
    String deliveryPersonPhone,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'assignDeliveryPerson',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'assignDeliveryPerson',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'deliveryPersonName': deliveryPersonName,
            'deliveryPersonPhone': deliveryPersonPhone,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<Map<String, dynamic>> getDashboardStats(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'order',
            method: 'getDashboardStats',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'order',
          methodName: 'getDashboardStats',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<Map<String, dynamic>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _OrderPgEndpoint {
  _OrderPgEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> createPendingOrder(
    _i1.TestSessionBuilder sessionBuilder,
    _i20.Order order,
    String idempotencyKey,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'orderPg',
            method: 'createPendingOrder',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'orderPg',
          methodName: 'createPendingOrder',
          parameters: _i1.testObjectToJson({
            'order': order,
            'idempotencyKey': idempotencyKey,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i42.OrderPage> getOrdersForUser(
    _i1.TestSessionBuilder sessionBuilder, {
    required String userReference,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'orderPg',
            method: 'getOrdersForUser',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'orderPg',
          methodName: 'getOrdersForUser',
          parameters: _i1.testObjectToJson({
            'userReference': userReference,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i42.OrderPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _OrderRealtimeEndpoint {
  _OrderRealtimeEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Stream<_i44.OrderRealtimeEvent> watchAdminOrders(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) {
    var _localTestStreamManager =
        _i1.TestStreamManager<_i44.OrderRealtimeEvent>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
              endpoint: 'orderRealtime',
              method: 'watchAdminOrders',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'orderRealtime',
              methodName: 'watchAdminOrders',
              arguments: {
                'firebaseUid': firebaseUid,
                'idToken': idToken,
              },
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<_i44.OrderRealtimeEvent> watchDashboardUpdates(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) {
    var _localTestStreamManager =
        _i1.TestStreamManager<_i44.OrderRealtimeEvent>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
              endpoint: 'orderRealtime',
              method: 'watchDashboardUpdates',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'orderRealtime',
              methodName: 'watchDashboardUpdates',
              arguments: {
                'firebaseUid': firebaseUid,
                'idToken': idToken,
              },
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<_i44.OrderRealtimeEvent> watchUserOrders(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) {
    var _localTestStreamManager =
        _i1.TestStreamManager<_i44.OrderRealtimeEvent>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
              endpoint: 'orderRealtime',
              method: 'watchUserOrders',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'orderRealtime',
              methodName: 'watchUserOrders',
              arguments: {
                'firebaseUid': firebaseUid,
                'idToken': idToken,
              },
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _OrderTrackingEndpoint {
  _OrderTrackingEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i45.OrderTrackingData?> getTrackingForUser(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'orderTracking',
            method: 'getTrackingForUser',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'orderTracking',
          methodName: 'getTrackingForUser',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i45.OrderTrackingData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i45.OrderTrackingData?> getTrackingForAdmin(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'orderTracking',
            method: 'getTrackingForAdmin',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'orderTracking',
          methodName: 'getTrackingForAdmin',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i45.OrderTrackingData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Stream<_i45.OrderTrackingData> streamTrackingForUser(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) {
    var _localTestStreamManager =
        _i1.TestStreamManager<_i45.OrderTrackingData>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
              endpoint: 'orderTracking',
              method: 'streamTrackingForUser',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'orderTracking',
              methodName: 'streamTrackingForUser',
              arguments: {
                'orderId': orderId,
                'firebaseUid': firebaseUid,
                'idToken': idToken,
              },
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Stream<_i45.OrderTrackingData> streamTrackingForAdmin(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) {
    var _localTestStreamManager =
        _i1.TestStreamManager<_i45.OrderTrackingData>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
              endpoint: 'orderTracking',
              method: 'streamTrackingForAdmin',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'orderTracking',
              methodName: 'streamTrackingForAdmin',
              arguments: {
                'orderId': orderId,
                'firebaseUid': firebaseUid,
                'idToken': idToken,
              },
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<_i45.OrderTrackingData> seedUserLocation(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'orderTracking',
            method: 'seedUserLocation',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'orderTracking',
          methodName: 'seedUserLocation',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'userLatitude': userLatitude,
            'userLongitude': userLongitude,
            'userAddress': userAddress,
            'userLocationType': userLocationType,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i45.OrderTrackingData>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i45.OrderTrackingData> updateTrackingEnabled(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    bool enabled,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'orderTracking',
            method: 'updateTrackingEnabled',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'orderTracking',
          methodName: 'updateTrackingEnabled',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'enabled': enabled,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i45.OrderTrackingData>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i45.OrderTrackingData> updateRiderLocation(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    double riderLatitude,
    double riderLongitude,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'orderTracking',
            method: 'updateRiderLocation',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'orderTracking',
          methodName: 'updateRiderLocation',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'riderLatitude': riderLatitude,
            'riderLongitude': riderLongitude,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i45.OrderTrackingData>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<List<double>>> getDeliveryRoute(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    double riderLatitude,
    double riderLongitude,
    double userLatitude,
    double userLongitude,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'orderTracking',
            method: 'getDeliveryRoute',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'orderTracking',
          methodName: 'getDeliveryRoute',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'riderLatitude': riderLatitude,
            'riderLongitude': riderLongitude,
            'userLatitude': userLatitude,
            'userLongitude': userLongitude,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<List<double>>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PaymentEndpoint {
  _PaymentEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i46.PaymentOrderResult> createPaymentOrder(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    double amount,
    String customerPhone,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'createPaymentOrder',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'createPaymentOrder',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'amount': amount,
            'customerPhone': customerPhone,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i46.PaymentOrderResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i47.PaymentVerifyResult> verifyPayment(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
    String razorpaySignature,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'verifyPayment',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'verifyPayment',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'razorpayOrderId': razorpayOrderId,
            'razorpayPaymentId': razorpayPaymentId,
            'razorpaySignature': razorpaySignature,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i47.PaymentVerifyResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> markPaymentFailed(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'markPaymentFailed',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'markPaymentFailed',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> initiateRefund(
    _i1.TestSessionBuilder sessionBuilder,
    String razorpayPaymentId,
    double amount,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'initiateRefund',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'initiateRefund',
          parameters: _i1.testObjectToJson({
            'razorpayPaymentId': razorpayPaymentId,
            'amount': amount,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> getPaymentStatus(
    _i1.TestSessionBuilder sessionBuilder,
    String razorpayPaymentId,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'getPaymentStatus',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'getPaymentStatus',
          parameters: _i1.testObjectToJson({
            'razorpayPaymentId': razorpayPaymentId,
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i47.PaymentVerifyResult> completePaymentVerification(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'completePaymentVerification',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'completePaymentVerification',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'razorpayOrderId': razorpayOrderId,
            'razorpayPaymentId': razorpayPaymentId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i47.PaymentVerifyResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> getPaymentStatusWithMessage(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'getPaymentStatusWithMessage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'getPaymentStatusWithMessage',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> adminReconcileAllPendingPayments(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'adminReconcileAllPendingPayments',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'adminReconcileAllPendingPayments',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<Map<String, dynamic>> adminGetPaymentDetail(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'adminGetPaymentDetail',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'adminGetPaymentDetail',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<Map<String, dynamic>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i42.OrderPage> adminSearchOrders(
    _i1.TestSessionBuilder sessionBuilder, {
    String? query,
    String? status,
    String? paymentStatus,
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'adminSearchOrders',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'adminSearchOrders',
          parameters: _i1.testObjectToJson({
            'query': query,
            'status': status,
            'paymentStatus': paymentStatus,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i42.OrderPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<Map<String, dynamic>> adminGetLivePaymentStatus(
    _i1.TestSessionBuilder sessionBuilder,
    String razorpayPaymentId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'adminGetLivePaymentStatus',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'adminGetLivePaymentStatus',
          parameters: _i1.testObjectToJson({
            'razorpayPaymentId': razorpayPaymentId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<Map<String, dynamic>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<Map<String, dynamic>> adminGetRefundDetail(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'adminGetRefundDetail',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'adminGetRefundDetail',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<Map<String, dynamic>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i43.PaymentActionResult> recoverPendingPayments(
    _i1.TestSessionBuilder sessionBuilder,
    String userId, {
    required String idToken,
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'payment',
            method: 'recoverPendingPayments',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'payment',
          methodName: 'recoverPendingPayments',
          parameters: _i1.testObjectToJson({
            'userId': userId,
            'idToken': idToken,
            'limit': limit,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i43.PaymentActionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PricingEndpoint {
  _PricingEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i48.CartPricingResult> calculateCartPricing(
    _i1.TestSessionBuilder sessionBuilder,
    List<_i23.CartItemInput> items, {
    String? userId,
    String? appliedCouponCode,
    required bool autoApplyCoupons,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'pricing',
            method: 'calculateCartPricing',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'pricing',
          methodName: 'calculateCartPricing',
          parameters: _i1.testObjectToJson({
            'items': items,
            'userId': userId,
            'appliedCouponCode': appliedCouponCode,
            'autoApplyCoupons': autoApplyCoupons,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i48.CartPricingResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i49.AppliedOfferInfo>> getApplicableOffers(
    _i1.TestSessionBuilder sessionBuilder,
    List<_i23.CartItemInput> items,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'pricing',
            method: 'getApplicableOffers',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'pricing',
          methodName: 'getApplicableOffers',
          parameters: _i1.testObjectToJson({'items': items}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i49.AppliedOfferInfo>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i50.BasketSuggestionResult> basketSuggestions(
    _i1.TestSessionBuilder sessionBuilder,
    List<_i23.CartItemInput>? items, {
    double? cartTotal,
    required String mode,
    String? userId,
    String? appliedCouponCode,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'pricing',
            method: 'basketSuggestions',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'pricing',
          methodName: 'basketSuggestions',
          parameters: _i1.testObjectToJson({
            'items': items,
            'cartTotal': cartTotal,
            'mode': mode,
            'userId': userId,
            'appliedCouponCode': appliedCouponCode,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i50.BasketSuggestionResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<double> calculateDeliveryFee(
    _i1.TestSessionBuilder sessionBuilder,
    double orderAmount,
    int itemCount,
    String? couponCode,
    String? userId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'pricing',
            method: 'calculateDeliveryFee',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'pricing',
          methodName: 'calculateDeliveryFee',
          parameters: _i1.testObjectToJson({
            'orderAmount': orderAmount,
            'itemCount': itemCount,
            'couponCode': couponCode,
            'userId': userId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<double>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ProductEndpoint {
  _ProductEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i51.Product>> getProductsByIds(
    _i1.TestSessionBuilder sessionBuilder,
    List<String> productIds,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'getProductsByIds',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'getProductsByIds',
          parameters: _i1.testObjectToJson({'productIds': productIds}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i51.Product>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i51.Product>> getProducts(
    _i1.TestSessionBuilder sessionBuilder, {
    required int limit,
    String? lastProductName,
    String? lastProductId,
    String? category,
    List<String>? subcategories,
    required String sortBy,
    bool? freeDelivery,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'getProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'getProducts',
          parameters: _i1.testObjectToJson({
            'limit': limit,
            'lastProductName': lastProductName,
            'lastProductId': lastProductId,
            'category': category,
            'subcategories': subcategories,
            'sortBy': sortBy,
            'freeDelivery': freeDelivery,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i51.Product>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i52.ProductPage> getProductsPage(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required int limit,
    String? pageToken,
    String? category,
    List<String>? subcategories,
    required String sortBy,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'getProductsPage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'getProductsPage',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
            'pageToken': pageToken,
            'category': category,
            'subcategories': subcategories,
            'sortBy': sortBy,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i52.ProductPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<int> getProductsCount(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    String? category,
    List<String>? subcategories,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'getProductsCount',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'getProductsCount',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'category': category,
            'subcategories': subcategories,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String?> uploadProduct(
    _i1.TestSessionBuilder sessionBuilder,
    _i51.Product product,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'uploadProduct',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'uploadProduct',
          parameters: _i1.testObjectToJson({
            'product': product,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> updateProduct(
    _i1.TestSessionBuilder sessionBuilder,
    _i51.Product product,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'updateProduct',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'updateProduct',
          parameters: _i1.testObjectToJson({
            'product': product,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> checkProductUpdateConflicts(
    _i1.TestSessionBuilder sessionBuilder,
    _i51.Product product,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'checkProductUpdateConflicts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'checkProductUpdateConflicts',
          parameters: _i1.testObjectToJson({
            'product': product,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> deleteProduct(
    _i1.TestSessionBuilder sessionBuilder,
    String productId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'deleteProduct',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'deleteProduct',
          parameters: _i1.testObjectToJson({
            'productId': productId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deactivateProduct(
    _i1.TestSessionBuilder sessionBuilder,
    String productId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'deactivateProduct',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'deactivateProduct',
          parameters: _i1.testObjectToJson({
            'productId': productId,
            'isActive': isActive,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<String>> getProductSuggestions(
    _i1.TestSessionBuilder sessionBuilder,
    String query,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'getProductSuggestions',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'getProductSuggestions',
          parameters: _i1.testObjectToJson({'query': query}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<String>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i52.ProductPage> searchProducts(
    _i1.TestSessionBuilder sessionBuilder,
    String query, {
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'searchProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'searchProducts',
          parameters: _i1.testObjectToJson({
            'query': query,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i52.ProductPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i53.OfferSearchPage> getProductsByOffer(
    _i1.TestSessionBuilder sessionBuilder, {
    required String offerType,
    required String query,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'getProductsByOffer',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'getProductsByOffer',
          parameters: _i1.testObjectToJson({
            'offerType': offerType,
            'query': query,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i53.OfferSearchPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i53.OfferSearchPage> getComboProducts(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'getComboProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'getComboProducts',
          parameters: _i1.testObjectToJson({
            'query': query,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i53.OfferSearchPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i53.OfferSearchPage> getBogoProducts(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'getBogoProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'getBogoProducts',
          parameters: _i1.testObjectToJson({
            'query': query,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i53.OfferSearchPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i53.OfferSearchPage> searchProductsWithOfferFilters(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
    required String offerFilter,
    required int limit,
    String? pageToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'searchProductsWithOfferFilters',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'searchProductsWithOfferFilters',
          parameters: _i1.testObjectToJson({
            'query': query,
            'offerFilter': offerFilter,
            'limit': limit,
            'pageToken': pageToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i53.OfferSearchPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<int> migrateProducts(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'migrateProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'migrateProducts',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<int> initializeProductMetrics(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'initializeProductMetrics',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'initializeProductMetrics',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> incrementProductSearch(
    _i1.TestSessionBuilder sessionBuilder,
    String productId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'incrementProductSearch',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'incrementProductSearch',
          parameters: _i1.testObjectToJson({'productId': productId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> incrementProductPurchase(
    _i1.TestSessionBuilder sessionBuilder,
    String productId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'incrementProductPurchase',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'incrementProductPurchase',
          parameters: _i1.testObjectToJson({'productId': productId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<int> seedProductMetricsForTesting(
    _i1.TestSessionBuilder sessionBuilder,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'seedProductMetricsForTesting',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'seedProductMetricsForTesting',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ProductPgEndpoint {
  _ProductPgEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i52.ProductPage> getActiveProductsPage(
    _i1.TestSessionBuilder sessionBuilder, {
    required int limit,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'productPg',
            method: 'getActiveProductsPage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'productPg',
          methodName: 'getActiveProductsPage',
          parameters: _i1.testObjectToJson({
            'limit': limit,
            'pageToken': pageToken,
            'categoryId': categoryId,
            'subCategoryId': subCategoryId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i52.ProductPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i52.ProductPage> searchActiveProducts(
    _i1.TestSessionBuilder sessionBuilder, {
    required String query,
    required int limit,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
    required double similarityThreshold,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'productPg',
            method: 'searchActiveProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'productPg',
          methodName: 'searchActiveProducts',
          parameters: _i1.testObjectToJson({
            'query': query,
            'limit': limit,
            'pageToken': pageToken,
            'categoryId': categoryId,
            'subCategoryId': subCategoryId,
            'similarityThreshold': similarityThreshold,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i52.ProductPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<void> enqueueSearchRebuild(
    _i1.TestSessionBuilder sessionBuilder, {
    required String productId,
    required String reason,
    required String firebaseUid,
    required String idToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'productPg',
            method: 'enqueueSearchRebuild',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'productPg',
          methodName: 'enqueueSearchRebuild',
          parameters: _i1.testObjectToJson({
            'productId': productId,
            'reason': reason,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<int> processPendingSearchRebuildJobs(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'productPg',
            method: 'processPendingSearchRebuildJobs',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'productPg',
          methodName: 'processPendingSearchRebuildJobs',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'limit': limit,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ProductRankingEndpoint {
  _ProductRankingEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> recordProductView(
    _i1.TestSessionBuilder sessionBuilder,
    String productId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'productRanking',
            method: 'recordProductView',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'productRanking',
          methodName: 'recordProductView',
          parameters: _i1.testObjectToJson({'productId': productId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i54.ProductRankingItem>> getTrendingProducts(
    _i1.TestSessionBuilder sessionBuilder, {
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'productRanking',
            method: 'getTrendingProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'productRanking',
          methodName: 'getTrendingProducts',
          parameters: _i1.testObjectToJson({'limit': limit}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i54.ProductRankingItem>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i54.ProductRankingItem>> getMostSellingProducts(
    _i1.TestSessionBuilder sessionBuilder, {
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'productRanking',
            method: 'getMostSellingProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'productRanking',
          methodName: 'getMostSellingProducts',
          parameters: _i1.testObjectToJson({'limit': limit}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i54.ProductRankingItem>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i54.ProductRankingItem>> getMostViewedProducts(
    _i1.TestSessionBuilder sessionBuilder, {
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'productRanking',
            method: 'getMostViewedProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'productRanking',
          methodName: 'getMostViewedProducts',
          parameters: _i1.testObjectToJson({'limit': limit}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i54.ProductRankingItem>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i54.ProductRankingItem>> getFrequentlyReorderedProducts(
    _i1.TestSessionBuilder sessionBuilder, {
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'productRanking',
            method: 'getFrequentlyReorderedProducts',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'productRanking',
          methodName: 'getFrequentlyReorderedProducts',
          parameters: _i1.testObjectToJson({'limit': limit}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i54.ProductRankingItem>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _RefundEndpoint {
  _RefundEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i27.RefundRecord> initiateRefund(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'refund',
            method: 'initiateRefund',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'refund',
          methodName: 'initiateRefund',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i27.RefundRecord>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i27.RefundRecord?> getRefundStatus(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'refund',
            method: 'getRefundStatus',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'refund',
          methodName: 'getRefundStatus',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i27.RefundRecord?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i27.RefundRecord?> adminGetRefundStatus(
    _i1.TestSessionBuilder sessionBuilder,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'refund',
            method: 'adminGetRefundStatus',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'refund',
          methodName: 'adminGetRefundStatus',
          parameters: _i1.testObjectToJson({
            'orderId': orderId,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i27.RefundRecord?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SubCategoryEndpoint {
  _SubCategoryEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i55.SubCategory>> getSubCategories(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'subCategory',
            method: 'getSubCategories',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subCategory',
          methodName: 'getSubCategories',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i55.SubCategory>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> uploadSubCategory(
    _i1.TestSessionBuilder sessionBuilder,
    _i55.SubCategory subCategory,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'subCategory',
            method: 'uploadSubCategory',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subCategory',
          methodName: 'uploadSubCategory',
          parameters: _i1.testObjectToJson({
            'subCategory': subCategory,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> updateSubCategory(
    _i1.TestSessionBuilder sessionBuilder,
    String categoryName,
    String oldSubName,
    _i55.SubCategory subCategory,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'subCategory',
            method: 'updateSubCategory',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subCategory',
          methodName: 'updateSubCategory',
          parameters: _i1.testObjectToJson({
            'categoryName': categoryName,
            'oldSubName': oldSubName,
            'subCategory': subCategory,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deleteSubCategory(
    _i1.TestSessionBuilder sessionBuilder,
    String categoryName,
    String subCategoryName,
    String firebaseUid,
    String idToken,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'subCategory',
            method: 'deleteSubCategory',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'subCategory',
          methodName: 'deleteSubCategory',
          parameters: _i1.testObjectToJson({
            'categoryName': categoryName,
            'subCategoryName': subCategoryName,
            'firebaseUid': firebaseUid,
            'idToken': idToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SupportEndpoint {
  _SupportEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i56.SupportIssue> submitIssue(
    _i1.TestSessionBuilder sessionBuilder, {
    required String firebaseUid,
    required String idToken,
    required String issueType,
    required String title,
    required String description,
    String? screenshotUrl,
    required String appVersion,
    required String buildNumber,
    required String deviceInfo,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'support',
            method: 'submitIssue',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'support',
          methodName: 'submitIssue',
          parameters: _i1.testObjectToJson({
            'firebaseUid': firebaseUid,
            'idToken': idToken,
            'issueType': issueType,
            'title': title,
            'description': description,
            'screenshotUrl': screenshotUrl,
            'appVersion': appVersion,
            'buildNumber': buildNumber,
            'deviceInfo': deviceInfo,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i56.SupportIssue>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _UserEndpoint {
  _UserEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i5.AppUser?> getUserByFirebaseUid(
    _i1.TestSessionBuilder sessionBuilder,
    String uid,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'user',
            method: 'getUserByFirebaseUid',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'user',
          methodName: 'getUserByFirebaseUid',
          parameters: _i1.testObjectToJson({'uid': uid}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i5.AppUser?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i5.AppUser> createOrUpdateUser(
    _i1.TestSessionBuilder sessionBuilder,
    _i5.AppUser user,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'user',
            method: 'createOrUpdateUser',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'user',
          methodName: 'createOrUpdateUser',
          parameters: _i1.testObjectToJson({'user': user}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i5.AppUser>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> updateCart(
    _i1.TestSessionBuilder sessionBuilder,
    String uid,
    List<_i57.CartItem> cart,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'user',
            method: 'updateCart',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'user',
          methodName: 'updateCart',
          parameters: _i1.testObjectToJson({
            'uid': uid,
            'cart': cart,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> updateFcmToken(
    _i1.TestSessionBuilder sessionBuilder,
    String uid,
    String token,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'user',
            method: 'updateFcmToken',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'user',
          methodName: 'updateFcmToken',
          parameters: _i1.testObjectToJson({
            'uid': uid,
            'token': token,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}
