import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import '../services/coupon_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class CouponEndpoint extends Endpoint {
  final String _database =
      'projects/freshpickkart-a6824/databases/(default)/documents';

  /// Fetch coupons from Firestore
  Future<List<Coupon>> fetchCoupons(Session session) async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();

      final query = firestore_api.StructuredQuery(
        from: [firestore_api.CollectionSelector(collectionId: 'coupons')],
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        _database,
      );

      final List<Coupon> coupons = [];
      for (var res in response) {
        if (res.document == null) continue;
        final fields = res.document!.fields!;

        // Parse dates safely
        DateTime startDate = DateTime(2000);
        DateTime endDate = DateTime(2100);

        if (fields['startDate']?.timestampValue != null) {
          startDate =
              DateTime.tryParse(fields['startDate']!.timestampValue!) ??
              DateTime.now();
        } else if (fields['startDate']?.stringValue != null) {
          startDate =
              DateTime.tryParse(fields['startDate']!.stringValue!) ??
              DateTime.now();
        }

        if (fields['endDate']?.timestampValue != null) {
          endDate =
              DateTime.tryParse(fields['endDate']!.timestampValue!) ??
              DateTime.now();
        } else if (fields['endDate']?.stringValue != null) {
          endDate =
              DateTime.tryParse(fields['endDate']!.stringValue!) ??
              DateTime.now();
        }

        final coupon = Coupon(
          code: fields['code']?.stringValue ?? '',
          description: fields['description']?.stringValue ?? '',
          discountType: fields['discountType']?.stringValue,
          discountValue:
              fields['discountValue']?.doubleValue ??
              (fields['discountValue']?.integerValue != null
                  ? double.tryParse(fields['discountValue']!.integerValue!)
                  : null),
          minOrderAmount:
              double.tryParse(
                fields['minOrderAmount']?.doubleValue?.toString() ??
                    fields['minOrderAmount']?.integerValue ??
                    '0',
              ) ??
              0.0,
          maxDiscount:
              fields['maxDiscount']?.doubleValue ??
              (fields['maxDiscount']?.integerValue != null
                  ? double.tryParse(fields['maxDiscount']!.integerValue!)
                  : null),
          startDate: startDate,
          endDate: endDate,
          usageLimit: fields['usageLimit']?.integerValue != null
              ? int.tryParse(fields['usageLimit']!.integerValue!)
              : null,
          usedCount:
              int.tryParse(fields['usedCount']?.integerValue ?? '0') ?? 0,
          isActive: fields['isActive']?.booleanValue ?? true,
          couponCategory: fields['couponCategory']?.stringValue ?? 'All',
        );
        session.log(
          'Fetched coupon: ${coupon.code}, active: ${coupon.isActive}, dates: ${coupon.startDate} to ${coupon.endDate}',
        );
        coupons.add(coupon);
      }
      session.log('Total coupons fetched from Firestore: ${coupons.length}');
      return coupons;
    } catch (e) {
      session.log('Error fetching coupons: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Upload a new coupon to Firestore
  Future<bool> uploadCoupon(Session session, Coupon coupon) async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();

      final document = firestore_api.Document(
        fields: {
          'code': firestore_api.Value(stringValue: coupon.code),
          'description': firestore_api.Value(stringValue: coupon.description),
          'discountType': coupon.discountType != null
              ? firestore_api.Value(stringValue: coupon.discountType)
              : firestore_api.Value(nullValue: 'NULL_VALUE'),
          'discountValue': coupon.discountValue != null
              ? firestore_api.Value(doubleValue: coupon.discountValue)
              : firestore_api.Value(nullValue: 'NULL_VALUE'),
          'minOrderAmount': firestore_api.Value(
            doubleValue: coupon.minOrderAmount,
          ),
          'maxDiscount': coupon.maxDiscount != null
              ? firestore_api.Value(doubleValue: coupon.maxDiscount)
              : firestore_api.Value(nullValue: 'NULL_VALUE'),
          'startDate': firestore_api.Value(
            timestampValue: coupon.startDate.toUtc().toIso8601String(),
          ),
          'endDate': firestore_api.Value(
            timestampValue: coupon.endDate.toUtc().toIso8601String(),
          ),
          'usageLimit': coupon.usageLimit != null
              ? firestore_api.Value(integerValue: coupon.usageLimit.toString())
              : firestore_api.Value(nullValue: 'NULL_VALUE'),
          'usedCount': firestore_api.Value(
            integerValue: coupon.usedCount.toString(),
          ),
          'isActive': firestore_api.Value(booleanValue: coupon.isActive),
          'couponCategory': firestore_api.Value(
            stringValue: coupon.couponCategory,
          ),
        },
      );

      await firestore.projects.databases.documents.createDocument(
        document,
        _database,
        'coupons',
      );
      return true;
    } catch (e) {
      session.log('Error uploading coupon: $e', level: LogLevel.error);
      return false;
    }
  }

  /// Fetch coupons filtered by order amount - only returns applicable coupons
  /// This only returns necessary fields for UI (not usageLimit, usedCount, dates, etc.)
  Future<List<CouponDisplay>> fetchApplicableCoupons(
    Session session,
    double orderAmount,
  ) async {
    try {
      final allCoupons = await fetchCoupons(session);
      return CouponService.getApplicableCoupons(
        coupons: allCoupons,
        orderAmount: orderAmount,
      );
    } catch (e) {
      session.log(
        'Error fetching applicable coupons: $e',
        level: LogLevel.error,
      );
      return [];
    }
  }

  /// Validate a coupon and calculate discount based on order amount
  Future<CouponValidationResult> validateCoupon(
    Session session,
    String couponCode,
    double orderAmount,
  ) async {
    try {
      final allCoupons = await fetchCoupons(session);

      final coupon = allCoupons.firstWhere(
        (c) => c.code.toUpperCase() == couponCode.toUpperCase(),
        orElse: () => Coupon(
          code: '',
          description: '',
          minOrderAmount: 0,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          usedCount: 0,
          isActive: false,
          couponCategory: '',
        ),
      );

      if (coupon.code.isEmpty) {
        return CouponValidationResult(
          isValid: false,
          errorMessage: 'Invalid coupon code',
          discountAmount: 0.0,
          isDeliveryDiscount: false,
        );
      }

      return CouponService.validateCoupon(
        coupon: coupon,
        orderAmount: orderAmount,
      );
    } catch (e) {
      session.log('Error validating coupon: $e', level: LogLevel.error);
      return CouponValidationResult(
        isValid: false,
        errorMessage: 'Error validating coupon',
        discountAmount: 0.0,
        isDeliveryDiscount: false,
      );
    }
  }
}
