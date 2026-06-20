import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freshpickkat_admin/controller/admin_complaint_controller.dart';
import 'package:freshpickkat_admin/screens/address_change_requests_screen.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'address change request screen shows request details and actions',
    (tester) async {
      final controller = _FakeAdminComplaintController(
        complaints: [
          _addressChangeComplaint(
            complaintId: 'c-1',
            orderNumber: 'ORD-9001',
            oldAddress: Address(
              street: '1 Old Street',
              city: 'Old City',
              state: 'Old State',
              zipCode: '123123',
              country: 'India',
              latitude: 28.55,
              longitude: 77.11,
            ),
            newAddress: Address(
              street: '99 New Street',
              city: 'New City',
              state: 'New State',
              zipCode: '321321',
              country: 'India',
              latitude: 28.57,
              longitude: 77.19,
            ),
          ),
        ],
      );
      Get.put<AdminComplaintController>(
        controller,
        tag: 'address_change_requests',
      );

      await _pumpApp(tester, const AddressChangeRequestsScreen());

      expect(find.text('Order #ORD-9001'), findsOneWidget);
      expect(find.text('Old address'), findsOneWidget);
      expect(find.text('New address'), findsOneWidget);
      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);
      expect(find.text('Call Customer'), findsOneWidget);
    },
  );
}

Future<void> _pumpApp(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, _) => GetMaterialApp(home: child),
    ),
  );
  await tester.pumpAndSettle();
}

class _FakeAdminComplaintController extends AdminComplaintController {
  _FakeAdminComplaintController({required List<Complaint> complaints}) {
    this.complaints.assignAll(complaints);
    isLoading.value = false;
    isLoadingMore.value = false;
    hasMore.value = false;
    error.value = null;
    totalCount.value = complaints.length;
  }

  @override
  Future<void> load({
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
  }) async {}

  @override
  Future<void> loadMore() async {}
}

Complaint _addressChangeComplaint({
  required String complaintId,
  required String orderNumber,
  required Address oldAddress,
  required Address newAddress,
}) {
  return Complaint(
    complaintId: complaintId,
    userId: 'user-1',
    orderId: 'order-1',
    orderNumber: orderNumber,
    complaintType: 'delivery',
    title: 'Delivery Location Issue',
    selectedProducts: const [],
    issueType: 'Delivery Location Issue',
    selectedField: 'address_change',
    extraData: {
      'currentAddressJson': jsonEncode(oldAddress.toJson()),
      'requestedAddressJson': jsonEncode(newAddress.toJson()),
      'requestedNote': 'Please call on arrival.',
    },
    userPhone: '9999999999',
    description: 'Please move the delivery to the new address.',
    imageUrls: const [],
    orderItems: const <ComplaintProductItem>[],
    status: 'Pending',
    adminReply: null,
    adminNote: null,
    resolutionType: null,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}
