import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_complaint_service.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Product complaint service', (sessionBuilder, endpoints) {
    test(
      'creates complaint for own delivered order item within 1 day',
      () async {
        final seed = await _seedDeliveredOrder(sessionBuilder);
        final session = sessionBuilder.build();
        try {
          final service = PostgresComplaintService();
          final complaint = await service.createComplaint(
            session,
            user: seed.user,
            orderNumber: seed.order.orderNumber,
            orderItemId: seed.item.id!.toString(),
            issueType: 'Damaged Product',
            description:
                'The product packaging was damaged and item was leaking.',
            imageUrls: ['https://example.com/issue.jpg'],
          );

          expect(complaint.status, equals('Pending'));
          expect(complaint.orderItemId, equals(seed.item.id!.toString()));
          expect(complaint.imageUrls, hasLength(1));
          expect(complaint.complaintType, equals('product'));
          expect(complaint.selectedProducts, hasLength(1));
        } finally {
          await session.close();
        }
      },
    );

    test('rejects duplicate active product complaint for same order', () async {
      final seed = await _seedDeliveredOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final service = PostgresComplaintService();
        await service.createComplaint(
          session,
          user: seed.user,
          orderNumber: seed.order.orderNumber,
          orderItemId: seed.item.id!.toString(),
          issueType: 'Wrong Product',
          description:
              'The product delivered is different from what I ordered.',
          imageUrls: ['https://example.com/issue.jpg'],
        );

        expect(
          () => service.createComplaint(
            session,
            user: seed.user,
            orderNumber: seed.order.orderNumber,
            orderItemId: seed.item.id!.toString(),
            issueType: 'Wrong Product',
            description:
                'The product delivered is different from what I ordered.',
            imageUrls: ['https://example.com/issue-2.jpg'],
          ),
          throwsException,
        );
      } finally {
        await session.close();
      }
    });

    test('rejects undelivered and expired orders', () async {
      final undelivered = await _seedDeliveredOrder(
        sessionBuilder,
        status: 'out_for_delivery',
        deliveredAt: null,
      );
      final expired = await _seedDeliveredOrder(
        sessionBuilder,
        deliveredAt: DateTime.now().toUtc().subtract(const Duration(days: 2)),
      );
      final session = sessionBuilder.build();
      try {
        final service = PostgresComplaintService();
        expect(
          () => service.createComplaint(
            session,
            user: undelivered.user,
            orderNumber: undelivered.order.orderNumber,
            orderItemId: undelivered.item.id!.toString(),
            issueType: 'Damaged Product',
            description: 'The product was not delivered so this should fail.',
            imageUrls: ['https://example.com/issue.jpg'],
          ),
          throwsException,
        );
        expect(
          () => service.createComplaint(
            session,
            user: expired.user,
            orderNumber: expired.order.orderNumber,
            orderItemId: expired.item.id!.toString(),
            issueType: 'Damaged Product',
            description: 'The delivered product was damaged and should fail.',
            imageUrls: ['https://example.com/issue.jpg'],
          ),
          throwsException,
        );
      } finally {
        await session.close();
      }
    });

    test('rejects invalid complaint fields', () async {
      final seed = await _seedDeliveredOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final service = PostgresComplaintService();
        Future<void> submit({
          required String issueType,
          required String description,
          required List<String> images,
        }) async {
          await service.createComplaint(
            session,
            user: seed.user,
            orderNumber: seed.order.orderNumber,
            orderItemId: seed.item.id!.toString(),
            issueType: issueType,
            description: description,
            imageUrls: images,
          );
        }

        expect(
          () => submit(
            issueType: 'Approved',
            description:
                'The product has a clear issue in this delivered order.',
            images: ['https://example.com/issue.jpg'],
          ),
          throwsException,
        );
        expect(
          () => submit(
            issueType: 'Damaged Product',
            description: 'Too short.',
            images: ['https://example.com/issue.jpg'],
          ),
          throwsException,
        );
        expect(
          () => submit(
            issueType: 'Damaged Product',
            description:
                'The product has a clear issue in this delivered order.',
            images: const [],
          ),
          throwsException,
        );
        expect(
          () => submit(
            issueType: 'Damaged Product',
            description:
                'The product has a clear issue in this delivered order.',
            images: [
              'https://example.com/1.jpg',
              'https://example.com/2.jpg',
              'https://example.com/3.jpg',
              'https://example.com/4.jpg',
            ],
          ),
          throwsException,
        );
      } finally {
        await session.close();
      }
    });

    test('admin list, reply, and status update work', () async {
      final seed = await _seedDeliveredOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final service = PostgresComplaintService();
        final created = await service.createComplaint(
          session,
          user: seed.user,
          orderNumber: seed.order.orderNumber,
          orderItemId: seed.item.id!.toString(),
          issueType: 'Defective Product',
          description: 'The product does not switch on after delivery.',
          imageUrls: ['https://example.com/issue.jpg'],
        );

        final page = await service.listComplaints(session, status: 'Pending');
        expect(
          page.complaints.map((c) => c.complaintId),
          contains(created.complaintId),
        );

        final replied = await service.replyToComplaint(
          session,
          complaintId: created.complaintId,
          adminReply: 'We are reviewing this complaint.',
        );
        expect(replied.adminReply, equals('We are reviewing this complaint.'));

        final updated = await service.updateComplaintStatus(
          session,
          complaintId: created.complaintId,
          status: 'Under Review',
        );
        expect(updated.status, equals('Under Review'));
      } finally {
        await session.close();
      }
    });
  });
}

