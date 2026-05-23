import 'dart:convert';

import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_complaint_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_order_service.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Address change complaints', (sessionBuilder, endpoints) {
    test('stores address change request metadata on complaint creation', () async {
      final seed = await _seedOrder(
        sessionBuilder,
        endpoints,
        status: 'out_for_delivery',
        address: protocol.Address(
          street: '12 Old Street',
          city: 'Old City',
          state: 'Old State',
          zipCode: '111111',
          country: 'India',
          latitude: 28.6001,
          longitude: 77.2001,
        ),
      );
      final service = PostgresComplaintService();
      final session = sessionBuilder.build();
      try {
        final requested = protocol.Address(
          street: '99 New Avenue',
          city: 'New City',
          state: 'New State',
          zipCode: '222222',
          country: 'India',
          latitude: 28.6123,
          longitude: 77.2199,
        );

        final complaint = await service.createDeliveryComplaint(
          session,
          user: seed.user,
          orderNumber: seed.order.orderNumber,
          issueType: 'Delivery Location Issue',
          title: 'Delivery Location Issue',
          description:
              'Please update the address because the order is now going to a different building.',
          selectedField: PostgresComplaintService.addressChangeField,
          requestedAddress: requested,
          requestedNote: 'Ring the side gate once you arrive.',
        );

        expect(complaint.status, equals(PostgresComplaintService.pendingStatus));
        expect(complaint.complaintType, equals(PostgresComplaintService.deliveryType));
        expect(complaint.selectedField, equals(PostgresComplaintService.addressChangeField));
        expect(complaint.userPhone, equals('9999999999'));
        expect(complaint.extraData, isNotNull);
        expect(complaint.extraData!['requestedNote'], contains('side gate'));

        final currentAddress = jsonDecode(complaint.extraData!['currentAddressJson']!)
            as Map<String, dynamic>;
        final requestedAddress = jsonDecode(complaint.extraData!['requestedAddressJson']!)
            as Map<String, dynamic>;
        expect(currentAddress['street'], equals('12 Old Street'));
        expect(requestedAddress['street'], equals('99 New Avenue'));
        expect(requestedAddress['latitude'], equals(28.6123));
      } finally {
        await session.close();
      }
    });

    test('updates order address and tracking metadata before out for delivery', () async {
      final seed = await _seedOrder(
        sessionBuilder,
        endpoints,
        status: 'pending',
        address: protocol.Address(
          street: '1 Old Lane',
          city: 'Old Town',
          state: 'Old State',
          zipCode: '333333',
          country: 'India',
          latitude: 28.501,
          longitude: 77.101,
        ),
      );
      final session = sessionBuilder.build();
      try {
        final service = PostgresOrderService();
        final updatedAddress = protocol.Address(
          street: '45 Updated Road',
          city: 'Updated City',
          state: 'Updated State',
          zipCode: '444444',
          country: 'India',
          latitude: 28.555,
          longitude: 77.155,
        );

        final result = await service.updateDeliveryAddress(
          session,
          orderNumber: seed.order.orderNumber,
          deliveryAddress: updatedAddress,
          deliveryNote: 'Leave near the side gate',
        );

        expect(result, isNotNull);

        final order = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(seed.order.orderNumber),
        );
        expect(order, isNotNull);

        final addressRow = await protocol.OrderAddressRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(order!.id!),
        );
        expect(addressRow, isNotNull);
        expect(addressRow!.streetLine1, equals('45 Updated Road'));
        expect(addressRow.city, equals('Updated City'));
        expect(addressRow.landmark, equals('Leave near the side gate'));

        final trackingRow = await protocol.OrderTrackingRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(order!.id!),
        );
        expect(trackingRow, isNotNull);
        expect(trackingRow!.userAddress, contains('45 Updated Road'));
        expect(trackingRow.userLatitude, equals(28.555));
        expect(trackingRow.userLongitude, equals(77.155));
      } finally {
        await session.close();
      }
    });

    test('approves address change complaints by updating order and audit log', () async {
      final seed = await _seedOrder(
        sessionBuilder,
        endpoints,
        status: 'out_for_delivery',
        address: protocol.Address(
          street: '10 Before St',
          city: 'Before City',
          state: 'Before State',
          zipCode: '555555',
          country: 'India',
          latitude: 28.61,
          longitude: 77.21,
        ),
      );
      final session = sessionBuilder.build();
      try {
        final complaintService = PostgresComplaintService();
        final requested = protocol.Address(
          street: '22 Approved Ave',
          city: 'Approved City',
          state: 'Approved State',
          zipCode: '666666',
          country: 'India',
          latitude: 28.62,
          longitude: 77.22,
        );
        final complaint = await complaintService.createDeliveryComplaint(
          session,
          user: seed.user,
          orderNumber: seed.order.orderNumber,
          issueType: 'Delivery Location Issue',
          title: 'Delivery Location Issue',
          description:
              'Please approve this address because the customer is moving to a nearby building.',
          selectedField: PostgresComplaintService.addressChangeField,
          requestedAddress: requested,
          requestedNote: 'Call on arrival.',
        );

        final updated = await complaintService.updateComplaintStatus(
          session,
          complaintId: complaint.complaintId,
          status: PostgresComplaintService.resolvedStatus,
          adminNote: 'Approved for nearby delivery',
          actorFirebaseUid: seed.user.firebaseUid,
        );

        expect(updated.status, equals(PostgresComplaintService.resolvedStatus));
        expect(updated.resolutionType, equals('address_change_approved'));
        expect(updated.adminNote, equals('Approved for nearby delivery'));

        final order = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(seed.order.orderNumber),
        );
        expect(order, isNotNull);

        final addressRow = await protocol.OrderAddressRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(order!.id!),
        );
        expect(addressRow, isNotNull);
        expect(addressRow!.streetLine1, equals('22 Approved Ave'));
        expect(addressRow.city, equals('Approved City'));

        final trackingRow = await protocol.OrderTrackingRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(order!.id!),
        );
        expect(trackingRow, isNotNull);
        expect(trackingRow!.userAddress, contains('22 Approved Ave'));

        final audit = await protocol.AdminAuditLogRow.db.findFirstRow(
          session,
          where: (t) => t.action.equals('approve_address_change')
              & t.entityType.equals('complaint'),
        );
        expect(audit, isNotNull);
        expect(audit!.metadata?['orderNumber'], equals(seed.order.orderNumber));
        expect(audit.metadata?['selectedField'], equals(PostgresComplaintService.addressChangeField));
      } finally {
        await session.close();
      }
    });

    test('rejects address change complaints with a required reason and audit log', () async {
      final seed = await _seedOrder(
        sessionBuilder,
        endpoints,
        status: 'out_for_delivery',
        address: protocol.Address(
          street: '40 Original Rd',
          city: 'Original City',
          state: 'Original State',
          zipCode: '777777',
          country: 'India',
        ),
      );
      final session = sessionBuilder.build();
      try {
        final complaintService = PostgresComplaintService();
        final complaint = await complaintService.createDeliveryComplaint(
          session,
          user: seed.user,
          orderNumber: seed.order.orderNumber,
          issueType: 'Delivery Location Issue',
          title: 'Delivery Location Issue',
          description: 'Reject this change because the rider is already nearby.',
          selectedField: PostgresComplaintService.addressChangeField,
          requestedAddress: protocol.Address(
            street: '99 Rejected St',
            city: 'Rejected City',
            state: 'Rejected State',
            zipCode: '888888',
            country: 'India',
          ),
        );

        final updated = await complaintService.updateComplaintStatus(
          session,
          complaintId: complaint.complaintId,
          status: PostgresComplaintService.rejectedStatus,
          adminNote: 'Rider already nearby',
          actorFirebaseUid: seed.user.firebaseUid,
        );

        expect(updated.status, equals(PostgresComplaintService.rejectedStatus));
        expect(updated.resolutionType, equals('address_change_rejected'));
        expect(updated.adminNote, equals('Rider already nearby'));

        final audit = await protocol.AdminAuditLogRow.db.findFirstRow(
          session,
          where: (t) => t.action.equals('reject_address_change')
              & t.entityType.equals('complaint'),
        );
        expect(audit, isNotNull);
        expect(audit!.metadata?['reason'], equals('Rider already nearby'));
      } finally {
        await session.close();
      }
    });

    test('filters paginated complaint lists down to address change requests', () async {
      final first = await _seedOrder(
        sessionBuilder,
        endpoints,
        status: 'out_for_delivery',
        address: protocol.Address(
          street: 'A1 Lane',
          city: 'Alpha City',
          state: 'Alpha State',
          zipCode: '900001',
          country: 'India',
        ),
      );
      final second = await _seedOrder(
        sessionBuilder,
        endpoints,
        status: 'out_for_delivery',
        address: protocol.Address(
          street: 'B1 Lane',
          city: 'Beta City',
          state: 'Beta State',
          zipCode: '900002',
          country: 'India',
        ),
      );
      final session = sessionBuilder.build();
      try {
        final complaintService = PostgresComplaintService();
        await complaintService.createDeliveryComplaint(
          session,
          user: first.user,
          orderNumber: first.order.orderNumber,
          issueType: 'Delivery Location Issue',
          title: 'Delivery Location Issue',
          description: 'First request is an address change complaint.',
          selectedField: PostgresComplaintService.addressChangeField,
          requestedAddress: protocol.Address(
            street: 'A2 Lane',
            city: 'Alpha City',
            state: 'Alpha State',
            zipCode: '900011',
            country: 'India',
          ),
        );
        await complaintService.createDeliveryComplaint(
          session,
          user: second.user,
          orderNumber: second.order.orderNumber,
          issueType: 'Delivery Location Issue',
          title: 'Delivery Location Issue',
          description: 'Second request is also an address change complaint.',
          selectedField: PostgresComplaintService.addressChangeField,
          requestedAddress: protocol.Address(
            street: 'B2 Lane',
            city: 'Beta City',
            state: 'Beta State',
            zipCode: '900022',
            country: 'India',
          ),
        );

        final firstPage = await complaintService.listComplaints(
          session,
          status: PostgresComplaintService.pendingStatus,
          issueType: 'Delivery Location Issue',
          selectedField: PostgresComplaintService.addressChangeField,
          complaintType: PostgresComplaintService.deliveryType,
          limit: 1,
        );
        expect(firstPage.complaints, hasLength(1));
        expect(firstPage.nextPageToken, isNotNull);
        expect(
          firstPage.complaints.first.selectedField,
          equals(PostgresComplaintService.addressChangeField),
        );

        final secondPage = await complaintService.listComplaints(
          session,
          status: PostgresComplaintService.pendingStatus,
          issueType: 'Delivery Location Issue',
          selectedField: PostgresComplaintService.addressChangeField,
          complaintType: PostgresComplaintService.deliveryType,
          limit: 1,
          pageToken: firstPage.nextPageToken,
        );
        expect(secondPage.complaints, hasLength(1));
        expect(secondPage.nextPageToken, isNull);
        expect(
          {firstPage.complaints.first.orderNumber, secondPage.complaints.first.orderNumber},
          equals({first.order.orderNumber, second.order.orderNumber}),
        );
      } finally {
        await session.close();
      }
    });
  });
}

