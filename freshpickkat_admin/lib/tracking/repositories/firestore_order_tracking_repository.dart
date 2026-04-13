import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/delivery_location.dart';
import '../models/order_tracking_snapshot.dart';

class FirestoreOrderTrackingRepository {
  FirestoreOrderTrackingRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  DocumentReference<Map<String, dynamic>> orderDoc(String orderId) =>
      _orders.doc(orderId);

  Stream<OrderTrackingSnapshot?> watchOrder(String orderId) {
    return orderDoc(orderId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return OrderTrackingSnapshot.fromFirestore(doc);
    });
  }

  Future<OrderTrackingSnapshot?> fetchOrder(String orderId) async {
    final doc = await orderDoc(orderId).get();
    if (!doc.exists) return null;
    return OrderTrackingSnapshot.fromFirestore(doc);
  }

  Future<void> seedOrderTrackingMetadata({
    required String orderId,
    required String status,
    required bool trackingEnabled,
    DeliveryLocation? userLocation,
    TrackingCoordinate? riderLocation,
  }) async {
    final payload = <String, dynamic>{
      'status': status,
      'trackingEnabled': trackingEnabled,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (userLocation != null) {
      payload['userLocation'] = userLocation.toMap();
    }
    if (riderLocation != null) {
      payload['riderLocation'] = riderLocation.toMap();
    }
    await orderDoc(orderId).set(payload, SetOptions(merge: true));
  }

  Future<void> updateTrackingEnabled({
    required String orderId,
    required bool enabled,
  }) {
    return orderDoc(orderId).set({
      'trackingEnabled': enabled,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateRiderLocation({
    required String orderId,
    required TrackingCoordinate riderLocation,
  }) {
    return orderDoc(orderId).set({
      'riderLocation': riderLocation.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
