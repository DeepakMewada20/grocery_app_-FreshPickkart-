import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/delivery_issue_controller.dart';
import 'package:freshpickkat_flutter/screens/report_delivery_issue_screen.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('shows direct update branch before out for delivery', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      ReportDeliveryIssueScreen(
        orderNumber: 'ORD-1001',
        orderStatus: 'packed',
        currentAddress: Address(
          street: '12 Old Street',
          city: 'Old City',
          state: 'Old State',
          zipCode: '111111',
          country: 'India',
        ),
      ),
    );

    // Open the dropdown, then select 'Delivery Location Issue'
    await tester.tap(find.text('Late Delivery'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(DeliveryIssueController.deliveryLocationIssue).last,
    );
    await tester.pumpAndSettle();

    expect(find.text('Update the delivery details directly'), findsOneWidget);
    expect(find.text('Update Address'), findsOneWidget);
    expect(find.text('Current address'), findsOneWidget);
    expect(find.textContaining('12 Old Street'), findsOneWidget);
  });

  testWidgets('shows approval branch while out for delivery', (tester) async {
    await _pumpApp(
      tester,
      ReportDeliveryIssueScreen(
        orderNumber: 'ORD-1002',
        orderStatus: 'out_for_delivery',
        currentAddress: Address(
          street: '77 Current Road',
          city: 'Current City',
          state: 'Current State',
          zipCode: '222222',
          country: 'India',
        ),
      ),
    );

    // Open the dropdown, then select 'Delivery Location Issue'
    await tester.tap(find.text('Late Delivery'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.text(DeliveryIssueController.deliveryLocationIssue).last,
    );
    await tester.pumpAndSettle();

    expect(find.text('Request approval for delivery changes'), findsOneWidget);
    expect(find.text('Change address'), findsWidgets);
    expect(find.text('Delivery note'), findsOneWidget);
    expect(find.text('Request Approval'), findsOneWidget);
    expect(find.textContaining('77 Current Road'), findsOneWidget);
  });
}

Future<void> _pumpApp(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, _) => GetMaterialApp(home: child),
    ),
  );
  await tester.pumpAndSettle();
}