class _SeededOrder {
  const _SeededOrder({
    required this.orderNumber,
    required this.order,
    required this.user,
    required this.address,
  });

  final String orderNumber;
  final protocol.CustomerOrderRow order;
  final protocol.AppUserRow user;
  final protocol.OrderAddressRow address;
}

Future<_SeededOrder> _seedOrder(
  TestSessionBuilder sessionBuilder,
  TestEndpoints endpoints, {
  required String status,
  required protocol.Address address,
}) async {
  final suffix = DateTime.now().microsecondsSinceEpoch;
  final orderNumber = await _createPendingOrder(
    endpoints,
    sessionBuilder,
    suffix: suffix,
    address: address,
  );
  final session = sessionBuilder.build();
  try {
    final order = await protocol.CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    expect(order, isNotNull);
    final orderRow = order!;

    if (status != orderRow.orderStatus) {
      final now = DateTime.now().toUtc();
      await protocol.CustomerOrderRow.db.updateById(
        session,
        orderRow.id!,
        columnValues: (t) => [
          t.orderStatus(status),
          if (status == 'out_for_delivery') t.outForDeliveryAt(now),
          t.updatedAt(now),
        ],
      );
    }

    final refreshedOrder = await protocol.CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    expect(refreshedOrder, isNotNull);
    final refreshedOrderRow = refreshedOrder!;
    final user = await protocol.AppUserRow.db.findById(
      session,
      refreshedOrderRow.userId,
    );
    final orderAddress = await protocol.OrderAddressRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(refreshedOrderRow.id!),
    );
    expect(user, isNotNull);
    expect(orderAddress, isNotNull);
    return _SeededOrder(
      orderNumber: orderNumber,
      order: refreshedOrderRow,
      user: user!,
      address: orderAddress!,
    );
  } finally {
    await session.close();
  }
}

