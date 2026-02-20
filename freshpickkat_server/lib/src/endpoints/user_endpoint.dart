import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class UserEndpoint extends Endpoint {
  // Firestore collection name
  static const String userCollection = 'users';
  static const String projectId = 'freshpickkart-a6824';

  // Get user by Firebase UID
  Future<AppUser?> getUserByFirebaseUid(Session session, String uid) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final doc = await firestore.projects.databases.documents.get(
      'projects/$projectId/databases/(default)/documents/$userCollection/$uid',
    );
    if (doc.fields == null) return null;
    return _appUserFromFirestore(doc.fields!, uid);
  }

  // Create or update user
  Future<AppUser> createOrUpdateUser(Session session, AppUser user) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath =
        'projects/$projectId/databases/(default)/documents/$userCollection/${user.firebaseUid}';
    final fields = _appUserToFirestore(user);
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
    );
    return user;
  }

  // Update user cart
  Future<bool> updateCart(
    Session session,
    String uid,
    List<CartItem> cart,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath =
        'projects/$projectId/databases/(default)/documents/$userCollection/$uid';
    final cartFields = <String, firestore_api.Value>{
      'cart': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: cart.map(_cartItemToFirestore).toList(),
        ),
      ),
    };
    final doc = firestore_api.Document(fields: cartFields);
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: ['cart'],
    );
    return true;
  }

  // Helper: Convert Firestore fields to AppUser
  AppUser _appUserFromFirestore(
    Map<String, firestore_api.Value> fields,
    String uid,
  ) {
    return AppUser(
      firebaseUid: uid,
      phoneNumber: fields['phoneNumber']?.stringValue ?? '',
      name: fields['name']?.stringValue,
      shippingAddress: fields['shippingAddress']?.mapValue?.fields != null
          ? _addressFromFirestore(
              fields['shippingAddress']!.mapValue!.fields!,
            )
          : null,
      cart: fields['cart']?.arrayValue?.values != null
          ? fields['cart']!.arrayValue!.values!
                .map((v) => _cartItemFromFirestore(v.mapValue!.fields!))
                .toList()
          : null,
    );
  }

  // Helper: Convert AppUser to Firestore fields
  Map<String, firestore_api.Value> _appUserToFirestore(AppUser user) {
    final map = <String, firestore_api.Value>{
      'phoneNumber': firestore_api.Value(stringValue: user.phoneNumber),
    };
    if (user.name != null) {
      map['name'] = firestore_api.Value(stringValue: user.name);
    }
    if (user.shippingAddress != null) {
      map['shippingAddress'] = firestore_api.Value(
        mapValue: firestore_api.MapValue(
          fields: _addressToFirestore(user.shippingAddress!),
        ),
      );
    }
    if (user.cart != null) {
      map['cart'] = firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: user.cart!.map(_cartItemToFirestore).toList(),
        ),
      );
    }
    return map;
  }

  // Helper: Convert Firestore fields to Address
  Address _addressFromFirestore(Map<String, firestore_api.Value> fields) {
    return Address(
      street: fields['street']?.stringValue ?? '',
      city: fields['city']?.stringValue ?? '',
      state: fields['state']?.stringValue ?? '',
      zipCode: fields['zipCode']?.stringValue ?? '',
      country: fields['country']?.stringValue ?? '',
      latitude: fields['latitude']?.doubleValue,
      longitude: fields['longitude']?.doubleValue,
    );
  }

  // Helper: Convert Address to Firestore fields
  Map<String, firestore_api.Value> _addressToFirestore(Address address) {
    final map = <String, firestore_api.Value>{
      'street': firestore_api.Value(stringValue: address.street),
      'city': firestore_api.Value(stringValue: address.city),
      'state': firestore_api.Value(stringValue: address.state),
      'zipCode': firestore_api.Value(stringValue: address.zipCode),
      'country': firestore_api.Value(stringValue: address.country),
    };
    if (address.latitude != null) {
      map['latitude'] = firestore_api.Value(doubleValue: address.latitude);
    }
    if (address.longitude != null) {
      map['longitude'] = firestore_api.Value(doubleValue: address.longitude);
    }
    return map;
  }

  // Helper: Convert Firestore fields to CartItem
  CartItem _cartItemFromFirestore(Map<String, firestore_api.Value> fields) {
    return CartItem(
      productId: fields['productId']?.stringValue ?? '',
      quantity: int.tryParse(fields['quantity']?.integerValue ?? '0') ?? 0,
    );
  }

  // Helper: Convert CartItem to Firestore fields
  firestore_api.Value _cartItemToFirestore(CartItem item) {
    return firestore_api.Value(
      mapValue: firestore_api.MapValue(
        fields: {
          'productId': firestore_api.Value(stringValue: item.productId),
          'quantity': firestore_api.Value(
            integerValue: item.quantity.toString(),
          ),
        },
      ),
    );
  }
}
