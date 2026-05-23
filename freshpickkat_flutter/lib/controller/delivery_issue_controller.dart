import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/services/order_service.dart';
import 'package:freshpickkat_flutter/services/product_complaint_service.dart';
import 'package:freshpickkat_flutter/screens/location_picker_screen.dart';
import 'package:get/get.dart';

class DeliveryIssueController extends GetxController {
  static const deliveryLocationIssue = 'Delivery Location Issue';
  static const addressChangeField = 'address_change';
  static const deliveryNoteField = 'delivery_note';

  static const issueTypes = [
    'Late Delivery',
    'Rider Not Reachable',
    deliveryLocationIssue,
    'Order Taking Too Long',
    'Rider Could Not Find Address',
    'Other',
  ];

  final selectedIssueType = issueTypes.first.obs;
  final selectedField = addressChangeField.obs;
  final selectedAddress = Rxn<Address>();
  final isSubmitting = false.obs;
  final submittedComplaint = Rxn<Complaint>();

  final String orderNumber;
  final String orderStatus;
  final Address currentAddress;

  DeliveryIssueController({
    required this.orderNumber,
    required this.orderStatus,
    required this.currentAddress,
  }) {
    selectedAddress.value = currentAddress;
  }

  bool get isOutForDelivery => orderStatus == 'out_for_delivery';
  bool get isDeliveryLocationIssue =>
      selectedIssueType.value == deliveryLocationIssue;
  bool get isAddressChange => selectedField.value == addressChangeField;

  void selectIssueType(String value) {
    selectedIssueType.value = value;
    if (value != deliveryLocationIssue) {
      selectedField.value = addressChangeField;
    }
  }

  void selectField(String value) {
    selectedField.value = value;
  }

  Future<void> pickAddress() async {
    final result = await Get.to<Address>(
      () => LocationPickerScreen(
        isCheckoutMode: false,
        initialAddress: selectedAddress.value ?? currentAddress,
      ),
    );
    if (result != null) {
      selectedAddress.value = result;
    }
  }

  Future<Object?> submit(String description, String note) async {
    if (isSubmitting.value) {
      throw Exception('Submission already in progress.');
    }

    final cleanDescription = description.trim();
    if (cleanDescription.length < 20) {
      throw Exception('Description must be at least 20 characters.');
    }
    if (cleanDescription.length > 2000) {
      throw Exception('Description must be 2000 characters or less.');
    }

    isSubmitting.value = true;
    try {
      if (isDeliveryLocationIssue && !isOutForDelivery) {
        if (isAddressChange) {
          final address = selectedAddress.value;
          if (address == null) {
            throw Exception('Please select a delivery address.');
          }
          final updated = await OrderService.instance.updateDeliveryAddress(
            orderId: orderNumber,
            deliveryAddress: address,
            deliveryNote: note.trim().isEmpty ? null : note.trim(),
          );
          return updated != null;
        }

        final updated = await OrderService.instance.updateDeliveryAddress(
          orderId: orderNumber,
          deliveryAddress: currentAddress,
          deliveryNote: note.trim().isEmpty ? null : note.trim(),
        );
        return updated != null;
      }

      final complaint = await ProductComplaintService.instance
          .createDeliveryComplaint(
            orderNumber: orderNumber,
            issueType: selectedIssueType.value,
            title: selectedIssueType.value,
            description: cleanDescription,
            selectedField: isDeliveryLocationIssue ? selectedField.value : null,
            requestedAddress:
                isDeliveryLocationIssue && isAddressChange
                    ? selectedAddress.value
                    : null,
            requestedNote:
                isDeliveryLocationIssue && !isAddressChange
                    ? note.trim().isEmpty
                        ? null
                        : note.trim()
                    : null,
          );
      submittedComplaint.value = complaint;
      return complaint;
    } finally {
      isSubmitting.value = false;
    }
  }

  String currentAddressLabel() {
    final address = selectedAddress.value ?? currentAddress;
    return [
      address.street,
      address.city,
      address.state,
      address.zipCode,
      address.country,
    ].where((part) => part.trim().isNotEmpty).join(', ');
  }

  String currentAddressSummary() {
    final address = selectedAddress.value ?? currentAddress;
    return '${address.street}, ${address.city}, ${address.state} - ${address.zipCode}';
  }
}