Future<String> _createPendingOrder(
  TestEndpoints endpoints,
  TestSessionBuilder sessionBuilder, {
  required int suffix,
  required protocol.Address address,
}) async {
  final productId = await _seedProduct(sessionBuilder, suffix: suffix);
  final order = protocol.Order(
    orderId: '',
    userId: 'address-change-user-$suffix',
    userName: 'Address Change Tester',
    userPhone: '9999999999',
    items: [
      protocol.OrderItem(
        productId: productId,
        productName: 'Address Change Product',
        productImage: 'https://example.com/product.png',
        quantity: 1,
        unitPrice: 100.0,
        totalPrice: 100.0,
        isFreeItem: false,
      ),
    ],
    itemCount: 1,
    totalAmount: 100.0,
    discountAmount: 0.0,
    deliveryFee: 0.0,
    finalAmount: 100.0,
    status: 'pending',
    paymentStatus: 'pending',
    refundStatus: 'none',
    orderType: 'regular',
    sourceOrderNumber: null,
    complaintId: null,
    deliveryAddress: address,
    orderedAt: DateTime.now(),
  );

  return endpoints.order.createPendingOrder(
    sessionBuilder,
    order,
    'address-change-itest-$suffix',
  );
}

Future<String> _seedProduct(
  TestSessionBuilder sessionBuilder, {
  required int suffix,
}) async {
  final session = sessionBuilder.build();
  try {
    final category = await protocol.CategoryRow.db.insertRow(
      session,
      protocol.CategoryRow(
        name: 'Address Change Category $suffix',
        slug: 'address-change-category-$suffix',
      ),
    );

    final product = await protocol.ProductRow.db.insertRow(
      session,
      protocol.ProductRow(
        categoryId: category.id!,
        name: 'Address Change Product $suffix',
        slug: 'address-change-product-$suffix',
        primaryImageUrl: 'https://example.com/product.png',
      ),
    );

    return product.id!.toString();
  } finally {
    await session.close();
  }
}
