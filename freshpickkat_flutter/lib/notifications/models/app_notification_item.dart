import 'package:freshpickkat_client/freshpickkat_client.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final Product? product;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.product,
  });
}
