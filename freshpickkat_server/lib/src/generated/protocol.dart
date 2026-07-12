/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'data_flow/active_user_statistics.dart' as _i5;
import 'data_flow/address.dart' as _i6;
import 'data_flow/admin_analytics.dart' as _i7;
import 'data_flow/admin_audit_log_entry.dart' as _i8;
import 'data_flow/admin_auth_result.dart' as _i9;
import 'data_flow/admin_dashboard_hydrated.dart' as _i10;
import 'data_flow/admin_dashboard_stats.dart' as _i11;
import 'data_flow/admin_notification_preference.dart' as _i12;
import 'data_flow/admin_top_product.dart' as _i13;
import 'data_flow/api_response.dart' as _i14;
import 'data_flow/app_user.dart' as _i15;
import 'data_flow/applied_coupon_info.dart' as _i16;
import 'data_flow/applied_offer_info.dart' as _i17;
import 'data_flow/banner.dart' as _i18;
import 'data_flow/banner_page.dart' as _i19;
import 'data_flow/basket_suggestion.dart' as _i20;
import 'data_flow/basket_suggestion_action.dart' as _i21;
import 'data_flow/basket_suggestion_result.dart' as _i22;
import 'data_flow/best_coupon_result.dart' as _i23;
import 'data_flow/bogo_free_product.dart' as _i24;
import 'data_flow/bogo_offer.dart' as _i25;
import 'data_flow/bogo_offer_page.dart' as _i26;
import 'data_flow/broadcast_page.dart' as _i27;
import 'data_flow/broadcast_request.dart' as _i28;
import 'data_flow/broadcast_summary.dart' as _i29;
import 'data_flow/cart_comparison_data.dart' as _i30;
import 'data_flow/cart_hydrated_data.dart' as _i31;
import 'data_flow/cart_item.dart' as _i32;
import 'data_flow/cart_item_input.dart' as _i33;
import 'data_flow/cart_item_snapshot.dart' as _i34;
import 'data_flow/cart_pricing_result.dart' as _i35;
import 'data_flow/cascade_entity_info.dart' as _i36;
import 'data_flow/cascade_execute_response.dart' as _i37;
import 'data_flow/cascade_impact_response.dart' as _i38;
import 'data_flow/category.dart' as _i39;
import 'data_flow/category_hierarchy.dart' as _i40;
import 'data_flow/category_offer.dart' as _i41;
import 'data_flow/category_offer_page.dart' as _i42;
import 'data_flow/checkout_init_hydrated.dart' as _i43;
import 'data_flow/checkout_result.dart' as _i44;
import 'data_flow/cod_payment_receipt.dart' as _i45;
import 'data_flow/combo_offer.dart' as _i46;
import 'data_flow/combo_offer_page.dart' as _i47;
import 'data_flow/combo_product_item.dart' as _i48;
import 'data_flow/complaint.dart' as _i49;
import 'data_flow/complaint_detail_hydrated.dart' as _i50;
import 'data_flow/complaint_page.dart' as _i51;
import 'data_flow/complaint_product_item.dart' as _i52;
import 'data_flow/coupon.dart' as _i53;
import 'data_flow/coupon_display.dart' as _i54;
import 'data_flow/coupon_validation_result.dart' as _i55;
import 'data_flow/delete_impact_reference.dart' as _i56;
import 'data_flow/delete_impact_response.dart' as _i57;
import 'data_flow/delivery_config.dart' as _i58;
import 'data_flow/delivery_pricing_result.dart' as _i59;
import 'data_flow/delivery_rule.dart' as _i60;
import 'data_flow/delivery_rule_page.dart' as _i61;
import 'data_flow/delivery_settings.dart' as _i62;
import 'data_flow/delivery_slab.dart' as _i63;
import 'data_flow/free_delivery_hydrated.dart' as _i64;
import 'data_flow/free_delivery_rule.dart' as _i65;
import 'data_flow/free_delivery_rule_page.dart' as _i66;
import 'data_flow/free_item_info.dart' as _i67;
import 'data_flow/fresh_points_adjust_request.dart' as _i68;
import 'data_flow/fresh_points_balance.dart' as _i69;
import 'data_flow/fresh_points_settings.dart' as _i70;
import 'data_flow/fresh_points_transaction.dart' as _i71;
import 'data_flow/hard_delete_response.dart' as _i72;
import 'data_flow/home_page_hydrated_data.dart' as _i73;
import 'data_flow/notification_draft.dart' as _i74;
import 'data_flow/notification_history_item.dart' as _i75;
import 'data_flow/notification_history_page.dart' as _i76;
import 'data_flow/notification_preference.dart' as _i77;
import 'data_flow/offer_conflict_response.dart' as _i78;
import 'data_flow/offer_mutation_result.dart' as _i79;
import 'data_flow/offer_search_item.dart' as _i80;
import 'data_flow/offer_search_page.dart' as _i81;
import 'data_flow/order.dart' as _i82;
import 'data_flow/order_detail_hydrated.dart' as _i83;
import 'data_flow/order_item.dart' as _i84;
import 'data_flow/order_page.dart' as _i85;
import 'data_flow/order_realtime_event.dart' as _i86;
import 'data_flow/order_tracking_data.dart' as _i87;
import 'data_flow/payment_action_result.dart' as _i88;
import 'data_flow/payment_event.dart' as _i89;
import 'data_flow/payment_link_data.dart' as _i90;
import 'data_flow/payment_order_detail_hydrated.dart' as _i91;
import 'data_flow/payment_order_result.dart' as _i92;
import 'data_flow/payment_page_data.dart' as _i93;
import 'data_flow/payment_page_item.dart' as _i94;
import 'data_flow/payment_session_data.dart' as _i95;
import 'data_flow/payment_transaction.dart' as _i96;
import 'data_flow/payment_verify_result.dart' as _i97;
import 'data_flow/pending_order_info.dart' as _i98;
import 'data_flow/pricing_line_item.dart' as _i99;
import 'data_flow/product.dart' as _i100;
import 'data_flow/product_form_reference_data.dart' as _i101;
import 'data_flow/product_page.dart' as _i102;
import 'data_flow/product_ranking_item.dart' as _i103;
import 'data_flow/product_variant.dart' as _i104;
import 'data_flow/razorpay_payment_status.dart' as _i105;
import 'data_flow/razorpay_refund_data.dart' as _i106;
import 'data_flow/referral.dart' as _i107;
import 'data_flow/referral_activity.dart' as _i108;
import 'data_flow/referral_admin_stats.dart' as _i109;
import 'data_flow/referral_code_info.dart' as _i110;
import 'data_flow/referral_fraud_result.dart' as _i111;
import 'data_flow/referral_fraud_rule_result.dart' as _i112;
import 'data_flow/referral_onboarding_status.dart' as _i113;
import 'data_flow/referral_settings.dart' as _i114;
import 'data_flow/referral_validation_result.dart' as _i115;
import 'data_flow/refund_record.dart' as _i116;
import 'data_flow/register_fcm_token_request.dart' as _i117;
import 'data_flow/shop_more_get_more_offer.dart' as _i118;
import 'data_flow/shop_more_get_more_offer_page.dart' as _i119;
import 'data_flow/smgm_analytics.dart' as _i120;
import 'data_flow/sub_category.dart' as _i121;
import 'data_flow/support_issue.dart' as _i122;
import 'data_flow/top_referrer_entry.dart' as _i123;
import 'db_rows/admin_audit_log_row.dart' as _i124;
import 'db_rows/admin_notification_preference_row.dart' as _i125;
import 'db_rows/app_user_row.dart' as _i126;
import 'db_rows/auto_refund_job_row.dart' as _i127;
import 'db_rows/banner_row.dart' as _i128;
import 'db_rows/bogo_offer_reward_row.dart' as _i129;
import 'db_rows/bogo_offer_row.dart' as _i130;
import 'db_rows/category_offer_row.dart' as _i131;
import 'db_rows/category_row.dart' as _i132;
import 'db_rows/cod_failure_record.dart' as _i133;
import 'db_rows/cod_settings_row.dart' as _i134;
import 'db_rows/combo_offer_item_row.dart' as _i135;
import 'db_rows/combo_offer_row.dart' as _i136;
import 'db_rows/complaint_row.dart' as _i137;
import 'db_rows/coupon_row.dart' as _i138;
import 'db_rows/customer_order_row.dart' as _i139;
import 'db_rows/delivery_config_row.dart' as _i140;
import 'db_rows/delivery_otp_row.dart' as _i141;
import 'db_rows/delivery_rule_row.dart' as _i142;
import 'db_rows/delivery_settings_row.dart' as _i143;
import 'db_rows/delivery_slab_row.dart' as _i144;
import 'db_rows/free_delivery_rule_row.dart' as _i145;
import 'db_rows/fresh_points_settings_row.dart' as _i146;
import 'db_rows/fresh_points_transaction_row.dart' as _i147;
import 'db_rows/idempotency_record_row.dart' as _i148;
import 'db_rows/notification_campaign_row.dart' as _i149;
import 'db_rows/notification_outbox_row.dart' as _i150;
import 'db_rows/notification_preference_row.dart' as _i151;
import 'db_rows/notification_user_state_row.dart' as _i152;
import 'db_rows/order_address_row.dart' as _i153;
import 'db_rows/order_item_row.dart' as _i154;
import 'db_rows/order_notification_outbox_row.dart' as _i155;
import 'db_rows/order_tracking_row.dart' as _i156;
import 'db_rows/payment_link_row.dart' as _i157;
import 'db_rows/payment_session_row.dart' as _i158;
import 'db_rows/payment_transaction_row.dart' as _i159;
import 'db_rows/product_row.dart' as _i160;
import 'db_rows/product_search_document_row.dart' as _i161;
import 'db_rows/product_search_rebuild_job_row.dart' as _i162;
import 'db_rows/product_variant_row.dart' as _i163;
import 'db_rows/referral_row.dart' as _i164;
import 'db_rows/referral_settings_row.dart' as _i165;
import 'db_rows/refund_record_row.dart' as _i166;
import 'db_rows/shop_more_get_more_offer_row.dart' as _i167;
import 'db_rows/sub_category_row.dart' as _i168;
import 'db_rows/support_issue_row.dart' as _i169;
import 'db_rows/user_address_row.dart' as _i170;
import 'db_rows/user_cart_item_row.dart' as _i171;
import 'db_rows/user_fcm_token_row.dart' as _i172;
import 'package:freshpickkat_server/src/generated/data_flow/app_user.dart'
    as _i173;
import 'package:freshpickkat_server/src/generated/data_flow/admin_audit_log_entry.dart'
    as _i174;
import 'package:freshpickkat_server/src/generated/data_flow/active_user_statistics.dart'
    as _i175;
import 'package:freshpickkat_server/src/generated/data_flow/banner.dart'
    as _i176;
import 'package:freshpickkat_server/src/generated/data_flow/bogo_offer.dart'
    as _i177;
import 'package:freshpickkat_server/src/generated/data_flow/cart_item_input.dart'
    as _i178;
import 'package:freshpickkat_server/src/generated/data_flow/category.dart'
    as _i179;
import 'package:freshpickkat_server/src/generated/data_flow/category_offer.dart'
    as _i180;
import 'package:freshpickkat_server/src/generated/data_flow/combo_offer.dart'
    as _i181;
import 'package:freshpickkat_server/src/generated/data_flow/coupon.dart'
    as _i182;
import 'package:freshpickkat_server/src/generated/data_flow/coupon_display.dart'
    as _i183;
import 'package:freshpickkat_server/src/generated/data_flow/delivery_rule.dart'
    as _i184;
import 'package:freshpickkat_server/src/generated/data_flow/admin_notification_preference.dart'
    as _i185;
import 'package:freshpickkat_server/src/generated/data_flow/order.dart'
    as _i186;
import 'package:freshpickkat_server/src/generated/data_flow/applied_offer_info.dart'
    as _i187;
import 'package:freshpickkat_server/src/generated/data_flow/product.dart'
    as _i188;
import 'package:freshpickkat_server/src/generated/data_flow/product_ranking_item.dart'
    as _i189;
import 'package:freshpickkat_server/src/generated/data_flow/referral_activity.dart'
    as _i190;
import 'package:freshpickkat_server/src/generated/data_flow/shop_more_get_more_offer.dart'
    as _i191;
import 'package:freshpickkat_server/src/generated/data_flow/sub_category.dart'
    as _i192;
import 'package:freshpickkat_server/src/generated/data_flow/support_issue.dart'
    as _i193;
import 'package:freshpickkat_server/src/generated/data_flow/cart_item.dart'
    as _i194;
