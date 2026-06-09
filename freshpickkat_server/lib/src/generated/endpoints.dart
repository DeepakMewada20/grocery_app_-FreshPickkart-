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
import '../endpoints/admin_endpoint.dart' as _i2;
import '../endpoints/auth_endpoint.dart' as _i3;
import '../endpoints/banner_endpoint.dart' as _i4;
import '../endpoints/bogo_endpoint.dart' as _i5;
import '../endpoints/category_endpoint.dart' as _i6;
import '../endpoints/category_offer_endpoint.dart' as _i7;
import '../endpoints/checkout_endpoint.dart' as _i8;
import '../endpoints/combo_offer_endpoint.dart' as _i9;
import '../endpoints/complaint_endpoint.dart' as _i10;
import '../endpoints/coupon_endpoint.dart' as _i11;
import '../endpoints/free_delivery_endpoint.dart' as _i12;
import '../endpoints/notification_endpoint.dart' as _i13;
import '../endpoints/order_endpoint.dart' as _i14;
import '../endpoints/order_pg_endpoint.dart' as _i15;
import '../endpoints/order_realtime_endpoint.dart' as _i16;
import '../endpoints/order_tracking_endpoint.dart' as _i17;
import '../endpoints/payment_endpoint.dart' as _i18;
import '../endpoints/pricing_endpoint.dart' as _i19;
import '../endpoints/product_endpoint.dart' as _i20;
import '../endpoints/product_pg_endpoint.dart' as _i21;
import '../endpoints/product_ranking_endpoint.dart' as _i22;
import '../endpoints/refund_endpoint.dart' as _i23;
import '../endpoints/sub_category_endpoint.dart' as _i24;
import '../endpoints/support_endpoint.dart' as _i25;
import '../endpoints/user_endpoint.dart' as _i26;
import 'package:freshpickkat_server/src/generated/banner.dart' as _i27;
import 'package:freshpickkat_server/src/generated/bogo_offer.dart' as _i28;
import 'package:freshpickkat_server/src/generated/notification_draft.dart'
    as _i29;
import 'package:freshpickkat_server/src/generated/category.dart' as _i30;
import 'package:freshpickkat_server/src/generated/category_offer.dart' as _i31;
import 'package:freshpickkat_server/src/generated/order.dart' as _i32;
import 'package:freshpickkat_server/src/generated/combo_offer.dart' as _i33;
import 'package:freshpickkat_server/src/generated/cart_item_input.dart' as _i34;
import 'package:freshpickkat_server/src/generated/address.dart' as _i35;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i36;
import 'package:freshpickkat_server/src/generated/delivery_config.dart' as _i37;
import 'package:freshpickkat_server/src/generated/delivery_rule.dart' as _i38;
import 'package:freshpickkat_server/src/generated/notification_preference.dart'
    as _i39;
import 'package:freshpickkat_server/src/generated/broadcast_request.dart'
    as _i40;
