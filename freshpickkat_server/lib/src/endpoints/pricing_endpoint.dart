import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/pricing_engine.dart';
import '../services/firebase_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class PricingEndpoint extends Endpoint {
  static const String _projectId = 'freshpickkart-a6824';
  static const double _baseDeliveryFee = 40.0;

  Future<CartPricingResult> calculateCartPricing({
    required Session session,
    required List<CartItemInput> items,
    String? appliedCouponCode,
    bool autoApplyCoupons = true,
  }) async {
    final cartItems = items
        .map(
          (item) => CartItemInput(
            productId: item.productId,
            variantId: item.variantId,
            quantity: item.quantity,
          ),
        )
        .toList();

    return await PricingEngine.calculateCartPricing(
      session: session,
      items: cartItems,
      appliedCouponCode: appliedCouponCode,
      autoApplyCoupons: autoApplyCoupons,
    );
  }

  Future<List<AppliedOfferInfo>> getApplicableOffers({
    required Session session,
    required List<CartItemInput> items,
  }) async {
    final result = await calculateCartPricing(
      session: session,
      items: items,
      appliedCouponCode: null,
      autoApplyCoupons: false,
    );
    return result.appliedOffers;
  }

  Future<double> calculateDeliveryFee({
    required Session session,
    required double orderAmount,
    required int itemCount,
    String? couponCode,
    String? userId,
  }) async {
    final rules = await _getActiveFreeDeliveryRules();

    for (final rule in rules) {
      bool qualifies = false;
      final ruleType = rule['ruleType'] as String? ?? 'min_order_amount';
      final minOrderAmount = rule['minOrderAmount'] as double?;
      final minItemsCount = rule['minItemsCount'] as int?;
      final ruleCouponCode = rule['couponCode'] as String?;
      final ruleUserId = rule['userId'] as String?;
      final deliveryFeeWaived =
          rule['deliveryFeeWaived'] as double? ?? _baseDeliveryFee;

      if (ruleType == 'min_order_amount' &&
          minOrderAmount != null &&
          orderAmount >= minOrderAmount) {
        qualifies = true;
      } else if (ruleType == 'min_items' &&
          minItemsCount != null &&
          itemCount >= minItemsCount) {
        qualifies = true;
      } else if (ruleType == 'coupon' &&
          ruleCouponCode != null &&
          couponCode?.toUpperCase() == ruleCouponCode.toUpperCase()) {
        qualifies = true;
      } else if (ruleType == 'user_specific' &&
          ruleUserId != null &&
          ruleUserId == userId) {
        qualifies = true;
      }

      if (qualifies) {
        return _baseDeliveryFee - deliveryFeeWaived;
      }
    }

    return _baseDeliveryFee;
  }

  Future<List<Map<String, dynamic>>> _getActiveFreeDeliveryRules() async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      final database = 'projects/$_projectId/databases/(default)/documents';

      final query = firestore_api.StructuredQuery(
        from: [
          firestore_api.CollectionSelector(collectionId: 'free_delivery_rules'),
        ],
        where: firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'isActive'),
            op: 'EQUAL',
            value: firestore_api.Value(booleanValue: true),
          ),
        ),
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      final rules = <Map<String, dynamic>>[];
      final now = DateTime.now();

      for (final res in response) {
        if (res.document?.fields == null) continue;
        final fields = res.document!.fields!;
        final startDate =
            DateTime.tryParse(fields['startDate']?.timestampValue ?? '') ??
            DateTime.now();
        final endDate =
            DateTime.tryParse(fields['endDate']?.timestampValue ?? '') ??
            DateTime.now().add(const Duration(days: 30));

        if (startDate.isAfter(now) || endDate.isBefore(now)) continue;

        rules.add({
          'ruleType': fields['ruleType']?.stringValue ?? 'min_order_amount',
          'minOrderAmount': fields['minOrderAmount']?.doubleValue,
          'minItemsCount': fields['minItemsCount']?.integerValue != null
              ? int.tryParse(fields['minItemsCount']!.integerValue!)
              : null,
          'couponCode': fields['couponCode']?.stringValue,
          'userId': fields['userId']?.stringValue,
          'deliveryFeeWaived':
              double.tryParse(
                fields['deliveryFeeWaived']?.doubleValue?.toString() ??
                    fields['deliveryFeeWaived']?.integerValue?.toString() ??
                    '40',
              ) ??
              _baseDeliveryFee,
        });
      }

      return rules;
    } catch (_) {
      return [];
    }
  }
}
