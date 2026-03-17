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
import '../endpoints/category_endpoint.dart' as _i4;
import '../endpoints/coupon_endpoint.dart' as _i5;
import '../endpoints/order_endpoint.dart' as _i6;
import '../endpoints/payment_endpoint.dart' as _i7;
import '../endpoints/product_endpoint.dart' as _i8;
import '../endpoints/sub_category_endpoint.dart' as _i9;
import '../endpoints/user_endpoint.dart' as _i10;
import 'package:freshpickkat_server/src/generated/category.dart' as _i11;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i12;
import 'package:freshpickkat_server/src/generated/order.dart' as _i13;
import 'package:freshpickkat_server/src/generated/product.dart' as _i14;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i15;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i16;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i17;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i18;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i19;

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
      'category': _i4.CategoryEndpoint()
        ..initialize(
          server,
          'category',
          null,
        ),
      'coupon': _i5.CouponEndpoint()
        ..initialize(
          server,
          'coupon',
          null,
        ),
      'order': _i6.OrderEndpoint()
        ..initialize(
          server,
          'order',
          null,
        ),
      'payment': _i7.PaymentEndpoint()
        ..initialize(
          server,
          'payment',
          null,
        ),
      'product': _i8.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'subCategory': _i9.SubCategoryEndpoint()
        ..initialize(
          server,
          'subCategory',
          null,
        ),
      'user': _i10.UserEndpoint()
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
              ) async => (endpoints['category'] as _i4.CategoryEndpoint)
                  .getCategories(session),
        ),
        'uploadCategory': _i1.MethodConnector(
          name: 'uploadCategory',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i11.Category>(),
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
              ) async => (endpoints['category'] as _i4.CategoryEndpoint)
                  .uploadCategory(
                    session,
                    params['category'],
                    params['firebaseUid'],
                    params['idToken'],
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
                  (endpoints['coupon'] as _i5.CouponEndpoint).fetchCoupons(
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
              type: _i1.getType<_i12.Coupon>(),
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
                  (endpoints['coupon'] as _i5.CouponEndpoint).uploadCoupon(
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
                  (endpoints['coupon'] as _i5.CouponEndpoint).setCouponActive(
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
              type: _i1.getType<_i12.Coupon>(),
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
                  (endpoints['coupon'] as _i5.CouponEndpoint).updateCoupon(
                    session,
                    params['coupon'],
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
              ) async => (endpoints['coupon'] as _i5.CouponEndpoint)
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
                  (endpoints['coupon'] as _i5.CouponEndpoint).validateCoupon(
                    session,
                    params['couponCode'],
                    params['orderAmount'],
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
              type: _i1.getType<_i13.Order>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i6.OrderEndpoint).createOrder(
                session,
                params['order'],
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
              ) async => (endpoints['order'] as _i6.OrderEndpoint).getOrders(
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
                  (endpoints['order'] as _i6.OrderEndpoint).getOrdersPage(
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
                  (endpoints['order'] as _i6.OrderEndpoint).getOrdersCount(
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
                  (endpoints['order'] as _i6.OrderEndpoint).getTodayOrders(
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
                  (endpoints['order'] as _i6.OrderEndpoint).getUserOrders(
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
              ) async => (endpoints['order'] as _i6.OrderEndpoint).getOrderById(
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
                  (endpoints['order'] as _i6.OrderEndpoint).updateOrderStatus(
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
              ) async =>
                  (endpoints['order'] as _i6.OrderEndpoint).updatePaymentStatus(
                    session,
                    params['orderId'],
                    params['paymentStatus'],
                    razorpayPaymentId: params['razorpayPaymentId'],
                    firebaseUid: params['firebaseUid'],
                    idToken: params['idToken'],
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
              ) async => (endpoints['order'] as _i6.OrderEndpoint)
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
                  (endpoints['order'] as _i6.OrderEndpoint).getDashboardStats(
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
              ) async => (endpoints['payment'] as _i7.PaymentEndpoint)
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
                  (endpoints['payment'] as _i7.PaymentEndpoint).verifyPayment(
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
              ) async => (endpoints['payment'] as _i7.PaymentEndpoint)
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
                  (endpoints['payment'] as _i7.PaymentEndpoint).initiateRefund(
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
              ) async => (endpoints['payment'] as _i7.PaymentEndpoint)
                  .getPaymentStatus(
                    session,
                    params['razorpayPaymentId'],
                  ),
        ),
      },
    );
    connectors['product'] = _i1.EndpointConnector(
      name: 'product',
      endpoint: endpoints['product']!,
      methodConnectors: {
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
                  (endpoints['product'] as _i8.ProductEndpoint).getProducts(
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
              ) async =>
                  (endpoints['product'] as _i8.ProductEndpoint).getProductsPage(
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
              ) async => (endpoints['product'] as _i8.ProductEndpoint)
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
              type: _i1.getType<_i14.Product>(),
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
                  (endpoints['product'] as _i8.ProductEndpoint).uploadProduct(
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
              type: _i1.getType<_i14.Product>(),
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
                  (endpoints['product'] as _i8.ProductEndpoint).updateProduct(
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
                  (endpoints['product'] as _i8.ProductEndpoint).deleteProduct(
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
              ) async => (endpoints['product'] as _i8.ProductEndpoint)
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
                  (endpoints['product'] as _i8.ProductEndpoint).searchProducts(
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
              ) async => (endpoints['product'] as _i8.ProductEndpoint)
                  .migrateProducts(session),
        ),
        'initializeProductMetrics': _i1.MethodConnector(
          name: 'initializeProductMetrics',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i8.ProductEndpoint)
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
              ) async => (endpoints['product'] as _i8.ProductEndpoint)
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
              ) async => (endpoints['product'] as _i8.ProductEndpoint)
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
              ) async => (endpoints['product'] as _i8.ProductEndpoint)
                  .seedProductMetricsForTesting(session),
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
              ) async => (endpoints['subCategory'] as _i9.SubCategoryEndpoint)
                  .getSubCategories(session),
        ),
        'uploadSubCategory': _i1.MethodConnector(
          name: 'uploadSubCategory',
          params: {
            'subCategory': _i1.ParameterDescription(
              name: 'subCategory',
              type: _i1.getType<_i15.SubCategory>(),
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
              ) async => (endpoints['subCategory'] as _i9.SubCategoryEndpoint)
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
                  (endpoints['user'] as _i10.UserEndpoint).getUserByFirebaseUid(
                    session,
                    params['uid'],
                  ),
        ),
        'createOrUpdateUser': _i1.MethodConnector(
          name: 'createOrUpdateUser',
          params: {
            'user': _i1.ParameterDescription(
              name: 'user',
              type: _i1.getType<_i16.AppUser>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i10.UserEndpoint).createOrUpdateUser(
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
              type: _i1.getType<List<_i17.CartItem>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i10.UserEndpoint).updateCart(
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
                  (endpoints['user'] as _i10.UserEndpoint).updateFcmToken(
                    session,
                    params['uid'],
                    params['token'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i18.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i19.Endpoints()
      ..initializeEndpoints(server);
  }
}
