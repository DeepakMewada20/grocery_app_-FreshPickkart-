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
import '../endpoints/coupon_endpoint.dart' as _i10;
import '../endpoints/free_delivery_endpoint.dart' as _i11;
import '../endpoints/order_endpoint.dart' as _i12;
import '../endpoints/payment_endpoint.dart' as _i13;
import '../endpoints/pricing_endpoint.dart' as _i14;
import '../endpoints/product_endpoint.dart' as _i15;
import '../endpoints/refund_endpoint.dart' as _i16;
import '../endpoints/sub_category_endpoint.dart' as _i17;
import '../endpoints/user_endpoint.dart' as _i18;
import 'package:freshpickkat_server/src/generated/banner.dart' as _i19;
import 'package:freshpickkat_server/src/generated/bogo_offer.dart' as _i20;
import 'package:freshpickkat_server/src/generated/category.dart' as _i21;
import 'package:freshpickkat_server/src/generated/category_offer.dart' as _i22;
import 'package:freshpickkat_server/src/generated/order.dart' as _i23;
import 'package:freshpickkat_server/src/generated/combo_offer.dart' as _i24;
import 'package:freshpickkat_server/src/generated/cart_item_input.dart' as _i25;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i26;
import 'package:freshpickkat_server/src/generated/delivery_config.dart' as _i27;
import 'package:freshpickkat_server/src/generated/delivery_rule.dart' as _i28;
import 'package:freshpickkat_server/src/generated/product.dart' as _i29;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i30;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i31;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i32;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i33;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i34;

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
      'coupon': _i10.CouponEndpoint()
        ..initialize(
          server,
          'coupon',
          null,
        ),
      'freeDelivery': _i11.FreeDeliveryEndpoint()
        ..initialize(
          server,
          'freeDelivery',
          null,
        ),
      'order': _i12.OrderEndpoint()
        ..initialize(
          server,
          'order',
          null,
        ),
      'payment': _i13.PaymentEndpoint()
        ..initialize(
          server,
          'payment',
          null,
        ),
      'pricing': _i14.PricingEndpoint()
        ..initialize(
          server,
          'pricing',
          null,
        ),
      'product': _i15.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'refund': _i16.RefundEndpoint()
        ..initialize(
          server,
          'refund',
          null,
        ),
      'subCategory': _i17.SubCategoryEndpoint()
        ..initialize(
          server,
          'subCategory',
          null,
        ),
      'user': _i18.UserEndpoint()
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
              type: _i1.getType<_i19.Banner>(),
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
                  ),
        ),
        'updateBanner': _i1.MethodConnector(
          name: 'updateBanner',
          params: {
            'banner': _i1.ParameterDescription(
              name: 'banner',
              type: _i1.getType<_i19.Banner>(),
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['banner'] as _i4.BannerEndpoint).deleteBanner(
                    session,
                    params['bannerId'],
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
                  ),
        ),
      },
    );
    connectors['bogo'] = _i1.EndpointConnector(
      name: 'bogo',
      endpoint: endpoints['bogo']!,
      methodConnectors: {
        'upsertOffer': _i1.MethodConnector(
          name: 'upsertOffer',
          params: {
            'offer': _i1.ParameterDescription(
              name: 'offer',
              type: _i1.getType<_i20.BogoOffer>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint).upsertOffer(
                session,
                params['offer'],
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint).deleteOffer(
                session,
                params['triggerProductId'],
              ),
        ),
        'getAllOffers': _i1.MethodConnector(
          name: 'getAllOffers',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['bogo'] as _i5.BogoEndpoint).getAllOffers(session),
        ),
        'getOffersPage': _i1.MethodConnector(
          name: 'getOffersPage',
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['bogo'] as _i5.BogoEndpoint).getOffersPage(
                session,
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
        'getOfferForProduct': _i1.MethodConnector(
          name: 'getOfferForProduct',
          params: {
            'triggerProductId': _i1.ParameterDescription(
              name: 'triggerProductId',
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
              type: _i1.getType<_i21.Category>(),
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
              type: _i1.getType<_i22.CategoryOffer>(),
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
                      .upsertCategoryOffer(
                        session,
                        params['offer'],
                        params['firebaseUid'],
                        params['idToken'],
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
              type: _i1.getType<_i23.Order>(),
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
        'upsertComboOffer': _i1.MethodConnector(
          name: 'upsertComboOffer',
          params: {
            'offer': _i1.ParameterDescription(
              name: 'offer',
              type: _i1.getType<_i24.ComboOffer>(),
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
                  .upsertComboOffer(
                    session,
                    params['offer'],
                    params['firebaseUid'],
                    params['idToken'],
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
              type: _i1.getType<List<_i25.CartItemInput>>(),
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
                  (endpoints['coupon'] as _i10.CouponEndpoint).fetchCoupons(
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
              type: _i1.getType<_i26.Coupon>(),
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
                  (endpoints['coupon'] as _i10.CouponEndpoint).uploadCoupon(
                    session,
                    params['coupon'],
                    params['firebaseUid'],
                    params['idToken'],
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
                  (endpoints['coupon'] as _i10.CouponEndpoint).setCouponActive(
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
              type: _i1.getType<_i26.Coupon>(),
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
                  (endpoints['coupon'] as _i10.CouponEndpoint).updateCoupon(
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
                  (endpoints['coupon'] as _i10.CouponEndpoint).deleteCoupon(
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
              ) async => (endpoints['coupon'] as _i10.CouponEndpoint)
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
                  (endpoints['coupon'] as _i10.CouponEndpoint).validateCoupon(
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
              type: _i1.getType<List<_i25.CartItemInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i10.CouponEndpoint).applyCoupon(
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
              type: _i1.getType<List<_i25.CartItemInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['coupon'] as _i10.CouponEndpoint)
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
              type: _i1.getType<List<_i25.CartItemInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['coupon'] as _i10.CouponEndpoint).getBestCoupon(
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
                  (endpoints['freeDelivery'] as _i11.FreeDeliveryEndpoint)
                      .getDeliveryConfig(session),
        ),
        'upsertDeliveryConfig': _i1.MethodConnector(
          name: 'upsertDeliveryConfig',
          params: {
            'config': _i1.ParameterDescription(
              name: 'config',
              type: _i1.getType<_i27.DeliveryConfig>(),
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
                  (endpoints['freeDelivery'] as _i11.FreeDeliveryEndpoint)
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
                  (endpoints['freeDelivery'] as _i11.FreeDeliveryEndpoint)
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
                  (endpoints['freeDelivery'] as _i11.FreeDeliveryEndpoint)
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
              type: _i1.getType<_i28.DeliveryRule>(),
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
                  (endpoints['freeDelivery'] as _i11.FreeDeliveryEndpoint)
                      .upsertDeliveryRule(
                        session,
                        params['rule'],
                        params['firebaseUid'],
                        params['idToken'],
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
                  (endpoints['freeDelivery'] as _i11.FreeDeliveryEndpoint)
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
                  (endpoints['freeDelivery'] as _i11.FreeDeliveryEndpoint)
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['freeDelivery'] as _i11.FreeDeliveryEndpoint)
                      .calculateDeliveryPricing(
                        session,
                        params['cartTotal'],
                        userId: params['userId'],
                        location: params['location'],
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
              type: _i1.getType<_i23.Order>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i12.OrderEndpoint).createOrder(
                session,
                params['order'],
              ),
        ),
        'createPendingOrder': _i1.MethodConnector(
          name: 'createPendingOrder',
          params: {
            'order': _i1.ParameterDescription(
              name: 'order',
              type: _i1.getType<_i23.Order>(),
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
                  (endpoints['order'] as _i12.OrderEndpoint).createPendingOrder(
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
              ) async => (endpoints['order'] as _i12.OrderEndpoint).getOrders(
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
                  (endpoints['order'] as _i12.OrderEndpoint).getOrdersPage(
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
                  (endpoints['order'] as _i12.OrderEndpoint).getOrdersCount(
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
                  (endpoints['order'] as _i12.OrderEndpoint).getTodayOrders(
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i12.OrderEndpoint).getUserOrders(
                    session,
                    params['userId'],
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i12.OrderEndpoint).getOrderById(
                    session,
                    params['orderId'],
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
                  (endpoints['order'] as _i12.OrderEndpoint).updateOrderStatus(
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
              ) async => (endpoints['order'] as _i12.OrderEndpoint)
                  .updatePaymentStatus(
                    session,
                    params['orderId'],
                    params['paymentStatus'],
                    razorpayPaymentId: params['razorpayPaymentId'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i12.OrderEndpoint).confirmOrder(
                    session,
                    params['orderId'],
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
              ) async => (endpoints['order'] as _i12.OrderEndpoint).cancelOrder(
                session,
                params['orderId'],
                params['userId'],
                reason: params['reason'],
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
              ) async => (endpoints['order'] as _i12.OrderEndpoint)
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
                  (endpoints['order'] as _i12.OrderEndpoint).getDashboardStats(
                    session,
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
              ) async => (endpoints['payment'] as _i13.PaymentEndpoint)
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
                  (endpoints['payment'] as _i13.PaymentEndpoint).verifyPayment(
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i13.PaymentEndpoint)
                  .markPaymentFailed(
                    session,
                    params['orderId'],
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['payment'] as _i13.PaymentEndpoint).initiateRefund(
                    session,
                    params['razorpayPaymentId'],
                    params['amount'],
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i13.PaymentEndpoint)
                  .getPaymentStatus(
                    session,
                    params['razorpayPaymentId'],
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
              ) async => (endpoints['payment'] as _i13.PaymentEndpoint)
                  .recoverPendingPayments(
                    session,
                    params['userId'],
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
              type: _i1.getType<List<_i25.CartItemInput>>(),
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
              ) async => (endpoints['pricing'] as _i14.PricingEndpoint)
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
              type: _i1.getType<List<_i25.CartItemInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['pricing'] as _i14.PricingEndpoint)
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
              type: _i1.getType<List<_i25.CartItemInput>?>(),
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
              ) async => (endpoints['pricing'] as _i14.PricingEndpoint)
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
              ) async => (endpoints['pricing'] as _i14.PricingEndpoint)
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
              ) async => (endpoints['product'] as _i15.ProductEndpoint)
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
              ) async =>
                  (endpoints['product'] as _i15.ProductEndpoint).getProducts(
                    session,
                    limit: params['limit'],
                    lastProductName: params['lastProductName'],
                    category: params['category'],
                    subcategories: params['subcategories'],
                    sortBy: params['sortBy'],
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
              ) async => (endpoints['product'] as _i15.ProductEndpoint)
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
              ) async => (endpoints['product'] as _i15.ProductEndpoint)
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
              type: _i1.getType<_i29.Product>(),
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
                  (endpoints['product'] as _i15.ProductEndpoint).uploadProduct(
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
              type: _i1.getType<_i29.Product>(),
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
                  (endpoints['product'] as _i15.ProductEndpoint).updateProduct(
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
                  (endpoints['product'] as _i15.ProductEndpoint).deleteProduct(
                    session,
                    params['productId'],
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
              ) async => (endpoints['product'] as _i15.ProductEndpoint)
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i15.ProductEndpoint).searchProducts(
                    session,
                    params['query'],
                  ),
        ),
        'migrateProducts': _i1.MethodConnector(
          name: 'migrateProducts',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i15.ProductEndpoint)
                  .migrateProducts(session),
        ),
        'initializeProductMetrics': _i1.MethodConnector(
          name: 'initializeProductMetrics',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i15.ProductEndpoint)
                  .initializeProductMetrics(session),
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
              ) async => (endpoints['product'] as _i15.ProductEndpoint)
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
              ) async => (endpoints['product'] as _i15.ProductEndpoint)
                  .incrementProductPurchase(
                    session,
                    params['productId'],
                  ),
        ),
        'seedProductMetricsForTesting': _i1.MethodConnector(
          name: 'seedProductMetricsForTesting',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i15.ProductEndpoint)
                  .seedProductMetricsForTesting(session),
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['refund'] as _i16.RefundEndpoint).initiateRefund(
                    session,
                    params['orderId'],
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['refund'] as _i16.RefundEndpoint).getRefundStatus(
                    session,
                    params['orderId'],
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
              ) async => (endpoints['subCategory'] as _i17.SubCategoryEndpoint)
                  .getSubCategories(session),
        ),
        'uploadSubCategory': _i1.MethodConnector(
          name: 'uploadSubCategory',
          params: {
            'subCategory': _i1.ParameterDescription(
              name: 'subCategory',
              type: _i1.getType<_i30.SubCategory>(),
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
              ) async => (endpoints['subCategory'] as _i17.SubCategoryEndpoint)
                  .uploadSubCategory(
                    session,
                    params['subCategory'],
                    params['firebaseUid'],
                    params['idToken'],
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
                  (endpoints['user'] as _i18.UserEndpoint).getUserByFirebaseUid(
                    session,
                    params['uid'],
                  ),
        ),
        'createOrUpdateUser': _i1.MethodConnector(
          name: 'createOrUpdateUser',
          params: {
            'user': _i1.ParameterDescription(
              name: 'user',
              type: _i1.getType<_i31.AppUser>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i18.UserEndpoint).createOrUpdateUser(
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
              type: _i1.getType<List<_i32.CartItem>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i18.UserEndpoint).updateCart(
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
                  (endpoints['user'] as _i18.UserEndpoint).updateFcmToken(
                    session,
                    params['uid'],
                    params['token'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i33.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i34.Endpoints()
      ..initializeEndpoints(server);
  }
}