export 'data_flow/active_user_statistics.dart';
export 'data_flow/address.dart';
export 'data_flow/admin_analytics.dart';
export 'data_flow/admin_audit_log_entry.dart';
export 'data_flow/admin_auth_result.dart';
export 'data_flow/admin_dashboard_hydrated.dart';
export 'data_flow/admin_dashboard_stats.dart';
export 'data_flow/admin_notification_preference.dart';
export 'data_flow/admin_top_product.dart';
export 'data_flow/api_response.dart';
export 'data_flow/app_user.dart';
export 'data_flow/applied_coupon_info.dart';
export 'data_flow/applied_offer_info.dart';
export 'data_flow/banner.dart';
export 'data_flow/banner_page.dart';
export 'data_flow/basket_suggestion.dart';
export 'data_flow/basket_suggestion_action.dart';
export 'data_flow/basket_suggestion_result.dart';
export 'data_flow/best_coupon_result.dart';
export 'data_flow/bogo_free_product.dart';
export 'data_flow/bogo_offer.dart';
export 'data_flow/bogo_offer_page.dart';
export 'data_flow/broadcast_page.dart';
export 'data_flow/broadcast_request.dart';
export 'data_flow/broadcast_summary.dart';
export 'data_flow/cart_comparison_data.dart';
export 'data_flow/cart_hydrated_data.dart';
export 'data_flow/cart_item.dart';
export 'data_flow/cart_item_input.dart';
export 'data_flow/cart_item_snapshot.dart';
export 'data_flow/cart_pricing_result.dart';
export 'data_flow/cascade_entity_info.dart';
export 'data_flow/cascade_execute_response.dart';
export 'data_flow/cascade_impact_response.dart';
export 'data_flow/category.dart';
export 'data_flow/category_hierarchy.dart';
export 'data_flow/category_offer.dart';
export 'data_flow/category_offer_page.dart';
export 'data_flow/checkout_init_hydrated.dart';
export 'data_flow/checkout_result.dart';
export 'data_flow/cod_payment_receipt.dart';
export 'data_flow/combo_offer.dart';
export 'data_flow/combo_offer_page.dart';
export 'data_flow/combo_product_item.dart';
export 'data_flow/complaint.dart';
export 'data_flow/complaint_detail_hydrated.dart';
export 'data_flow/complaint_page.dart';
export 'data_flow/complaint_product_item.dart';
export 'data_flow/coupon.dart';
export 'data_flow/coupon_display.dart';
export 'data_flow/coupon_validation_result.dart';
export 'data_flow/delete_impact_reference.dart';
export 'data_flow/delete_impact_response.dart';
export 'data_flow/delivery_config.dart';
export 'data_flow/delivery_pricing_result.dart';
export 'data_flow/delivery_rule.dart';
export 'data_flow/delivery_rule_page.dart';
export 'data_flow/delivery_settings.dart';
export 'data_flow/delivery_slab.dart';
export 'data_flow/free_delivery_hydrated.dart';
export 'data_flow/free_delivery_rule.dart';
export 'data_flow/free_delivery_rule_page.dart';
export 'data_flow/free_item_info.dart';
export 'data_flow/fresh_points_adjust_request.dart';
export 'data_flow/fresh_points_balance.dart';
export 'data_flow/fresh_points_settings.dart';
export 'data_flow/fresh_points_transaction.dart';
export 'data_flow/hard_delete_response.dart';
export 'data_flow/home_page_hydrated_data.dart';
export 'data_flow/notification_draft.dart';
export 'data_flow/notification_history_item.dart';
export 'data_flow/notification_history_page.dart';
export 'data_flow/notification_preference.dart';
export 'data_flow/offer_conflict_response.dart';
export 'data_flow/offer_mutation_result.dart';
export 'data_flow/offer_search_item.dart';
export 'data_flow/offer_search_page.dart';
export 'data_flow/order.dart';
export 'data_flow/order_detail_hydrated.dart';
export 'data_flow/order_item.dart';
export 'data_flow/order_page.dart';
export 'data_flow/order_realtime_event.dart';
export 'data_flow/order_tracking_data.dart';
export 'data_flow/payment_action_result.dart';
export 'data_flow/payment_event.dart';
export 'data_flow/payment_link_data.dart';
export 'data_flow/payment_order_detail_hydrated.dart';
export 'data_flow/payment_order_result.dart';
export 'data_flow/payment_page_data.dart';
export 'data_flow/payment_page_item.dart';
export 'data_flow/payment_session_data.dart';
export 'data_flow/payment_transaction.dart';
export 'data_flow/payment_verify_result.dart';
export 'data_flow/pending_order_info.dart';
export 'data_flow/pricing_line_item.dart';
export 'data_flow/product.dart';
export 'data_flow/product_form_reference_data.dart';
export 'data_flow/product_page.dart';
export 'data_flow/product_ranking_item.dart';
export 'data_flow/product_variant.dart';
export 'data_flow/razorpay_payment_status.dart';
export 'data_flow/razorpay_refund_data.dart';
export 'data_flow/referral.dart';
export 'data_flow/referral_activity.dart';
export 'data_flow/referral_admin_stats.dart';
export 'data_flow/referral_code_info.dart';
export 'data_flow/referral_fraud_result.dart';
export 'data_flow/referral_fraud_rule_result.dart';
export 'data_flow/referral_onboarding_status.dart';
export 'data_flow/referral_settings.dart';
export 'data_flow/referral_validation_result.dart';
export 'data_flow/refund_record.dart';
export 'data_flow/register_fcm_token_request.dart';
export 'data_flow/shop_more_get_more_offer.dart';
export 'data_flow/shop_more_get_more_offer_page.dart';
export 'data_flow/smgm_analytics.dart';
export 'data_flow/sub_category.dart';
export 'data_flow/support_issue.dart';
export 'data_flow/top_referrer_entry.dart';
export 'db_rows/admin_audit_log_row.dart';
export 'db_rows/admin_notification_preference_row.dart';
export 'db_rows/app_user_row.dart';
export 'db_rows/auto_refund_job_row.dart';
export 'db_rows/banner_row.dart';
export 'db_rows/bogo_offer_reward_row.dart';
export 'db_rows/bogo_offer_row.dart';
export 'db_rows/category_offer_row.dart';
export 'db_rows/category_row.dart';
export 'db_rows/cod_failure_record.dart';
export 'db_rows/cod_settings_row.dart';
export 'db_rows/combo_offer_item_row.dart';
export 'db_rows/combo_offer_row.dart';
export 'db_rows/complaint_row.dart';
export 'db_rows/coupon_row.dart';
export 'db_rows/customer_order_row.dart';
export 'db_rows/delivery_config_row.dart';
export 'db_rows/delivery_otp_row.dart';
export 'db_rows/delivery_rule_row.dart';
export 'db_rows/delivery_settings_row.dart';
export 'db_rows/delivery_slab_row.dart';
export 'db_rows/free_delivery_rule_row.dart';
export 'db_rows/fresh_points_settings_row.dart';
export 'db_rows/fresh_points_transaction_row.dart';
export 'db_rows/idempotency_record_row.dart';
export 'db_rows/notification_campaign_row.dart';
export 'db_rows/notification_outbox_row.dart';
export 'db_rows/notification_preference_row.dart';
export 'db_rows/notification_user_state_row.dart';
export 'db_rows/order_address_row.dart';
export 'db_rows/order_item_row.dart';
export 'db_rows/order_notification_outbox_row.dart';
export 'db_rows/order_tracking_row.dart';
export 'db_rows/payment_link_row.dart';
export 'db_rows/payment_session_row.dart';
export 'db_rows/payment_transaction_row.dart';
export 'db_rows/product_row.dart';
export 'db_rows/product_search_document_row.dart';
export 'db_rows/product_search_rebuild_job_row.dart';
export 'db_rows/product_variant_row.dart';
export 'db_rows/referral_row.dart';
export 'db_rows/referral_settings_row.dart';
export 'db_rows/refund_record_row.dart';
export 'db_rows/shop_more_get_more_offer_row.dart';
export 'db_rows/sub_category_row.dart';
export 'db_rows/support_issue_row.dart';
export 'db_rows/user_address_row.dart';
export 'db_rows/user_cart_item_row.dart';
export 'db_rows/user_fcm_token_row.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'admin_audit_log',
      dartName: 'AdminAuditLogRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'actorUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'action',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'entityType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'entityId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'metadata',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,String>?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'admin_audit_log_fk_0',
          columns: ['actorUserId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'admin_audit_log_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'admin_notification_preference',
      dartName: 'AdminNotificationPreferenceRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'adminUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'adminFirebaseUid',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'preferenceKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'pushEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'soundEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'critical',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'admin_notification_preference_fk_0',
          columns: ['adminUserId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'admin_notification_preference_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'admin_notification_preference_admin_key_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'adminUserId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'preferenceKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'admin_notification_preference_firebase_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'adminFirebaseUid',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'app_user',
      dartName: 'AppUserRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'firebaseUid',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'phoneNumber',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'customer\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'fcmToken',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'currentFreshPoints',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'totalEarned',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'totalRedeemed',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'referralCode',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'referralCodeApplied',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'referralSource',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'referralAppliedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'referralWindowExpiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'referralOnboardingDismissedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'termsAcceptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'codOrdersPlaced',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'codOrdersDelivered',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'codOrdersRejected',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'isCodBlocked',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'codBlockedReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'codBlockedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'app_user_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'app_user_firebase_uid_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'firebaseUid',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'app_user_referral_code_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'referralCode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'auto_refund_job',
      dartName: 'AutoRefundJobRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'orderNumber',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'customerId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'gatewayPaymentId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'paymentTransactionId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'gatewayOrderId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'INR\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'jobStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'PENDING\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'attemptCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'nextRetryAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'lastError',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'processedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'auto_refund_job_fk_0',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'auto_refund_job_fk_1',
          columns: ['customerId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'auto_refund_job_fk_2',
          columns: ['paymentTransactionId'],
          referenceTable: 'payment_transaction',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auto_refund_job_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'auto_refund_job_gateway_payment_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'gatewayPaymentId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'auto_refund_job_status_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'jobStatus',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'auto_refund_job_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'banner',
      dartName: 'BannerRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'imageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'actionType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'offerId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'externalUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'linkedProductId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'comboOfferId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'couponId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'linkedCategoryId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'linkedSubCategoryId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'screenPlacements',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'linkedProductIds',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'priority',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'isBaseImage',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'startsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'banner_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bogo_offer',
      dartName: 'BogoOfferRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'triggerProductId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'triggerVariantId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'minTriggerQuantity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _i2.ColumnDefinition(
          name: 'triggerBaseQuantity',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'triggerBaseUnit',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'startsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bogo_offer_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bogo_offer_reward',
      dartName: 'BogoOfferRewardRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'bogoOfferId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'rewardProductId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'rewardVariantId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'freeQuantity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'bogo_offer_reward_fk_0',
          columns: ['bogoOfferId'],
          referenceTable: 'bogo_offer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bogo_offer_reward_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'bogo_offer_reward_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bogoOfferId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'rewardProductId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'rewardVariantId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'category',
      dartName: 'CategoryRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'slug',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'imageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'displayOrder',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'category_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'category_slug_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'category_offer',
      dartName: 'CategoryOfferRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'categoryId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'discountType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'discountValue',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'maxDiscountAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'minOrderAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'priority',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'startsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'scopeProductIds',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'excludeProductIds',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'category_offer_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'cod_failure_record',
      dartName: 'CodFailureRecord',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'reason',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'failureNote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'recordedBy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'recordedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'cod_failure_record_fk_0',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'cod_failure_record_fk_1',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'cod_failure_record_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'cod_failure_record_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'cod_failure_record_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'recordedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'cod_settings',
      dartName: 'CodSettingsRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'maximumAllowedCodFailures',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '3',
        ),
        _i2.ColumnDefinition(
          name: 'enableAutoBlocking',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'cod_settings_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'combo_offer',
      dartName: 'ComboOfferRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'discountType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'discountValue',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'minQuantityPerProduct',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _i2.ColumnDefinition(
          name: 'maxUsagePerUser',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'maxUsageTotal',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'usedCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'priority',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'startsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'combo_offer_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'combo_offer_item',
      dartName: 'ComboOfferItemRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'comboOfferId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'productVariantId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'quantity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'sortOrder',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'combo_offer_item_fk_0',
          columns: ['comboOfferId'],
          referenceTable: 'combo_offer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'combo_offer_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'combo_offer_item_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'comboOfferId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productVariantId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'complaint',
      dartName: 'ComplaintRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'orderItemId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'complaintType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'product\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'selectedProducts',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:ComplaintProductItem>',
        ),
        _i2.ColumnDefinition(
          name: 'issueType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'selectedField',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'extraData',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,String>?',
        ),
        _i2.ColumnDefinition(
          name: 'userPhone',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'imageUrls',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'Pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'adminReply',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'adminNote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'resolutionType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'complaint_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'complaint_fk_1',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'complaint_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'complaint_order_item_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderItemId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'complaint_order_type_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'complaintType',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'selectedField',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'complaint_user_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'complaint_status_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'complaint_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'coupon',
      dartName: 'CouponRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'code',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'couponType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'couponCategory',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'General\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'discountValue',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'minOrderAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'maxDiscountAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'maxUsageTotal',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'maxUsagePerUser',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'loyaltyRequiredOrders',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'usedCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'startsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'assignedUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'assignedPhone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'productIds',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'coupon_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'coupon_code_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'customer_order',
      dartName: 'CustomerOrderRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'orderNumber',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'orderStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'paymentStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'refundStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'couponId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentMode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'standard\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'paymentExpiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'paidByName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paidByPhone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paidByEmail',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentSessionId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentLinkId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentLinkUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentLinkExpiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'linkStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'itemCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'totalAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'discountAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'mrpTotal',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'productDiscountAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'comboDiscountAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'bogoDiscountAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'categoryOfferDiscountAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryFee',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'originalDeliveryFee',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryDiscountAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'freeDeliveryApplied',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'freeDeliveryReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'couponSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'addressSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'pricingSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deliverySnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'freshPointsUsed',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'freshPointsValue',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'actualPaymentAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'finalAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'placedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'confirmedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'packedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'outForDeliveryAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveredAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'cancelledAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'cancellationReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'codFailureReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryPersonName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryPersonPhone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryOtp',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryOtpExpiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryVerificationMethod',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'otp\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryProofImageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryProofLatitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryProofLongitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryProofTimestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryProofDistanceMeters',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryProofGpsAccuracy',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveredByUserId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveredByName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveredByRole',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'admin\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryCompletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryOtpVerifiedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'orderType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'regular\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'sourceOrderNumber',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'complaintId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentCollectedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentCollectedBy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentCollectionMode',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'analyticsProcessedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'orderedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'customer_order_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'customer_order_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'customer_order_order_number_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderNumber',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'customer_order_user_ordered_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderedAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'customer_order_status_ordered_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderStatus',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderedAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'customer_order_payment_ordered_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'paymentStatus',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderedAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'customer_order_user_payment_ordered_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'paymentStatus',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderedAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'delivery_config',
      dartName: 'DeliveryConfigRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'configKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'baseDeliveryFee',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'delivery_config_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'delivery_config_key_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'configKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'delivery_otp',
      dartName: 'DeliveryOtpRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'otpHash',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'verifiedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'resendCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'generatedByAdminId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'verifiedByAdminId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'delivery_otp_fk_0',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'delivery_otp_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'delivery_otp_order_active_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'isActive',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'delivery_rule',
      dartName: 'DeliveryRuleRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryFee',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'sortOrder',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'targetUserType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'targetOrderCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'startsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'delivery_rule_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'delivery_settings',
      dartName: 'DeliverySettingsRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'defaultVerificationMethod',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'otp\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'cameraOnlyCapture',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'gpsRequired',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'strictDistanceValidation',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'maxAllowedRadiusMeters',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '200',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'delivery_settings_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'delivery_slab',
      dartName: 'DeliverySlabRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'configId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'minOrderAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'maxOrderAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'fee',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'sortOrder',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'delivery_slab_fk_0',
          columns: ['configId'],
          referenceTable: 'delivery_config',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'delivery_slab_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'delivery_slab_config_sort_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'configId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sortOrder',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'free_delivery_rule',
      dartName: 'FreeDeliveryRuleRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'ruleType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'minOrderAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'minItemsCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'couponId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'waivedAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'startsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'free_delivery_rule_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'fresh_points_settings',
      dartName: 'FreshPointsSettingsRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'isEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'redemptionPercentageLimit',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '50.0',
        ),
        _i2.ColumnDefinition(
          name: 'allowRedemptionOnCOD',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'minimumOrderForRedemption',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'enablePointExpiry',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'pointExpiryDays',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '90',
        ),
        _i2.ColumnDefinition(
          name: 'enableAdminAdjustments',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'lastUpdatedBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'fresh_points_settings_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'fresh_points_transaction',
      dartName: 'FreshPointsTransactionRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'transactionType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'points',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'balanceBefore',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'balanceAfter',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'referenceType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'referenceId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'fresh_points_transaction_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'fresh_points_transaction_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'fresh_points_transaction_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'fresh_points_transaction_type_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'transactionType',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'fresh_points_transaction_ref_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'referenceType',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'referenceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'idempotency_record',
      dartName: 'IdempotencyRecordRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'scope',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'idempotencyKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentTransactionId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'requestHash',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'responseReference',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'idempotency_record_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'idempotency_scope_key_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'scope',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'idempotencyKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'notification_campaign',
      dartName: 'NotificationCampaignRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'body',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'type',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'topic',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'imageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'targetAudience',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'queued\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'priority',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'normal\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'scheduledAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'creatorAdminFirebaseUid',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'targetMetadataJson',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'recipientCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'successCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'failureCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'lastError',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'sentAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'entityType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'entityId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'dataJson',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'notification_campaign_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_campaign_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_campaign_topic_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'topic',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_campaign_status_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_campaign_scheduled_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'scheduledAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'notification_outbox',
      dartName: 'NotificationOutboxRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'dedupeKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'campaignId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'payloadJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'queued\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'attemptCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'maxAttempts',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '5',
        ),
        _i2.ColumnDefinition(
          name: 'lastError',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'nextAttemptAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'processedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'notification_outbox_fk_0',
          columns: ['campaignId'],
          referenceTable: 'notification_campaign',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'notification_outbox_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_outbox_dedupe_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'dedupeKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_outbox_pending_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'processedAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'nextAttemptAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_outbox_status_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'nextAttemptAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_outbox_campaign_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'campaignId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'notification_preference',
      dartName: 'NotificationPreferenceRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'firebaseUid',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'trackOrderNotifications',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'couponNotifications',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'offerNotifications',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'announcementNotifications',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'importantAlerts',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'notification_preference_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'notification_preference_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_preference_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_preference_firebase_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'firebaseUid',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'notification_user_state',
      dartName: 'NotificationUserStateRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'campaignId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'isRead',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'isDeleted',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'readAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'notification_user_state_fk_0',
          columns: ['campaignId'],
          referenceTable: 'notification_campaign',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'notification_user_state_fk_1',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'notification_user_state_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_user_state_campaign_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'campaignId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_user_state_user_deleted_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'isDeleted',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'updatedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'order_address',
      dartName: 'OrderAddressRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'recipientName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'phoneNumber',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'streetLine1',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'streetLine2',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'landmark',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'city',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'state',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'postalCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'country',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'latitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'longitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'order_address_fk_0',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_address_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'order_address_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'order_item',
      dartName: 'OrderItemRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'productVariantId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'comboOfferId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'bogoOfferId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'triggerProductId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'productNameSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'productImageUrlSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'variantLabelSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'mrpSnapshot',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'skuSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'productSlugSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'categoryNameSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'productStatusSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'appliedOfferSnapshot',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'quantity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'unitPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'totalPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'isFreeItem',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'isRewardProduct',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'quantityEditable',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'priceEditable',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'originalUnitPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'rewardValue',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'rewardOfferId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'rewardOfferName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'rewardThreshold',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'rewardSource',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isFreeDelivery',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'order_item_fk_0',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'order_item_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'order_item_product_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'order_item_product_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'order_notification_outbox',
      dartName: 'OrderNotificationOutboxRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'dedupeKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'eventType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'payloadJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'attemptCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'lastError',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'processedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_notification_outbox_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'order_notification_outbox_dedupe_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'dedupeKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'order_notification_outbox_pending_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'processedAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'order_notification_outbox_user_pending_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'processedAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'order_tracking',
      dartName: 'OrderTrackingRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'trackingEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'userLatitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'userLongitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'userAddress',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'userLocationType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'riderLatitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'riderLongitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'order_tracking_fk_0',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_tracking_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'order_tracking_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'payment_link',
      dartName: 'PaymentLinkRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'token',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isUsed',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'usedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'paidByName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paidByPhone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paidByEmail',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'razorpayPaymentLinkId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'razorpayPaymentLinkUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'linkType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'browser\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'linkStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'ACTIVE\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'generatedBy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'payment_link_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'payment_link_token_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'token',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'payment_link_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'payment_session',
      dartName: 'PaymentSessionRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'customerId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdByAdminId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'paymentMethod',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'cod_online\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'collectionMode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'upi_qr\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'INR\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'razorpayQrId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'qrImageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'gatewayPaymentId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'gatewaySignature',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'gatewayTransactionReference',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'notes',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'paidAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'expiredAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'cancelledAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'payment_session_fk_0',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'payment_session_fk_1',
          columns: ['customerId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'payment_session_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'payment_session_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'payment_session_razorpay_qr_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'razorpayQrId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'payment_session_status_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'payment_transaction',
      dartName: 'PaymentTransactionRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'idempotencyKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'gatewayName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'gatewayOrderId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'gatewayPaymentId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'currencyCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'INR\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'paymentStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'gatewayStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'failureReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'paidAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'payment_transaction_fk_0',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'payment_transaction_fk_1',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'payment_transaction_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'payment_transaction_idempotency_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'idempotencyKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'payment_transaction_gateway_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'gatewayOrderId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'payment_transaction_gateway_payment_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'gatewayPaymentId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'payment_transaction_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'product',
      dartName: 'ProductRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'categoryId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'slug',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'shortDescription',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'primaryImageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'countryOfOrigin',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'baseUnit',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'baseQuantity',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'quantityDescription',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'subCategoryIds',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'stock',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'stockUnit',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'discountType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isFreeDelivery',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'mostSearchCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'mostPurchaseCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'last7DaysSold',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'last7DaysViews',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'reorderCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'trendingScore',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'product_fk_0',
          columns: ['categoryId'],
          referenceTable: 'category',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'product_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'product_slug_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'product_trending_score_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'trendingScore',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'product_most_purchase_count_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'mostPurchaseCount',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'product_most_search_count_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'mostSearchCount',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'product_reorder_count_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'reorderCount',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'product_is_free_delivery_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'isFreeDelivery',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'product_search_document',
      dartName: 'ProductSearchDocumentRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'searchText',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'builtAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'sourceCreatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'sourceUpdatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'product_search_document_fk_0',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'product_search_document_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'product_search_document_product_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'product_search_rebuild_job',
      dartName: 'ProductSearchRebuildJobRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'reason',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'jobStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'attemptCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'scheduledAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'startedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'finishedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'lastError',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'product_search_rebuild_job_fk_0',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'product_search_rebuild_job_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'product_search_rebuild_job_status_scheduled_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'jobStatus',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'scheduledAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'product_variant',
      dartName: 'ProductVariantRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'label',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'sku',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'quantityValue',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'quantityUnit',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'quantityDescription',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'salePrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'listPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'isAvailable',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'isDefault',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'isFreeDelivery',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'sortOrder',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'product_variant_fk_0',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'product_variant_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'product_variant_sku_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sku',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'product_variant_product_sort_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sortOrder',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'referral',
      dartName: 'ReferralRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'referrerUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'inviteeUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'inviteePhone',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'referralCodeUsed',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'LINK_SHARED\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'qualifyingOrderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'qualifyingOrderAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0.0',
        ),
        _i2.ColumnDefinition(
          name: 'rewardPointsIssued',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'inviteeCouponIssued',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'rewardIssuedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'fraudNotes',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'fraudScore',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'fraudBreakdown',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'holdExpiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'scheduledReleaseAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'attempts',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'lastError',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'outstandingRecoveryPoints',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'isRecoveryPending',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'recoveryReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'dailyShareCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'monthlyShareCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'lastShareDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'referral_fk_0',
          columns: ['referrerUserId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'referral_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'referral_referrer_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'referrerUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'referral_invitee_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'inviteeUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'referral_code_status_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'referralCodeUsed',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'referral_settings',
      dartName: 'ReferralSettingsRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'isEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'inviteeCouponEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'inviteeCouponAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '50.0',
        ),
        _i2.ColumnDefinition(
          name: 'inviteeCouponCodeTemplate',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'WELCOME{CODE}\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'referrerPointsEnabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'referrerRewardPoints',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '50',
        ),
        _i2.ColumnDefinition(
          name: 'rewardTriggerStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'DELIVERED\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'maxRewardedPerMonth',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '20',
        ),
        _i2.ColumnDefinition(
          name: 'enableFraudProtection',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'inviteeCouponMinOrderAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '199.0',
        ),
        _i2.ColumnDefinition(
          name: 'inviteeCouponValidityDays',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '15',
        ),
        _i2.ColumnDefinition(
          name: 'enableReferralExpiry',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'referralExpiryDays',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '90',
        ),
        _i2.ColumnDefinition(
          name: 'shareMessageTemplate',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault:
              '\'Join FreshPickKat using my referral code {CODE}. Get ₹50 OFF on your first order!\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'lastUpdatedBy',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'enableFraudScoring',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'autoApproveThreshold',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '40',
        ),
        _i2.ColumnDefinition(
          name: 'manualReviewThreshold',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '69',
        ),
        _i2.ColumnDefinition(
          name: 'autoRejectThreshold',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '90',
        ),
        _i2.ColumnDefinition(
          name: 'enableRewardHold',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'holdDurationHours',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '72',
        ),
        _i2.ColumnDefinition(
          name: 'enableAutoReject',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'minimumActualPaymentForQualification',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'maxRewardedPerDay',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '3',
        ),
        _i2.ColumnDefinition(
          name: 'maxPendingReferrals',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '50',
        ),
        _i2.ColumnDefinition(
          name: 'maxSharesPerDay',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '100',
        ),
        _i2.ColumnDefinition(
          name: 'maxSharesPerMonth',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1000',
        ),
        _i2.ColumnDefinition(
          name: 'referralVelocityScore',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '30',
        ),
        _i2.ColumnDefinition(
          name: 'velocityTimeWindowHours',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '24',
        ),
        _i2.ColumnDefinition(
          name: 'velocityThreshold',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '3',
        ),
        _i2.ColumnDefinition(
          name: 'autoReversalWindowDays',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '30',
        ),
        _i2.ColumnDefinition(
          name: 'termsText',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'referral_settings_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'refund_record',
      dartName: 'RefundRecordRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'paymentTransactionId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'gatewayRefundId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'refundStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'source',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'order\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'reason',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'complaintId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'failureReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'refund_record_fk_0',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'refund_record_fk_1',
          columns: ['paymentTransactionId'],
          referenceTable: 'payment_transaction',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'refund_record_fk_2',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'refund_record_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'refund_record_gateway_refund_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'gatewayRefundId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'refund_record_order_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'refund_record_complaint_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'complaintId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shop_more_get_more_offer',
      dartName: 'ShopMoreGetMoreOfferRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'minimumOrderAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'freeProductId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'freeVariantId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'freeQuantity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _i2.ColumnDefinition(
          name: 'startsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdBy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'updatedBy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'activatedBy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedBy',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'shop_more_get_more_offer_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'sub_category',
      dartName: 'SubCategoryRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'categoryId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'slug',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'imageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'displayOrder',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'deactivatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'sub_category_fk_0',
          columns: ['categoryId'],
          referenceTable: 'category',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'sub_category_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'sub_category_category_slug_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'categoryId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'support_issue',
      dartName: 'SupportIssueRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'issueType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'screenshotUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'appVersion',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'buildNumber',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deviceInfo',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'Pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'support_issue_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'support_issue_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'support_issue_user_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'support_issue_status_created_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_address',
      dartName: 'UserAddressRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'label',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'recipientName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'phoneNumber',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'streetLine1',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'streetLine2',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'landmark',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'city',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'state',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'postalCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'country',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'latitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'longitude',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'isDefault',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'user_address_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_address_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_address_user_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_cart_item',
      dartName: 'UserCartItemRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'variantId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'quantity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'bogoFreeProductId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'comboId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'comboName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'comboDiscountType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'comboDiscountValue',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'comboItemQuantity',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'user_cart_item_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_cart_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_cart_item_user_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_fcm_token',
      dartName: 'UserFcmTokenRow',
      schema: 'public',
      module: 'freshpickkat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'firebaseUid',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'fcmToken',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deviceId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'platform',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'user_fcm_token_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_fcm_token_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_fcm_token_user_device_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_fcm_token_firebase_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'firebaseUid',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'isActive',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'updatedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_fcm_token_token_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'fcmToken',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.ActiveUserStatistics) {
      return _i5.ActiveUserStatistics.fromJson(data) as T;
    }
    if (t == _i6.Address) {
      return _i6.Address.fromJson(data) as T;
    }
    if (t == _i7.AdminAnalytics) {
      return _i7.AdminAnalytics.fromJson(data) as T;
    }
    if (t == _i8.AdminAuditLogEntry) {
      return _i8.AdminAuditLogEntry.fromJson(data) as T;
    }
    if (t == _i9.AdminAuthResult) {
      return _i9.AdminAuthResult.fromJson(data) as T;
    }
    if (t == _i10.AdminDashboardHydrated) {
      return _i10.AdminDashboardHydrated.fromJson(data) as T;
    }
    if (t == _i11.AdminDashboardStats) {
      return _i11.AdminDashboardStats.fromJson(data) as T;
    }
    if (t == _i12.AdminNotificationPreference) {
      return _i12.AdminNotificationPreference.fromJson(data) as T;
    }
    if (t == _i13.AdminTopProduct) {
      return _i13.AdminTopProduct.fromJson(data) as T;
    }
    if (t == _i14.ApiResponse) {
      return _i14.ApiResponse.fromJson(data) as T;
    }
    if (t == _i15.AppUser) {
      return _i15.AppUser.fromJson(data) as T;
    }
    if (t == _i16.AppliedCouponInfo) {
      return _i16.AppliedCouponInfo.fromJson(data) as T;
    }
    if (t == _i17.AppliedOfferInfo) {
      return _i17.AppliedOfferInfo.fromJson(data) as T;
    }
    if (t == _i18.Banner) {
      return _i18.Banner.fromJson(data) as T;
    }
    if (t == _i19.BannerPage) {
      return _i19.BannerPage.fromJson(data) as T;
    }
    if (t == _i20.BasketSuggestion) {
      return _i20.BasketSuggestion.fromJson(data) as T;
    }
    if (t == _i21.BasketSuggestionAction) {
      return _i21.BasketSuggestionAction.fromJson(data) as T;
    }
    if (t == _i22.BasketSuggestionResult) {
      return _i22.BasketSuggestionResult.fromJson(data) as T;
    }
    if (t == _i23.BestCouponResult) {
      return _i23.BestCouponResult.fromJson(data) as T;
    }
    if (t == _i24.BogoFreeProduct) {
      return _i24.BogoFreeProduct.fromJson(data) as T;
    }
    if (t == _i25.BogoOffer) {
      return _i25.BogoOffer.fromJson(data) as T;
    }
    if (t == _i26.BogoOfferPage) {
      return _i26.BogoOfferPage.fromJson(data) as T;
    }
    if (t == _i27.BroadcastPage) {
      return _i27.BroadcastPage.fromJson(data) as T;
    }
    if (t == _i28.BroadcastRequest) {
      return _i28.BroadcastRequest.fromJson(data) as T;
    }
    if (t == _i29.BroadcastSummary) {
      return _i29.BroadcastSummary.fromJson(data) as T;
    }
    if (t == _i30.CartComparisonData) {
      return _i30.CartComparisonData.fromJson(data) as T;
    }
    if (t == _i31.CartHydratedData) {
      return _i31.CartHydratedData.fromJson(data) as T;
    }
    if (t == _i32.CartItem) {
      return _i32.CartItem.fromJson(data) as T;
    }
    if (t == _i33.CartItemInput) {
      return _i33.CartItemInput.fromJson(data) as T;
    }
    if (t == _i34.CartItemSnapshot) {
      return _i34.CartItemSnapshot.fromJson(data) as T;
    }
    if (t == _i35.CartPricingResult) {
      return _i35.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i36.CascadeEntityInfo) {
      return _i36.CascadeEntityInfo.fromJson(data) as T;
    }
    if (t == _i37.CascadeExecuteResponse) {
      return _i37.CascadeExecuteResponse.fromJson(data) as T;
    }
    if (t == _i38.CascadeImpactResponse) {
      return _i38.CascadeImpactResponse.fromJson(data) as T;
    }
    if (t == _i39.Category) {
      return _i39.Category.fromJson(data) as T;
    }
    if (t == _i40.CategoryHierarchy) {
      return _i40.CategoryHierarchy.fromJson(data) as T;
    }
    if (t == _i41.CategoryOffer) {
      return _i41.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i42.CategoryOfferPage) {
      return _i42.CategoryOfferPage.fromJson(data) as T;
    }
    if (t == _i43.CheckoutInitHydrated) {
      return _i43.CheckoutInitHydrated.fromJson(data) as T;
    }
    if (t == _i44.CheckoutResult) {
      return _i44.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i45.CodPaymentReceipt) {
      return _i45.CodPaymentReceipt.fromJson(data) as T;
    }
    if (t == _i46.ComboOffer) {
      return _i46.ComboOffer.fromJson(data) as T;
    }
    if (t == _i47.ComboOfferPage) {
      return _i47.ComboOfferPage.fromJson(data) as T;
    }
    if (t == _i48.ComboProductItem) {
      return _i48.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i49.Complaint) {
      return _i49.Complaint.fromJson(data) as T;
    }
    if (t == _i50.ComplaintDetailHydrated) {
      return _i50.ComplaintDetailHydrated.fromJson(data) as T;
    }
    if (t == _i51.ComplaintPage) {
      return _i51.ComplaintPage.fromJson(data) as T;
    }
    if (t == _i52.ComplaintProductItem) {
      return _i52.ComplaintProductItem.fromJson(data) as T;
    }
    if (t == _i53.Coupon) {
      return _i53.Coupon.fromJson(data) as T;
    }
    if (t == _i54.CouponDisplay) {
      return _i54.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i55.CouponValidationResult) {
      return _i55.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i56.DeleteImpactReference) {
      return _i56.DeleteImpactReference.fromJson(data) as T;
    }
    if (t == _i57.DeleteImpactResponse) {
      return _i57.DeleteImpactResponse.fromJson(data) as T;
    }
    if (t == _i58.DeliveryConfig) {
      return _i58.DeliveryConfig.fromJson(data) as T;
    }
    if (t == _i59.DeliveryPricingResult) {
      return _i59.DeliveryPricingResult.fromJson(data) as T;
    }
    if (t == _i60.DeliveryRule) {
      return _i60.DeliveryRule.fromJson(data) as T;
    }
    if (t == _i61.DeliveryRulePage) {
      return _i61.DeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i62.DeliverySettings) {
      return _i62.DeliverySettings.fromJson(data) as T;
    }
    if (t == _i63.DeliverySlab) {
      return _i63.DeliverySlab.fromJson(data) as T;
    }
    if (t == _i64.FreeDeliveryHydrated) {
      return _i64.FreeDeliveryHydrated.fromJson(data) as T;
    }
    if (t == _i65.FreeDeliveryRule) {
      return _i65.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i66.FreeDeliveryRulePage) {
      return _i66.FreeDeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i67.FreeItemInfo) {
      return _i67.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i68.FreshPointsAdjustRequest) {
      return _i68.FreshPointsAdjustRequest.fromJson(data) as T;
    }
    if (t == _i69.FreshPointsBalance) {
      return _i69.FreshPointsBalance.fromJson(data) as T;
    }
    if (t == _i70.FreshPointsSettings) {
      return _i70.FreshPointsSettings.fromJson(data) as T;
    }
    if (t == _i71.FreshPointsTransaction) {
      return _i71.FreshPointsTransaction.fromJson(data) as T;
    }
    if (t == _i72.HardDeleteResponse) {
      return _i72.HardDeleteResponse.fromJson(data) as T;
    }
    if (t == _i73.HomePageHydratedData) {
      return _i73.HomePageHydratedData.fromJson(data) as T;
    }
    if (t == _i74.NotificationDraft) {
      return _i74.NotificationDraft.fromJson(data) as T;
    }
    if (t == _i75.NotificationHistoryItem) {
      return _i75.NotificationHistoryItem.fromJson(data) as T;
    }
    if (t == _i76.NotificationHistoryPage) {
      return _i76.NotificationHistoryPage.fromJson(data) as T;
    }
    if (t == _i77.NotificationPreference) {
      return _i77.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i78.OfferConflictResponse) {
      return _i78.OfferConflictResponse.fromJson(data) as T;
    }
    if (t == _i79.OfferMutationResult) {
      return _i79.OfferMutationResult.fromJson(data) as T;
    }
    if (t == _i80.OfferSearchItem) {
      return _i80.OfferSearchItem.fromJson(data) as T;
    }
    if (t == _i81.OfferSearchPage) {
      return _i81.OfferSearchPage.fromJson(data) as T;
    }
    if (t == _i82.Order) {
      return _i82.Order.fromJson(data) as T;
    }
    if (t == _i83.OrderDetailHydrated) {
      return _i83.OrderDetailHydrated.fromJson(data) as T;
    }
    if (t == _i84.OrderItem) {
      return _i84.OrderItem.fromJson(data) as T;
    }
    if (t == _i85.OrderPage) {
      return _i85.OrderPage.fromJson(data) as T;
    }
    if (t == _i86.OrderRealtimeEvent) {
      return _i86.OrderRealtimeEvent.fromJson(data) as T;
    }
    if (t == _i87.OrderTrackingData) {
      return _i87.OrderTrackingData.fromJson(data) as T;
    }
    if (t == _i88.PaymentActionResult) {
      return _i88.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i89.PaymentEvent) {
      return _i89.PaymentEvent.fromJson(data) as T;
    }
    if (t == _i90.PaymentLinkData) {
      return _i90.PaymentLinkData.fromJson(data) as T;
    }
    if (t == _i91.PaymentOrderDetailHydrated) {
      return _i91.PaymentOrderDetailHydrated.fromJson(data) as T;
    }
    if (t == _i92.PaymentOrderResult) {
      return _i92.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i93.PaymentPageData) {
      return _i93.PaymentPageData.fromJson(data) as T;
    }
    if (t == _i94.PaymentPageItem) {
      return _i94.PaymentPageItem.fromJson(data) as T;
    }
    if (t == _i95.PaymentSessionData) {
      return _i95.PaymentSessionData.fromJson(data) as T;
    }
    if (t == _i96.PaymentTransaction) {
      return _i96.PaymentTransaction.fromJson(data) as T;
    }
    if (t == _i97.PaymentVerifyResult) {
      return _i97.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i98.PendingOrderInfo) {
      return _i98.PendingOrderInfo.fromJson(data) as T;
    }
    if (t == _i99.PricingLineItem) {
      return _i99.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i100.Product) {
      return _i100.Product.fromJson(data) as T;
    }
    if (t == _i101.ProductFormReferenceData) {
      return _i101.ProductFormReferenceData.fromJson(data) as T;
    }
    if (t == _i102.ProductPage) {
      return _i102.ProductPage.fromJson(data) as T;
    }
    if (t == _i103.ProductRankingItem) {
      return _i103.ProductRankingItem.fromJson(data) as T;
    }
    if (t == _i104.ProductVariant) {
      return _i104.ProductVariant.fromJson(data) as T;
    }
    if (t == _i105.RazorpayPaymentStatus) {
      return _i105.RazorpayPaymentStatus.fromJson(data) as T;
    }
    if (t == _i106.RazorpayRefundData) {
      return _i106.RazorpayRefundData.fromJson(data) as T;
    }
    if (t == _i107.Referral) {
      return _i107.Referral.fromJson(data) as T;
    }
    if (t == _i108.ReferralActivity) {
      return _i108.ReferralActivity.fromJson(data) as T;
    }
    if (t == _i109.ReferralAdminStats) {
      return _i109.ReferralAdminStats.fromJson(data) as T;
    }
    if (t == _i110.ReferralCodeInfo) {
      return _i110.ReferralCodeInfo.fromJson(data) as T;
    }
    if (t == _i111.ReferralFraudResult) {
      return _i111.ReferralFraudResult.fromJson(data) as T;
    }
    if (t == _i112.ReferralFraudRuleResult) {
      return _i112.ReferralFraudRuleResult.fromJson(data) as T;
    }
    if (t == _i113.ReferralOnboardingStatus) {
      return _i113.ReferralOnboardingStatus.fromJson(data) as T;
    }
    if (t == _i114.ReferralSettings) {
      return _i114.ReferralSettings.fromJson(data) as T;
    }
    if (t == _i115.ReferralValidationResult) {
      return _i115.ReferralValidationResult.fromJson(data) as T;
    }
    if (t == _i116.RefundRecord) {
      return _i116.RefundRecord.fromJson(data) as T;
    }
    if (t == _i117.RegisterFcmTokenRequest) {
      return _i117.RegisterFcmTokenRequest.fromJson(data) as T;
    }
    if (t == _i118.ShopMoreGetMoreOffer) {
      return _i118.ShopMoreGetMoreOffer.fromJson(data) as T;
    }
    if (t == _i119.ShopMoreGetMoreOfferPage) {
      return _i119.ShopMoreGetMoreOfferPage.fromJson(data) as T;
    }
    if (t == _i120.SmgmAnalytics) {
      return _i120.SmgmAnalytics.fromJson(data) as T;
    }
    if (t == _i121.SubCategory) {
      return _i121.SubCategory.fromJson(data) as T;
    }
    if (t == _i122.SupportIssue) {
      return _i122.SupportIssue.fromJson(data) as T;
    }
    if (t == _i123.TopReferrerEntry) {
      return _i123.TopReferrerEntry.fromJson(data) as T;
    }
    if (t == _i124.AdminAuditLogRow) {
      return _i124.AdminAuditLogRow.fromJson(data) as T;
    }
    if (t == _i125.AdminNotificationPreferenceRow) {
      return _i125.AdminNotificationPreferenceRow.fromJson(data) as T;
    }
    if (t == _i126.AppUserRow) {
      return _i126.AppUserRow.fromJson(data) as T;
    }
    if (t == _i127.AutoRefundJobRow) {
      return _i127.AutoRefundJobRow.fromJson(data) as T;
    }
    if (t == _i128.BannerRow) {
      return _i128.BannerRow.fromJson(data) as T;
    }
    if (t == _i129.BogoOfferRewardRow) {
      return _i129.BogoOfferRewardRow.fromJson(data) as T;
    }
    if (t == _i130.BogoOfferRow) {
      return _i130.BogoOfferRow.fromJson(data) as T;
    }
    if (t == _i131.CategoryOfferRow) {
      return _i131.CategoryOfferRow.fromJson(data) as T;
    }
    if (t == _i132.CategoryRow) {
      return _i132.CategoryRow.fromJson(data) as T;
    }
    if (t == _i133.CodFailureRecord) {
      return _i133.CodFailureRecord.fromJson(data) as T;
    }
    if (t == _i134.CodSettingsRow) {
      return _i134.CodSettingsRow.fromJson(data) as T;
    }
    if (t == _i135.ComboOfferItemRow) {
      return _i135.ComboOfferItemRow.fromJson(data) as T;
    }
    if (t == _i136.ComboOfferRow) {
      return _i136.ComboOfferRow.fromJson(data) as T;
    }
    if (t == _i137.ComplaintRow) {
      return _i137.ComplaintRow.fromJson(data) as T;
    }
    if (t == _i138.CouponRow) {
      return _i138.CouponRow.fromJson(data) as T;
    }
    if (t == _i139.CustomerOrderRow) {
      return _i139.CustomerOrderRow.fromJson(data) as T;
    }
    if (t == _i140.DeliveryConfigRow) {
      return _i140.DeliveryConfigRow.fromJson(data) as T;
    }
    if (t == _i141.DeliveryOtpRow) {
      return _i141.DeliveryOtpRow.fromJson(data) as T;
    }
    if (t == _i142.DeliveryRuleRow) {
      return _i142.DeliveryRuleRow.fromJson(data) as T;
    }
    if (t == _i143.DeliverySettingsRow) {
      return _i143.DeliverySettingsRow.fromJson(data) as T;
    }
    if (t == _i144.DeliverySlabRow) {
      return _i144.DeliverySlabRow.fromJson(data) as T;
    }
    if (t == _i145.FreeDeliveryRuleRow) {
      return _i145.FreeDeliveryRuleRow.fromJson(data) as T;
    }
    if (t == _i146.FreshPointsSettingsRow) {
      return _i146.FreshPointsSettingsRow.fromJson(data) as T;
    }
    if (t == _i147.FreshPointsTransactionRow) {
      return _i147.FreshPointsTransactionRow.fromJson(data) as T;
    }
    if (t == _i148.IdempotencyRecordRow) {
      return _i148.IdempotencyRecordRow.fromJson(data) as T;
    }
    if (t == _i149.NotificationCampaignRow) {
      return _i149.NotificationCampaignRow.fromJson(data) as T;
    }
    if (t == _i150.NotificationOutboxRow) {
      return _i150.NotificationOutboxRow.fromJson(data) as T;
    }
    if (t == _i151.NotificationPreferenceRow) {
      return _i151.NotificationPreferenceRow.fromJson(data) as T;
    }
    if (t == _i152.NotificationUserStateRow) {
      return _i152.NotificationUserStateRow.fromJson(data) as T;
    }
    if (t == _i153.OrderAddressRow) {
      return _i153.OrderAddressRow.fromJson(data) as T;
    }
    if (t == _i154.OrderItemRow) {
      return _i154.OrderItemRow.fromJson(data) as T;
    }
    if (t == _i155.OrderNotificationOutboxRow) {
      return _i155.OrderNotificationOutboxRow.fromJson(data) as T;
    }
    if (t == _i156.OrderTrackingRow) {
      return _i156.OrderTrackingRow.fromJson(data) as T;
    }
    if (t == _i157.PaymentLinkRow) {
      return _i157.PaymentLinkRow.fromJson(data) as T;
    }
    if (t == _i158.PaymentSessionRow) {
      return _i158.PaymentSessionRow.fromJson(data) as T;
    }
    if (t == _i159.PaymentTransactionRow) {
      return _i159.PaymentTransactionRow.fromJson(data) as T;
    }
    if (t == _i160.ProductRow) {
      return _i160.ProductRow.fromJson(data) as T;
    }
    if (t == _i161.ProductSearchDocumentRow) {
      return _i161.ProductSearchDocumentRow.fromJson(data) as T;
    }
    if (t == _i162.ProductSearchRebuildJobRow) {
      return _i162.ProductSearchRebuildJobRow.fromJson(data) as T;
    }
    if (t == _i163.ProductVariantRow) {
      return _i163.ProductVariantRow.fromJson(data) as T;
    }
    if (t == _i164.ReferralRow) {
      return _i164.ReferralRow.fromJson(data) as T;
    }
    if (t == _i165.ReferralSettingsRow) {
      return _i165.ReferralSettingsRow.fromJson(data) as T;
    }
    if (t == _i166.RefundRecordRow) {
      return _i166.RefundRecordRow.fromJson(data) as T;
    }
    if (t == _i167.ShopMoreGetMoreOfferRow) {
      return _i167.ShopMoreGetMoreOfferRow.fromJson(data) as T;
    }
    if (t == _i168.SubCategoryRow) {
      return _i168.SubCategoryRow.fromJson(data) as T;
    }
    if (t == _i169.SupportIssueRow) {
      return _i169.SupportIssueRow.fromJson(data) as T;
    }
    if (t == _i170.UserAddressRow) {
      return _i170.UserAddressRow.fromJson(data) as T;
    }
    if (t == _i171.UserCartItemRow) {
      return _i171.UserCartItemRow.fromJson(data) as T;
    }
    if (t == _i172.UserFcmTokenRow) {
      return _i172.UserFcmTokenRow.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ActiveUserStatistics?>()) {
      return (data != null ? _i5.ActiveUserStatistics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.Address?>()) {
      return (data != null ? _i6.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AdminAnalytics?>()) {
      return (data != null ? _i7.AdminAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AdminAuditLogEntry?>()) {
      return (data != null ? _i8.AdminAuditLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AdminAuthResult?>()) {
      return (data != null ? _i9.AdminAuthResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.AdminDashboardHydrated?>()) {
      return (data != null ? _i10.AdminDashboardHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.AdminDashboardStats?>()) {
      return (data != null ? _i11.AdminDashboardStats.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.AdminNotificationPreference?>()) {
      return (data != null
              ? _i12.AdminNotificationPreference.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.AdminTopProduct?>()) {
      return (data != null ? _i13.AdminTopProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ApiResponse?>()) {
      return (data != null ? _i14.ApiResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.AppUser?>()) {
      return (data != null ? _i15.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.AppliedCouponInfo?>()) {
      return (data != null ? _i16.AppliedCouponInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.AppliedOfferInfo?>()) {
      return (data != null ? _i17.AppliedOfferInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Banner?>()) {
      return (data != null ? _i18.Banner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.BannerPage?>()) {
      return (data != null ? _i19.BannerPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.BasketSuggestion?>()) {
      return (data != null ? _i20.BasketSuggestion.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.BasketSuggestionAction?>()) {
      return (data != null ? _i21.BasketSuggestionAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.BasketSuggestionResult?>()) {
      return (data != null ? _i22.BasketSuggestionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.BestCouponResult?>()) {
      return (data != null ? _i23.BestCouponResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.BogoFreeProduct?>()) {
      return (data != null ? _i24.BogoFreeProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.BogoOffer?>()) {
      return (data != null ? _i25.BogoOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.BogoOfferPage?>()) {
      return (data != null ? _i26.BogoOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.BroadcastPage?>()) {
      return (data != null ? _i27.BroadcastPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.BroadcastRequest?>()) {
      return (data != null ? _i28.BroadcastRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.BroadcastSummary?>()) {
      return (data != null ? _i29.BroadcastSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.CartComparisonData?>()) {
      return (data != null ? _i30.CartComparisonData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.CartHydratedData?>()) {
      return (data != null ? _i31.CartHydratedData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.CartItem?>()) {
      return (data != null ? _i32.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.CartItemInput?>()) {
      return (data != null ? _i33.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.CartItemSnapshot?>()) {
      return (data != null ? _i34.CartItemSnapshot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.CartPricingResult?>()) {
      return (data != null ? _i35.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.CascadeEntityInfo?>()) {
      return (data != null ? _i36.CascadeEntityInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.CascadeExecuteResponse?>()) {
      return (data != null ? _i37.CascadeExecuteResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.CascadeImpactResponse?>()) {
      return (data != null ? _i38.CascadeImpactResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.Category?>()) {
      return (data != null ? _i39.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.CategoryHierarchy?>()) {
      return (data != null ? _i40.CategoryHierarchy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.CategoryOffer?>()) {
      return (data != null ? _i41.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.CategoryOfferPage?>()) {
      return (data != null ? _i42.CategoryOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.CheckoutInitHydrated?>()) {
      return (data != null ? _i43.CheckoutInitHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.CheckoutResult?>()) {
      return (data != null ? _i44.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.CodPaymentReceipt?>()) {
      return (data != null ? _i45.CodPaymentReceipt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.ComboOffer?>()) {
      return (data != null ? _i46.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.ComboOfferPage?>()) {
      return (data != null ? _i47.ComboOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.ComboProductItem?>()) {
      return (data != null ? _i48.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.Complaint?>()) {
      return (data != null ? _i49.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.ComplaintDetailHydrated?>()) {
      return (data != null ? _i50.ComplaintDetailHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.ComplaintPage?>()) {
      return (data != null ? _i51.ComplaintPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.ComplaintProductItem?>()) {
      return (data != null ? _i52.ComplaintProductItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.Coupon?>()) {
      return (data != null ? _i53.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.CouponDisplay?>()) {
      return (data != null ? _i54.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.CouponValidationResult?>()) {
      return (data != null ? _i55.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.DeleteImpactReference?>()) {
      return (data != null ? _i56.DeleteImpactReference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.DeleteImpactResponse?>()) {
      return (data != null ? _i57.DeleteImpactResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.DeliveryConfig?>()) {
      return (data != null ? _i58.DeliveryConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.DeliveryPricingResult?>()) {
      return (data != null ? _i59.DeliveryPricingResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.DeliveryRule?>()) {
      return (data != null ? _i60.DeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.DeliveryRulePage?>()) {
      return (data != null ? _i61.DeliveryRulePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.DeliverySettings?>()) {
      return (data != null ? _i62.DeliverySettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.DeliverySlab?>()) {
      return (data != null ? _i63.DeliverySlab.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.FreeDeliveryHydrated?>()) {
      return (data != null ? _i64.FreeDeliveryHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i65.FreeDeliveryRule?>()) {
      return (data != null ? _i65.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.FreeDeliveryRulePage?>()) {
      return (data != null ? _i66.FreeDeliveryRulePage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i67.FreeItemInfo?>()) {
      return (data != null ? _i67.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.FreshPointsAdjustRequest?>()) {
      return (data != null
              ? _i68.FreshPointsAdjustRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i69.FreshPointsBalance?>()) {
      return (data != null ? _i69.FreshPointsBalance.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i70.FreshPointsSettings?>()) {
      return (data != null ? _i70.FreshPointsSettings.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i71.FreshPointsTransaction?>()) {
      return (data != null ? _i71.FreshPointsTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i72.HardDeleteResponse?>()) {
      return (data != null ? _i72.HardDeleteResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.HomePageHydratedData?>()) {
      return (data != null ? _i73.HomePageHydratedData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i74.NotificationDraft?>()) {
      return (data != null ? _i74.NotificationDraft.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.NotificationHistoryItem?>()) {
      return (data != null ? _i75.NotificationHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i76.NotificationHistoryPage?>()) {
      return (data != null ? _i76.NotificationHistoryPage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i77.NotificationPreference?>()) {
      return (data != null ? _i77.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i78.OfferConflictResponse?>()) {
      return (data != null ? _i78.OfferConflictResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i79.OfferMutationResult?>()) {
      return (data != null ? _i79.OfferMutationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i80.OfferSearchItem?>()) {
      return (data != null ? _i80.OfferSearchItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i81.OfferSearchPage?>()) {
      return (data != null ? _i81.OfferSearchPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i82.Order?>()) {
      return (data != null ? _i82.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i83.OrderDetailHydrated?>()) {
      return (data != null ? _i83.OrderDetailHydrated.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i84.OrderItem?>()) {
      return (data != null ? _i84.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i85.OrderPage?>()) {
      return (data != null ? _i85.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i86.OrderRealtimeEvent?>()) {
      return (data != null ? _i86.OrderRealtimeEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i87.OrderTrackingData?>()) {
      return (data != null ? _i87.OrderTrackingData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i88.PaymentActionResult?>()) {
      return (data != null ? _i88.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i89.PaymentEvent?>()) {
      return (data != null ? _i89.PaymentEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i90.PaymentLinkData?>()) {
      return (data != null ? _i90.PaymentLinkData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i91.PaymentOrderDetailHydrated?>()) {
      return (data != null
              ? _i91.PaymentOrderDetailHydrated.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i92.PaymentOrderResult?>()) {
      return (data != null ? _i92.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i93.PaymentPageData?>()) {
      return (data != null ? _i93.PaymentPageData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.PaymentPageItem?>()) {
      return (data != null ? _i94.PaymentPageItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.PaymentSessionData?>()) {
      return (data != null ? _i95.PaymentSessionData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i96.PaymentTransaction?>()) {
      return (data != null ? _i96.PaymentTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i97.PaymentVerifyResult?>()) {
      return (data != null ? _i97.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i98.PendingOrderInfo?>()) {
      return (data != null ? _i98.PendingOrderInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i99.PricingLineItem?>()) {
      return (data != null ? _i99.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.Product?>()) {
      return (data != null ? _i100.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i101.ProductFormReferenceData?>()) {
      return (data != null
              ? _i101.ProductFormReferenceData.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i102.ProductPage?>()) {
      return (data != null ? _i102.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i103.ProductRankingItem?>()) {
      return (data != null ? _i103.ProductRankingItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i104.ProductVariant?>()) {
      return (data != null ? _i104.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i105.RazorpayPaymentStatus?>()) {
      return (data != null ? _i105.RazorpayPaymentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i106.RazorpayRefundData?>()) {
      return (data != null ? _i106.RazorpayRefundData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i107.Referral?>()) {
      return (data != null ? _i107.Referral.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i108.ReferralActivity?>()) {
      return (data != null ? _i108.ReferralActivity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i109.ReferralAdminStats?>()) {
      return (data != null ? _i109.ReferralAdminStats.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i110.ReferralCodeInfo?>()) {
      return (data != null ? _i110.ReferralCodeInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i111.ReferralFraudResult?>()) {
      return (data != null ? _i111.ReferralFraudResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i112.ReferralFraudRuleResult?>()) {
      return (data != null
              ? _i112.ReferralFraudRuleResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i113.ReferralOnboardingStatus?>()) {
      return (data != null
              ? _i113.ReferralOnboardingStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i114.ReferralSettings?>()) {
      return (data != null ? _i114.ReferralSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i115.ReferralValidationResult?>()) {
      return (data != null
              ? _i115.ReferralValidationResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i116.RefundRecord?>()) {
      return (data != null ? _i116.RefundRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i117.RegisterFcmTokenRequest?>()) {
      return (data != null
              ? _i117.RegisterFcmTokenRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i118.ShopMoreGetMoreOffer?>()) {
      return (data != null ? _i118.ShopMoreGetMoreOffer.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i119.ShopMoreGetMoreOfferPage?>()) {
      return (data != null
              ? _i119.ShopMoreGetMoreOfferPage.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i120.SmgmAnalytics?>()) {
      return (data != null ? _i120.SmgmAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i121.SubCategory?>()) {
      return (data != null ? _i121.SubCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i122.SupportIssue?>()) {
      return (data != null ? _i122.SupportIssue.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i123.TopReferrerEntry?>()) {
      return (data != null ? _i123.TopReferrerEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i124.AdminAuditLogRow?>()) {
      return (data != null ? _i124.AdminAuditLogRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i125.AdminNotificationPreferenceRow?>()) {
      return (data != null
              ? _i125.AdminNotificationPreferenceRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i126.AppUserRow?>()) {
      return (data != null ? _i126.AppUserRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i127.AutoRefundJobRow?>()) {
      return (data != null ? _i127.AutoRefundJobRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i128.BannerRow?>()) {
      return (data != null ? _i128.BannerRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i129.BogoOfferRewardRow?>()) {
      return (data != null ? _i129.BogoOfferRewardRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i130.BogoOfferRow?>()) {
      return (data != null ? _i130.BogoOfferRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i131.CategoryOfferRow?>()) {
      return (data != null ? _i131.CategoryOfferRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i132.CategoryRow?>()) {
      return (data != null ? _i132.CategoryRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i133.CodFailureRecord?>()) {
      return (data != null ? _i133.CodFailureRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i134.CodSettingsRow?>()) {
      return (data != null ? _i134.CodSettingsRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i135.ComboOfferItemRow?>()) {
      return (data != null ? _i135.ComboOfferItemRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i136.ComboOfferRow?>()) {
      return (data != null ? _i136.ComboOfferRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i137.ComplaintRow?>()) {
      return (data != null ? _i137.ComplaintRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i138.CouponRow?>()) {
      return (data != null ? _i138.CouponRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i139.CustomerOrderRow?>()) {
      return (data != null ? _i139.CustomerOrderRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i140.DeliveryConfigRow?>()) {
      return (data != null ? _i140.DeliveryConfigRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i141.DeliveryOtpRow?>()) {
      return (data != null ? _i141.DeliveryOtpRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i142.DeliveryRuleRow?>()) {
      return (data != null ? _i142.DeliveryRuleRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i143.DeliverySettingsRow?>()) {
      return (data != null ? _i143.DeliverySettingsRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i144.DeliverySlabRow?>()) {
      return (data != null ? _i144.DeliverySlabRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i145.FreeDeliveryRuleRow?>()) {
      return (data != null ? _i145.FreeDeliveryRuleRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i146.FreshPointsSettingsRow?>()) {
      return (data != null ? _i146.FreshPointsSettingsRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i147.FreshPointsTransactionRow?>()) {
      return (data != null
              ? _i147.FreshPointsTransactionRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i148.IdempotencyRecordRow?>()) {
      return (data != null ? _i148.IdempotencyRecordRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i149.NotificationCampaignRow?>()) {
      return (data != null
              ? _i149.NotificationCampaignRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i150.NotificationOutboxRow?>()) {
      return (data != null ? _i150.NotificationOutboxRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i151.NotificationPreferenceRow?>()) {
      return (data != null
              ? _i151.NotificationPreferenceRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i152.NotificationUserStateRow?>()) {
      return (data != null
              ? _i152.NotificationUserStateRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i153.OrderAddressRow?>()) {
      return (data != null ? _i153.OrderAddressRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i154.OrderItemRow?>()) {
      return (data != null ? _i154.OrderItemRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i155.OrderNotificationOutboxRow?>()) {
      return (data != null
              ? _i155.OrderNotificationOutboxRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i156.OrderTrackingRow?>()) {
      return (data != null ? _i156.OrderTrackingRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i157.PaymentLinkRow?>()) {
      return (data != null ? _i157.PaymentLinkRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i158.PaymentSessionRow?>()) {
      return (data != null ? _i158.PaymentSessionRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i159.PaymentTransactionRow?>()) {
      return (data != null ? _i159.PaymentTransactionRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i160.ProductRow?>()) {
      return (data != null ? _i160.ProductRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i161.ProductSearchDocumentRow?>()) {
      return (data != null
              ? _i161.ProductSearchDocumentRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i162.ProductSearchRebuildJobRow?>()) {
      return (data != null
              ? _i162.ProductSearchRebuildJobRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i163.ProductVariantRow?>()) {
      return (data != null ? _i163.ProductVariantRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i164.ReferralRow?>()) {
      return (data != null ? _i164.ReferralRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i165.ReferralSettingsRow?>()) {
      return (data != null ? _i165.ReferralSettingsRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i166.RefundRecordRow?>()) {
      return (data != null ? _i166.RefundRecordRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i167.ShopMoreGetMoreOfferRow?>()) {
      return (data != null
              ? _i167.ShopMoreGetMoreOfferRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i168.SubCategoryRow?>()) {
      return (data != null ? _i168.SubCategoryRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i169.SupportIssueRow?>()) {
      return (data != null ? _i169.SupportIssueRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i170.UserAddressRow?>()) {
      return (data != null ? _i170.UserAddressRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i171.UserCartItemRow?>()) {
      return (data != null ? _i171.UserCartItemRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i172.UserFcmTokenRow?>()) {
      return (data != null ? _i172.UserFcmTokenRow.fromJson(data) : null) as T;
    }
    if (t == List<_i13.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i13.AdminTopProduct>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.CartItem>) {
      return (data as List).map((e) => deserialize<_i32.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i32.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i32.CartItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i18.Banner>) {
      return (data as List).map((e) => deserialize<_i18.Banner>(e)).toList()
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == List<_i21.BasketSuggestionAction>) {
      return (data as List)
              .map((e) => deserialize<_i21.BasketSuggestionAction>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i21.BasketSuggestionAction>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i21.BasketSuggestionAction>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i20.BasketSuggestion>) {
      return (data as List)
              .map((e) => deserialize<_i20.BasketSuggestion>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i20.BasketSuggestion>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i20.BasketSuggestion>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i24.BogoFreeProduct>) {
      return (data as List)
              .map((e) => deserialize<_i24.BogoFreeProduct>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i24.BogoFreeProduct>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i24.BogoFreeProduct>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i25.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i25.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i29.BroadcastSummary>) {
      return (data as List)
              .map((e) => deserialize<_i29.BroadcastSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.CartItemSnapshot>) {
      return (data as List)
              .map((e) => deserialize<_i34.CartItemSnapshot>(e))
              .toList()
          as T;
    }
    if (t == List<_i54.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i54.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i17.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i67.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i67.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i99.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i99.PricingLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.CascadeEntityInfo>) {
      return (data as List)
              .map((e) => deserialize<_i36.CascadeEntityInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.Category>) {
      return (data as List).map((e) => deserialize<_i39.Category>(e)).toList()
          as T;
    }
    if (t == List<_i121.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i121.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i41.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i41.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i48.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i48.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i46.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i46.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i52.ComplaintProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i52.ComplaintProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i49.Complaint>) {
      return (data as List).map((e) => deserialize<_i49.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i56.DeleteImpactReference>) {
      return (data as List)
              .map((e) => deserialize<_i56.DeleteImpactReference>(e))
              .toList()
          as T;
    }
    if (t == List<_i63.DeliverySlab>) {
      return (data as List)
              .map((e) => deserialize<_i63.DeliverySlab>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i60.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i65.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i65.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i71.FreshPointsTransaction>) {
      return (data as List)
              .map((e) => deserialize<_i71.FreshPointsTransaction>(e))
              .toList()
          as T;
    }
    if (t == List<_i100.Product>) {
      return (data as List).map((e) => deserialize<_i100.Product>(e)).toList()
          as T;
    }
    if (t == List<_i75.NotificationHistoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i75.NotificationHistoryItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i100.Product>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i100.Product>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i80.OfferSearchItem>) {
      return (data as List)
              .map((e) => deserialize<_i80.OfferSearchItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i84.OrderItem>) {
      return (data as List).map((e) => deserialize<_i84.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i82.Order>) {
      return (data as List).map((e) => deserialize<_i82.Order>(e)).toList()
          as T;
    }
    if (t == List<_i116.RefundRecord>) {
      return (data as List)
              .map((e) => deserialize<_i116.RefundRecord>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i116.RefundRecord>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i116.RefundRecord>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i94.PaymentPageItem>) {
      return (data as List)
              .map((e) => deserialize<_i94.PaymentPageItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i94.PaymentPageItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i94.PaymentPageItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i104.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i104.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i104.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i104.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i123.TopReferrerEntry>) {
      return (data as List)
              .map((e) => deserialize<_i123.TopReferrerEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i112.ReferralFraudRuleResult>) {
      return (data as List)
              .map((e) => deserialize<_i112.ReferralFraudRuleResult>(e))
              .toList()
          as T;
    }
    if (t == List<_i118.ShopMoreGetMoreOffer>) {
      return (data as List)
              .map((e) => deserialize<_i118.ShopMoreGetMoreOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i173.AppUser>) {
      return (data as List).map((e) => deserialize<_i173.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i174.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i174.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i175.ActiveUserStatistics>) {
      return (data as List)
              .map((e) => deserialize<_i175.ActiveUserStatistics>(e))
              .toList()
          as T;
    }
    if (t == List<_i176.Banner>) {
      return (data as List).map((e) => deserialize<_i176.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i177.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i177.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i178.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i178.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i179.Category>) {
      return (data as List).map((e) => deserialize<_i179.Category>(e)).toList()
          as T;
    }
    if (t == List<_i180.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i180.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i181.ComboOffer>) {
      return (data as List)
              .map((e) => deserialize<_i181.ComboOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i182.Coupon>) {
      return (data as List).map((e) => deserialize<_i182.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i183.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i183.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i184.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i184.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i178.CartItemInput>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i178.CartItemInput>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i185.AdminNotificationPreference>) {
      return (data as List)
              .map((e) => deserialize<_i185.AdminNotificationPreference>(e))
              .toList()
          as T;
    }
    if (t == List<_i186.Order>) {
      return (data as List).map((e) => deserialize<_i186.Order>(e)).toList()
          as T;
    }
    if (t == _i1.getType<Map<String, dynamic>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
                )
              : null)
          as T;
    }
    if (t == List<List<double>>) {
      return (data as List).map((e) => deserialize<List<double>>(e)).toList()
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<_i187.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i187.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i188.Product>) {
      return (data as List).map((e) => deserialize<_i188.Product>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i189.ProductRankingItem>) {
      return (data as List)
              .map((e) => deserialize<_i189.ProductRankingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i190.ReferralActivity>) {
      return (data as List)
              .map((e) => deserialize<_i190.ReferralActivity>(e))
              .toList()
          as T;
    }
    if (t == List<_i191.ShopMoreGetMoreOffer>) {
      return (data as List)
              .map((e) => deserialize<_i191.ShopMoreGetMoreOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i192.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i192.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i193.SupportIssue>) {
      return (data as List)
              .map((e) => deserialize<_i193.SupportIssue>(e))
              .toList()
          as T;
    }
    if (t == List<_i194.CartItem>) {
      return (data as List).map((e) => deserialize<_i194.CartItem>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.ActiveUserStatistics => 'ActiveUserStatistics',
      _i6.Address => 'Address',
      _i7.AdminAnalytics => 'AdminAnalytics',
      _i8.AdminAuditLogEntry => 'AdminAuditLogEntry',
      _i9.AdminAuthResult => 'AdminAuthResult',
      _i10.AdminDashboardHydrated => 'AdminDashboardHydrated',
      _i11.AdminDashboardStats => 'AdminDashboardStats',
      _i12.AdminNotificationPreference => 'AdminNotificationPreference',
      _i13.AdminTopProduct => 'AdminTopProduct',
      _i14.ApiResponse => 'ApiResponse',
      _i15.AppUser => 'AppUser',
      _i16.AppliedCouponInfo => 'AppliedCouponInfo',
      _i17.AppliedOfferInfo => 'AppliedOfferInfo',
      _i18.Banner => 'Banner',
      _i19.BannerPage => 'BannerPage',
      _i20.BasketSuggestion => 'BasketSuggestion',
      _i21.BasketSuggestionAction => 'BasketSuggestionAction',
      _i22.BasketSuggestionResult => 'BasketSuggestionResult',
      _i23.BestCouponResult => 'BestCouponResult',
      _i24.BogoFreeProduct => 'BogoFreeProduct',
      _i25.BogoOffer => 'BogoOffer',
      _i26.BogoOfferPage => 'BogoOfferPage',
      _i27.BroadcastPage => 'BroadcastPage',
      _i28.BroadcastRequest => 'BroadcastRequest',
      _i29.BroadcastSummary => 'BroadcastSummary',
      _i30.CartComparisonData => 'CartComparisonData',
      _i31.CartHydratedData => 'CartHydratedData',
      _i32.CartItem => 'CartItem',
      _i33.CartItemInput => 'CartItemInput',
      _i34.CartItemSnapshot => 'CartItemSnapshot',
      _i35.CartPricingResult => 'CartPricingResult',
      _i36.CascadeEntityInfo => 'CascadeEntityInfo',
      _i37.CascadeExecuteResponse => 'CascadeExecuteResponse',
      _i38.CascadeImpactResponse => 'CascadeImpactResponse',
      _i39.Category => 'Category',
      _i40.CategoryHierarchy => 'CategoryHierarchy',
      _i41.CategoryOffer => 'CategoryOffer',
      _i42.CategoryOfferPage => 'CategoryOfferPage',
      _i43.CheckoutInitHydrated => 'CheckoutInitHydrated',
      _i44.CheckoutResult => 'CheckoutResult',
      _i45.CodPaymentReceipt => 'CodPaymentReceipt',
      _i46.ComboOffer => 'ComboOffer',
      _i47.ComboOfferPage => 'ComboOfferPage',
      _i48.ComboProductItem => 'ComboProductItem',
      _i49.Complaint => 'Complaint',
      _i50.ComplaintDetailHydrated => 'ComplaintDetailHydrated',
      _i51.ComplaintPage => 'ComplaintPage',
      _i52.ComplaintProductItem => 'ComplaintProductItem',
      _i53.Coupon => 'Coupon',
      _i54.CouponDisplay => 'CouponDisplay',
      _i55.CouponValidationResult => 'CouponValidationResult',
      _i56.DeleteImpactReference => 'DeleteImpactReference',
      _i57.DeleteImpactResponse => 'DeleteImpactResponse',
      _i58.DeliveryConfig => 'DeliveryConfig',
      _i59.DeliveryPricingResult => 'DeliveryPricingResult',
      _i60.DeliveryRule => 'DeliveryRule',
      _i61.DeliveryRulePage => 'DeliveryRulePage',
      _i62.DeliverySettings => 'DeliverySettings',
      _i63.DeliverySlab => 'DeliverySlab',
      _i64.FreeDeliveryHydrated => 'FreeDeliveryHydrated',
      _i65.FreeDeliveryRule => 'FreeDeliveryRule',
      _i66.FreeDeliveryRulePage => 'FreeDeliveryRulePage',
      _i67.FreeItemInfo => 'FreeItemInfo',
      _i68.FreshPointsAdjustRequest => 'FreshPointsAdjustRequest',
      _i69.FreshPointsBalance => 'FreshPointsBalance',
      _i70.FreshPointsSettings => 'FreshPointsSettings',
      _i71.FreshPointsTransaction => 'FreshPointsTransaction',
      _i72.HardDeleteResponse => 'HardDeleteResponse',
      _i73.HomePageHydratedData => 'HomePageHydratedData',
      _i74.NotificationDraft => 'NotificationDraft',
      _i75.NotificationHistoryItem => 'NotificationHistoryItem',
      _i76.NotificationHistoryPage => 'NotificationHistoryPage',
      _i77.NotificationPreference => 'NotificationPreference',
      _i78.OfferConflictResponse => 'OfferConflictResponse',
      _i79.OfferMutationResult => 'OfferMutationResult',
      _i80.OfferSearchItem => 'OfferSearchItem',
      _i81.OfferSearchPage => 'OfferSearchPage',
      _i82.Order => 'Order',
      _i83.OrderDetailHydrated => 'OrderDetailHydrated',
      _i84.OrderItem => 'OrderItem',
      _i85.OrderPage => 'OrderPage',
      _i86.OrderRealtimeEvent => 'OrderRealtimeEvent',
      _i87.OrderTrackingData => 'OrderTrackingData',
      _i88.PaymentActionResult => 'PaymentActionResult',
      _i89.PaymentEvent => 'PaymentEvent',
      _i90.PaymentLinkData => 'PaymentLinkData',
      _i91.PaymentOrderDetailHydrated => 'PaymentOrderDetailHydrated',
      _i92.PaymentOrderResult => 'PaymentOrderResult',
      _i93.PaymentPageData => 'PaymentPageData',
      _i94.PaymentPageItem => 'PaymentPageItem',
      _i95.PaymentSessionData => 'PaymentSessionData',
      _i96.PaymentTransaction => 'PaymentTransaction',
      _i97.PaymentVerifyResult => 'PaymentVerifyResult',
      _i98.PendingOrderInfo => 'PendingOrderInfo',
      _i99.PricingLineItem => 'PricingLineItem',
      _i100.Product => 'Product',
      _i101.ProductFormReferenceData => 'ProductFormReferenceData',
      _i102.ProductPage => 'ProductPage',
      _i103.ProductRankingItem => 'ProductRankingItem',
      _i104.ProductVariant => 'ProductVariant',
      _i105.RazorpayPaymentStatus => 'RazorpayPaymentStatus',
      _i106.RazorpayRefundData => 'RazorpayRefundData',
      _i107.Referral => 'Referral',
      _i108.ReferralActivity => 'ReferralActivity',
      _i109.ReferralAdminStats => 'ReferralAdminStats',
      _i110.ReferralCodeInfo => 'ReferralCodeInfo',
      _i111.ReferralFraudResult => 'ReferralFraudResult',
      _i112.ReferralFraudRuleResult => 'ReferralFraudRuleResult',
      _i113.ReferralOnboardingStatus => 'ReferralOnboardingStatus',
      _i114.ReferralSettings => 'ReferralSettings',
      _i115.ReferralValidationResult => 'ReferralValidationResult',
      _i116.RefundRecord => 'RefundRecord',
      _i117.RegisterFcmTokenRequest => 'RegisterFcmTokenRequest',
      _i118.ShopMoreGetMoreOffer => 'ShopMoreGetMoreOffer',
      _i119.ShopMoreGetMoreOfferPage => 'ShopMoreGetMoreOfferPage',
      _i120.SmgmAnalytics => 'SmgmAnalytics',
      _i121.SubCategory => 'SubCategory',
      _i122.SupportIssue => 'SupportIssue',
      _i123.TopReferrerEntry => 'TopReferrerEntry',
      _i124.AdminAuditLogRow => 'AdminAuditLogRow',
      _i125.AdminNotificationPreferenceRow => 'AdminNotificationPreferenceRow',
      _i126.AppUserRow => 'AppUserRow',
      _i127.AutoRefundJobRow => 'AutoRefundJobRow',
      _i128.BannerRow => 'BannerRow',
      _i129.BogoOfferRewardRow => 'BogoOfferRewardRow',
      _i130.BogoOfferRow => 'BogoOfferRow',
      _i131.CategoryOfferRow => 'CategoryOfferRow',
      _i132.CategoryRow => 'CategoryRow',
      _i133.CodFailureRecord => 'CodFailureRecord',
      _i134.CodSettingsRow => 'CodSettingsRow',
      _i135.ComboOfferItemRow => 'ComboOfferItemRow',
      _i136.ComboOfferRow => 'ComboOfferRow',
      _i137.ComplaintRow => 'ComplaintRow',
      _i138.CouponRow => 'CouponRow',
      _i139.CustomerOrderRow => 'CustomerOrderRow',
      _i140.DeliveryConfigRow => 'DeliveryConfigRow',
      _i141.DeliveryOtpRow => 'DeliveryOtpRow',
      _i142.DeliveryRuleRow => 'DeliveryRuleRow',
      _i143.DeliverySettingsRow => 'DeliverySettingsRow',
      _i144.DeliverySlabRow => 'DeliverySlabRow',
      _i145.FreeDeliveryRuleRow => 'FreeDeliveryRuleRow',
      _i146.FreshPointsSettingsRow => 'FreshPointsSettingsRow',
      _i147.FreshPointsTransactionRow => 'FreshPointsTransactionRow',
      _i148.IdempotencyRecordRow => 'IdempotencyRecordRow',
      _i149.NotificationCampaignRow => 'NotificationCampaignRow',
      _i150.NotificationOutboxRow => 'NotificationOutboxRow',
      _i151.NotificationPreferenceRow => 'NotificationPreferenceRow',
      _i152.NotificationUserStateRow => 'NotificationUserStateRow',
      _i153.OrderAddressRow => 'OrderAddressRow',
      _i154.OrderItemRow => 'OrderItemRow',
      _i155.OrderNotificationOutboxRow => 'OrderNotificationOutboxRow',
      _i156.OrderTrackingRow => 'OrderTrackingRow',
      _i157.PaymentLinkRow => 'PaymentLinkRow',
      _i158.PaymentSessionRow => 'PaymentSessionRow',
      _i159.PaymentTransactionRow => 'PaymentTransactionRow',
      _i160.ProductRow => 'ProductRow',
      _i161.ProductSearchDocumentRow => 'ProductSearchDocumentRow',
      _i162.ProductSearchRebuildJobRow => 'ProductSearchRebuildJobRow',
      _i163.ProductVariantRow => 'ProductVariantRow',
      _i164.ReferralRow => 'ReferralRow',
      _i165.ReferralSettingsRow => 'ReferralSettingsRow',
      _i166.RefundRecordRow => 'RefundRecordRow',
      _i167.ShopMoreGetMoreOfferRow => 'ShopMoreGetMoreOfferRow',
      _i168.SubCategoryRow => 'SubCategoryRow',
      _i169.SupportIssueRow => 'SupportIssueRow',
      _i170.UserAddressRow => 'UserAddressRow',
      _i171.UserCartItemRow => 'UserCartItemRow',
      _i172.UserFcmTokenRow => 'UserFcmTokenRow',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'freshpickkat.',
        '',
      );
    }

    switch (data) {
      case _i5.ActiveUserStatistics():
        return 'ActiveUserStatistics';
      case _i6.Address():
        return 'Address';
      case _i7.AdminAnalytics():
        return 'AdminAnalytics';
      case _i8.AdminAuditLogEntry():
        return 'AdminAuditLogEntry';
      case _i9.AdminAuthResult():
        return 'AdminAuthResult';
      case _i10.AdminDashboardHydrated():
        return 'AdminDashboardHydrated';
      case _i11.AdminDashboardStats():
        return 'AdminDashboardStats';
      case _i12.AdminNotificationPreference():
        return 'AdminNotificationPreference';
      case _i13.AdminTopProduct():
        return 'AdminTopProduct';
      case _i14.ApiResponse():
        return 'ApiResponse';
      case _i15.AppUser():
        return 'AppUser';
      case _i16.AppliedCouponInfo():
        return 'AppliedCouponInfo';
      case _i17.AppliedOfferInfo():
        return 'AppliedOfferInfo';
      case _i18.Banner():
        return 'Banner';
      case _i19.BannerPage():
        return 'BannerPage';
      case _i20.BasketSuggestion():
        return 'BasketSuggestion';
      case _i21.BasketSuggestionAction():
        return 'BasketSuggestionAction';
      case _i22.BasketSuggestionResult():
        return 'BasketSuggestionResult';
      case _i23.BestCouponResult():
        return 'BestCouponResult';
      case _i24.BogoFreeProduct():
        return 'BogoFreeProduct';
      case _i25.BogoOffer():
        return 'BogoOffer';
      case _i26.BogoOfferPage():
        return 'BogoOfferPage';
      case _i27.BroadcastPage():
        return 'BroadcastPage';
      case _i28.BroadcastRequest():
        return 'BroadcastRequest';
      case _i29.BroadcastSummary():
        return 'BroadcastSummary';
      case _i30.CartComparisonData():
        return 'CartComparisonData';
      case _i31.CartHydratedData():
        return 'CartHydratedData';
      case _i32.CartItem():
        return 'CartItem';
      case _i33.CartItemInput():
        return 'CartItemInput';
      case _i34.CartItemSnapshot():
        return 'CartItemSnapshot';
      case _i35.CartPricingResult():
        return 'CartPricingResult';
      case _i36.CascadeEntityInfo():
        return 'CascadeEntityInfo';
      case _i37.CascadeExecuteResponse():
        return 'CascadeExecuteResponse';
      case _i38.CascadeImpactResponse():
        return 'CascadeImpactResponse';
      case _i39.Category():
        return 'Category';
      case _i40.CategoryHierarchy():
        return 'CategoryHierarchy';
      case _i41.CategoryOffer():
        return 'CategoryOffer';
      case _i42.CategoryOfferPage():
        return 'CategoryOfferPage';
      case _i43.CheckoutInitHydrated():
        return 'CheckoutInitHydrated';
      case _i44.CheckoutResult():
        return 'CheckoutResult';
      case _i45.CodPaymentReceipt():
        return 'CodPaymentReceipt';
      case _i46.ComboOffer():
        return 'ComboOffer';
      case _i47.ComboOfferPage():
        return 'ComboOfferPage';
      case _i48.ComboProductItem():
        return 'ComboProductItem';
      case _i49.Complaint():
        return 'Complaint';
      case _i50.ComplaintDetailHydrated():
        return 'ComplaintDetailHydrated';
      case _i51.ComplaintPage():
        return 'ComplaintPage';
      case _i52.ComplaintProductItem():
        return 'ComplaintProductItem';
      case _i53.Coupon():
        return 'Coupon';
      case _i54.CouponDisplay():
        return 'CouponDisplay';
      case _i55.CouponValidationResult():
        return 'CouponValidationResult';
      case _i56.DeleteImpactReference():
        return 'DeleteImpactReference';
      case _i57.DeleteImpactResponse():
        return 'DeleteImpactResponse';
      case _i58.DeliveryConfig():
        return 'DeliveryConfig';
      case _i59.DeliveryPricingResult():
        return 'DeliveryPricingResult';
      case _i60.DeliveryRule():
        return 'DeliveryRule';
      case _i61.DeliveryRulePage():
        return 'DeliveryRulePage';
      case _i62.DeliverySettings():
        return 'DeliverySettings';
      case _i63.DeliverySlab():
        return 'DeliverySlab';
      case _i64.FreeDeliveryHydrated():
        return 'FreeDeliveryHydrated';
      case _i65.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i66.FreeDeliveryRulePage():
        return 'FreeDeliveryRulePage';
      case _i67.FreeItemInfo():
        return 'FreeItemInfo';
      case _i68.FreshPointsAdjustRequest():
        return 'FreshPointsAdjustRequest';
      case _i69.FreshPointsBalance():
        return 'FreshPointsBalance';
      case _i70.FreshPointsSettings():
        return 'FreshPointsSettings';
      case _i71.FreshPointsTransaction():
        return 'FreshPointsTransaction';
      case _i72.HardDeleteResponse():
        return 'HardDeleteResponse';
      case _i73.HomePageHydratedData():
        return 'HomePageHydratedData';
      case _i74.NotificationDraft():
        return 'NotificationDraft';
      case _i75.NotificationHistoryItem():
        return 'NotificationHistoryItem';
      case _i76.NotificationHistoryPage():
        return 'NotificationHistoryPage';
      case _i77.NotificationPreference():
        return 'NotificationPreference';
      case _i78.OfferConflictResponse():
        return 'OfferConflictResponse';
      case _i79.OfferMutationResult():
        return 'OfferMutationResult';
      case _i80.OfferSearchItem():
        return 'OfferSearchItem';
      case _i81.OfferSearchPage():
        return 'OfferSearchPage';
      case _i82.Order():
        return 'Order';
      case _i83.OrderDetailHydrated():
        return 'OrderDetailHydrated';
      case _i84.OrderItem():
        return 'OrderItem';
      case _i85.OrderPage():
        return 'OrderPage';
      case _i86.OrderRealtimeEvent():
        return 'OrderRealtimeEvent';
      case _i87.OrderTrackingData():
        return 'OrderTrackingData';
      case _i88.PaymentActionResult():
        return 'PaymentActionResult';
      case _i89.PaymentEvent():
        return 'PaymentEvent';
      case _i90.PaymentLinkData():
        return 'PaymentLinkData';
      case _i91.PaymentOrderDetailHydrated():
        return 'PaymentOrderDetailHydrated';
      case _i92.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i93.PaymentPageData():
        return 'PaymentPageData';
      case _i94.PaymentPageItem():
        return 'PaymentPageItem';
      case _i95.PaymentSessionData():
        return 'PaymentSessionData';
      case _i96.PaymentTransaction():
        return 'PaymentTransaction';
      case _i97.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i98.PendingOrderInfo():
        return 'PendingOrderInfo';
      case _i99.PricingLineItem():
        return 'PricingLineItem';
      case _i100.Product():
        return 'Product';
      case _i101.ProductFormReferenceData():
        return 'ProductFormReferenceData';
      case _i102.ProductPage():
        return 'ProductPage';
      case _i103.ProductRankingItem():
        return 'ProductRankingItem';
      case _i104.ProductVariant():
        return 'ProductVariant';
      case _i105.RazorpayPaymentStatus():
        return 'RazorpayPaymentStatus';
      case _i106.RazorpayRefundData():
        return 'RazorpayRefundData';
      case _i107.Referral():
        return 'Referral';
      case _i108.ReferralActivity():
        return 'ReferralActivity';
      case _i109.ReferralAdminStats():
        return 'ReferralAdminStats';
      case _i110.ReferralCodeInfo():
        return 'ReferralCodeInfo';
      case _i111.ReferralFraudResult():
        return 'ReferralFraudResult';
      case _i112.ReferralFraudRuleResult():
        return 'ReferralFraudRuleResult';
      case _i113.ReferralOnboardingStatus():
        return 'ReferralOnboardingStatus';
      case _i114.ReferralSettings():
        return 'ReferralSettings';
      case _i115.ReferralValidationResult():
        return 'ReferralValidationResult';
      case _i116.RefundRecord():
        return 'RefundRecord';
      case _i117.RegisterFcmTokenRequest():
        return 'RegisterFcmTokenRequest';
      case _i118.ShopMoreGetMoreOffer():
        return 'ShopMoreGetMoreOffer';
      case _i119.ShopMoreGetMoreOfferPage():
        return 'ShopMoreGetMoreOfferPage';
      case _i120.SmgmAnalytics():
        return 'SmgmAnalytics';
      case _i121.SubCategory():
        return 'SubCategory';
      case _i122.SupportIssue():
        return 'SupportIssue';
      case _i123.TopReferrerEntry():
        return 'TopReferrerEntry';
      case _i124.AdminAuditLogRow():
        return 'AdminAuditLogRow';
      case _i125.AdminNotificationPreferenceRow():
        return 'AdminNotificationPreferenceRow';
      case _i126.AppUserRow():
        return 'AppUserRow';
      case _i127.AutoRefundJobRow():
        return 'AutoRefundJobRow';
      case _i128.BannerRow():
        return 'BannerRow';
      case _i129.BogoOfferRewardRow():
        return 'BogoOfferRewardRow';
      case _i130.BogoOfferRow():
        return 'BogoOfferRow';
      case _i131.CategoryOfferRow():
        return 'CategoryOfferRow';
      case _i132.CategoryRow():
        return 'CategoryRow';
      case _i133.CodFailureRecord():
        return 'CodFailureRecord';
      case _i134.CodSettingsRow():
        return 'CodSettingsRow';
      case _i135.ComboOfferItemRow():
        return 'ComboOfferItemRow';
      case _i136.ComboOfferRow():
        return 'ComboOfferRow';
      case _i137.ComplaintRow():
        return 'ComplaintRow';
      case _i138.CouponRow():
        return 'CouponRow';
      case _i139.CustomerOrderRow():
        return 'CustomerOrderRow';
      case _i140.DeliveryConfigRow():
        return 'DeliveryConfigRow';
      case _i141.DeliveryOtpRow():
        return 'DeliveryOtpRow';
      case _i142.DeliveryRuleRow():
        return 'DeliveryRuleRow';
      case _i143.DeliverySettingsRow():
        return 'DeliverySettingsRow';
      case _i144.DeliverySlabRow():
        return 'DeliverySlabRow';
      case _i145.FreeDeliveryRuleRow():
        return 'FreeDeliveryRuleRow';
      case _i146.FreshPointsSettingsRow():
        return 'FreshPointsSettingsRow';
      case _i147.FreshPointsTransactionRow():
        return 'FreshPointsTransactionRow';
      case _i148.IdempotencyRecordRow():
        return 'IdempotencyRecordRow';
      case _i149.NotificationCampaignRow():
        return 'NotificationCampaignRow';
      case _i150.NotificationOutboxRow():
        return 'NotificationOutboxRow';
      case _i151.NotificationPreferenceRow():
        return 'NotificationPreferenceRow';
      case _i152.NotificationUserStateRow():
        return 'NotificationUserStateRow';
      case _i153.OrderAddressRow():
        return 'OrderAddressRow';
      case _i154.OrderItemRow():
        return 'OrderItemRow';
      case _i155.OrderNotificationOutboxRow():
        return 'OrderNotificationOutboxRow';
      case _i156.OrderTrackingRow():
        return 'OrderTrackingRow';
      case _i157.PaymentLinkRow():
        return 'PaymentLinkRow';
      case _i158.PaymentSessionRow():
        return 'PaymentSessionRow';
      case _i159.PaymentTransactionRow():
        return 'PaymentTransactionRow';
      case _i160.ProductRow():
        return 'ProductRow';
      case _i161.ProductSearchDocumentRow():
        return 'ProductSearchDocumentRow';
      case _i162.ProductSearchRebuildJobRow():
        return 'ProductSearchRebuildJobRow';
      case _i163.ProductVariantRow():
        return 'ProductVariantRow';
      case _i164.ReferralRow():
        return 'ReferralRow';
      case _i165.ReferralSettingsRow():
        return 'ReferralSettingsRow';
      case _i166.RefundRecordRow():
        return 'RefundRecordRow';
      case _i167.ShopMoreGetMoreOfferRow():
        return 'ShopMoreGetMoreOfferRow';
      case _i168.SubCategoryRow():
        return 'SubCategoryRow';
      case _i169.SupportIssueRow():
        return 'SupportIssueRow';
      case _i170.UserAddressRow():
        return 'UserAddressRow';
      case _i171.UserCartItemRow():
        return 'UserCartItemRow';
      case _i172.UserFcmTokenRow():
        return 'UserFcmTokenRow';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ActiveUserStatistics') {
      return deserialize<_i5.ActiveUserStatistics>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i6.Address>(data['data']);
    }
    if (dataClassName == 'AdminAnalytics') {
      return deserialize<_i7.AdminAnalytics>(data['data']);
    }
    if (dataClassName == 'AdminAuditLogEntry') {
      return deserialize<_i8.AdminAuditLogEntry>(data['data']);
    }
    if (dataClassName == 'AdminAuthResult') {
      return deserialize<_i9.AdminAuthResult>(data['data']);
    }
    if (dataClassName == 'AdminDashboardHydrated') {
      return deserialize<_i10.AdminDashboardHydrated>(data['data']);
    }
    if (dataClassName == 'AdminDashboardStats') {
      return deserialize<_i11.AdminDashboardStats>(data['data']);
    }
    if (dataClassName == 'AdminNotificationPreference') {
      return deserialize<_i12.AdminNotificationPreference>(data['data']);
    }
    if (dataClassName == 'AdminTopProduct') {
      return deserialize<_i13.AdminTopProduct>(data['data']);
    }
    if (dataClassName == 'ApiResponse') {
      return deserialize<_i14.ApiResponse>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i15.AppUser>(data['data']);
    }
    if (dataClassName == 'AppliedCouponInfo') {
      return deserialize<_i16.AppliedCouponInfo>(data['data']);
    }
    if (dataClassName == 'AppliedOfferInfo') {
      return deserialize<_i17.AppliedOfferInfo>(data['data']);
    }
    if (dataClassName == 'Banner') {
      return deserialize<_i18.Banner>(data['data']);
    }
    if (dataClassName == 'BannerPage') {
      return deserialize<_i19.BannerPage>(data['data']);
    }
    if (dataClassName == 'BasketSuggestion') {
      return deserialize<_i20.BasketSuggestion>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionAction') {
      return deserialize<_i21.BasketSuggestionAction>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionResult') {
      return deserialize<_i22.BasketSuggestionResult>(data['data']);
    }
    if (dataClassName == 'BestCouponResult') {
      return deserialize<_i23.BestCouponResult>(data['data']);
    }
    if (dataClassName == 'BogoFreeProduct') {
      return deserialize<_i24.BogoFreeProduct>(data['data']);
    }
    if (dataClassName == 'BogoOffer') {
      return deserialize<_i25.BogoOffer>(data['data']);
    }
    if (dataClassName == 'BogoOfferPage') {
      return deserialize<_i26.BogoOfferPage>(data['data']);
    }
    if (dataClassName == 'BroadcastPage') {
      return deserialize<_i27.BroadcastPage>(data['data']);
    }
    if (dataClassName == 'BroadcastRequest') {
      return deserialize<_i28.BroadcastRequest>(data['data']);
    }
    if (dataClassName == 'BroadcastSummary') {
      return deserialize<_i29.BroadcastSummary>(data['data']);
    }
    if (dataClassName == 'CartComparisonData') {
      return deserialize<_i30.CartComparisonData>(data['data']);
    }
    if (dataClassName == 'CartHydratedData') {
      return deserialize<_i31.CartHydratedData>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i32.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i33.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartItemSnapshot') {
      return deserialize<_i34.CartItemSnapshot>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i35.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'CascadeEntityInfo') {
      return deserialize<_i36.CascadeEntityInfo>(data['data']);
    }
    if (dataClassName == 'CascadeExecuteResponse') {
      return deserialize<_i37.CascadeExecuteResponse>(data['data']);
    }
    if (dataClassName == 'CascadeImpactResponse') {
      return deserialize<_i38.CascadeImpactResponse>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i39.Category>(data['data']);
    }
    if (dataClassName == 'CategoryHierarchy') {
      return deserialize<_i40.CategoryHierarchy>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i41.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'CategoryOfferPage') {
      return deserialize<_i42.CategoryOfferPage>(data['data']);
    }
    if (dataClassName == 'CheckoutInitHydrated') {
      return deserialize<_i43.CheckoutInitHydrated>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i44.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'CodPaymentReceipt') {
      return deserialize<_i45.CodPaymentReceipt>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i46.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboOfferPage') {
      return deserialize<_i47.ComboOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i48.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i49.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintDetailHydrated') {
      return deserialize<_i50.ComplaintDetailHydrated>(data['data']);
    }
    if (dataClassName == 'ComplaintPage') {
      return deserialize<_i51.ComplaintPage>(data['data']);
    }
    if (dataClassName == 'ComplaintProductItem') {
      return deserialize<_i52.ComplaintProductItem>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i53.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i54.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i55.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'DeleteImpactReference') {
      return deserialize<_i56.DeleteImpactReference>(data['data']);
    }
    if (dataClassName == 'DeleteImpactResponse') {
      return deserialize<_i57.DeleteImpactResponse>(data['data']);
    }
    if (dataClassName == 'DeliveryConfig') {
      return deserialize<_i58.DeliveryConfig>(data['data']);
    }
    if (dataClassName == 'DeliveryPricingResult') {
      return deserialize<_i59.DeliveryPricingResult>(data['data']);
    }
    if (dataClassName == 'DeliveryRule') {
      return deserialize<_i60.DeliveryRule>(data['data']);
    }
    if (dataClassName == 'DeliveryRulePage') {
      return deserialize<_i61.DeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'DeliverySettings') {
      return deserialize<_i62.DeliverySettings>(data['data']);
    }
    if (dataClassName == 'DeliverySlab') {
      return deserialize<_i63.DeliverySlab>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryHydrated') {
      return deserialize<_i64.FreeDeliveryHydrated>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i65.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRulePage') {
      return deserialize<_i66.FreeDeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i67.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'FreshPointsAdjustRequest') {
      return deserialize<_i68.FreshPointsAdjustRequest>(data['data']);
    }
    if (dataClassName == 'FreshPointsBalance') {
      return deserialize<_i69.FreshPointsBalance>(data['data']);
    }
    if (dataClassName == 'FreshPointsSettings') {
      return deserialize<_i70.FreshPointsSettings>(data['data']);
    }
    if (dataClassName == 'FreshPointsTransaction') {
      return deserialize<_i71.FreshPointsTransaction>(data['data']);
    }
    if (dataClassName == 'HardDeleteResponse') {
      return deserialize<_i72.HardDeleteResponse>(data['data']);
    }
    if (dataClassName == 'HomePageHydratedData') {
      return deserialize<_i73.HomePageHydratedData>(data['data']);
    }
    if (dataClassName == 'NotificationDraft') {
      return deserialize<_i74.NotificationDraft>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryItem') {
      return deserialize<_i75.NotificationHistoryItem>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryPage') {
      return deserialize<_i76.NotificationHistoryPage>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i77.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'OfferConflictResponse') {
      return deserialize<_i78.OfferConflictResponse>(data['data']);
    }
    if (dataClassName == 'OfferMutationResult') {
      return deserialize<_i79.OfferMutationResult>(data['data']);
    }
    if (dataClassName == 'OfferSearchItem') {
      return deserialize<_i80.OfferSearchItem>(data['data']);
    }
    if (dataClassName == 'OfferSearchPage') {
      return deserialize<_i81.OfferSearchPage>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i82.Order>(data['data']);
    }
    if (dataClassName == 'OrderDetailHydrated') {
      return deserialize<_i83.OrderDetailHydrated>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i84.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i85.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderRealtimeEvent') {
      return deserialize<_i86.OrderRealtimeEvent>(data['data']);
    }
    if (dataClassName == 'OrderTrackingData') {
      return deserialize<_i87.OrderTrackingData>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i88.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentEvent') {
      return deserialize<_i89.PaymentEvent>(data['data']);
    }
    if (dataClassName == 'PaymentLinkData') {
      return deserialize<_i90.PaymentLinkData>(data['data']);
    }
    if (dataClassName == 'PaymentOrderDetailHydrated') {
      return deserialize<_i91.PaymentOrderDetailHydrated>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i92.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentPageData') {
      return deserialize<_i93.PaymentPageData>(data['data']);
    }
    if (dataClassName == 'PaymentPageItem') {
      return deserialize<_i94.PaymentPageItem>(data['data']);
    }
    if (dataClassName == 'PaymentSessionData') {
      return deserialize<_i95.PaymentSessionData>(data['data']);
    }
    if (dataClassName == 'PaymentTransaction') {
      return deserialize<_i96.PaymentTransaction>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i97.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PendingOrderInfo') {
      return deserialize<_i98.PendingOrderInfo>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i99.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i100.Product>(data['data']);
    }
    if (dataClassName == 'ProductFormReferenceData') {
      return deserialize<_i101.ProductFormReferenceData>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i102.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductRankingItem') {
      return deserialize<_i103.ProductRankingItem>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i104.ProductVariant>(data['data']);
    }
    if (dataClassName == 'RazorpayPaymentStatus') {
      return deserialize<_i105.RazorpayPaymentStatus>(data['data']);
    }
    if (dataClassName == 'RazorpayRefundData') {
      return deserialize<_i106.RazorpayRefundData>(data['data']);
    }
    if (dataClassName == 'Referral') {
      return deserialize<_i107.Referral>(data['data']);
    }
    if (dataClassName == 'ReferralActivity') {
      return deserialize<_i108.ReferralActivity>(data['data']);
    }
    if (dataClassName == 'ReferralAdminStats') {
      return deserialize<_i109.ReferralAdminStats>(data['data']);
    }
    if (dataClassName == 'ReferralCodeInfo') {
      return deserialize<_i110.ReferralCodeInfo>(data['data']);
    }
    if (dataClassName == 'ReferralFraudResult') {
      return deserialize<_i111.ReferralFraudResult>(data['data']);
    }
    if (dataClassName == 'ReferralFraudRuleResult') {
      return deserialize<_i112.ReferralFraudRuleResult>(data['data']);
    }
    if (dataClassName == 'ReferralOnboardingStatus') {
      return deserialize<_i113.ReferralOnboardingStatus>(data['data']);
    }
    if (dataClassName == 'ReferralSettings') {
      return deserialize<_i114.ReferralSettings>(data['data']);
    }
    if (dataClassName == 'ReferralValidationResult') {
      return deserialize<_i115.ReferralValidationResult>(data['data']);
    }
    if (dataClassName == 'RefundRecord') {
      return deserialize<_i116.RefundRecord>(data['data']);
    }
    if (dataClassName == 'RegisterFcmTokenRequest') {
      return deserialize<_i117.RegisterFcmTokenRequest>(data['data']);
    }
    if (dataClassName == 'ShopMoreGetMoreOffer') {
      return deserialize<_i118.ShopMoreGetMoreOffer>(data['data']);
    }
    if (dataClassName == 'ShopMoreGetMoreOfferPage') {
      return deserialize<_i119.ShopMoreGetMoreOfferPage>(data['data']);
    }
    if (dataClassName == 'SmgmAnalytics') {
      return deserialize<_i120.SmgmAnalytics>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i121.SubCategory>(data['data']);
    }
    if (dataClassName == 'SupportIssue') {
      return deserialize<_i122.SupportIssue>(data['data']);
    }
    if (dataClassName == 'TopReferrerEntry') {
      return deserialize<_i123.TopReferrerEntry>(data['data']);
    }
    if (dataClassName == 'AdminAuditLogRow') {
      return deserialize<_i124.AdminAuditLogRow>(data['data']);
    }
    if (dataClassName == 'AdminNotificationPreferenceRow') {
      return deserialize<_i125.AdminNotificationPreferenceRow>(data['data']);
    }
    if (dataClassName == 'AppUserRow') {
      return deserialize<_i126.AppUserRow>(data['data']);
    }
    if (dataClassName == 'AutoRefundJobRow') {
      return deserialize<_i127.AutoRefundJobRow>(data['data']);
    }
    if (dataClassName == 'BannerRow') {
      return deserialize<_i128.BannerRow>(data['data']);
    }
    if (dataClassName == 'BogoOfferRewardRow') {
      return deserialize<_i129.BogoOfferRewardRow>(data['data']);
    }
    if (dataClassName == 'BogoOfferRow') {
      return deserialize<_i130.BogoOfferRow>(data['data']);
    }
    if (dataClassName == 'CategoryOfferRow') {
      return deserialize<_i131.CategoryOfferRow>(data['data']);
    }
    if (dataClassName == 'CategoryRow') {
      return deserialize<_i132.CategoryRow>(data['data']);
    }
    if (dataClassName == 'CodFailureRecord') {
      return deserialize<_i133.CodFailureRecord>(data['data']);
    }
    if (dataClassName == 'CodSettingsRow') {
      return deserialize<_i134.CodSettingsRow>(data['data']);
    }
    if (dataClassName == 'ComboOfferItemRow') {
      return deserialize<_i135.ComboOfferItemRow>(data['data']);
    }
    if (dataClassName == 'ComboOfferRow') {
      return deserialize<_i136.ComboOfferRow>(data['data']);
    }
    if (dataClassName == 'ComplaintRow') {
      return deserialize<_i137.ComplaintRow>(data['data']);
    }
    if (dataClassName == 'CouponRow') {
      return deserialize<_i138.CouponRow>(data['data']);
    }
    if (dataClassName == 'CustomerOrderRow') {
      return deserialize<_i139.CustomerOrderRow>(data['data']);
    }
    if (dataClassName == 'DeliveryConfigRow') {
      return deserialize<_i140.DeliveryConfigRow>(data['data']);
    }
    if (dataClassName == 'DeliveryOtpRow') {
      return deserialize<_i141.DeliveryOtpRow>(data['data']);
    }
    if (dataClassName == 'DeliveryRuleRow') {
      return deserialize<_i142.DeliveryRuleRow>(data['data']);
    }
    if (dataClassName == 'DeliverySettingsRow') {
      return deserialize<_i143.DeliverySettingsRow>(data['data']);
    }
    if (dataClassName == 'DeliverySlabRow') {
      return deserialize<_i144.DeliverySlabRow>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRuleRow') {
      return deserialize<_i145.FreeDeliveryRuleRow>(data['data']);
    }
    if (dataClassName == 'FreshPointsSettingsRow') {
      return deserialize<_i146.FreshPointsSettingsRow>(data['data']);
    }
    if (dataClassName == 'FreshPointsTransactionRow') {
      return deserialize<_i147.FreshPointsTransactionRow>(data['data']);
    }
    if (dataClassName == 'IdempotencyRecordRow') {
      return deserialize<_i148.IdempotencyRecordRow>(data['data']);
    }
    if (dataClassName == 'NotificationCampaignRow') {
      return deserialize<_i149.NotificationCampaignRow>(data['data']);
    }
    if (dataClassName == 'NotificationOutboxRow') {
      return deserialize<_i150.NotificationOutboxRow>(data['data']);
    }
    if (dataClassName == 'NotificationPreferenceRow') {
      return deserialize<_i151.NotificationPreferenceRow>(data['data']);
    }
    if (dataClassName == 'NotificationUserStateRow') {
      return deserialize<_i152.NotificationUserStateRow>(data['data']);
    }
    if (dataClassName == 'OrderAddressRow') {
      return deserialize<_i153.OrderAddressRow>(data['data']);
    }
    if (dataClassName == 'OrderItemRow') {
      return deserialize<_i154.OrderItemRow>(data['data']);
    }
    if (dataClassName == 'OrderNotificationOutboxRow') {
      return deserialize<_i155.OrderNotificationOutboxRow>(data['data']);
    }
    if (dataClassName == 'OrderTrackingRow') {
      return deserialize<_i156.OrderTrackingRow>(data['data']);
    }
    if (dataClassName == 'PaymentLinkRow') {
      return deserialize<_i157.PaymentLinkRow>(data['data']);
    }
    if (dataClassName == 'PaymentSessionRow') {
      return deserialize<_i158.PaymentSessionRow>(data['data']);
    }
    if (dataClassName == 'PaymentTransactionRow') {
      return deserialize<_i159.PaymentTransactionRow>(data['data']);
    }
    if (dataClassName == 'ProductRow') {
      return deserialize<_i160.ProductRow>(data['data']);
    }
    if (dataClassName == 'ProductSearchDocumentRow') {
      return deserialize<_i161.ProductSearchDocumentRow>(data['data']);
    }
    if (dataClassName == 'ProductSearchRebuildJobRow') {
      return deserialize<_i162.ProductSearchRebuildJobRow>(data['data']);
    }
    if (dataClassName == 'ProductVariantRow') {
      return deserialize<_i163.ProductVariantRow>(data['data']);
    }
    if (dataClassName == 'ReferralRow') {
      return deserialize<_i164.ReferralRow>(data['data']);
    }
    if (dataClassName == 'ReferralSettingsRow') {
      return deserialize<_i165.ReferralSettingsRow>(data['data']);
    }
    if (dataClassName == 'RefundRecordRow') {
      return deserialize<_i166.RefundRecordRow>(data['data']);
    }
    if (dataClassName == 'ShopMoreGetMoreOfferRow') {
      return deserialize<_i167.ShopMoreGetMoreOfferRow>(data['data']);
    }
    if (dataClassName == 'SubCategoryRow') {
      return deserialize<_i168.SubCategoryRow>(data['data']);
    }
    if (dataClassName == 'SupportIssueRow') {
      return deserialize<_i169.SupportIssueRow>(data['data']);
    }
    if (dataClassName == 'UserAddressRow') {
      return deserialize<_i170.UserAddressRow>(data['data']);
    }
    if (dataClassName == 'UserCartItemRow') {
      return deserialize<_i171.UserCartItemRow>(data['data']);
    }
    if (dataClassName == 'UserFcmTokenRow') {
      return deserialize<_i172.UserFcmTokenRow>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i124.AdminAuditLogRow:
        return _i124.AdminAuditLogRow.t;
      case _i125.AdminNotificationPreferenceRow:
        return _i125.AdminNotificationPreferenceRow.t;
      case _i126.AppUserRow:
        return _i126.AppUserRow.t;
      case _i127.AutoRefundJobRow:
        return _i127.AutoRefundJobRow.t;
      case _i128.BannerRow:
        return _i128.BannerRow.t;
      case _i129.BogoOfferRewardRow:
        return _i129.BogoOfferRewardRow.t;
      case _i130.BogoOfferRow:
        return _i130.BogoOfferRow.t;
      case _i131.CategoryOfferRow:
        return _i131.CategoryOfferRow.t;
      case _i132.CategoryRow:
        return _i132.CategoryRow.t;
      case _i133.CodFailureRecord:
        return _i133.CodFailureRecord.t;
      case _i134.CodSettingsRow:
        return _i134.CodSettingsRow.t;
      case _i135.ComboOfferItemRow:
        return _i135.ComboOfferItemRow.t;
      case _i136.ComboOfferRow:
        return _i136.ComboOfferRow.t;
      case _i137.ComplaintRow:
        return _i137.ComplaintRow.t;
      case _i138.CouponRow:
        return _i138.CouponRow.t;
      case _i139.CustomerOrderRow:
        return _i139.CustomerOrderRow.t;
      case _i140.DeliveryConfigRow:
        return _i140.DeliveryConfigRow.t;
      case _i141.DeliveryOtpRow:
        return _i141.DeliveryOtpRow.t;
      case _i142.DeliveryRuleRow:
        return _i142.DeliveryRuleRow.t;
      case _i143.DeliverySettingsRow:
        return _i143.DeliverySettingsRow.t;
      case _i144.DeliverySlabRow:
        return _i144.DeliverySlabRow.t;
      case _i145.FreeDeliveryRuleRow:
        return _i145.FreeDeliveryRuleRow.t;
      case _i146.FreshPointsSettingsRow:
        return _i146.FreshPointsSettingsRow.t;
      case _i147.FreshPointsTransactionRow:
        return _i147.FreshPointsTransactionRow.t;
      case _i148.IdempotencyRecordRow:
        return _i148.IdempotencyRecordRow.t;
      case _i149.NotificationCampaignRow:
        return _i149.NotificationCampaignRow.t;
      case _i150.NotificationOutboxRow:
        return _i150.NotificationOutboxRow.t;
      case _i151.NotificationPreferenceRow:
        return _i151.NotificationPreferenceRow.t;
      case _i152.NotificationUserStateRow:
        return _i152.NotificationUserStateRow.t;
      case _i153.OrderAddressRow:
        return _i153.OrderAddressRow.t;
      case _i154.OrderItemRow:
        return _i154.OrderItemRow.t;
      case _i155.OrderNotificationOutboxRow:
        return _i155.OrderNotificationOutboxRow.t;
      case _i156.OrderTrackingRow:
        return _i156.OrderTrackingRow.t;
      case _i157.PaymentLinkRow:
        return _i157.PaymentLinkRow.t;
      case _i158.PaymentSessionRow:
        return _i158.PaymentSessionRow.t;
      case _i159.PaymentTransactionRow:
        return _i159.PaymentTransactionRow.t;
      case _i160.ProductRow:
        return _i160.ProductRow.t;
      case _i161.ProductSearchDocumentRow:
        return _i161.ProductSearchDocumentRow.t;
      case _i162.ProductSearchRebuildJobRow:
        return _i162.ProductSearchRebuildJobRow.t;
      case _i163.ProductVariantRow:
        return _i163.ProductVariantRow.t;
      case _i164.ReferralRow:
        return _i164.ReferralRow.t;
      case _i165.ReferralSettingsRow:
        return _i165.ReferralSettingsRow.t;
      case _i166.RefundRecordRow:
        return _i166.RefundRecordRow.t;
      case _i167.ShopMoreGetMoreOfferRow:
        return _i167.ShopMoreGetMoreOfferRow.t;
      case _i168.SubCategoryRow:
        return _i168.SubCategoryRow.t;
      case _i169.SupportIssueRow:
        return _i169.SupportIssueRow.t;
      case _i170.UserAddressRow:
        return _i170.UserAddressRow.t;
      case _i171.UserCartItemRow:
        return _i171.UserCartItemRow.t;
      case _i172.UserFcmTokenRow:
        return _i172.UserFcmTokenRow.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'freshpickkat';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