Future<_ComplaintSeed> _seedDeliveredOrder(
  TestSessionBuilder sessionBuilder, {
  String status = 'delivered',
  DateTime? deliveredAt,
}) async {
  final session = sessionBuilder.build();
  try {
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final now = DateTime.now().toUtc();
    final user = await protocol.AppUserRow.db.insertRow(
      session,
      protocol.AppUserRow(
        firebaseUid: 'complaint-user-$suffix',
        phoneNumber: '9999999999',
        role: 'customer',
        status: 'active',
      ),
    );
    final category = await protocol.CategoryRow.db.insertRow(
      session,
      protocol.CategoryRow(
        name: 'Complaint Category $suffix',
        slug: 'complaint-category-$suffix',
      ),
    );
    final product = await protocol.ProductRow.db.insertRow(
      session,
      protocol.ProductRow(
        categoryId: category.id!,
        name: 'Complaint Product $suffix',
        slug: 'complaint-product-$suffix',
        primaryImageUrl: 'https://example.com/product.jpg',
      ),
    );
    final order = await protocol.CustomerOrderRow.db.insertRow(
      session,
      protocol.CustomerOrderRow(
        userId: user.id!,
        orderNumber: 'CMP-$suffix',
        orderStatus: status,
        paymentStatus: 'paid',
        refundStatus: 'none',
        itemCount: 1,
        totalAmount: 100,
        discountAmount: 0,
        deliveryFee: 0,
        finalAmount: 100,
        placedAt: now,
        deliveredAt: deliveredAt ?? (status == 'delivered' ? now : null),
        orderedAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );
    final item = await protocol.OrderItemRow.db.insertRow(
      session,
      protocol.OrderItemRow(
        orderId: order.id!,
        productId: product.id!,
        productNameSnapshot: product.name,
        productImageUrlSnapshot: product.primaryImageUrl,
        quantity: 1,
        unitPrice: 100,
        totalPrice: 100,
        isFreeItem: false,
        createdAt: now,
      ),
    );
    return _ComplaintSeed(user: user, order: order, item: item);
  } finally {
    await session.close();
  }
}

class _ComplaintSeed {
  const _ComplaintSeed({
    required this.user,
    required this.order,
    required this.item,
  });

  final protocol.AppUserRow user;
  final protocol.CustomerOrderRow order;
  final protocol.OrderItemRow item;
}
