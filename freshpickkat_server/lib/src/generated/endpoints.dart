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
import '../endpoints/auth_endpoint.dart' as _i2;
import '../endpoints/category_endpoint.dart' as _i3;
import '../endpoints/product_endpoint.dart' as _i4;
import '../endpoints/sub_category_endpoint.dart' as _i5;
import '../endpoints/user_endpoint.dart' as _i6;
import 'package:freshpickkat_server/src/generated/product.dart' as _i7;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i8;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i9;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i10;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i11;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i12;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'auth': _i2.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'category': _i3.CategoryEndpoint()
        ..initialize(
          server,
          'category',
          null,
        ),
      'product': _i4.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'subCategory': _i5.SubCategoryEndpoint()
        ..initialize(
          server,
          'subCategory',
          null,
        ),
      'user': _i6.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'verifyPhoneLogin': _i1.MethodConnector(
          name: 'verifyPhoneLogin',
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
                  (endpoints['auth'] as _i2.AuthEndpoint).verifyPhoneLogin(
                    session,
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
              ) async => (endpoints['category'] as _i3.CategoryEndpoint)
                  .getCategories(session),
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i4.ProductEndpoint).getProducts(
                    session,
                    limit: params['limit'],
                    lastProductName: params['lastProductName'],
                    category: params['category'],
                    subcategories: params['subcategories'],
                  ),
        ),
        'uploadProduct': _i1.MethodConnector(
          name: 'uploadProduct',
          params: {
            'product': _i1.ParameterDescription(
              name: 'product',
              type: _i1.getType<_i7.Product>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i4.ProductEndpoint).uploadProduct(
                    session,
                    params['product'],
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
              ) async => (endpoints['product'] as _i4.ProductEndpoint)
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
                  (endpoints['product'] as _i4.ProductEndpoint).searchProducts(
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
              ) async => (endpoints['product'] as _i4.ProductEndpoint)
                  .migrateProducts(session),
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
              ) async => (endpoints['subCategory'] as _i5.SubCategoryEndpoint)
                  .getSubCategories(session),
        ),
        'uploadSubCategory': _i1.MethodConnector(
          name: 'uploadSubCategory',
          params: {
            'subCategory': _i1.ParameterDescription(
              name: 'subCategory',
              type: _i1.getType<_i8.SubCategory>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['subCategory'] as _i5.SubCategoryEndpoint)
                  .uploadSubCategory(
                    session,
                    params['subCategory'],
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
                  (endpoints['user'] as _i6.UserEndpoint).getUserByFirebaseUid(
                    session,
                    params['uid'],
                  ),
        ),
        'createOrUpdateUser': _i1.MethodConnector(
          name: 'createOrUpdateUser',
          params: {
            'user': _i1.ParameterDescription(
              name: 'user',
              type: _i1.getType<_i9.AppUser>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i6.UserEndpoint).createOrUpdateUser(
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
              type: _i1.getType<List<_i10.CartItem>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i6.UserEndpoint).updateCart(
                session,
                params['uid'],
                params['cart'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i11.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i12.Endpoints()
      ..initializeEndpoints(server);
  }
}
