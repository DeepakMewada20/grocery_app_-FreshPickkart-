import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/network_controller.dart';
import '../services/api_client.dart';
import '../core/exceptions.dart';
import '../widgets/network_error_widget.dart';

// Example Controller
class ExampleProductController extends GetxController {
  final NetworkController networkController = Get.put(NetworkController());
  
  final RxBool isLoading = false.obs;
  final RxList<String> products = <String>[].obs; // Mock product data

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    networkController.hideError();

    try {
      // Use ApiClient to wrap the Serverpod call
      final result = await ApiClient().request(() async {
        // Example Serverpod client call usage:
        // return await ServerpodAdminClient().client.product.getProductsPage(...);
        await Future.delayed(const Duration(seconds: 2)); // Mock network delay
        return ['Product 1', 'Product 2', 'Product 3']; // Mock response
      });

      products.value = result;
    } on NoInternetException {
      networkController.showError(onRetry: fetchProducts);
    } on NetworkException {
      networkController.showError(onRetry: fetchProducts);
    } on RequestTimeoutException {
      networkController.showError(onRetry: fetchProducts);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

// Example Screen
class ExampleUsageScreen extends StatelessWidget {
  const ExampleUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final controller = Get.put(ExampleProductController());

    return Scaffold(
      appBar: AppBar(title: const Text('Network Example')),
      body: Obx(() {
        // 1. If network error -> show retry UI
        if (controller.networkController.hasError.value) {
          return NetworkErrorWidget(
            onRetry: () {
              // Retry triggered manually or auto-trigger from NetworkController
              controller.networkController.retryLastRequest();
            },
          );
        }

        // 2. Else if loading -> show spinner
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 3. Else -> show data
        if (controller.products.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(controller.products[index]),
            );
          },
        );
      }),
    );
  }
}
