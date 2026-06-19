import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_user_guard_service.dart';

class PaymentStreamEndpoint extends Endpoint {
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();

  static String paymentChannel(String orderId) => 'payment_$orderId';

  Stream<PaymentEvent> watchPaymentStatus(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async* {
    await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final channelName = paymentChannel(orderId);
    final controller = StreamController<PaymentEvent>();
    late final void Function(dynamic) listener;
    listener = (event) {
      if (!controller.isClosed && event is PaymentEvent) {
        controller.add(event);
      }
    };
    session.messages.addListener(channelName, listener);
    try {
      yield* controller.stream;
    } finally {
      session.messages.removeListener(channelName, listener);
      if (!controller.isClosed) {
        await controller.close();
      }
    }
  }
}