import 'package:freshpickkat_server/src/generated/product.dart' as _i41;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i42;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i43;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i44;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i45;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i46;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'admin': _i2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'auth': _i3.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'banner': _i4.BannerEndpoint()
        ..initialize(
          server,
          'banner',
          null,
        ),
      'bogo': _i5.BogoEndpoint()
        ..initialize(
          server,
          'bogo',
          null,
        ),
      'category': _i6.CategoryEndpoint()
        ..initialize(
          server,
          'category',
          null,
        ),
      'categoryOffer': _i7.CategoryOfferEndpoint()
        ..initialize(
          server,
          'categoryOffer',
          null,
        ),
      'checkout': _i8.CheckoutEndpoint()
        ..initialize(
          server,
          'checkout',
          null,
        ),
      'comboOffer': _i9.ComboOfferEndpoint()
        ..initialize(
          server,
          'comboOffer',
          null,
        ),
      'complaint': _i10.ComplaintEndpoint()
        ..initialize(
          server,
          'complaint',
          null,
        ),
      'coupon': _i11.CouponEndpoint()
        ..initialize(
          server,
          'coupon',
          null,
        ),
      'freeDelivery': _i12.FreeDeliveryEndpoint()
        ..initialize(
          server,
          'freeDelivery',
          null,
        ),
      'notification': _i13.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'order': _i14.OrderEndpoint()
        ..initialize(
          server,
          'order',
          null,
        ),
      'orderPg': _i15.OrderPgEndpoint()
        ..initialize(
          server,
          'orderPg',
          null,
        ),
      'orderRealtime': _i16.OrderRealtimeEndpoint()
        ..initialize(
          server,
          'orderRealtime',
          null,
        ),
      'orderTracking': _i17.OrderTrackingEndpoint()
        ..initialize(
          server,
          'orderTracking',
          null,
        ),
      'payment': _i18.PaymentEndpoint()
        ..initialize(
          server,
          'payment',
          null,
        ),
      'pricing': _i19.PricingEndpoint()
        ..initialize(
          server,
          'pricing',
          null,
        ),
      'product': _i20.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'productPg': _i21.ProductPgEndpoint()
        ..initialize(
          server,
          'productPg',
          null,
        ),
      'productRanking': _i22.ProductRankingEndpoint()
        ..initialize(
          server,
          'productRanking',
          null,
        ),
      'refund': _i23.RefundEndpoint()
        ..initialize(
          server,
          'refund',
          null,
        ),
      'subCategory': _i24.SubCategoryEndpoint()
        ..initialize(
          server,
          'subCategory',
          null,
        ),
      'support': _i25.SupportEndpoint()
        ..initialize(
          server,
          'support',
          null,
        ),
      'user': _i26.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'isAdminSetupCompleted': _i1.MethodConnector(
          name: 'isAdminSetupCompleted',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint)
                  .isAdminSetupCompleted(session),
        ),
        'resolveAdminLoginEmail': _i1.MethodConnector(
          name: 'resolveAdminLoginEmail',
          params: {
            'usernameOrEmail': _i1.ParameterDescription(
              name: 'usernameOrEmail',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint)
                  .resolveAdminLoginEmail(
                    session,
                    params['usernameOrEmail'],
                  ),
        ),
        'firebaseLogin': _i1.MethodConnector(
          name: 'firebaseLogin',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i2.AdminEndpoint).firebaseLogin(
                    session,
                    params['idToken'],
                  ),
        ),
        'completeFirebaseSetup': _i1.MethodConnector(
          name: 'completeFirebaseSetup',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint)
                  .completeFirebaseSetup(
                    session,
                    params['idToken'],
                    params['username'],
                  ),
        ),
        'getAllUsers': _i1.MethodConnector(
          name: 'getAllUsers',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint).getAllUsers(
                session,
                params['firebaseUid'],
                params['idToken'],
              ),
        ),
        'getDashboardStats': _i1.MethodConnector(
          name: 'getDashboardStats',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i2.AdminEndpoint).getDashboardStats(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'getAnalytics': _i1.MethodConnector(
          name: 'getAnalytics',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint).getAnalytics(
                session,
                params['firebaseUid'],
                params['idToken'],
              ),
        ),
        'getAuditLogs': _i1.MethodConnector(
          name: 'getAuditLogs',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint).getAuditLogs(
                session,
                params['firebaseUid'],
                params['idToken'],
                limit: params['limit'],
              ),
        ),
        'getActiveUsersWithStats': _i1.MethodConnector(
          name: 'getActiveUsersWithStats',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint)
                  .getActiveUsersWithStats(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                    limit: params['limit'],
                  ),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'signOut': _i1.MethodConnector(
          name: 'signOut',
          params: {
            'uid': _i1.ParameterDescription(
              name: 'uid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i3.AuthEndpoint).signOut(
                session,
                params['uid'],
              ),
        ),
      },
    );
    connectors['banner'] = _i1.EndpointConnector(
      name: 'banner',
      endpoint: endpoints['banner']!,
      methodConnectors: {
        'getBanners': _i1.MethodConnector(
          name: 'getBanners',
          params: {
            'screen': _i1.ParameterDescription(
              name: 'screen',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'activeOnly': _i1.ParameterDescription(
              name: 'activeOnly',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['banner'] as _i4.BannerEndpoint).getBanners(
                session,
                screen: params['screen'],
                activeOnly: params['activeOnly'],
              ),
        ),
        'getBannersPage': _i1.MethodConnector(
          name: 'getBannersPage',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'activeOnly': _i1.ParameterDescription(
              name: 'activeOnly',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'screen': _i1.ParameterDescription(
              name: 'screen',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['banner'] as _i4.BannerEndpoint).getBannersPage(
                    session,
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                    activeOnly: params['activeOnly'],
                    screen: params['screen'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                  ),
        ),
        'getBannerById': _i1.MethodConnector(
          name: 'getBannerById',
          params: {
            'bannerId': _i1.ParameterDescription(
              name: 'bannerId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['banner'] as _i4.BannerEndpoint).getBannerById(
                    session,
                    params['bannerId'],
                  ),
        ),
        'createBanner': _i1.MethodConnector(
          name: 'createBanner',
          params: {
            'banner': _i1.ParameterDescription(
              name: 'banner',
              type: _i1.getType<_i27.Banner>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['banner'] as _i4.BannerEndpoint).createBanner(
                    session,
                    params['banner'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'updateBanner': _i1.MethodConnector(
          name: 'updateBanner',
          params: {
            'banner': _i1.ParameterDescription(
              name: 'banner',
              type: _i1.getType<_i27.Banner>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['banner'] as _i4.BannerEndpoint).updateBanner(
                    session,
                    params['banner'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'deleteBanner': _i1.MethodConnector(
          name: 'deleteBanner',
          params: {
            'bannerId': _i1.ParameterDescription(
              name: 'bannerId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['banner'] as _i4.BannerEndpoint).deleteBanner(
                    session,
                    params['bannerId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'toggleBannerActive': _i1.MethodConnector(
          name: 'toggleBannerActive',
          params: {
            'bannerId': _i1.ParameterDescription(
              name: 'bannerId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'active': _i1.ParameterDescription(
              name: 'active',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['banner'] as _i4.BannerEndpoint)
                  .toggleBannerActive(
                    session,
                    params['bannerId'],
                    params['active'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'updateBannerPriority': _i1.MethodConnector(
          name: 'updateBannerPriority',
          params: {
            'bannerId': _i1.ParameterDescription(
              name: 'bannerId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['banner'] as _i4.BannerEndpoint)
                  .updateBannerPriority(
                    session,
                    params['bannerId'],
                    params['priority'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['bogo'] = _i1.EndpointConnector(
      name: 'bogo',
      endpoint: endpoints['bogo']!,
      methodConnectors: {
        'upsertOfferWithConflicts': _i1.MethodConnector(
          name: 'upsertOfferWithConflicts',
          params: {
            'offer': _i1.ParameterDescription(
              name: 'offer',
              type: _i1.getType<_i28.BogoOffer>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationDraft': _i1.ParameterDescription(
              name: 'notificationDraft',
              type: _i1.getType<_i29.NotificationDraft?>(),
              nullable: true,
            ),
            'confirmDisableConflictingCombo': _i1.ParameterDescription(
              name: 'confirmDisableConflictingCombo',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'forceDisableFreeDelivery': _i1.ParameterDescription(
              name: 'forceDisableFreeDelivery',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint)
                  .upsertOfferWithConflicts(
                    session,
                    params['offer'],
                    params['firebaseUid'],
                    params['idToken'],
                    notificationDraft: params['notificationDraft'],
                    confirmDisableConflictingCombo:
                        params['confirmDisableConflictingCombo'],
                    forceDisableFreeDelivery:
                        params['forceDisableFreeDelivery'],
                  ),
        ),
        'upsertOffer': _i1.MethodConnector(
          name: 'upsertOffer',
          params: {
            'offer': _i1.ParameterDescription(
              name: 'offer',
              type: _i1.getType<_i28.BogoOffer>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationDraft': _i1.ParameterDescription(
              name: 'notificationDraft',
              type: _i1.getType<_i29.NotificationDraft?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint).upsertOffer(
                session,
                params['offer'],
                params['firebaseUid'],
                params['idToken'],
                notificationDraft: params['notificationDraft'],
              ),
        ),
        'deleteOffer': _i1.MethodConnector(
          name: 'deleteOffer',
          params: {
            'triggerProductId': _i1.ParameterDescription(
              name: 'triggerProductId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint).deleteOffer(
                session,
                params['triggerProductId'],
                params['firebaseUid'],
                params['idToken'],
              ),
        ),
        'setBogoOfferActive': _i1.MethodConnector(
          name: 'setBogoOfferActive',
          params: {
            'triggerProductId': _i1.ParameterDescription(
              name: 'triggerProductId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['bogo'] as _i5.BogoEndpoint).setBogoOfferActive(
                    session,
                    params['triggerProductId'],
                    params['isActive'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'getAllOffers': _i1.MethodConnector(
          name: 'getAllOffers',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint).getAllOffers(
                session,
                params['firebaseUid'],
                params['idToken'],
              ),
        ),
        'getOffersPage': _i1.MethodConnector(
          name: 'getOffersPage',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint).getOffersPage(
                session,
                firebaseUid: params['firebaseUid'],
                idToken: params['idToken'],
                limit: params['limit'],
                pageToken: params['pageToken'],
              ),
        ),
        'getActiveOffers': _i1.MethodConnector(
          name: 'getActiveOffers',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint)
                  .getActiveOffers(session),
        ),
        'getActiveOfferForProduct': _i1.MethodConnector(
          name: 'getActiveOfferForProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint)
                  .getActiveOfferForProduct(
                    session,
                    params['productId'],
                  ),
        ),
        'getActiveBogoOffersForProducts': _i1.MethodConnector(
          name: 'getActiveBogoOffersForProducts',
          params: {
            'productIds': _i1.ParameterDescription(
              name: 'productIds',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint)
                  .getActiveBogoOffersForProducts(
                    session,
                    params['productIds'],
                  ),
        ),
        'getOfferForProduct': _i1.MethodConnector(
          name: 'getOfferForProduct',
          params: {
            'triggerProductId': _i1.ParameterDescription(
              name: 'triggerProductId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['bogo'] as _i5.BogoEndpoint).getOfferForProduct(
                    session,
                    params['triggerProductId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['category'] = _i1.EndpointConnector(
      name: 'category',
      endpoint: endpoints['category']!,
      methodConnectors: {
        'getCategories': _i1.MethodConnector(
          name: 'getCategories',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['category'] as _i6.CategoryEndpoint)
                  .getCategories(session),
        ),
        'uploadCategory': _i1.MethodConnector(
          name: 'uploadCategory',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i30.Category>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['category'] as _i6.CategoryEndpoint)
                  .uploadCategory(
                    session,
                    params['category'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'updateCategory': _i1.MethodConnector(
          name: 'updateCategory',
          params: {
            'oldName': _i1.ParameterDescription(
              name: 'oldName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i30.Category>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['category'] as _i6.CategoryEndpoint)
                  .updateCategory(
                    session,
                    params['oldName'],
                    params['category'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'deleteCategory': _i1.MethodConnector(
          name: 'deleteCategory',
          params: {
            'categoryName': _i1.ParameterDescription(
              name: 'categoryName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['category'] as _i6.CategoryEndpoint)
                  .deleteCategory(
                    session,
                    params['categoryName'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'setCategoryActive': _i1.MethodConnector(
          name: 'setCategoryActive',
          params: {
            'categoryName': _i1.ParameterDescription(
              name: 'categoryName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['category'] as _i6.CategoryEndpoint)
                  .setCategoryActive(
                    session,
                    params['categoryName'],
                    params['isActive'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['categoryOffer'] = _i1.EndpointConnector(
      name: 'categoryOffer',
      endpoint: endpoints['categoryOffer']!,
      methodConnectors: {
        'upsertCategoryOffer': _i1.MethodConnector(
          name: 'upsertCategoryOffer',
          params: {
            'offer': _i1.ParameterDescription(
              name: 'offer',
              type: _i1.getType<_i31.CategoryOffer>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationDraft': _i1.ParameterDescription(
              name: 'notificationDraft',
              type: _i1.getType<_i29.NotificationDraft?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['categoryOffer'] as _i7.CategoryOfferEndpoint)
                      .upsertCategoryOffer(
                        session,
                        params['offer'],
                        params['firebaseUid'],
                        params['idToken'],
                        notificationDraft: params['notificationDraft'],
                      ),
        ),
        'deleteCategoryOffer': _i1.MethodConnector(
          name: 'deleteCategoryOffer',
          params: {
            'offerId': _i1.ParameterDescription(
              name: 'offerId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['categoryOffer'] as _i7.CategoryOfferEndpoint)
                      .deleteCategoryOffer(
                        session,
                        params['offerId'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'getActiveCategoryOffers': _i1.MethodConnector(
          name: 'getActiveCategoryOffers',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['categoryOffer'] as _i7.CategoryOfferEndpoint)
                      .getActiveCategoryOffers(session),
        ),
        'getAllCategoryOffers': _i1.MethodConnector(
          name: 'getAllCategoryOffers',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['categoryOffer'] as _i7.CategoryOfferEndpoint)
                      .getAllCategoryOffers(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'getCategoryOffersPage': _i1.MethodConnector(
          name: 'getCategoryOffersPage',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['categoryOffer'] as _i7.CategoryOfferEndpoint)
                      .getCategoryOffersPage(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                        limit: params['limit'],
                        pageToken: params['pageToken'],
                      ),
        ),
        'setCategoryOfferActive': _i1.MethodConnector(
          name: 'setCategoryOfferActive',
          params: {
            'offerId': _i1.ParameterDescription(
              name: 'offerId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['categoryOffer'] as _i7.CategoryOfferEndpoint)
                      .setCategoryOfferActive(
                        session,
                        params['offerId'],
                        params['isActive'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
      },
    );
    connectors['checkout'] = _i1.EndpointConnector(
      name: 'checkout',
      endpoint: endpoints['checkout']!,
      methodConnectors: {
        'createOrderAndPayment': _i1.MethodConnector(
          name: 'createOrderAndPayment',
          params: {
            'order': _i1.ParameterDescription(
              name: 'order',
              type: _i1.getType<_i32.Order>(),
              nullable: false,
            ),
            'idempotencyKey': _i1.ParameterDescription(
              name: 'idempotencyKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'customerPhone': _i1.ParameterDescription(
              name: 'customerPhone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['checkout'] as _i8.CheckoutEndpoint)
                  .createOrderAndPayment(
                    session,
                    params['order'],
                    params['idempotencyKey'],
                    params['amount'],
                    params['customerPhone'],
                  ),
        ),
      },
    );
    connectors['comboOffer'] = _i1.EndpointConnector(
      name: 'comboOffer',
      endpoint: endpoints['comboOffer']!,
      methodConnectors: {
        'upsertComboOfferWithConflicts': _i1.MethodConnector(
          name: 'upsertComboOfferWithConflicts',
          params: {
            'offer': _i1.ParameterDescription(
              name: 'offer',
              type: _i1.getType<_i33.ComboOffer>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationDraft': _i1.ParameterDescription(
              name: 'notificationDraft',
              type: _i1.getType<_i29.NotificationDraft?>(),
              nullable: true,
            ),
            'force': _i1.ParameterDescription(
              name: 'force',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['comboOffer'] as _i9.ComboOfferEndpoint)
                  .upsertComboOfferWithConflicts(
                    session,
                    params['offer'],
                    params['firebaseUid'],
                    params['idToken'],
                    notificationDraft: params['notificationDraft'],
                    force: params['force'],
                  ),
        ),
        'upsertComboOffer': _i1.MethodConnector(
          name: 'upsertComboOffer',
          params: {
            'offer': _i1.ParameterDescription(
              name: 'offer',
              type: _i1.getType<_i33.ComboOffer>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationDraft': _i1.ParameterDescription(
              name: 'notificationDraft',
              type: _i1.getType<_i29.NotificationDraft?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['comboOffer'] as _i9.ComboOfferEndpoint)
                  .upsertComboOffer(
                    session,
                    params['offer'],
                    params['firebaseUid'],
                    params['idToken'],
                    notificationDraft: params['notificationDraft'],
                  ),
        ),
        'deleteComboOffer': _i1.MethodConnector(
          name: 'deleteComboOffer',
          params: {
            'comboId': _i1.ParameterDescription(
              name: 'comboId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['comboOffer'] as _i9.ComboOfferEndpoint)
                  .deleteComboOffer(
                    session,
                    params['comboId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'getActiveComboOffers': _i1.MethodConnector(
          name: 'getActiveComboOffers',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['comboOffer'] as _i9.ComboOfferEndpoint)
                  .getActiveComboOffers(session),
        ),
        'getActiveComboOffersForProducts': _i1.MethodConnector(
          name: 'getActiveComboOffersForProducts',
          params: {
            'productIds': _i1.ParameterDescription(
              name: 'productIds',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['comboOffer'] as _i9.ComboOfferEndpoint)
                  .getActiveComboOffersForProducts(
                    session,
                    params['productIds'],
                  ),
        ),
        'getAllComboOffers': _i1.MethodConnector(
          name: 'getAllComboOffers',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['comboOffer'] as _i9.ComboOfferEndpoint)
                  .getAllComboOffers(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'getComboOffersPage': _i1.MethodConnector(
          name: 'getComboOffersPage',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['comboOffer'] as _i9.ComboOfferEndpoint)
                  .getComboOffersPage(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'setComboOfferActive': _i1.MethodConnector(
          name: 'setComboOfferActive',
          params: {
            'comboId': _i1.ParameterDescription(
              name: 'comboId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['comboOffer'] as _i9.ComboOfferEndpoint)
                  .setComboOfferActive(
                    session,
                    params['comboId'],
                    params['isActive'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'checkApplicableCombos': _i1.MethodConnector(
          name: 'checkApplicableCombos',
          params: {
            'cartItems': _i1.ParameterDescription(
              name: 'cartItems',
              type: _i1.getType<List<_i34.CartItemInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['comboOffer'] as _i9.ComboOfferEndpoint)
                  .checkApplicableCombos(
                    session,
                    params['cartItems'],
                  ),
        ),
      },
    );
    connectors['complaint'] = _i1.EndpointConnector(
      name: 'complaint',
      endpoint: endpoints['complaint']!,
      methodConnectors: {
        'createComplaint': _i1.MethodConnector(
          name: 'createComplaint',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'orderNumber': _i1.ParameterDescription(
              name: 'orderNumber',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'orderItemId': _i1.ParameterDescription(
              name: 'orderItemId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'issueType': _i1.ParameterDescription(
              name: 'issueType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'imageUrls': _i1.ParameterDescription(
              name: 'imageUrls',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .createComplaint(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    orderNumber: params['orderNumber'],
                    orderItemId: params['orderItemId'],
                    issueType: params['issueType'],
                    description: params['description'],
                    imageUrls: params['imageUrls'],
                  ),
        ),
        'createProductComplaint': _i1.MethodConnector(
          name: 'createProductComplaint',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'orderNumber': _i1.ParameterDescription(
              name: 'orderNumber',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'selectedOrderItemIds': _i1.ParameterDescription(
              name: 'selectedOrderItemIds',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
            'issueType': _i1.ParameterDescription(
              name: 'issueType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'imageUrls': _i1.ParameterDescription(
              name: 'imageUrls',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .createProductComplaint(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    orderNumber: params['orderNumber'],
                    selectedOrderItemIds: params['selectedOrderItemIds'],
                    issueType: params['issueType'],
                    title: params['title'],
                    description: params['description'],
                    imageUrls: params['imageUrls'],
                  ),
        ),
        'createDeliveryComplaint': _i1.MethodConnector(
          name: 'createDeliveryComplaint',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'orderNumber': _i1.ParameterDescription(
              name: 'orderNumber',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'issueType': _i1.ParameterDescription(
              name: 'issueType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'imageUrls': _i1.ParameterDescription(
              name: 'imageUrls',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
            'selectedField': _i1.ParameterDescription(
              name: 'selectedField',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'requestedAddress': _i1.ParameterDescription(
              name: 'requestedAddress',
              type: _i1.getType<_i35.Address?>(),
              nullable: true,
            ),
            'requestedNote': _i1.ParameterDescription(
              name: 'requestedNote',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .createDeliveryComplaint(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    orderNumber: params['orderNumber'],
                    issueType: params['issueType'],
                    title: params['title'],
                    description: params['description'],
                    imageUrls: params['imageUrls'],
                    selectedField: params['selectedField'],
                    requestedAddress: params['requestedAddress'],
                    requestedNote: params['requestedNote'],
                  ),
        ),
        'getActiveComplaintForOrder': _i1.MethodConnector(
          name: 'getActiveComplaintForOrder',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'orderNumber': _i1.ParameterDescription(
              name: 'orderNumber',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintType': _i1.ParameterDescription(
              name: 'complaintType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .getActiveComplaintForOrder(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    orderNumber: params['orderNumber'],
                    complaintType: params['complaintType'],
                  ),
        ),
        'listMyComplaints': _i1.MethodConnector(
          name: 'listMyComplaints',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'issueType': _i1.ParameterDescription(
              name: 'issueType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'selectedField': _i1.ParameterDescription(
              name: 'selectedField',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'complaintType': _i1.ParameterDescription(
              name: 'complaintType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .listMyComplaints(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    status: params['status'],
                    issueType: params['issueType'],
                    selectedField: params['selectedField'],
                    complaintType: params['complaintType'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'getMyComplaint': _i1.MethodConnector(
          name: 'getMyComplaint',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .getMyComplaint(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                  ),
        ),
        'getComplaintForOrderItem': _i1.MethodConnector(
          name: 'getComplaintForOrderItem',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'orderItemId': _i1.ParameterDescription(
              name: 'orderItemId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .getComplaintForOrderItem(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    orderItemId: params['orderItemId'],
                  ),
        ),
        'listComplaints': _i1.MethodConnector(
          name: 'listComplaints',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'issueType': _i1.ParameterDescription(
              name: 'issueType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'selectedField': _i1.ParameterDescription(
              name: 'selectedField',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'complaintType': _i1.ParameterDescription(
              name: 'complaintType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .listComplaints(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    status: params['status'],
                    issueType: params['issueType'],
                    selectedField: params['selectedField'],
                    complaintType: params['complaintType'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'getComplaintAdmin': _i1.MethodConnector(
          name: 'getComplaintAdmin',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .getComplaintAdmin(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                  ),
        ),
        'updateComplaintStatus': _i1.MethodConnector(
          name: 'updateComplaintStatus',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'adminReply': _i1.ParameterDescription(
              name: 'adminReply',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'adminNote': _i1.ParameterDescription(
              name: 'adminNote',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'resolutionType': _i1.ParameterDescription(
              name: 'resolutionType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .updateComplaintStatus(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                    status: params['status'],
                    adminReply: params['adminReply'],
                    adminNote: params['adminNote'],
                    resolutionType: params['resolutionType'],
                  ),
        ),
        'calculateRefundCap': _i1.MethodConnector(
          name: 'calculateRefundCap',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .calculateRefundCap(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                  ),
        ),
        'refundComplaint': _i1.MethodConnector(
          name: 'refundComplaint',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'adminReply': _i1.ParameterDescription(
              name: 'adminReply',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'adminNote': _i1.ParameterDescription(
              name: 'adminNote',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .refundComplaint(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                    amount: params['amount'],
                    adminReply: params['adminReply'],
                    adminNote: params['adminNote'],
                  ),
        ),
        'createReplacementOrder': _i1.MethodConnector(
          name: 'createReplacementOrder',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'adminReply': _i1.ParameterDescription(
              name: 'adminReply',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'adminNote': _i1.ParameterDescription(
              name: 'adminNote',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .createReplacementOrder(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                    adminReply: params['adminReply'],
                    adminNote: params['adminNote'],
                  ),
        ),
        'retryDelivery': _i1.MethodConnector(
          name: 'retryDelivery',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'adminReply': _i1.ParameterDescription(
              name: 'adminReply',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'adminNote': _i1.ParameterDescription(
              name: 'adminNote',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .retryDelivery(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                    adminReply: params['adminReply'],
                    adminNote: params['adminNote'],
                  ),
        ),
        'reassignRider': _i1.MethodConnector(
          name: 'reassignRider',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'riderName': _i1.ParameterDescription(
              name: 'riderName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'riderPhone': _i1.ParameterDescription(
              name: 'riderPhone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'adminReply': _i1.ParameterDescription(
              name: 'adminReply',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'adminNote': _i1.ParameterDescription(
              name: 'adminNote',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .reassignRider(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                    riderName: params['riderName'],
                    riderPhone: params['riderPhone'],
                    adminReply: params['adminReply'],
                    adminNote: params['adminNote'],
                  ),
        ),
        'rejectComplaint': _i1.MethodConnector(
          name: 'rejectComplaint',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'adminReply': _i1.ParameterDescription(
              name: 'adminReply',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'adminNote': _i1.ParameterDescription(
              name: 'adminNote',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .rejectComplaint(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                    adminReply: params['adminReply'],
                    adminNote: params['adminNote'],
                  ),
        ),
        'replyToComplaint': _i1.MethodConnector(
          name: 'replyToComplaint',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'adminReply': _i1.ParameterDescription(
              name: 'adminReply',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .replyToComplaint(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                    adminReply: params['adminReply'],
                  ),
        ),
        'getRefundForComplaint': _i1.MethodConnector(
          name: 'getRefundForComplaint',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .getRefundForComplaint(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                  ),
        ),
        'getUserRefundForComplaint': _i1.MethodConnector(
          name: 'getUserRefundForComplaint',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['complaint'] as _i10.ComplaintEndpoint)
                  .getUserRefundForComplaint(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    complaintId: params['complaintId'],
                  ),
        ),
      },
    );
    connectors['coupon'] = _i1.EndpointConnector(
      name: 'coupon',
      endpoint: endpoints['coupon']!,
      methodConnectors: {
        'fetchCoupons': _i1.MethodConnector(
          name: 'fetchCoupons',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i11.CouponEndpoint).fetchCoupons(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'uploadCoupon': _i1.MethodConnector(
          name: 'uploadCoupon',
          params: {
            'coupon': _i1.ParameterDescription(
              name: 'coupon',
              type: _i1.getType<_i36.Coupon>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationDraft': _i1.ParameterDescription(
              name: 'notificationDraft',
              type: _i1.getType<_i29.NotificationDraft?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i11.CouponEndpoint).uploadCoupon(
                    session,
                    params['coupon'],
                    params['firebaseUid'],
                    params['idToken'],
                    notificationDraft: params['notificationDraft'],
                  ),
        ),
        'setCouponActive': _i1.MethodConnector(
          name: 'setCouponActive',
          params: {
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i11.CouponEndpoint).setCouponActive(
                    session,
                    params['code'],
                    params['isActive'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'updateCoupon': _i1.MethodConnector(
          name: 'updateCoupon',
          params: {
            'coupon': _i1.ParameterDescription(
              name: 'coupon',
              type: _i1.getType<_i36.Coupon>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i11.CouponEndpoint).updateCoupon(
                    session,
                    params['coupon'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'deleteCoupon': _i1.MethodConnector(
          name: 'deleteCoupon',
          params: {
            'code': _i1.ParameterDescription(
              name: 'code',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i11.CouponEndpoint).deleteCoupon(
                    session,
                    params['code'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'fetchApplicableCoupons': _i1.MethodConnector(
          name: 'fetchApplicableCoupons',
          params: {
            'orderAmount': _i1.ParameterDescription(
              name: 'orderAmount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['coupon'] as _i11.CouponEndpoint)
                  .fetchApplicableCoupons(
                    session,
                    params['orderAmount'],
                  ),
        ),
        'validateCoupon': _i1.MethodConnector(
          name: 'validateCoupon',
          params: {
            'couponCode': _i1.ParameterDescription(
              name: 'couponCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'orderAmount': _i1.ParameterDescription(
              name: 'orderAmount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i11.CouponEndpoint).validateCoupon(
                    session,
                    params['couponCode'],
                    params['orderAmount'],
                  ),
        ),
        'applyCoupon': _i1.MethodConnector(
          name: 'applyCoupon',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'couponCode': _i1.ParameterDescription(
              name: 'couponCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'cartSubtotal': _i1.ParameterDescription(
              name: 'cartSubtotal',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'cartItems': _i1.ParameterDescription(
              name: 'cartItems',
              type: _i1.getType<List<_i34.CartItemInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i11.CouponEndpoint).applyCoupon(
                    session,
                    params['userId'],
                    params['couponCode'],
                    params['cartSubtotal'],
                    params['cartItems'],
                  ),
        ),
        'getAvailableCoupons': _i1.MethodConnector(
          name: 'getAvailableCoupons',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'cartSubtotal': _i1.ParameterDescription(
              name: 'cartSubtotal',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'cartItems': _i1.ParameterDescription(
              name: 'cartItems',
              type: _i1.getType<List<_i34.CartItemInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['coupon'] as _i11.CouponEndpoint)
                  .getAvailableCoupons(
                    session,
                    params['userId'],
                    params['cartSubtotal'],
                    params['cartItems'],
                  ),
        ),
        'getBestCoupon': _i1.MethodConnector(
          name: 'getBestCoupon',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'cartSubtotal': _i1.ParameterDescription(
              name: 'cartSubtotal',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'cartItems': _i1.ParameterDescription(
              name: 'cartItems',
              type: _i1.getType<List<_i34.CartItemInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i11.CouponEndpoint).getBestCoupon(
                    session,
                    params['userId'],
                    params['cartSubtotal'],
                    params['cartItems'],
                  ),
        ),
      },
    );
    connectors['freeDelivery'] = _i1.EndpointConnector(
      name: 'freeDelivery',
      endpoint: endpoints['freeDelivery']!,
      methodConnectors: {
        'getDeliveryConfig': _i1.MethodConnector(
          name: 'getDeliveryConfig',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .getDeliveryConfig(session),
        ),
        'getUserDeliveryOffer': _i1.MethodConnector(
          name: 'getUserDeliveryOffer',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .getUserDeliveryOffer(
                        session,
                        params['userId'],
                      ),
        ),
        'setProductFreeDelivery': _i1.MethodConnector(
          name: 'setProductFreeDelivery',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isFreeDelivery': _i1.ParameterDescription(
              name: 'isFreeDelivery',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'confirmDisableConflictingCombo': _i1.ParameterDescription(
              name: 'confirmDisableConflictingCombo',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'forceDisableBogo': _i1.ParameterDescription(
              name: 'forceDisableBogo',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .setProductFreeDelivery(
                        session,
                        params['productId'],
                        params['isFreeDelivery'],
                        params['firebaseUid'],
                        params['idToken'],
                        confirmDisableConflictingCombo:
                            params['confirmDisableConflictingCombo'],
                        forceDisableBogo: params['forceDisableBogo'],
                      ),
        ),
        'setCategoryFreeDelivery': _i1.MethodConnector(
          name: 'setCategoryFreeDelivery',
          params: {
            'categoryName': _i1.ParameterDescription(
              name: 'categoryName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isFreeDelivery': _i1.ParameterDescription(
              name: 'isFreeDelivery',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'confirmDisableConflictingCombo': _i1.ParameterDescription(
              name: 'confirmDisableConflictingCombo',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'forceDisableBogo': _i1.ParameterDescription(
              name: 'forceDisableBogo',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .setCategoryFreeDelivery(
                        session,
                        params['categoryName'],
                        params['isFreeDelivery'],
                        params['firebaseUid'],
                        params['idToken'],
                        confirmDisableConflictingCombo:
                            params['confirmDisableConflictingCombo'],
                        forceDisableBogo: params['forceDisableBogo'],
                      ),
        ),
        'upsertDeliveryConfig': _i1.MethodConnector(
          name: 'upsertDeliveryConfig',
          params: {
            'config': _i1.ParameterDescription(
              name: 'config',
              type: _i1.getType<_i37.DeliveryConfig>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .upsertDeliveryConfig(
                        session,
                        params['config'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'getAllDeliveryRules': _i1.MethodConnector(
          name: 'getAllDeliveryRules',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .getAllDeliveryRules(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'getDeliveryRulesPage': _i1.MethodConnector(
          name: 'getDeliveryRulesPage',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .getDeliveryRulesPage(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                        limit: params['limit'],
                        pageToken: params['pageToken'],
                      ),
        ),
        'upsertDeliveryRule': _i1.MethodConnector(
          name: 'upsertDeliveryRule',
          params: {
            'rule': _i1.ParameterDescription(
              name: 'rule',
              type: _i1.getType<_i38.DeliveryRule>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'notificationDraft': _i1.ParameterDescription(
              name: 'notificationDraft',
              type: _i1.getType<_i29.NotificationDraft?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .upsertDeliveryRule(
                        session,
                        params['rule'],
                        params['firebaseUid'],
                        params['idToken'],
                        notificationDraft: params['notificationDraft'],
                      ),
        ),
        'deleteDeliveryRule': _i1.MethodConnector(
          name: 'deleteDeliveryRule',
          params: {
            'ruleId': _i1.ParameterDescription(
              name: 'ruleId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .deleteDeliveryRule(
                        session,
                        params['ruleId'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'setDeliveryRuleActive': _i1.MethodConnector(
          name: 'setDeliveryRuleActive',
          params: {
            'ruleId': _i1.ParameterDescription(
              name: 'ruleId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .setDeliveryRuleActive(
                        session,
                        params['ruleId'],
                        params['isActive'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'calculateDeliveryPricing': _i1.MethodConnector(
          name: 'calculateDeliveryPricing',
          params: {
            'cartTotal': _i1.ParameterDescription(
              name: 'cartTotal',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'location': _i1.ParameterDescription(
              name: 'location',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'cartItems': _i1.ParameterDescription(
              name: 'cartItems',
              type: _i1.getType<List<_i34.CartItemInput>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i12.FreeDeliveryEndpoint)
                      .calculateDeliveryPricing(
                        session,
                        params['cartTotal'],
                        userId: params['userId'],
                        location: params['location'],
                        cartItems: params['cartItems'],
                      ),
        ),
      },
    );
    connectors['notification'] = _i1.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'registerFcmToken': _i1.MethodConnector(
          name: 'registerFcmToken',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'platform': _i1.ParameterDescription(
              name: 'platform',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .registerFcmToken(
                        session,
                        params['firebaseUid'],
                        params['token'],
                        params['deviceId'],
                        params['platform'],
                      ),
        ),
        'unregisterFcmToken': _i1.MethodConnector(
          name: 'unregisterFcmToken',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .unregisterFcmToken(
                        session,
                        params['firebaseUid'],
                        params['deviceId'],
                        token: params['token'],
                      ),
        ),
        'getPreferences': _i1.MethodConnector(
          name: 'getPreferences',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .getPreferences(
                        session,
                        params['firebaseUid'],
                      ),
        ),
        'updatePreferences': _i1.MethodConnector(
          name: 'updatePreferences',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'preferences': _i1.ParameterDescription(
              name: 'preferences',
              type: _i1.getType<_i39.NotificationPreference>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .updatePreferences(
                        session,
                        params['firebaseUid'],
                        params['preferences'],
                      ),
        ),
        'listNotifications': _i1.MethodConnector(
          name: 'listNotifications',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .listNotifications(
                        session,
                        params['firebaseUid'],
                        limit: params['limit'],
                        pageToken: params['pageToken'],
                      ),
        ),
        'markNotificationRead': _i1.MethodConnector(
          name: 'markNotificationRead',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'campaignId': _i1.ParameterDescription(
              name: 'campaignId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .markNotificationRead(
                        session,
                        params['firebaseUid'],
                        params['campaignId'],
                      ),
        ),
        'deleteNotification': _i1.MethodConnector(
          name: 'deleteNotification',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'campaignId': _i1.ParameterDescription(
              name: 'campaignId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .deleteNotification(
                        session,
                        params['firebaseUid'],
                        params['campaignId'],
                      ),
        ),
        'createAnnouncement': _i1.MethodConnector(
          name: 'createAnnouncement',
          params: {
            'draft': _i1.ParameterDescription(
              name: 'draft',
              type: _i1.getType<_i29.NotificationDraft>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .createAnnouncement(
                        session,
                        params['draft'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'getAdminNotificationPreferences': _i1.MethodConnector(
          name: 'getAdminNotificationPreferences',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .getAdminNotificationPreferences(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'updateAdminNotificationPreference': _i1.MethodConnector(
          name: 'updateAdminNotificationPreference',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'pushEnabled': _i1.ParameterDescription(
              name: 'pushEnabled',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'soundEnabled': _i1.ParameterDescription(
              name: 'soundEnabled',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .updateAdminNotificationPreference(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                        params['key'],
                        params['pushEnabled'],
                        params['soundEnabled'],
                      ),
        ),
        'registerAdminFcmToken': _i1.MethodConnector(
          name: 'registerAdminFcmToken',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'platform': _i1.ParameterDescription(
              name: 'platform',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .registerAdminFcmToken(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                        params['token'],
                        params['deviceId'],
                        params['platform'],
                      ),
        ),
        'unregisterAdminFcmToken': _i1.MethodConnector(
          name: 'unregisterAdminFcmToken',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .unregisterAdminFcmToken(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                        params['deviceId'],
                        token: params['token'],
                      ),
        ),
        'createBroadcast': _i1.MethodConnector(
          name: 'createBroadcast',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i40.BroadcastRequest>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .createBroadcast(
                        session,
                        params['request'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'saveBroadcastDraft': _i1.MethodConnector(
          name: 'saveBroadcastDraft',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i40.BroadcastRequest>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .saveBroadcastDraft(
                        session,
                        params['request'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'sendBroadcastDraft': _i1.MethodConnector(
          name: 'sendBroadcastDraft',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'broadcastId': _i1.ParameterDescription(
              name: 'broadcastId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .sendBroadcastDraft(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                        params['broadcastId'],
                      ),
        ),
        'listBroadcasts': _i1.MethodConnector(
          name: 'listBroadcasts',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .listBroadcasts(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                        status: params['status'],
                        query: params['query'],
                        limit: params['limit'],
                        pageToken: params['pageToken'],
                      ),
        ),
        'deleteBroadcastDraft': _i1.MethodConnector(
          name: 'deleteBroadcastDraft',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'broadcastId': _i1.ParameterDescription(
              name: 'broadcastId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i13.NotificationEndpoint)
                      .deleteBroadcastDraft(
                        session,
                        params['firebaseUid'],
                        params['idToken'],
                        params['broadcastId'],
                      ),
        ),
      },
    );
    connectors['order'] = _i1.EndpointConnector(
      name: 'order',
      endpoint: endpoints['order']!,
      methodConnectors: {
        'createOrder': _i1.MethodConnector(
          name: 'createOrder',
          params: {
            'order': _i1.ParameterDescription(
              name: 'order',
              type: _i1.getType<_i32.Order>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint).createOrder(
                session,
                params['order'],
              ),
        ),
        'createPendingOrder': _i1.MethodConnector(
          name: 'createPendingOrder',
          params: {
            'order': _i1.ParameterDescription(
              name: 'order',
              type: _i1.getType<_i32.Order>(),
              nullable: false,
            ),
            'idempotencyKey': _i1.ParameterDescription(
              name: 'idempotencyKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i14.OrderEndpoint).createPendingOrder(
                    session,
                    params['order'],
                    params['idempotencyKey'],
                  ),
        ),
        'getOrders': _i1.MethodConnector(
          name: 'getOrders',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint).getOrders(
                session,
                status: params['status'],
                firebaseUid: params['firebaseUid'],
                idToken: params['idToken'],
              ),
        ),
        'getOrdersPage': _i1.MethodConnector(
          name: 'getOrdersPage',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i14.OrderEndpoint).getOrdersPage(
                    session,
                    status: params['status'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'getOrdersCount': _i1.MethodConnector(
          name: 'getOrdersCount',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i14.OrderEndpoint).getOrdersCount(
                    session,
                    status: params['status'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                  ),
        ),
        'getTodayOrders': _i1.MethodConnector(
          name: 'getTodayOrders',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i14.OrderEndpoint).getTodayOrders(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'getUserOrders': _i1.MethodConnector(
          name: 'getUserOrders',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i14.OrderEndpoint).getUserOrders(
                    session,
                    params['userId'],
                    params['idToken'],
                  ),
        ),
        'getOrderById': _i1.MethodConnector(
          name: 'getOrderById',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i14.OrderEndpoint).getOrderById(
                    session,
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'updateOrderStatus': _i1.MethodConnector(
          name: 'updateOrderStatus',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newStatus': _i1.ParameterDescription(
              name: 'newStatus',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'cancellationReason': _i1.ParameterDescription(
              name: 'cancellationReason',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i14.OrderEndpoint).updateOrderStatus(
                    session,
                    params['orderId'],
                    params['newStatus'],
                    cancellationReason: params['cancellationReason'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                  ),
        ),
        'updatePaymentStatus': _i1.MethodConnector(
          name: 'updatePaymentStatus',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'paymentStatus': _i1.ParameterDescription(
              name: 'paymentStatus',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'razorpayPaymentId': _i1.ParameterDescription(
              name: 'razorpayPaymentId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint)
                  .updatePaymentStatus(
                    session,
                    params['orderId'],
                    params['paymentStatus'],
                    razorpayPaymentId: params['razorpayPaymentId'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                  ),
        ),
        'updateDeliveryAddress': _i1.MethodConnector(
          name: 'updateDeliveryAddress',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deliveryAddress': _i1.ParameterDescription(
              name: 'deliveryAddress',
              type: _i1.getType<_i35.Address>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deliveryNote': _i1.ParameterDescription(
              name: 'deliveryNote',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint)
                  .updateDeliveryAddress(
                    session,
                    params['orderId'],
                    params['deliveryAddress'],
                    params['firebaseUid'],
                    params['idToken'],
                    deliveryNote: params['deliveryNote'],
                  ),
        ),
        'confirmOrder': _i1.MethodConnector(
          name: 'confirmOrder',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i14.OrderEndpoint).confirmOrder(
                    session,
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'cancelOrder': _i1.MethodConnector(
          name: 'cancelOrder',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint).cancelOrder(
                session,
                params['orderId'],
                params['userId'],
                idToken: params['idToken'],
                reason: params['reason'],
              ),
        ),
        'requestCancellation': _i1.MethodConnector(
          name: 'requestCancellation',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint)
                  .requestCancellation(
                    session,
                    params['orderId'],
                    params['userId'],
                    idToken: params['idToken'],
                    reason: params['reason'],
                  ),
        ),
        'listCancellationRequests': _i1.MethodConnector(
          name: 'listCancellationRequests',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint)
                  .listCancellationRequests(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'approveCancellationRequest': _i1.MethodConnector(
          name: 'approveCancellationRequest',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fixedRefundAmount': _i1.ParameterDescription(
              name: 'fixedRefundAmount',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'adminNote': _i1.ParameterDescription(
              name: 'adminNote',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint)
                  .approveCancellationRequest(
                    session,
                    params['orderId'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    fixedRefundAmount: params['fixedRefundAmount'],
                    adminNote: params['adminNote'],
                  ),
        ),
        'rejectCancellationRequest': _i1.MethodConnector(
          name: 'rejectCancellationRequest',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'adminNote': _i1.ParameterDescription(
              name: 'adminNote',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint)
                  .rejectCancellationRequest(
                    session,
                    params['orderId'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    adminNote: params['adminNote'],
                  ),
        ),
        'assignDeliveryPerson': _i1.MethodConnector(
          name: 'assignDeliveryPerson',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deliveryPersonName': _i1.ParameterDescription(
              name: 'deliveryPersonName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deliveryPersonPhone': _i1.ParameterDescription(
              name: 'deliveryPersonPhone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i14.OrderEndpoint)
                  .assignDeliveryPerson(
                    session,
                    params['orderId'],
                    params['deliveryPersonName'],
                    params['deliveryPersonPhone'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'getDashboardStats': _i1.MethodConnector(
          name: 'getDashboardStats',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i14.OrderEndpoint).getDashboardStats(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['orderPg'] = _i1.EndpointConnector(
      name: 'orderPg',
      endpoint: endpoints['orderPg']!,
      methodConnectors: {
        'createPendingOrder': _i1.MethodConnector(
          name: 'createPendingOrder',
          params: {
            'order': _i1.ParameterDescription(
              name: 'order',
              type: _i1.getType<_i32.Order>(),
              nullable: false,
            ),
            'idempotencyKey': _i1.ParameterDescription(
              name: 'idempotencyKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['orderPg'] as _i15.OrderPgEndpoint)
                  .createPendingOrder(
                    session,
                    params['order'],
                    params['idempotencyKey'],
                  ),
        ),
        'getOrdersForUser': _i1.MethodConnector(
          name: 'getOrdersForUser',
          params: {
            'userReference': _i1.ParameterDescription(
              name: 'userReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['orderPg'] as _i15.OrderPgEndpoint)
                  .getOrdersForUser(
                    session,
                    userReference: params['userReference'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
      },
    );
    connectors['orderRealtime'] = _i1.EndpointConnector(
      name: 'orderRealtime',
      endpoint: endpoints['orderRealtime']!,
      methodConnectors: {
        'watchAdminOrders': _i1.MethodStreamConnector(
          name: 'watchAdminOrders',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['orderRealtime'] as _i16.OrderRealtimeEndpoint)
                  .watchAdminOrders(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'watchDashboardUpdates': _i1.MethodStreamConnector(
          name: 'watchDashboardUpdates',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['orderRealtime'] as _i16.OrderRealtimeEndpoint)
                  .watchDashboardUpdates(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'watchUserOrders': _i1.MethodStreamConnector(
          name: 'watchUserOrders',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['orderRealtime'] as _i16.OrderRealtimeEndpoint)
                  .watchUserOrders(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['orderTracking'] = _i1.EndpointConnector(
      name: 'orderTracking',
      endpoint: endpoints['orderTracking']!,
      methodConnectors: {
        'getTrackingForUser': _i1.MethodConnector(
          name: 'getTrackingForUser',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['orderTracking'] as _i17.OrderTrackingEndpoint)
                      .getTrackingForUser(
                        session,
                        params['orderId'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'getTrackingForAdmin': _i1.MethodConnector(
          name: 'getTrackingForAdmin',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['orderTracking'] as _i17.OrderTrackingEndpoint)
                      .getTrackingForAdmin(
                        session,
                        params['orderId'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'seedUserLocation': _i1.MethodConnector(
          name: 'seedUserLocation',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userLatitude': _i1.ParameterDescription(
              name: 'userLatitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'userLongitude': _i1.ParameterDescription(
              name: 'userLongitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'userAddress': _i1.ParameterDescription(
              name: 'userAddress',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'userLocationType': _i1.ParameterDescription(
              name: 'userLocationType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['orderTracking'] as _i17.OrderTrackingEndpoint)
                      .seedUserLocation(
                        session,
                        params['orderId'],
                        params['firebaseUid'],
                        params['idToken'],
                        params['userLatitude'],
                        params['userLongitude'],
                        params['userAddress'],
                        params['userLocationType'],
                      ),
        ),
        'updateTrackingEnabled': _i1.MethodConnector(
          name: 'updateTrackingEnabled',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'enabled': _i1.ParameterDescription(
              name: 'enabled',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['orderTracking'] as _i17.OrderTrackingEndpoint)
                      .updateTrackingEnabled(
                        session,
                        params['orderId'],
                        params['enabled'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'updateRiderLocation': _i1.MethodConnector(
          name: 'updateRiderLocation',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'riderLatitude': _i1.ParameterDescription(
              name: 'riderLatitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'riderLongitude': _i1.ParameterDescription(
              name: 'riderLongitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['orderTracking'] as _i17.OrderTrackingEndpoint)
                      .updateRiderLocation(
                        session,
                        params['orderId'],
                        params['riderLatitude'],
                        params['riderLongitude'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'getDeliveryRoute': _i1.MethodConnector(
          name: 'getDeliveryRoute',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'riderLatitude': _i1.ParameterDescription(
              name: 'riderLatitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'riderLongitude': _i1.ParameterDescription(
              name: 'riderLongitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'userLatitude': _i1.ParameterDescription(
              name: 'userLatitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'userLongitude': _i1.ParameterDescription(
              name: 'userLongitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['orderTracking'] as _i17.OrderTrackingEndpoint)
                      .getDeliveryRoute(
                        session,
                        params['orderId'],
                        params['riderLatitude'],
                        params['riderLongitude'],
                        params['userLatitude'],
                        params['userLongitude'],
                        params['firebaseUid'],
                        params['idToken'],
                      ),
        ),
        'streamTrackingForUser': _i1.MethodStreamConnector(
          name: 'streamTrackingForUser',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['orderTracking'] as _i17.OrderTrackingEndpoint)
                  .streamTrackingForUser(
                    session,
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'streamTrackingForAdmin': _i1.MethodStreamConnector(
          name: 'streamTrackingForAdmin',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['orderTracking'] as _i17.OrderTrackingEndpoint)
                  .streamTrackingForAdmin(
                    session,
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['payment'] = _i1.EndpointConnector(
      name: 'payment',
      endpoint: endpoints['payment']!,
      methodConnectors: {
        'createPaymentOrder': _i1.MethodConnector(
          name: 'createPaymentOrder',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'customerPhone': _i1.ParameterDescription(
              name: 'customerPhone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .createPaymentOrder(
                    session,
                    params['orderId'],
                    params['amount'],
                    params['customerPhone'],
                  ),
        ),
        'verifyPayment': _i1.MethodConnector(
          name: 'verifyPayment',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'razorpayOrderId': _i1.ParameterDescription(
              name: 'razorpayOrderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'razorpayPaymentId': _i1.ParameterDescription(
              name: 'razorpayPaymentId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'razorpaySignature': _i1.ParameterDescription(
              name: 'razorpaySignature',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['payment'] as _i18.PaymentEndpoint).verifyPayment(
                    session,
                    params['orderId'],
                    params['razorpayOrderId'],
                    params['razorpayPaymentId'],
                    params['razorpaySignature'],
                  ),
        ),
        'markPaymentFailed': _i1.MethodConnector(
          name: 'markPaymentFailed',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .markPaymentFailed(
                    session,
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'initiateRefund': _i1.MethodConnector(
          name: 'initiateRefund',
          params: {
            'razorpayPaymentId': _i1.ParameterDescription(
              name: 'razorpayPaymentId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['payment'] as _i18.PaymentEndpoint).initiateRefund(
                    session,
                    params['razorpayPaymentId'],
                    params['amount'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'getPaymentStatus': _i1.MethodConnector(
          name: 'getPaymentStatus',
          params: {
            'razorpayPaymentId': _i1.ParameterDescription(
              name: 'razorpayPaymentId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .getPaymentStatus(
                    session,
                    params['razorpayPaymentId'],
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'completePaymentVerification': _i1.MethodConnector(
          name: 'completePaymentVerification',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'razorpayOrderId': _i1.ParameterDescription(
              name: 'razorpayOrderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'razorpayPaymentId': _i1.ParameterDescription(
              name: 'razorpayPaymentId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .completePaymentVerification(
                    session,
                    params['orderId'],
                    params['razorpayOrderId'],
                    params['razorpayPaymentId'],
                  ),
        ),
        'getPaymentStatusWithMessage': _i1.MethodConnector(
          name: 'getPaymentStatusWithMessage',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .getPaymentStatusWithMessage(
                    session,
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'adminReconcileAllPendingPayments': _i1.MethodConnector(
          name: 'adminReconcileAllPendingPayments',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .adminReconcileAllPendingPayments(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                  ),
        ),
        'adminGetPaymentDetail': _i1.MethodConnector(
          name: 'adminGetPaymentDetail',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .adminGetPaymentDetail(
                    session,
                    params['orderId'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                  ),
        ),
        'adminSearchOrders': _i1.MethodConnector(
          name: 'adminSearchOrders',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'paymentStatus': _i1.ParameterDescription(
              name: 'paymentStatus',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .adminSearchOrders(
                    session,
                    query: params['query'],
                    status: params['status'],
                    paymentStatus: params['paymentStatus'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'adminGetLivePaymentStatus': _i1.MethodConnector(
          name: 'adminGetLivePaymentStatus',
          params: {
            'razorpayPaymentId': _i1.ParameterDescription(
              name: 'razorpayPaymentId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .adminGetLivePaymentStatus(
                    session,
                    params['razorpayPaymentId'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                  ),
        ),
        'adminGetRefundDetail': _i1.MethodConnector(
          name: 'adminGetRefundDetail',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .adminGetRefundDetail(
                    session,
                    params['orderId'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                  ),
        ),
        'recoverPendingPayments': _i1.MethodConnector(
          name: 'recoverPendingPayments',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i18.PaymentEndpoint)
                  .recoverPendingPayments(
                    session,
                    params['userId'],
                    idToken: params['idToken'],
                    limit: params['limit'],
                  ),
        ),
      },
    );
    connectors['pricing'] = _i1.EndpointConnector(
      name: 'pricing',
      endpoint: endpoints['pricing']!,
      methodConnectors: {
        'calculateCartPricing': _i1.MethodConnector(
          name: 'calculateCartPricing',
          params: {
            'items': _i1.ParameterDescription(
              name: 'items',
              type: _i1.getType<List<_i34.CartItemInput>>(),
              nullable: false,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'appliedCouponCode': _i1.ParameterDescription(
              name: 'appliedCouponCode',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'autoApplyCoupons': _i1.ParameterDescription(
              name: 'autoApplyCoupons',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pricing'] as _i19.PricingEndpoint)
                  .calculateCartPricing(
                    session,
                    params['items'],
                    userId: params['userId'],
                    appliedCouponCode: params['appliedCouponCode'],
                    autoApplyCoupons: params['autoApplyCoupons'],
                  ),
        ),
        'getApplicableOffers': _i1.MethodConnector(
          name: 'getApplicableOffers',
          params: {
            'items': _i1.ParameterDescription(
              name: 'items',
              type: _i1.getType<List<_i34.CartItemInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pricing'] as _i19.PricingEndpoint)
                  .getApplicableOffers(
                    session,
                    params['items'],
                  ),
        ),
        'basketSuggestions': _i1.MethodConnector(
          name: 'basketSuggestions',
          params: {
            'items': _i1.ParameterDescription(
              name: 'items',
              type: _i1.getType<List<_i34.CartItemInput>?>(),
              nullable: true,
            ),
            'cartTotal': _i1.ParameterDescription(
              name: 'cartTotal',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'mode': _i1.ParameterDescription(
              name: 'mode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'appliedCouponCode': _i1.ParameterDescription(
              name: 'appliedCouponCode',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pricing'] as _i19.PricingEndpoint)
                  .basketSuggestions(
                    session,
                    params['items'],
                    cartTotal: params['cartTotal'],
                    mode: params['mode'],
                    userId: params['userId'],
                    appliedCouponCode: params['appliedCouponCode'],
                  ),
        ),
        'calculateDeliveryFee': _i1.MethodConnector(
          name: 'calculateDeliveryFee',
          params: {
            'orderAmount': _i1.ParameterDescription(
              name: 'orderAmount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'itemCount': _i1.ParameterDescription(
              name: 'itemCount',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'couponCode': _i1.ParameterDescription(
              name: 'couponCode',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pricing'] as _i19.PricingEndpoint)
                  .calculateDeliveryFee(
                    session,
                    params['orderAmount'],
                    params['itemCount'],
                    params['couponCode'],
                    params['userId'],
                  ),
        ),
      },
    );
    connectors['product'] = _i1.EndpointConnector(
      name: 'product',
      endpoint: endpoints['product']!,
      methodConnectors: {
        'getProductsByIds': _i1.MethodConnector(
          name: 'getProductsByIds',
          params: {
            'productIds': _i1.ParameterDescription(
              name: 'productIds',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .getProductsByIds(
                    session,
                    params['productIds'],
                  ),
        ),
        'getProducts': _i1.MethodConnector(
          name: 'getProducts',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'lastProductName': _i1.ParameterDescription(
              name: 'lastProductName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'lastProductId': _i1.ParameterDescription(
              name: 'lastProductId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'subcategories': _i1.ParameterDescription(
              name: 'subcategories',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'sortBy': _i1.ParameterDescription(
              name: 'sortBy',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'freeDelivery': _i1.ParameterDescription(
              name: 'freeDelivery',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i20.ProductEndpoint).getProducts(
                    session,
                    limit: params['limit'],
                    lastProductName: params['lastProductName'],
                    lastProductId: params['lastProductId'],
                    category: params['category'],
                    subcategories: params['subcategories'],
                    sortBy: params['sortBy'],
                    freeDelivery: params['freeDelivery'],
                  ),
        ),
        'getProductsPage': _i1.MethodConnector(
          name: 'getProductsPage',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'subcategories': _i1.ParameterDescription(
              name: 'subcategories',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
            'sortBy': _i1.ParameterDescription(
              name: 'sortBy',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .getProductsPage(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                    category: params['category'],
                    subcategories: params['subcategories'],
                    sortBy: params['sortBy'],
                  ),
        ),
        'getProductsCount': _i1.MethodConnector(
          name: 'getProductsCount',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'subcategories': _i1.ParameterDescription(
              name: 'subcategories',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .getProductsCount(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    category: params['category'],
                    subcategories: params['subcategories'],
                  ),
        ),
        'uploadProduct': _i1.MethodConnector(
          name: 'uploadProduct',
          params: {
            'product': _i1.ParameterDescription(
              name: 'product',
              type: _i1.getType<_i41.Product>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i20.ProductEndpoint).uploadProduct(
                    session,
                    params['product'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'updateProduct': _i1.MethodConnector(
          name: 'updateProduct',
          params: {
            'product': _i1.ParameterDescription(
              name: 'product',
              type: _i1.getType<_i41.Product>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i20.ProductEndpoint).updateProduct(
                    session,
                    params['product'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'checkProductUpdateConflicts': _i1.MethodConnector(
          name: 'checkProductUpdateConflicts',
          params: {
            'product': _i1.ParameterDescription(
              name: 'product',
              type: _i1.getType<_i41.Product>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .checkProductUpdateConflicts(
                    session,
                    params['product'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'deleteProduct': _i1.MethodConnector(
          name: 'deleteProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i20.ProductEndpoint).deleteProduct(
                    session,
                    params['productId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'deactivateProduct': _i1.MethodConnector(
          name: 'deactivateProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .deactivateProduct(
                    session,
                    params['productId'],
                    params['isActive'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'getProductSuggestions': _i1.MethodConnector(
          name: 'getProductSuggestions',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .getProductSuggestions(
                    session,
                    params['query'],
                  ),
        ),
        'searchProducts': _i1.MethodConnector(
          name: 'searchProducts',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i20.ProductEndpoint).searchProducts(
                    session,
                    params['query'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'getProductsByOffer': _i1.MethodConnector(
          name: 'getProductsByOffer',
          params: {
            'offerType': _i1.ParameterDescription(
              name: 'offerType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .getProductsByOffer(
                    session,
                    offerType: params['offerType'],
                    query: params['query'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'getComboProducts': _i1.MethodConnector(
          name: 'getComboProducts',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .getComboProducts(
                    session,
                    query: params['query'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'getBogoProducts': _i1.MethodConnector(
          name: 'getBogoProducts',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .getBogoProducts(
                    session,
                    query: params['query'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'searchProductsWithOfferFilters': _i1.MethodConnector(
          name: 'searchProductsWithOfferFilters',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'offerFilter': _i1.ParameterDescription(
              name: 'offerFilter',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .searchProductsWithOfferFilters(
                    session,
                    query: params['query'],
                    offerFilter: params['offerFilter'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                  ),
        ),
        'migrateProducts': _i1.MethodConnector(
          name: 'migrateProducts',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .migrateProducts(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'initializeProductMetrics': _i1.MethodConnector(
          name: 'initializeProductMetrics',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .initializeProductMetrics(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'incrementProductSearch': _i1.MethodConnector(
          name: 'incrementProductSearch',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .incrementProductSearch(
                    session,
                    params['productId'],
                  ),
        ),
        'incrementProductPurchase': _i1.MethodConnector(
          name: 'incrementProductPurchase',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .incrementProductPurchase(
                    session,
                    params['productId'],
                  ),
        ),
        'seedProductMetricsForTesting': _i1.MethodConnector(
          name: 'seedProductMetricsForTesting',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i20.ProductEndpoint)
                  .seedProductMetricsForTesting(
                    session,
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['productPg'] = _i1.EndpointConnector(
      name: 'productPg',
      endpoint: endpoints['productPg']!,
      methodConnectors: {
        'getActiveProductsPage': _i1.MethodConnector(
          name: 'getActiveProductsPage',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'subCategoryId': _i1.ParameterDescription(
              name: 'subCategoryId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['productPg'] as _i21.ProductPgEndpoint)
                  .getActiveProductsPage(
                    session,
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                    categoryId: params['categoryId'],
                    subCategoryId: params['subCategoryId'],
                  ),
        ),
        'searchActiveProducts': _i1.MethodConnector(
          name: 'searchActiveProducts',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'pageToken': _i1.ParameterDescription(
              name: 'pageToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'subCategoryId': _i1.ParameterDescription(
              name: 'subCategoryId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'similarityThreshold': _i1.ParameterDescription(
              name: 'similarityThreshold',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['productPg'] as _i21.ProductPgEndpoint)
                  .searchActiveProducts(
                    session,
                    query: params['query'],
                    limit: params['limit'],
                    pageToken: params['pageToken'],
                    categoryId: params['categoryId'],
                    subCategoryId: params['subCategoryId'],
                    similarityThreshold: params['similarityThreshold'],
                  ),
        ),
        'enqueueSearchRebuild': _i1.MethodConnector(
          name: 'enqueueSearchRebuild',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['productPg'] as _i21.ProductPgEndpoint)
                  .enqueueSearchRebuild(
                    session,
                    productId: params['productId'],
                    reason: params['reason'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                  ),
        ),
        'processPendingSearchRebuildJobs': _i1.MethodConnector(
          name: 'processPendingSearchRebuildJobs',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['productPg'] as _i21.ProductPgEndpoint)
                  .processPendingSearchRebuildJobs(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    limit: params['limit'],
                  ),
        ),
      },
    );
    connectors['productRanking'] = _i1.EndpointConnector(
      name: 'productRanking',
      endpoint: endpoints['productRanking']!,
      methodConnectors: {
        'recordProductView': _i1.MethodConnector(
          name: 'recordProductView',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['productRanking'] as _i22.ProductRankingEndpoint)
                      .recordProductView(
                        session,
                        params['productId'],
                      ),
        ),
        'getTrendingProducts': _i1.MethodConnector(
          name: 'getTrendingProducts',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['productRanking'] as _i22.ProductRankingEndpoint)
                      .getTrendingProducts(
                        session,
                        limit: params['limit'],
                      ),
        ),
        'getMostSellingProducts': _i1.MethodConnector(
          name: 'getMostSellingProducts',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['productRanking'] as _i22.ProductRankingEndpoint)
                      .getMostSellingProducts(
                        session,
                        limit: params['limit'],
                      ),
        ),
        'getMostViewedProducts': _i1.MethodConnector(
          name: 'getMostViewedProducts',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['productRanking'] as _i22.ProductRankingEndpoint)
                      .getMostViewedProducts(
                        session,
                        limit: params['limit'],
                      ),
        ),
        'getFrequentlyReorderedProducts': _i1.MethodConnector(
          name: 'getFrequentlyReorderedProducts',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['productRanking'] as _i22.ProductRankingEndpoint)
                      .getFrequentlyReorderedProducts(
                        session,
                        limit: params['limit'],
                      ),
        ),
      },
    );
    connectors['refund'] = _i1.EndpointConnector(
      name: 'refund',
      endpoint: endpoints['refund']!,
      methodConnectors: {
        'initiateRefund': _i1.MethodConnector(
          name: 'initiateRefund',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['refund'] as _i23.RefundEndpoint).initiateRefund(
                    session,
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'getRefundStatus': _i1.MethodConnector(
          name: 'getRefundStatus',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['refund'] as _i23.RefundEndpoint).getRefundStatus(
                    session,
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'adminGetRefundStatus': _i1.MethodConnector(
          name: 'adminGetRefundStatus',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['refund'] as _i23.RefundEndpoint)
                  .adminGetRefundStatus(
                    session,
                    params['orderId'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['subCategory'] = _i1.EndpointConnector(
      name: 'subCategory',
      endpoint: endpoints['subCategory']!,
      methodConnectors: {
        'getSubCategories': _i1.MethodConnector(
          name: 'getSubCategories',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['subCategory'] as _i24.SubCategoryEndpoint)
                  .getSubCategories(session),
        ),
        'uploadSubCategory': _i1.MethodConnector(
          name: 'uploadSubCategory',
          params: {
            'subCategory': _i1.ParameterDescription(
              name: 'subCategory',
              type: _i1.getType<_i42.SubCategory>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['subCategory'] as _i24.SubCategoryEndpoint)
                  .uploadSubCategory(
                    session,
                    params['subCategory'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'updateSubCategory': _i1.MethodConnector(
          name: 'updateSubCategory',
          params: {
            'categoryName': _i1.ParameterDescription(
              name: 'categoryName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'oldSubName': _i1.ParameterDescription(
              name: 'oldSubName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'subCategory': _i1.ParameterDescription(
              name: 'subCategory',
              type: _i1.getType<_i42.SubCategory>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['subCategory'] as _i24.SubCategoryEndpoint)
                  .updateSubCategory(
                    session,
                    params['categoryName'],
                    params['oldSubName'],
                    params['subCategory'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
        'deleteSubCategory': _i1.MethodConnector(
          name: 'deleteSubCategory',
          params: {
            'categoryName': _i1.ParameterDescription(
              name: 'categoryName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'subCategoryName': _i1.ParameterDescription(
              name: 'subCategoryName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['subCategory'] as _i24.SubCategoryEndpoint)
                  .deleteSubCategory(
                    session,
                    params['categoryName'],
                    params['subCategoryName'],
                    params['firebaseUid'],
                    params['idToken'],
                  ),
        ),
      },
    );
    connectors['support'] = _i1.EndpointConnector(
      name: 'support',
      endpoint: endpoints['support']!,
      methodConnectors: {
        'submitIssue': _i1.MethodConnector(
          name: 'submitIssue',
          params: {
            'firebaseUid': _i1.ParameterDescription(
              name: 'firebaseUid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'issueType': _i1.ParameterDescription(
              name: 'issueType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'screenshotUrl': _i1.ParameterDescription(
              name: 'screenshotUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'appVersion': _i1.ParameterDescription(
              name: 'appVersion',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'buildNumber': _i1.ParameterDescription(
              name: 'buildNumber',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceInfo': _i1.ParameterDescription(
              name: 'deviceInfo',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['support'] as _i25.SupportEndpoint).submitIssue(
                    session,
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
                    issueType: params['issueType'],
                    title: params['title'],
                    description: params['description'],
                    screenshotUrl: params['screenshotUrl'],
                    appVersion: params['appVersion'],
                    buildNumber: params['buildNumber'],
                    deviceInfo: params['deviceInfo'],
                  ),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getUserByFirebaseUid': _i1.MethodConnector(
          name: 'getUserByFirebaseUid',
          params: {
            'uid': _i1.ParameterDescription(
              name: 'uid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i26.UserEndpoint).getUserByFirebaseUid(
                    session,
                    params['uid'],
                  ),
        ),
        'createOrUpdateUser': _i1.MethodConnector(
          name: 'createOrUpdateUser',
          params: {
            'user': _i1.ParameterDescription(
              name: 'user',
              type: _i1.getType<_i43.AppUser>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i26.UserEndpoint).createOrUpdateUser(
                    session,
                    params['user'],
                  ),
        ),
        'updateCart': _i1.MethodConnector(
          name: 'updateCart',
          params: {
            'uid': _i1.ParameterDescription(
              name: 'uid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'cart': _i1.ParameterDescription(
              name: 'cart',
              type: _i1.getType<List<_i44.CartItem>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i26.UserEndpoint).updateCart(
                session,
                params['uid'],
                params['cart'],
              ),
        ),
        'updateFcmToken': _i1.MethodConnector(
          name: 'updateFcmToken',
          params: {
            'uid': _i1.ParameterDescription(
              name: 'uid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i26.UserEndpoint).updateFcmToken(
                    session,
                    params['uid'],
                    params['token'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i45.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i46.Endpoints()
      ..initializeEndpoints(server);
  }
}
