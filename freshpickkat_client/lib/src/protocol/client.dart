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
import 'dart:async' as _i2;
import 'package:freshpickkat_client/src/protocol/category.dart' as _i3;
import 'package:freshpickkat_client/src/protocol/product.dart' as _i4;
import 'package:freshpickkat_client/src/protocol/sub_category.dart' as _i5;
import 'package:freshpickkat_client/src/protocol/app_user.dart' as _i6;
import 'package:freshpickkat_client/src/protocol/cart_item.dart' as _i7;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i8;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i9;
import 'protocol.dart' as _i10;

/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  _i2.Future<String> verifyPhoneLogin(String idToken) =>
      caller.callServerEndpoint<String>(
        'auth',
        'verifyPhoneLogin',
        {'idToken': idToken},
      );
}

/// {@category Endpoint}
class EndpointCategory extends _i1.EndpointRef {
  EndpointCategory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'category';

  _i2.Future<List<_i3.Category>> getCategories() =>
      caller.callServerEndpoint<List<_i3.Category>>(
        'category',
        'getCategories',
        {},
      );
}

/// {@category Endpoint}
class EndpointProduct extends _i1.EndpointRef {
  EndpointProduct(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  _i2.Future<List<_i4.Product>> getProducts({
    required int limit,
    String? lastProductName,
    String? category,
    List<String>? subcategories,
  }) => caller.callServerEndpoint<List<_i4.Product>>(
    'product',
    'getProducts',
    {
      'limit': limit,
      'lastProductName': lastProductName,
      'category': category,
      'subcategories': subcategories,
    },
  );

  /// Upload a product to Firestore 'Products' collection
  _i2.Future<bool> uploadProduct(_i4.Product product) =>
      caller.callServerEndpoint<bool>(
        'product',
        'uploadProduct',
        {'product': product},
      );

  _i2.Future<List<String>> getProductSuggestions(String query) =>
      caller.callServerEndpoint<List<String>>(
        'product',
        'getProductSuggestions',
        {'query': query},
      );

  _i2.Future<List<_i4.Product>> searchProducts(String query) =>
      caller.callServerEndpoint<List<_i4.Product>>(
        'product',
        'searchProducts',
        {'query': query},
      );

  _i2.Future<int> migrateProducts() => caller.callServerEndpoint<int>(
    'product',
    'migrateProducts',
    {},
  );
}

/// {@category Endpoint}
class EndpointSubCategory extends _i1.EndpointRef {
  EndpointSubCategory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subCategory';

  /// Fetch all subcategories from Firestore 'subCategories' collection
  _i2.Future<List<_i5.SubCategory>> getSubCategories() =>
      caller.callServerEndpoint<List<_i5.SubCategory>>(
        'subCategory',
        'getSubCategories',
        {},
      );

  /// Upload a subcategory to Firestore 'subCategories' collection
  _i2.Future<bool> uploadSubCategory(_i5.SubCategory subCategory) =>
      caller.callServerEndpoint<bool>(
        'subCategory',
        'uploadSubCategory',
        {'subCategory': subCategory},
      );
}

/// {@category Endpoint}
class EndpointUser extends _i1.EndpointRef {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i2.Future<_i6.AppUser?> getUserByFirebaseUid(String uid) =>
      caller.callServerEndpoint<_i6.AppUser?>(
        'user',
        'getUserByFirebaseUid',
        {'uid': uid},
      );

  _i2.Future<_i6.AppUser> createOrUpdateUser(_i6.AppUser user) =>
      caller.callServerEndpoint<_i6.AppUser>(
        'user',
        'createOrUpdateUser',
        {'user': user},
      );

  _i2.Future<bool> updateCart(
    String uid,
    List<_i7.CartItem> cart,
  ) => caller.callServerEndpoint<bool>(
    'user',
    'updateCart',
    {
      'uid': uid,
      'cart': cart,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i8.Caller(client);
    serverpod_auth_core = _i9.Caller(client);
  }

  late final _i8.Caller serverpod_auth_idp;

  late final _i9.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i10.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    auth = EndpointAuth(this);
    category = EndpointCategory(this);
    product = EndpointProduct(this);
    subCategory = EndpointSubCategory(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointAuth auth;

  late final EndpointCategory category;

  late final EndpointProduct product;

  late final EndpointSubCategory subCategory;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'auth': auth,
    'category': category,
    'product': product,
    'subCategory': subCategory,
    'user': user,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
