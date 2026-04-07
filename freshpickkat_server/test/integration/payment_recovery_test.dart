import 'package:test/test.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/generated/endpoints.dart';
import 'package:freshpickkat_server/src/services/firebase_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Payment recovery', (sessionBuilder, endpoints) {
    test('create pending order -> verify payment succeeds', () async {
      final orderId = await _createPendingOrder(endpoints, sessionBuilder);

      final firestore = await FirebaseService.getFirestoreClient();
      final orderDocPath =
          'projects/freshpickkart-a6824/databases/(default)/documents/orders/$orderId';
      final doc = firestore_api.Document(fields: {
        'razorpayOrderId': firestore_api.Value(stringValue: 'rzp_test_order'),
      });
      await firestore.projects.databases.documents.patch(
        doc,
        orderDocPath,
        updateMask_fieldPaths: ['razorpayOrderId'],
      );

      final verifyResult = await endpoints.payment.verifyPayment(
        sessionBuilder,
        orderId,
        'rzp_test_order',
        'fake_payment_id',
        '',
      );
      expect(verifyResult.success, isTrue);
      expect(verifyResult.verified, isTrue);

      final updatedOrder =
          await endpoints.order.getOrderById(sessionBuilder, orderId);
      expect(updatedOrder, isNotNull);
      expect(updatedOrder!.paymentStatus, equals('paid'));
      expect(updatedOrder.status, equals('confirmed'));
    });
  });
}

Future<String> _createPendingOrder(
  TestEndpoints endpoints,
  TestSessionBuilder sessionBuilder,
) async {
  final order = protocol.Order(
    orderId: '',
    userId: 'integration-user',
    userName: 'Integration Tester',
    userPhone: '9999999999',
    items: [],
    itemCount: 0,
    totalAmount: 100.0,
    discountAmount: 0.0,
    deliveryFee: 0.0,
    finalAmount: 100.0,
    status: 'pending',
    paymentStatus: 'pending',
    refundStatus: 'none',
    deliveryAddress: protocol.Address(
      street: '123 Testing Rd',
      city: 'Testville',
      state: 'Test',
      zipCode: '000000',
      country: 'Testland',
    ),
    orderedAt: DateTime.now(),
  );

  final idempotencyKey = 'itest-${DateTime.now().millisecondsSinceEpoch}';
  final orderId = await endpoints.order.createPendingOrder(
    sessionBuilder,
    order,
    idempotencyKey,
  );
  return orderId;
}
