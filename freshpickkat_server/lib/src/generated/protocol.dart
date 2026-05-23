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
import 'active_user_statistics.dart' as _i5;
import 'address.dart' as _i6;
import 'admin_analytics.dart' as _i7;
import 'admin_audit_log_entry.dart' as _i8;
import 'admin_audit_log_row.dart' as _i9;
import 'admin_auth_result.dart' as _i10;
import 'admin_dashboard_stats.dart' as _i11;
import 'admin_notification_preference.dart' as _i12;
import 'admin_notification_preference_row.dart' as _i13;
import 'admin_top_product.dart' as _i14;
import 'api_response.dart' as _i15;
import 'app_user.dart' as _i16;
import 'app_user_row.dart' as _i17;
import 'applied_coupon_info.dart' as _i18;
import 'applied_offer_info.dart' as _i19;
import 'banner.dart' as _i20;
import 'banner_linked_product_row.dart' as _i21;
import 'banner_page.dart' as _i22;
import 'banner_placement_row.dart' as _i23;
import 'banner_row.dart' as _i24;
import 'basket_suggestion.dart' as _i25;
import 'basket_suggestion_action.dart' as _i26;
import 'basket_suggestion_result.dart' as _i27;
import 'best_coupon_result.dart' as _i28;
import 'bogo_free_product.dart' as _i29;
import 'bogo_offer.dart' as _i30;
import 'bogo_offer_page.dart' as _i31;
import 'bogo_offer_reward_row.dart' as _i32;
import 'bogo_offer_row.dart' as _i33;
import 'broadcast_page.dart' as _i34;
import 'broadcast_request.dart' as _i35;
import 'broadcast_summary.dart' as _i36;
import 'cart_item.dart' as _i37;
import 'cart_item_input.dart' as _i38;
import 'cart_pricing_result.dart' as _i39;
import 'category.dart' as _i40;
import 'category_offer.dart' as _i41;
import 'category_offer_page.dart' as _i42;
import 'category_offer_product_exclusion_row.dart' as _i43;
import 'category_offer_product_scope_row.dart' as _i44;
import 'category_offer_row.dart' as _i45;
import 'category_row.dart' as _i46;
import 'checkout_result.dart' as _i47;
import 'combo_offer.dart' as _i48;
import 'combo_offer_item_row.dart' as _i49;
import 'combo_offer_page.dart' as _i50;
import 'combo_offer_row.dart' as _i51;
import 'combo_product_item.dart' as _i52;
import 'complaint.dart' as _i53;
import 'complaint_page.dart' as _i54;
import 'complaint_product_item.dart' as _i55;
import 'complaint_row.dart' as _i56;
import 'coupon.dart' as _i57;
import 'coupon_display.dart' as _i58;
import 'coupon_product_scope_row.dart' as _i59;
import 'coupon_row.dart' as _i60;
import 'coupon_validation_result.dart' as _i61;
import 'customer_order_row.dart' as _i62;
import 'delivery_config.dart' as _i63;
import 'delivery_config_row.dart' as _i64;
import 'delivery_pricing_result.dart' as _i65;
import 'delivery_rule.dart' as _i66;
import 'delivery_rule_page.dart' as _i67;
import 'delivery_rule_row.dart' as _i68;
import 'delivery_slab.dart' as _i69;
import 'delivery_slab_row.dart' as _i70;
import 'free_delivery_rule.dart' as _i71;
import 'free_delivery_rule_page.dart' as _i72;
import 'free_delivery_rule_row.dart' as _i73;
import 'free_item_info.dart' as _i74;
import 'idempotency_record_row.dart' as _i75;
import 'notification_campaign_row.dart' as _i76;
import 'notification_draft.dart' as _i77;
import 'notification_history_item.dart' as _i78;
import 'notification_history_page.dart' as _i79;
import 'notification_outbox_row.dart' as _i80;
import 'notification_preference.dart' as _i81;
import 'notification_preference_row.dart' as _i82;
import 'notification_user_state_row.dart' as _i83;
import 'offer_search_item.dart' as _i84;
import 'offer_search_page.dart' as _i85;
import 'order.dart' as _i86;
import 'order_address_row.dart' as _i87;
import 'order_item.dart' as _i88;
import 'order_item_row.dart' as _i89;
import 'order_notification_outbox_row.dart' as _i90;
import 'order_page.dart' as _i91;
import 'order_realtime_event.dart' as _i92;
import 'order_tracking_data.dart' as _i93;
import 'order_tracking_row.dart' as _i94;
import 'payment_action_result.dart' as _i95;
import 'payment_order_result.dart' as _i96;
import 'payment_transaction_row.dart' as _i97;
import 'payment_verify_result.dart' as _i98;
import 'pricing_line_item.dart' as _i99;
import 'product.dart' as _i100;
import 'product_page.dart' as _i101;
import 'product_ranking_item.dart' as _i102;
import 'product_row.dart' as _i103;
import 'product_search_document_row.dart' as _i104;
import 'product_search_rebuild_job_row.dart' as _i105;
import 'product_sub_category_row.dart' as _i106;
import 'product_variant.dart' as _i107;
import 'product_variant_row.dart' as _i108;
import 'refund_record.dart' as _i109;
import 'refund_record_row.dart' as _i110;
import 'register_fcm_token_request.dart' as _i111;
import 'sub_category.dart' as _i112;
import 'sub_category_row.dart' as _i113;
import 'support_issue.dart' as _i114;
import 'support_issue_row.dart' as _i115;
import 'user_address_row.dart' as _i116;
import 'user_cart_item_row.dart' as _i117;
import 'user_fcm_token_row.dart' as _i118;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i119;
import 'package:freshpickkat_server/src/generated/admin_audit_log_entry.dart'
    as _i120;
import 'package:freshpickkat_server/src/generated/active_user_statistics.dart'
    as _i121;
import 'package:freshpickkat_server/src/generated/banner.dart' as _i122;
import 'package:freshpickkat_server/src/generated/bogo_offer.dart' as _i123;
import 'package:freshpickkat_server/src/generated/category.dart' as _i124;
import 'package:freshpickkat_server/src/generated/category_offer.dart' as _i125;
import 'package:freshpickkat_server/src/generated/combo_offer.dart' as _i126;
import 'package:freshpickkat_server/src/generated/cart_item_input.dart'
    as _i127;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i128;
import 'package:freshpickkat_server/src/generated/coupon_display.dart' as _i129;
import 'package:freshpickkat_server/src/generated/delivery_rule.dart' as _i130;
import 'package:freshpickkat_server/src/generated/admin_notification_preference.dart'
    as _i131;
import 'package:freshpickkat_server/src/generated/order.dart' as _i132;
import 'package:freshpickkat_server/src/generated/applied_offer_info.dart'
    as _i133;
import 'package:freshpickkat_server/src/generated/product.dart' as _i134;
import 'package:freshpickkat_server/src/generated/product_ranking_item.dart'
    as _i135;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i136;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i137;
export 'active_user_statistics.dart';
export 'address.dart';
export 'admin_analytics.dart';
export 'admin_audit_log_entry.dart';
export 'admin_audit_log_row.dart';
export 'admin_auth_result.dart';
export 'admin_dashboard_stats.dart';
export 'admin_notification_preference.dart';
export 'admin_notification_preference_row.dart';
export 'admin_top_product.dart';
export 'api_response.dart';
export 'app_user.dart';
export 'app_user_row.dart';
export 'applied_coupon_info.dart';
export 'applied_offer_info.dart';
export 'banner.dart';
export 'banner_linked_product_row.dart';
export 'banner_page.dart';
export 'banner_placement_row.dart';
export 'banner_row.dart';
export 'basket_suggestion.dart';
export 'basket_suggestion_action.dart';
export 'basket_suggestion_result.dart';
export 'best_coupon_result.dart';
export 'bogo_free_product.dart';
export 'bogo_offer.dart';
export 'bogo_offer_page.dart';
export 'bogo_offer_reward_row.dart';
export 'bogo_offer_row.dart';
export 'broadcast_page.dart';
export 'broadcast_request.dart';
export 'broadcast_summary.dart';
export 'cart_item.dart';
export 'cart_item_input.dart';
export 'cart_pricing_result.dart';
export 'category.dart';
export 'category_offer.dart';
export 'category_offer_page.dart';
export 'category_offer_product_exclusion_row.dart';
export 'category_offer_product_scope_row.dart';
export 'category_offer_row.dart';
export 'category_row.dart';
export 'checkout_result.dart';
export 'combo_offer.dart';
export 'combo_offer_item_row.dart';
export 'combo_offer_page.dart';
export 'combo_offer_row.dart';
export 'combo_product_item.dart';
export 'complaint.dart';
export 'complaint_page.dart';
export 'complaint_product_item.dart';
export 'complaint_row.dart';
export 'coupon.dart';
export 'coupon_display.dart';
export 'coupon_product_scope_row.dart';
export 'coupon_row.dart';
export 'coupon_validation_result.dart';
export 'customer_order_row.dart';
export 'delivery_config.dart';
export 'delivery_config_row.dart';
export 'delivery_pricing_result.dart';
export 'delivery_rule.dart';
export 'delivery_rule_page.dart';
export 'delivery_rule_row.dart';
export 'delivery_slab.dart';
export 'delivery_slab_row.dart';
export 'free_delivery_rule.dart';
export 'free_delivery_rule_page.dart';
export 'free_delivery_rule_row.dart';
export 'free_item_info.dart';
export 'idempotency_record_row.dart';
export 'notification_campaign_row.dart';
export 'notification_draft.dart';
export 'notification_history_item.dart';
export 'notification_history_page.dart';
export 'notification_outbox_row.dart';
export 'notification_preference.dart';
export 'notification_preference_row.dart';
export 'notification_user_state_row.dart';
export 'offer_search_item.dart';
export 'offer_search_page.dart';
export 'order.dart';
export 'order_address_row.dart';
export 'order_item.dart';
export 'order_item_row.dart';
export 'order_notification_outbox_row.dart';
export 'order_page.dart';
export 'order_realtime_event.dart';
export 'order_tracking_data.dart';
export 'order_tracking_row.dart';
export 'payment_action_result.dart';
export 'payment_order_result.dart';
export 'payment_transaction_row.dart';
export 'payment_verify_result.dart';
export 'pricing_line_item.dart';
export 'product.dart';
export 'product_page.dart';
export 'product_ranking_item.dart';
export 'product_row.dart';
export 'product_search_document_row.dart';
export 'product_search_rebuild_job_row.dart';
export 'product_sub_category_row.dart';
export 'product_variant.dart';
export 'product_variant_row.dart';
export 'refund_record.dart';
export 'refund_record_row.dart';
export 'register_fcm_token_request.dart';
export 'sub_category.dart';
export 'sub_category_row.dart';
export 'support_issue.dart';
export 'support_issue_row.dart';
export 'user_address_row.dart';
export 'user_cart_item_row.dart';
export 'user_fcm_token_row.dart';

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
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
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
          constraintName: 'banner_fk_0',
          columns: ['linkedProductId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'banner_fk_1',
          columns: ['comboOfferId'],
          referenceTable: 'combo_offer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'banner_fk_2',
          columns: ['couponId'],
          referenceTable: 'coupon',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'banner_fk_3',
          columns: ['linkedCategoryId'],
          referenceTable: 'category',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'banner_fk_4',
          columns: ['linkedSubCategoryId'],
          referenceTable: 'sub_category',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
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
      name: 'banner_linked_product',
      dartName: 'BannerLinkedProductRow',
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
          name: 'bannerId',
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
          constraintName: 'banner_linked_product_fk_0',
          columns: ['bannerId'],
          referenceTable: 'banner',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'banner_linked_product_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'banner_linked_product_pkey',
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
          indexName: 'banner_linked_product_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bannerId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'banner_linked_product_banner_sort_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bannerId',
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
      name: 'banner_placement',
      dartName: 'BannerPlacementRow',
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
          name: 'bannerId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'placementKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
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
          constraintName: 'banner_placement_fk_0',
          columns: ['bannerId'],
          referenceTable: 'banner',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'banner_placement_pkey',
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
          indexName: 'banner_placement_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bannerId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'placementKey',
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
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
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
          constraintName: 'bogo_offer_fk_0',
          columns: ['triggerProductId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'bogo_offer_fk_1',
          columns: ['triggerVariantId'],
          referenceTable: 'product_variant',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
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
        _i2.ForeignKeyDefinition(
          constraintName: 'bogo_offer_reward_fk_1',
          columns: ['rewardProductId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'bogo_offer_reward_fk_2',
          columns: ['rewardVariantId'],
          referenceTable: 'product_variant',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
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
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
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
          constraintName: 'category_offer_fk_0',
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
      name: 'category_offer_product_exclusion',
      dartName: 'CategoryOfferProductExclusionRow',
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
          name: 'categoryOfferId',
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
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'category_offer_product_exclusion_fk_0',
          columns: ['categoryOfferId'],
          referenceTable: 'category_offer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'category_offer_product_exclusion_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'category_offer_product_exclusion_pkey',
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
          indexName: 'category_offer_product_exclusion_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'categoryOfferId',
            ),
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
      name: 'category_offer_product_scope',
      dartName: 'CategoryOfferProductScopeRow',
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
          name: 'categoryOfferId',
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
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'category_offer_product_scope_fk_0',
          columns: ['categoryOfferId'],
          referenceTable: 'category_offer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'category_offer_product_scope_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'category_offer_product_scope_pkey',
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
          indexName: 'category_offer_product_scope_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'categoryOfferId',
            ),
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
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
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
        _i2.ForeignKeyDefinition(
          constraintName: 'combo_offer_item_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'combo_offer_item_fk_2',
          columns: ['productVariantId'],
          referenceTable: 'product_variant',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
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
        _i2.ForeignKeyDefinition(
          constraintName: 'complaint_fk_2',
          columns: ['orderItemId'],
          referenceTable: 'order_item',
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
          columnDefault: '\'All\'::text',
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
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
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
      name: 'coupon_product_scope',
      dartName: 'CouponProductScopeRow',
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
          name: 'couponId',
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
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'coupon_product_scope_fk_0',
          columns: ['couponId'],
          referenceTable: 'coupon',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'coupon_product_scope_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'coupon_product_scope_pkey',
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
          indexName: 'coupon_product_scope_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'couponId',
            ),
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
          name: 'deliveryFee',
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
        _i2.ForeignKeyDefinition(
          constraintName: 'customer_order_fk_1',
          columns: ['couponId'],
          referenceTable: 'coupon',
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
          name: 'freeDeliveryThreshold',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
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
          name: 'ruleType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'deliveryFee',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'priority',
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
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
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
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'endsAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
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
          constraintName: 'free_delivery_rule_fk_0',
          columns: ['couponId'],
          referenceTable: 'coupon',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'free_delivery_rule_fk_1',
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
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'idempotency_record_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'idempotency_record_fk_1',
          columns: ['orderId'],
          referenceTable: 'customer_order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'idempotency_record_fk_2',
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
        _i2.ForeignKeyDefinition(
          constraintName: 'order_item_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'order_item_fk_2',
          columns: ['productVariantId'],
          referenceTable: 'product_variant',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'order_item_fk_3',
          columns: ['comboOfferId'],
          referenceTable: 'combo_offer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'order_item_fk_4',
          columns: ['bogoOfferId'],
          referenceTable: 'bogo_offer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
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
      name: 'product_sub_category',
      dartName: 'ProductSubCategoryRow',
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
          name: 'subCategoryId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
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
          constraintName: 'product_sub_category_fk_0',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'product_sub_category_fk_1',
          columns: ['subCategoryId'],
          referenceTable: 'sub_category',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'product_sub_category_pkey',
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
          indexName: 'product_sub_category_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'subCategoryId',
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
        _i2.ForeignKeyDefinition(
          constraintName: 'refund_record_fk_3',
          columns: ['complaintId'],
          referenceTable: 'complaint',
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
    if (t == _i9.AdminAuditLogRow) {
      return _i9.AdminAuditLogRow.fromJson(data) as T;
    }
    if (t == _i10.AdminAuthResult) {
      return _i10.AdminAuthResult.fromJson(data) as T;
    }
    if (t == _i11.AdminDashboardStats) {
      return _i11.AdminDashboardStats.fromJson(data) as T;
    }
    if (t == _i12.AdminNotificationPreference) {
      return _i12.AdminNotificationPreference.fromJson(data) as T;
    }
    if (t == _i13.AdminNotificationPreferenceRow) {
      return _i13.AdminNotificationPreferenceRow.fromJson(data) as T;
    }
    if (t == _i14.AdminTopProduct) {
      return _i14.AdminTopProduct.fromJson(data) as T;
    }
    if (t == _i15.ApiResponse) {
      return _i15.ApiResponse.fromJson(data) as T;
    }
    if (t == _i16.AppUser) {
      return _i16.AppUser.fromJson(data) as T;
    }
    if (t == _i17.AppUserRow) {
      return _i17.AppUserRow.fromJson(data) as T;
    }
    if (t == _i18.AppliedCouponInfo) {
      return _i18.AppliedCouponInfo.fromJson(data) as T;
    }
    if (t == _i19.AppliedOfferInfo) {
      return _i19.AppliedOfferInfo.fromJson(data) as T;
    }
    if (t == _i20.Banner) {
      return _i20.Banner.fromJson(data) as T;
    }
    if (t == _i21.BannerLinkedProductRow) {
      return _i21.BannerLinkedProductRow.fromJson(data) as T;
    }
    if (t == _i22.BannerPage) {
      return _i22.BannerPage.fromJson(data) as T;
    }
    if (t == _i23.BannerPlacementRow) {
      return _i23.BannerPlacementRow.fromJson(data) as T;
    }
    if (t == _i24.BannerRow) {
      return _i24.BannerRow.fromJson(data) as T;
    }
    if (t == _i25.BasketSuggestion) {
      return _i25.BasketSuggestion.fromJson(data) as T;
    }
    if (t == _i26.BasketSuggestionAction) {
      return _i26.BasketSuggestionAction.fromJson(data) as T;
    }
    if (t == _i27.BasketSuggestionResult) {
      return _i27.BasketSuggestionResult.fromJson(data) as T;
    }
    if (t == _i28.BestCouponResult) {
      return _i28.BestCouponResult.fromJson(data) as T;
    }
    if (t == _i29.BogoFreeProduct) {
      return _i29.BogoFreeProduct.fromJson(data) as T;
    }
    if (t == _i30.BogoOffer) {
      return _i30.BogoOffer.fromJson(data) as T;
    }
    if (t == _i31.BogoOfferPage) {
      return _i31.BogoOfferPage.fromJson(data) as T;
    }
    if (t == _i32.BogoOfferRewardRow) {
      return _i32.BogoOfferRewardRow.fromJson(data) as T;
    }
    if (t == _i33.BogoOfferRow) {
      return _i33.BogoOfferRow.fromJson(data) as T;
    }
    if (t == _i34.BroadcastPage) {
      return _i34.BroadcastPage.fromJson(data) as T;
    }
    if (t == _i35.BroadcastRequest) {
      return _i35.BroadcastRequest.fromJson(data) as T;
    }
    if (t == _i36.BroadcastSummary) {
      return _i36.BroadcastSummary.fromJson(data) as T;
    }
    if (t == _i37.CartItem) {
      return _i37.CartItem.fromJson(data) as T;
    }
    if (t == _i38.CartItemInput) {
      return _i38.CartItemInput.fromJson(data) as T;
    }
    if (t == _i39.CartPricingResult) {
      return _i39.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i40.Category) {
      return _i40.Category.fromJson(data) as T;
    }
    if (t == _i41.CategoryOffer) {
      return _i41.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i42.CategoryOfferPage) {
      return _i42.CategoryOfferPage.fromJson(data) as T;
    }
    if (t == _i43.CategoryOfferProductExclusionRow) {
      return _i43.CategoryOfferProductExclusionRow.fromJson(data) as T;
    }
    if (t == _i44.CategoryOfferProductScopeRow) {
      return _i44.CategoryOfferProductScopeRow.fromJson(data) as T;
    }
    if (t == _i45.CategoryOfferRow) {
      return _i45.CategoryOfferRow.fromJson(data) as T;
    }
    if (t == _i46.CategoryRow) {
      return _i46.CategoryRow.fromJson(data) as T;
    }
    if (t == _i47.CheckoutResult) {
      return _i47.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i48.ComboOffer) {
      return _i48.ComboOffer.fromJson(data) as T;
    }
    if (t == _i49.ComboOfferItemRow) {
      return _i49.ComboOfferItemRow.fromJson(data) as T;
    }
    if (t == _i50.ComboOfferPage) {
      return _i50.ComboOfferPage.fromJson(data) as T;
    }
    if (t == _i51.ComboOfferRow) {
      return _i51.ComboOfferRow.fromJson(data) as T;
    }
    if (t == _i52.ComboProductItem) {
      return _i52.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i53.Complaint) {
      return _i53.Complaint.fromJson(data) as T;
    }
    if (t == _i54.ComplaintPage) {
      return _i54.ComplaintPage.fromJson(data) as T;
    }
    if (t == _i55.ComplaintProductItem) {
      return _i55.ComplaintProductItem.fromJson(data) as T;
    }
    if (t == _i56.ComplaintRow) {
      return _i56.ComplaintRow.fromJson(data) as T;
    }
    if (t == _i57.Coupon) {
      return _i57.Coupon.fromJson(data) as T;
    }
    if (t == _i58.CouponDisplay) {
      return _i58.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i59.CouponProductScopeRow) {
      return _i59.CouponProductScopeRow.fromJson(data) as T;
    }
    if (t == _i60.CouponRow) {
      return _i60.CouponRow.fromJson(data) as T;
    }
    if (t == _i61.CouponValidationResult) {
      return _i61.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i62.CustomerOrderRow) {
      return _i62.CustomerOrderRow.fromJson(data) as T;
    }
    if (t == _i63.DeliveryConfig) {
      return _i63.DeliveryConfig.fromJson(data) as T;
    }
    if (t == _i64.DeliveryConfigRow) {
      return _i64.DeliveryConfigRow.fromJson(data) as T;
    }
    if (t == _i65.DeliveryPricingResult) {
      return _i65.DeliveryPricingResult.fromJson(data) as T;
    }
    if (t == _i66.DeliveryRule) {
      return _i66.DeliveryRule.fromJson(data) as T;
    }
    if (t == _i67.DeliveryRulePage) {
      return _i67.DeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i68.DeliveryRuleRow) {
      return _i68.DeliveryRuleRow.fromJson(data) as T;
    }
    if (t == _i69.DeliverySlab) {
      return _i69.DeliverySlab.fromJson(data) as T;
    }
    if (t == _i70.DeliverySlabRow) {
      return _i70.DeliverySlabRow.fromJson(data) as T;
    }
    if (t == _i71.FreeDeliveryRule) {
      return _i71.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i72.FreeDeliveryRulePage) {
      return _i72.FreeDeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i73.FreeDeliveryRuleRow) {
      return _i73.FreeDeliveryRuleRow.fromJson(data) as T;
    }
    if (t == _i74.FreeItemInfo) {
      return _i74.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i75.IdempotencyRecordRow) {
      return _i75.IdempotencyRecordRow.fromJson(data) as T;
    }
    if (t == _i76.NotificationCampaignRow) {
      return _i76.NotificationCampaignRow.fromJson(data) as T;
    }
    if (t == _i77.NotificationDraft) {
      return _i77.NotificationDraft.fromJson(data) as T;
    }
    if (t == _i78.NotificationHistoryItem) {
      return _i78.NotificationHistoryItem.fromJson(data) as T;
    }
    if (t == _i79.NotificationHistoryPage) {
      return _i79.NotificationHistoryPage.fromJson(data) as T;
    }
    if (t == _i80.NotificationOutboxRow) {
      return _i80.NotificationOutboxRow.fromJson(data) as T;
    }
    if (t == _i81.NotificationPreference) {
      return _i81.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i82.NotificationPreferenceRow) {
      return _i82.NotificationPreferenceRow.fromJson(data) as T;
    }
    if (t == _i83.NotificationUserStateRow) {
      return _i83.NotificationUserStateRow.fromJson(data) as T;
    }
    if (t == _i84.OfferSearchItem) {
      return _i84.OfferSearchItem.fromJson(data) as T;
    }
    if (t == _i85.OfferSearchPage) {
      return _i85.OfferSearchPage.fromJson(data) as T;
    }
    if (t == _i86.Order) {
      return _i86.Order.fromJson(data) as T;
    }
    if (t == _i87.OrderAddressRow) {
      return _i87.OrderAddressRow.fromJson(data) as T;
    }
    if (t == _i88.OrderItem) {
      return _i88.OrderItem.fromJson(data) as T;
    }
    if (t == _i89.OrderItemRow) {
      return _i89.OrderItemRow.fromJson(data) as T;
    }
    if (t == _i90.OrderNotificationOutboxRow) {
      return _i90.OrderNotificationOutboxRow.fromJson(data) as T;
    }
    if (t == _i91.OrderPage) {
      return _i91.OrderPage.fromJson(data) as T;
    }
    if (t == _i92.OrderRealtimeEvent) {
      return _i92.OrderRealtimeEvent.fromJson(data) as T;
    }
    if (t == _i93.OrderTrackingData) {
      return _i93.OrderTrackingData.fromJson(data) as T;
    }
    if (t == _i94.OrderTrackingRow) {
      return _i94.OrderTrackingRow.fromJson(data) as T;
    }
    if (t == _i95.PaymentActionResult) {
      return _i95.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i96.PaymentOrderResult) {
      return _i96.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i97.PaymentTransactionRow) {
      return _i97.PaymentTransactionRow.fromJson(data) as T;
    }
    if (t == _i98.PaymentVerifyResult) {
      return _i98.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i99.PricingLineItem) {
      return _i99.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i100.Product) {
      return _i100.Product.fromJson(data) as T;
    }
    if (t == _i101.ProductPage) {
      return _i101.ProductPage.fromJson(data) as T;
    }
    if (t == _i102.ProductRankingItem) {
      return _i102.ProductRankingItem.fromJson(data) as T;
    }
    if (t == _i103.ProductRow) {
      return _i103.ProductRow.fromJson(data) as T;
    }
    if (t == _i104.ProductSearchDocumentRow) {
      return _i104.ProductSearchDocumentRow.fromJson(data) as T;
    }
    if (t == _i105.ProductSearchRebuildJobRow) {
      return _i105.ProductSearchRebuildJobRow.fromJson(data) as T;
    }
    if (t == _i106.ProductSubCategoryRow) {
      return _i106.ProductSubCategoryRow.fromJson(data) as T;
    }
    if (t == _i107.ProductVariant) {
      return _i107.ProductVariant.fromJson(data) as T;
    }
    if (t == _i108.ProductVariantRow) {
      return _i108.ProductVariantRow.fromJson(data) as T;
    }
    if (t == _i109.RefundRecord) {
      return _i109.RefundRecord.fromJson(data) as T;
    }
    if (t == _i110.RefundRecordRow) {
      return _i110.RefundRecordRow.fromJson(data) as T;
    }
    if (t == _i111.RegisterFcmTokenRequest) {
      return _i111.RegisterFcmTokenRequest.fromJson(data) as T;
    }
    if (t == _i112.SubCategory) {
      return _i112.SubCategory.fromJson(data) as T;
    }
    if (t == _i113.SubCategoryRow) {
      return _i113.SubCategoryRow.fromJson(data) as T;
    }
    if (t == _i114.SupportIssue) {
      return _i114.SupportIssue.fromJson(data) as T;
    }
    if (t == _i115.SupportIssueRow) {
      return _i115.SupportIssueRow.fromJson(data) as T;
    }
    if (t == _i116.UserAddressRow) {
      return _i116.UserAddressRow.fromJson(data) as T;
    }
    if (t == _i117.UserCartItemRow) {
      return _i117.UserCartItemRow.fromJson(data) as T;
    }
    if (t == _i118.UserFcmTokenRow) {
      return _i118.UserFcmTokenRow.fromJson(data) as T;
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
    if (t == _i1.getType<_i9.AdminAuditLogRow?>()) {
      return (data != null ? _i9.AdminAuditLogRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.AdminAuthResult?>()) {
      return (data != null ? _i10.AdminAuthResult.fromJson(data) : null) as T;
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
    if (t == _i1.getType<_i13.AdminNotificationPreferenceRow?>()) {
      return (data != null
              ? _i13.AdminNotificationPreferenceRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i14.AdminTopProduct?>()) {
      return (data != null ? _i14.AdminTopProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.ApiResponse?>()) {
      return (data != null ? _i15.ApiResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.AppUser?>()) {
      return (data != null ? _i16.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.AppUserRow?>()) {
      return (data != null ? _i17.AppUserRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.AppliedCouponInfo?>()) {
      return (data != null ? _i18.AppliedCouponInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.AppliedOfferInfo?>()) {
      return (data != null ? _i19.AppliedOfferInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Banner?>()) {
      return (data != null ? _i20.Banner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.BannerLinkedProductRow?>()) {
      return (data != null ? _i21.BannerLinkedProductRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.BannerPage?>()) {
      return (data != null ? _i22.BannerPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.BannerPlacementRow?>()) {
      return (data != null ? _i23.BannerPlacementRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.BannerRow?>()) {
      return (data != null ? _i24.BannerRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.BasketSuggestion?>()) {
      return (data != null ? _i25.BasketSuggestion.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.BasketSuggestionAction?>()) {
      return (data != null ? _i26.BasketSuggestionAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.BasketSuggestionResult?>()) {
      return (data != null ? _i27.BasketSuggestionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.BestCouponResult?>()) {
      return (data != null ? _i28.BestCouponResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.BogoFreeProduct?>()) {
      return (data != null ? _i29.BogoFreeProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.BogoOffer?>()) {
      return (data != null ? _i30.BogoOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.BogoOfferPage?>()) {
      return (data != null ? _i31.BogoOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.BogoOfferRewardRow?>()) {
      return (data != null ? _i32.BogoOfferRewardRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.BogoOfferRow?>()) {
      return (data != null ? _i33.BogoOfferRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.BroadcastPage?>()) {
      return (data != null ? _i34.BroadcastPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.BroadcastRequest?>()) {
      return (data != null ? _i35.BroadcastRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.BroadcastSummary?>()) {
      return (data != null ? _i36.BroadcastSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.CartItem?>()) {
      return (data != null ? _i37.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.CartItemInput?>()) {
      return (data != null ? _i38.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.CartPricingResult?>()) {
      return (data != null ? _i39.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.Category?>()) {
      return (data != null ? _i40.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.CategoryOffer?>()) {
      return (data != null ? _i41.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.CategoryOfferPage?>()) {
      return (data != null ? _i42.CategoryOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.CategoryOfferProductExclusionRow?>()) {
      return (data != null
              ? _i43.CategoryOfferProductExclusionRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i44.CategoryOfferProductScopeRow?>()) {
      return (data != null
              ? _i44.CategoryOfferProductScopeRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i45.CategoryOfferRow?>()) {
      return (data != null ? _i45.CategoryOfferRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.CategoryRow?>()) {
      return (data != null ? _i46.CategoryRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.CheckoutResult?>()) {
      return (data != null ? _i47.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.ComboOffer?>()) {
      return (data != null ? _i48.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.ComboOfferItemRow?>()) {
      return (data != null ? _i49.ComboOfferItemRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.ComboOfferPage?>()) {
      return (data != null ? _i50.ComboOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.ComboOfferRow?>()) {
      return (data != null ? _i51.ComboOfferRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.ComboProductItem?>()) {
      return (data != null ? _i52.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.Complaint?>()) {
      return (data != null ? _i53.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.ComplaintPage?>()) {
      return (data != null ? _i54.ComplaintPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.ComplaintProductItem?>()) {
      return (data != null ? _i55.ComplaintProductItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.ComplaintRow?>()) {
      return (data != null ? _i56.ComplaintRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.Coupon?>()) {
      return (data != null ? _i57.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.CouponDisplay?>()) {
      return (data != null ? _i58.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.CouponProductScopeRow?>()) {
      return (data != null ? _i59.CouponProductScopeRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.CouponRow?>()) {
      return (data != null ? _i60.CouponRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.CouponValidationResult?>()) {
      return (data != null ? _i61.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.CustomerOrderRow?>()) {
      return (data != null ? _i62.CustomerOrderRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.DeliveryConfig?>()) {
      return (data != null ? _i63.DeliveryConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.DeliveryConfigRow?>()) {
      return (data != null ? _i64.DeliveryConfigRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.DeliveryPricingResult?>()) {
      return (data != null ? _i65.DeliveryPricingResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.DeliveryRule?>()) {
      return (data != null ? _i66.DeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.DeliveryRulePage?>()) {
      return (data != null ? _i67.DeliveryRulePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.DeliveryRuleRow?>()) {
      return (data != null ? _i68.DeliveryRuleRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.DeliverySlab?>()) {
      return (data != null ? _i69.DeliverySlab.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.DeliverySlabRow?>()) {
      return (data != null ? _i70.DeliverySlabRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.FreeDeliveryRule?>()) {
      return (data != null ? _i71.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.FreeDeliveryRulePage?>()) {
      return (data != null ? _i72.FreeDeliveryRulePage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.FreeDeliveryRuleRow?>()) {
      return (data != null ? _i73.FreeDeliveryRuleRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i74.FreeItemInfo?>()) {
      return (data != null ? _i74.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.IdempotencyRecordRow?>()) {
      return (data != null ? _i75.IdempotencyRecordRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i76.NotificationCampaignRow?>()) {
      return (data != null ? _i76.NotificationCampaignRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i77.NotificationDraft?>()) {
      return (data != null ? _i77.NotificationDraft.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.NotificationHistoryItem?>()) {
      return (data != null ? _i78.NotificationHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i79.NotificationHistoryPage?>()) {
      return (data != null ? _i79.NotificationHistoryPage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i80.NotificationOutboxRow?>()) {
      return (data != null ? _i80.NotificationOutboxRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i81.NotificationPreference?>()) {
      return (data != null ? _i81.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i82.NotificationPreferenceRow?>()) {
      return (data != null
              ? _i82.NotificationPreferenceRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i83.NotificationUserStateRow?>()) {
      return (data != null
              ? _i83.NotificationUserStateRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i84.OfferSearchItem?>()) {
      return (data != null ? _i84.OfferSearchItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i85.OfferSearchPage?>()) {
      return (data != null ? _i85.OfferSearchPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i86.Order?>()) {
      return (data != null ? _i86.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i87.OrderAddressRow?>()) {
      return (data != null ? _i87.OrderAddressRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i88.OrderItem?>()) {
      return (data != null ? _i88.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i89.OrderItemRow?>()) {
      return (data != null ? _i89.OrderItemRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i90.OrderNotificationOutboxRow?>()) {
      return (data != null
              ? _i90.OrderNotificationOutboxRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i91.OrderPage?>()) {
      return (data != null ? _i91.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i92.OrderRealtimeEvent?>()) {
      return (data != null ? _i92.OrderRealtimeEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i93.OrderTrackingData?>()) {
      return (data != null ? _i93.OrderTrackingData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.OrderTrackingRow?>()) {
      return (data != null ? _i94.OrderTrackingRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.PaymentActionResult?>()) {
      return (data != null ? _i95.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i96.PaymentOrderResult?>()) {
      return (data != null ? _i96.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i97.PaymentTransactionRow?>()) {
      return (data != null ? _i97.PaymentTransactionRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i98.PaymentVerifyResult?>()) {
      return (data != null ? _i98.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i99.PricingLineItem?>()) {
      return (data != null ? _i99.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.Product?>()) {
      return (data != null ? _i100.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i101.ProductPage?>()) {
      return (data != null ? _i101.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i102.ProductRankingItem?>()) {
      return (data != null ? _i102.ProductRankingItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i103.ProductRow?>()) {
      return (data != null ? _i103.ProductRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i104.ProductSearchDocumentRow?>()) {
      return (data != null
              ? _i104.ProductSearchDocumentRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i105.ProductSearchRebuildJobRow?>()) {
      return (data != null
              ? _i105.ProductSearchRebuildJobRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i106.ProductSubCategoryRow?>()) {
      return (data != null ? _i106.ProductSubCategoryRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i107.ProductVariant?>()) {
      return (data != null ? _i107.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i108.ProductVariantRow?>()) {
      return (data != null ? _i108.ProductVariantRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i109.RefundRecord?>()) {
      return (data != null ? _i109.RefundRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i110.RefundRecordRow?>()) {
      return (data != null ? _i110.RefundRecordRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i111.RegisterFcmTokenRequest?>()) {
      return (data != null
              ? _i111.RegisterFcmTokenRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i112.SubCategory?>()) {
      return (data != null ? _i112.SubCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i113.SubCategoryRow?>()) {
      return (data != null ? _i113.SubCategoryRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i114.SupportIssue?>()) {
      return (data != null ? _i114.SupportIssue.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i115.SupportIssueRow?>()) {
      return (data != null ? _i115.SupportIssueRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i116.UserAddressRow?>()) {
      return (data != null ? _i116.UserAddressRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i117.UserCartItemRow?>()) {
      return (data != null ? _i117.UserCartItemRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i118.UserFcmTokenRow?>()) {
      return (data != null ? _i118.UserFcmTokenRow.fromJson(data) : null) as T;
    }
    if (t == List<_i14.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i14.AdminTopProduct>(e))
              .toList()
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
    if (t == List<_i37.CartItem>) {
      return (data as List).map((e) => deserialize<_i37.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i37.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i37.CartItem>(e))
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
    if (t == List<_i20.Banner>) {
      return (data as List).map((e) => deserialize<_i20.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i26.BasketSuggestionAction>) {
      return (data as List)
              .map((e) => deserialize<_i26.BasketSuggestionAction>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i26.BasketSuggestionAction>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i26.BasketSuggestionAction>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i25.BasketSuggestion>) {
      return (data as List)
              .map((e) => deserialize<_i25.BasketSuggestion>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i25.BasketSuggestion>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i25.BasketSuggestion>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i29.BogoFreeProduct>) {
      return (data as List)
              .map((e) => deserialize<_i29.BogoFreeProduct>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i29.BogoFreeProduct>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i29.BogoFreeProduct>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i30.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i30.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i36.BroadcastSummary>) {
      return (data as List)
              .map((e) => deserialize<_i36.BroadcastSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i19.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i74.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i74.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i99.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i99.PricingLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i41.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i41.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i52.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i52.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i48.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i48.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i55.ComplaintProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i55.ComplaintProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i53.Complaint>) {
      return (data as List).map((e) => deserialize<_i53.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i69.DeliverySlab>) {
      return (data as List)
              .map((e) => deserialize<_i69.DeliverySlab>(e))
              .toList()
          as T;
    }
    if (t == List<_i66.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i66.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i71.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i71.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i78.NotificationHistoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i78.NotificationHistoryItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i100.Product>) {
      return (data as List).map((e) => deserialize<_i100.Product>(e)).toList()
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
    if (t == List<_i84.OfferSearchItem>) {
      return (data as List)
              .map((e) => deserialize<_i84.OfferSearchItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i88.OrderItem>) {
      return (data as List).map((e) => deserialize<_i88.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i86.Order>) {
      return (data as List).map((e) => deserialize<_i86.Order>(e)).toList()
          as T;
    }
    if (t == List<_i107.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i107.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i107.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i107.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i119.AppUser>) {
      return (data as List).map((e) => deserialize<_i119.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i120.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i120.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i121.ActiveUserStatistics>) {
      return (data as List)
              .map((e) => deserialize<_i121.ActiveUserStatistics>(e))
              .toList()
          as T;
    }
    if (t == List<_i122.Banner>) {
      return (data as List).map((e) => deserialize<_i122.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i123.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i123.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i124.Category>) {
      return (data as List).map((e) => deserialize<_i124.Category>(e)).toList()
          as T;
    }
    if (t == List<_i125.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i125.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i126.ComboOffer>) {
      return (data as List)
              .map((e) => deserialize<_i126.ComboOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i127.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i127.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i128.Coupon>) {
      return (data as List).map((e) => deserialize<_i128.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i129.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i129.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i130.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i130.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i131.AdminNotificationPreference>) {
      return (data as List)
              .map((e) => deserialize<_i131.AdminNotificationPreference>(e))
              .toList()
          as T;
    }
    if (t == List<_i132.Order>) {
      return (data as List).map((e) => deserialize<_i132.Order>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<List<double>>) {
      return (data as List).map((e) => deserialize<List<double>>(e)).toList()
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<_i133.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i133.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i127.CartItemInput>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i127.CartItemInput>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i134.Product>) {
      return (data as List).map((e) => deserialize<_i134.Product>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i135.ProductRankingItem>) {
      return (data as List)
              .map((e) => deserialize<_i135.ProductRankingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i136.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i136.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i137.CartItem>) {
      return (data as List).map((e) => deserialize<_i137.CartItem>(e)).toList()
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
      _i9.AdminAuditLogRow => 'AdminAuditLogRow',
      _i10.AdminAuthResult => 'AdminAuthResult',
      _i11.AdminDashboardStats => 'AdminDashboardStats',
      _i12.AdminNotificationPreference => 'AdminNotificationPreference',
      _i13.AdminNotificationPreferenceRow => 'AdminNotificationPreferenceRow',
      _i14.AdminTopProduct => 'AdminTopProduct',
      _i15.ApiResponse => 'ApiResponse',
      _i16.AppUser => 'AppUser',
      _i17.AppUserRow => 'AppUserRow',
      _i18.AppliedCouponInfo => 'AppliedCouponInfo',
      _i19.AppliedOfferInfo => 'AppliedOfferInfo',
      _i20.Banner => 'Banner',
      _i21.BannerLinkedProductRow => 'BannerLinkedProductRow',
      _i22.BannerPage => 'BannerPage',
      _i23.BannerPlacementRow => 'BannerPlacementRow',
      _i24.BannerRow => 'BannerRow',
      _i25.BasketSuggestion => 'BasketSuggestion',
      _i26.BasketSuggestionAction => 'BasketSuggestionAction',
      _i27.BasketSuggestionResult => 'BasketSuggestionResult',
      _i28.BestCouponResult => 'BestCouponResult',
      _i29.BogoFreeProduct => 'BogoFreeProduct',
      _i30.BogoOffer => 'BogoOffer',
      _i31.BogoOfferPage => 'BogoOfferPage',
      _i32.BogoOfferRewardRow => 'BogoOfferRewardRow',
      _i33.BogoOfferRow => 'BogoOfferRow',
      _i34.BroadcastPage => 'BroadcastPage',
      _i35.BroadcastRequest => 'BroadcastRequest',
      _i36.BroadcastSummary => 'BroadcastSummary',
      _i37.CartItem => 'CartItem',
      _i38.CartItemInput => 'CartItemInput',
      _i39.CartPricingResult => 'CartPricingResult',
      _i40.Category => 'Category',
      _i41.CategoryOffer => 'CategoryOffer',
      _i42.CategoryOfferPage => 'CategoryOfferPage',
      _i43.CategoryOfferProductExclusionRow =>
        'CategoryOfferProductExclusionRow',
      _i44.CategoryOfferProductScopeRow => 'CategoryOfferProductScopeRow',
      _i45.CategoryOfferRow => 'CategoryOfferRow',
      _i46.CategoryRow => 'CategoryRow',
      _i47.CheckoutResult => 'CheckoutResult',
      _i48.ComboOffer => 'ComboOffer',
      _i49.ComboOfferItemRow => 'ComboOfferItemRow',
      _i50.ComboOfferPage => 'ComboOfferPage',
      _i51.ComboOfferRow => 'ComboOfferRow',
      _i52.ComboProductItem => 'ComboProductItem',
      _i53.Complaint => 'Complaint',
      _i54.ComplaintPage => 'ComplaintPage',
      _i55.ComplaintProductItem => 'ComplaintProductItem',
      _i56.ComplaintRow => 'ComplaintRow',
      _i57.Coupon => 'Coupon',
      _i58.CouponDisplay => 'CouponDisplay',
      _i59.CouponProductScopeRow => 'CouponProductScopeRow',
      _i60.CouponRow => 'CouponRow',
      _i61.CouponValidationResult => 'CouponValidationResult',
      _i62.CustomerOrderRow => 'CustomerOrderRow',
      _i63.DeliveryConfig => 'DeliveryConfig',
      _i64.DeliveryConfigRow => 'DeliveryConfigRow',
      _i65.DeliveryPricingResult => 'DeliveryPricingResult',
      _i66.DeliveryRule => 'DeliveryRule',
      _i67.DeliveryRulePage => 'DeliveryRulePage',
      _i68.DeliveryRuleRow => 'DeliveryRuleRow',
      _i69.DeliverySlab => 'DeliverySlab',
      _i70.DeliverySlabRow => 'DeliverySlabRow',
      _i71.FreeDeliveryRule => 'FreeDeliveryRule',
      _i72.FreeDeliveryRulePage => 'FreeDeliveryRulePage',
      _i73.FreeDeliveryRuleRow => 'FreeDeliveryRuleRow',
      _i74.FreeItemInfo => 'FreeItemInfo',
      _i75.IdempotencyRecordRow => 'IdempotencyRecordRow',
      _i76.NotificationCampaignRow => 'NotificationCampaignRow',
      _i77.NotificationDraft => 'NotificationDraft',
      _i78.NotificationHistoryItem => 'NotificationHistoryItem',
      _i79.NotificationHistoryPage => 'NotificationHistoryPage',
      _i80.NotificationOutboxRow => 'NotificationOutboxRow',
      _i81.NotificationPreference => 'NotificationPreference',
      _i82.NotificationPreferenceRow => 'NotificationPreferenceRow',
      _i83.NotificationUserStateRow => 'NotificationUserStateRow',
      _i84.OfferSearchItem => 'OfferSearchItem',
      _i85.OfferSearchPage => 'OfferSearchPage',
      _i86.Order => 'Order',
      _i87.OrderAddressRow => 'OrderAddressRow',
      _i88.OrderItem => 'OrderItem',
      _i89.OrderItemRow => 'OrderItemRow',
      _i90.OrderNotificationOutboxRow => 'OrderNotificationOutboxRow',
      _i91.OrderPage => 'OrderPage',
      _i92.OrderRealtimeEvent => 'OrderRealtimeEvent',
      _i93.OrderTrackingData => 'OrderTrackingData',
      _i94.OrderTrackingRow => 'OrderTrackingRow',
      _i95.PaymentActionResult => 'PaymentActionResult',
      _i96.PaymentOrderResult => 'PaymentOrderResult',
      _i97.PaymentTransactionRow => 'PaymentTransactionRow',
      _i98.PaymentVerifyResult => 'PaymentVerifyResult',
      _i99.PricingLineItem => 'PricingLineItem',
      _i100.Product => 'Product',
      _i101.ProductPage => 'ProductPage',
      _i102.ProductRankingItem => 'ProductRankingItem',
      _i103.ProductRow => 'ProductRow',
      _i104.ProductSearchDocumentRow => 'ProductSearchDocumentRow',
      _i105.ProductSearchRebuildJobRow => 'ProductSearchRebuildJobRow',
      _i106.ProductSubCategoryRow => 'ProductSubCategoryRow',
      _i107.ProductVariant => 'ProductVariant',
      _i108.ProductVariantRow => 'ProductVariantRow',
      _i109.RefundRecord => 'RefundRecord',
      _i110.RefundRecordRow => 'RefundRecordRow',
      _i111.RegisterFcmTokenRequest => 'RegisterFcmTokenRequest',
      _i112.SubCategory => 'SubCategory',
      _i113.SubCategoryRow => 'SubCategoryRow',
      _i114.SupportIssue => 'SupportIssue',
      _i115.SupportIssueRow => 'SupportIssueRow',
      _i116.UserAddressRow => 'UserAddressRow',
      _i117.UserCartItemRow => 'UserCartItemRow',
      _i118.UserFcmTokenRow => 'UserFcmTokenRow',
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
      case _i9.AdminAuditLogRow():
        return 'AdminAuditLogRow';
      case _i10.AdminAuthResult():
        return 'AdminAuthResult';
      case _i11.AdminDashboardStats():
        return 'AdminDashboardStats';
      case _i12.AdminNotificationPreference():
        return 'AdminNotificationPreference';
      case _i13.AdminNotificationPreferenceRow():
        return 'AdminNotificationPreferenceRow';
      case _i14.AdminTopProduct():
        return 'AdminTopProduct';
      case _i15.ApiResponse():
        return 'ApiResponse';
      case _i16.AppUser():
        return 'AppUser';
      case _i17.AppUserRow():
        return 'AppUserRow';
      case _i18.AppliedCouponInfo():
        return 'AppliedCouponInfo';
      case _i19.AppliedOfferInfo():
        return 'AppliedOfferInfo';
      case _i20.Banner():
        return 'Banner';
      case _i21.BannerLinkedProductRow():
        return 'BannerLinkedProductRow';
      case _i22.BannerPage():
        return 'BannerPage';
      case _i23.BannerPlacementRow():
        return 'BannerPlacementRow';
      case _i24.BannerRow():
        return 'BannerRow';
      case _i25.BasketSuggestion():
        return 'BasketSuggestion';
      case _i26.BasketSuggestionAction():
        return 'BasketSuggestionAction';
      case _i27.BasketSuggestionResult():
        return 'BasketSuggestionResult';
      case _i28.BestCouponResult():
        return 'BestCouponResult';
      case _i29.BogoFreeProduct():
        return 'BogoFreeProduct';
      case _i30.BogoOffer():
        return 'BogoOffer';
      case _i31.BogoOfferPage():
        return 'BogoOfferPage';
      case _i32.BogoOfferRewardRow():
        return 'BogoOfferRewardRow';
      case _i33.BogoOfferRow():
        return 'BogoOfferRow';
      case _i34.BroadcastPage():
        return 'BroadcastPage';
      case _i35.BroadcastRequest():
        return 'BroadcastRequest';
      case _i36.BroadcastSummary():
        return 'BroadcastSummary';
      case _i37.CartItem():
        return 'CartItem';
      case _i38.CartItemInput():
        return 'CartItemInput';
      case _i39.CartPricingResult():
        return 'CartPricingResult';
      case _i40.Category():
        return 'Category';
      case _i41.CategoryOffer():
        return 'CategoryOffer';
      case _i42.CategoryOfferPage():
        return 'CategoryOfferPage';
      case _i43.CategoryOfferProductExclusionRow():
        return 'CategoryOfferProductExclusionRow';
      case _i44.CategoryOfferProductScopeRow():
        return 'CategoryOfferProductScopeRow';
      case _i45.CategoryOfferRow():
        return 'CategoryOfferRow';
      case _i46.CategoryRow():
        return 'CategoryRow';
      case _i47.CheckoutResult():
        return 'CheckoutResult';
      case _i48.ComboOffer():
        return 'ComboOffer';
      case _i49.ComboOfferItemRow():
        return 'ComboOfferItemRow';
      case _i50.ComboOfferPage():
        return 'ComboOfferPage';
      case _i51.ComboOfferRow():
        return 'ComboOfferRow';
      case _i52.ComboProductItem():
        return 'ComboProductItem';
      case _i53.Complaint():
        return 'Complaint';
      case _i54.ComplaintPage():
        return 'ComplaintPage';
      case _i55.ComplaintProductItem():
        return 'ComplaintProductItem';
      case _i56.ComplaintRow():
        return 'ComplaintRow';
      case _i57.Coupon():
        return 'Coupon';
      case _i58.CouponDisplay():
        return 'CouponDisplay';
      case _i59.CouponProductScopeRow():
        return 'CouponProductScopeRow';
      case _i60.CouponRow():
        return 'CouponRow';
      case _i61.CouponValidationResult():
        return 'CouponValidationResult';
      case _i62.CustomerOrderRow():
        return 'CustomerOrderRow';
      case _i63.DeliveryConfig():
        return 'DeliveryConfig';
      case _i64.DeliveryConfigRow():
        return 'DeliveryConfigRow';
      case _i65.DeliveryPricingResult():
        return 'DeliveryPricingResult';
      case _i66.DeliveryRule():
        return 'DeliveryRule';
      case _i67.DeliveryRulePage():
        return 'DeliveryRulePage';
      case _i68.DeliveryRuleRow():
        return 'DeliveryRuleRow';
      case _i69.DeliverySlab():
        return 'DeliverySlab';
      case _i70.DeliverySlabRow():
        return 'DeliverySlabRow';
      case _i71.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i72.FreeDeliveryRulePage():
        return 'FreeDeliveryRulePage';
      case _i73.FreeDeliveryRuleRow():
        return 'FreeDeliveryRuleRow';
      case _i74.FreeItemInfo():
        return 'FreeItemInfo';
      case _i75.IdempotencyRecordRow():
        return 'IdempotencyRecordRow';
      case _i76.NotificationCampaignRow():
        return 'NotificationCampaignRow';
      case _i77.NotificationDraft():
        return 'NotificationDraft';
      case _i78.NotificationHistoryItem():
        return 'NotificationHistoryItem';
      case _i79.NotificationHistoryPage():
        return 'NotificationHistoryPage';
      case _i80.NotificationOutboxRow():
        return 'NotificationOutboxRow';
      case _i81.NotificationPreference():
        return 'NotificationPreference';
      case _i82.NotificationPreferenceRow():
        return 'NotificationPreferenceRow';
      case _i83.NotificationUserStateRow():
        return 'NotificationUserStateRow';
      case _i84.OfferSearchItem():
        return 'OfferSearchItem';
      case _i85.OfferSearchPage():
        return 'OfferSearchPage';
      case _i86.Order():
        return 'Order';
      case _i87.OrderAddressRow():
        return 'OrderAddressRow';
      case _i88.OrderItem():
        return 'OrderItem';
      case _i89.OrderItemRow():
        return 'OrderItemRow';
      case _i90.OrderNotificationOutboxRow():
        return 'OrderNotificationOutboxRow';
      case _i91.OrderPage():
        return 'OrderPage';
      case _i92.OrderRealtimeEvent():
        return 'OrderRealtimeEvent';
      case _i93.OrderTrackingData():
        return 'OrderTrackingData';
      case _i94.OrderTrackingRow():
        return 'OrderTrackingRow';
      case _i95.PaymentActionResult():
        return 'PaymentActionResult';
      case _i96.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i97.PaymentTransactionRow():
        return 'PaymentTransactionRow';
      case _i98.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i99.PricingLineItem():
        return 'PricingLineItem';
      case _i100.Product():
        return 'Product';
      case _i101.ProductPage():
        return 'ProductPage';
      case _i102.ProductRankingItem():
        return 'ProductRankingItem';
      case _i103.ProductRow():
        return 'ProductRow';
      case _i104.ProductSearchDocumentRow():
        return 'ProductSearchDocumentRow';
      case _i105.ProductSearchRebuildJobRow():
        return 'ProductSearchRebuildJobRow';
      case _i106.ProductSubCategoryRow():
        return 'ProductSubCategoryRow';
      case _i107.ProductVariant():
        return 'ProductVariant';
      case _i108.ProductVariantRow():
        return 'ProductVariantRow';
      case _i109.RefundRecord():
        return 'RefundRecord';
      case _i110.RefundRecordRow():
        return 'RefundRecordRow';
      case _i111.RegisterFcmTokenRequest():
        return 'RegisterFcmTokenRequest';
      case _i112.SubCategory():
        return 'SubCategory';
      case _i113.SubCategoryRow():
        return 'SubCategoryRow';
      case _i114.SupportIssue():
        return 'SupportIssue';
      case _i115.SupportIssueRow():
        return 'SupportIssueRow';
      case _i116.UserAddressRow():
        return 'UserAddressRow';
      case _i117.UserCartItemRow():
        return 'UserCartItemRow';
      case _i118.UserFcmTokenRow():
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
    if (dataClassName == 'AdminAuditLogRow') {
      return deserialize<_i9.AdminAuditLogRow>(data['data']);
    }
    if (dataClassName == 'AdminAuthResult') {
      return deserialize<_i10.AdminAuthResult>(data['data']);
    }
    if (dataClassName == 'AdminDashboardStats') {
      return deserialize<_i11.AdminDashboardStats>(data['data']);
    }
    if (dataClassName == 'AdminNotificationPreference') {
      return deserialize<_i12.AdminNotificationPreference>(data['data']);
    }
    if (dataClassName == 'AdminNotificationPreferenceRow') {
      return deserialize<_i13.AdminNotificationPreferenceRow>(data['data']);
    }
    if (dataClassName == 'AdminTopProduct') {
      return deserialize<_i14.AdminTopProduct>(data['data']);
    }
    if (dataClassName == 'ApiResponse') {
      return deserialize<_i15.ApiResponse>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i16.AppUser>(data['data']);
    }
    if (dataClassName == 'AppUserRow') {
      return deserialize<_i17.AppUserRow>(data['data']);
    }
    if (dataClassName == 'AppliedCouponInfo') {
      return deserialize<_i18.AppliedCouponInfo>(data['data']);
    }
    if (dataClassName == 'AppliedOfferInfo') {
      return deserialize<_i19.AppliedOfferInfo>(data['data']);
    }
    if (dataClassName == 'Banner') {
      return deserialize<_i20.Banner>(data['data']);
    }
    if (dataClassName == 'BannerLinkedProductRow') {
      return deserialize<_i21.BannerLinkedProductRow>(data['data']);
    }
    if (dataClassName == 'BannerPage') {
      return deserialize<_i22.BannerPage>(data['data']);
    }
    if (dataClassName == 'BannerPlacementRow') {
      return deserialize<_i23.BannerPlacementRow>(data['data']);
    }
    if (dataClassName == 'BannerRow') {
      return deserialize<_i24.BannerRow>(data['data']);
    }
    if (dataClassName == 'BasketSuggestion') {
      return deserialize<_i25.BasketSuggestion>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionAction') {
      return deserialize<_i26.BasketSuggestionAction>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionResult') {
      return deserialize<_i27.BasketSuggestionResult>(data['data']);
    }
    if (dataClassName == 'BestCouponResult') {
      return deserialize<_i28.BestCouponResult>(data['data']);
    }
    if (dataClassName == 'BogoFreeProduct') {
      return deserialize<_i29.BogoFreeProduct>(data['data']);
    }
    if (dataClassName == 'BogoOffer') {
      return deserialize<_i30.BogoOffer>(data['data']);
    }
    if (dataClassName == 'BogoOfferPage') {
      return deserialize<_i31.BogoOfferPage>(data['data']);
    }
    if (dataClassName == 'BogoOfferRewardRow') {
      return deserialize<_i32.BogoOfferRewardRow>(data['data']);
    }
    if (dataClassName == 'BogoOfferRow') {
      return deserialize<_i33.BogoOfferRow>(data['data']);
    }
    if (dataClassName == 'BroadcastPage') {
      return deserialize<_i34.BroadcastPage>(data['data']);
    }
    if (dataClassName == 'BroadcastRequest') {
      return deserialize<_i35.BroadcastRequest>(data['data']);
    }
    if (dataClassName == 'BroadcastSummary') {
      return deserialize<_i36.BroadcastSummary>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i37.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i38.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i39.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i40.Category>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i41.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'CategoryOfferPage') {
      return deserialize<_i42.CategoryOfferPage>(data['data']);
    }
    if (dataClassName == 'CategoryOfferProductExclusionRow') {
      return deserialize<_i43.CategoryOfferProductExclusionRow>(data['data']);
    }
    if (dataClassName == 'CategoryOfferProductScopeRow') {
      return deserialize<_i44.CategoryOfferProductScopeRow>(data['data']);
    }
    if (dataClassName == 'CategoryOfferRow') {
      return deserialize<_i45.CategoryOfferRow>(data['data']);
    }
    if (dataClassName == 'CategoryRow') {
      return deserialize<_i46.CategoryRow>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i47.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i48.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboOfferItemRow') {
      return deserialize<_i49.ComboOfferItemRow>(data['data']);
    }
    if (dataClassName == 'ComboOfferPage') {
      return deserialize<_i50.ComboOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboOfferRow') {
      return deserialize<_i51.ComboOfferRow>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i52.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i53.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintPage') {
      return deserialize<_i54.ComplaintPage>(data['data']);
    }
    if (dataClassName == 'ComplaintProductItem') {
      return deserialize<_i55.ComplaintProductItem>(data['data']);
    }
    if (dataClassName == 'ComplaintRow') {
      return deserialize<_i56.ComplaintRow>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i57.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i58.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponProductScopeRow') {
      return deserialize<_i59.CouponProductScopeRow>(data['data']);
    }
    if (dataClassName == 'CouponRow') {
      return deserialize<_i60.CouponRow>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i61.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'CustomerOrderRow') {
      return deserialize<_i62.CustomerOrderRow>(data['data']);
    }
    if (dataClassName == 'DeliveryConfig') {
      return deserialize<_i63.DeliveryConfig>(data['data']);
    }
    if (dataClassName == 'DeliveryConfigRow') {
      return deserialize<_i64.DeliveryConfigRow>(data['data']);
    }
    if (dataClassName == 'DeliveryPricingResult') {
      return deserialize<_i65.DeliveryPricingResult>(data['data']);
    }
    if (dataClassName == 'DeliveryRule') {
      return deserialize<_i66.DeliveryRule>(data['data']);
    }
    if (dataClassName == 'DeliveryRulePage') {
      return deserialize<_i67.DeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'DeliveryRuleRow') {
      return deserialize<_i68.DeliveryRuleRow>(data['data']);
    }
    if (dataClassName == 'DeliverySlab') {
      return deserialize<_i69.DeliverySlab>(data['data']);
    }
    if (dataClassName == 'DeliverySlabRow') {
      return deserialize<_i70.DeliverySlabRow>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i71.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRulePage') {
      return deserialize<_i72.FreeDeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRuleRow') {
      return deserialize<_i73.FreeDeliveryRuleRow>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i74.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'IdempotencyRecordRow') {
      return deserialize<_i75.IdempotencyRecordRow>(data['data']);
    }
    if (dataClassName == 'NotificationCampaignRow') {
      return deserialize<_i76.NotificationCampaignRow>(data['data']);
    }
    if (dataClassName == 'NotificationDraft') {
      return deserialize<_i77.NotificationDraft>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryItem') {
      return deserialize<_i78.NotificationHistoryItem>(data['data']);
    }
    if (dataClassName == 'NotificationHistoryPage') {
      return deserialize<_i79.NotificationHistoryPage>(data['data']);
    }
    if (dataClassName == 'NotificationOutboxRow') {
      return deserialize<_i80.NotificationOutboxRow>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i81.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'NotificationPreferenceRow') {
      return deserialize<_i82.NotificationPreferenceRow>(data['data']);
    }
    if (dataClassName == 'NotificationUserStateRow') {
      return deserialize<_i83.NotificationUserStateRow>(data['data']);
    }
    if (dataClassName == 'OfferSearchItem') {
      return deserialize<_i84.OfferSearchItem>(data['data']);
    }
    if (dataClassName == 'OfferSearchPage') {
      return deserialize<_i85.OfferSearchPage>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i86.Order>(data['data']);
    }
    if (dataClassName == 'OrderAddressRow') {
      return deserialize<_i87.OrderAddressRow>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i88.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderItemRow') {
      return deserialize<_i89.OrderItemRow>(data['data']);
    }
    if (dataClassName == 'OrderNotificationOutboxRow') {
      return deserialize<_i90.OrderNotificationOutboxRow>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i91.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderRealtimeEvent') {
      return deserialize<_i92.OrderRealtimeEvent>(data['data']);
    }
    if (dataClassName == 'OrderTrackingData') {
      return deserialize<_i93.OrderTrackingData>(data['data']);
    }
    if (dataClassName == 'OrderTrackingRow') {
      return deserialize<_i94.OrderTrackingRow>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i95.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i96.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentTransactionRow') {
      return deserialize<_i97.PaymentTransactionRow>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i98.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i99.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i100.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i101.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductRankingItem') {
      return deserialize<_i102.ProductRankingItem>(data['data']);
    }
    if (dataClassName == 'ProductRow') {
      return deserialize<_i103.ProductRow>(data['data']);
    }
    if (dataClassName == 'ProductSearchDocumentRow') {
      return deserialize<_i104.ProductSearchDocumentRow>(data['data']);
    }
    if (dataClassName == 'ProductSearchRebuildJobRow') {
      return deserialize<_i105.ProductSearchRebuildJobRow>(data['data']);
    }
    if (dataClassName == 'ProductSubCategoryRow') {
      return deserialize<_i106.ProductSubCategoryRow>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i107.ProductVariant>(data['data']);
    }
    if (dataClassName == 'ProductVariantRow') {
      return deserialize<_i108.ProductVariantRow>(data['data']);
    }
    if (dataClassName == 'RefundRecord') {
      return deserialize<_i109.RefundRecord>(data['data']);
    }
    if (dataClassName == 'RefundRecordRow') {
      return deserialize<_i110.RefundRecordRow>(data['data']);
    }
    if (dataClassName == 'RegisterFcmTokenRequest') {
      return deserialize<_i111.RegisterFcmTokenRequest>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i112.SubCategory>(data['data']);
    }
    if (dataClassName == 'SubCategoryRow') {
      return deserialize<_i113.SubCategoryRow>(data['data']);
    }
    if (dataClassName == 'SupportIssue') {
      return deserialize<_i114.SupportIssue>(data['data']);
    }
    if (dataClassName == 'SupportIssueRow') {
      return deserialize<_i115.SupportIssueRow>(data['data']);
    }
    if (dataClassName == 'UserAddressRow') {
      return deserialize<_i116.UserAddressRow>(data['data']);
    }
    if (dataClassName == 'UserCartItemRow') {
      return deserialize<_i117.UserCartItemRow>(data['data']);
    }
    if (dataClassName == 'UserFcmTokenRow') {
      return deserialize<_i118.UserFcmTokenRow>(data['data']);
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
      case _i9.AdminAuditLogRow:
        return _i9.AdminAuditLogRow.t;
      case _i13.AdminNotificationPreferenceRow:
        return _i13.AdminNotificationPreferenceRow.t;
      case _i17.AppUserRow:
        return _i17.AppUserRow.t;
      case _i21.BannerLinkedProductRow:
        return _i21.BannerLinkedProductRow.t;
      case _i23.BannerPlacementRow:
        return _i23.BannerPlacementRow.t;
      case _i24.BannerRow:
        return _i24.BannerRow.t;
      case _i32.BogoOfferRewardRow:
        return _i32.BogoOfferRewardRow.t;
      case _i33.BogoOfferRow:
        return _i33.BogoOfferRow.t;
      case _i43.CategoryOfferProductExclusionRow:
        return _i43.CategoryOfferProductExclusionRow.t;
      case _i44.CategoryOfferProductScopeRow:
        return _i44.CategoryOfferProductScopeRow.t;
      case _i45.CategoryOfferRow:
        return _i45.CategoryOfferRow.t;
      case _i46.CategoryRow:
        return _i46.CategoryRow.t;
      case _i49.ComboOfferItemRow:
        return _i49.ComboOfferItemRow.t;
      case _i51.ComboOfferRow:
        return _i51.ComboOfferRow.t;
      case _i56.ComplaintRow:
        return _i56.ComplaintRow.t;
      case _i59.CouponProductScopeRow:
        return _i59.CouponProductScopeRow.t;
      case _i60.CouponRow:
        return _i60.CouponRow.t;
      case _i62.CustomerOrderRow:
        return _i62.CustomerOrderRow.t;
      case _i64.DeliveryConfigRow:
        return _i64.DeliveryConfigRow.t;
      case _i68.DeliveryRuleRow:
        return _i68.DeliveryRuleRow.t;
      case _i70.DeliverySlabRow:
        return _i70.DeliverySlabRow.t;
      case _i73.FreeDeliveryRuleRow:
        return _i73.FreeDeliveryRuleRow.t;
      case _i75.IdempotencyRecordRow:
        return _i75.IdempotencyRecordRow.t;
      case _i76.NotificationCampaignRow:
        return _i76.NotificationCampaignRow.t;
      case _i80.NotificationOutboxRow:
        return _i80.NotificationOutboxRow.t;
      case _i82.NotificationPreferenceRow:
        return _i82.NotificationPreferenceRow.t;
      case _i83.NotificationUserStateRow:
        return _i83.NotificationUserStateRow.t;
      case _i87.OrderAddressRow:
        return _i87.OrderAddressRow.t;
      case _i89.OrderItemRow:
        return _i89.OrderItemRow.t;
      case _i90.OrderNotificationOutboxRow:
        return _i90.OrderNotificationOutboxRow.t;
      case _i94.OrderTrackingRow:
        return _i94.OrderTrackingRow.t;
      case _i97.PaymentTransactionRow:
        return _i97.PaymentTransactionRow.t;
      case _i103.ProductRow:
        return _i103.ProductRow.t;
      case _i104.ProductSearchDocumentRow:
        return _i104.ProductSearchDocumentRow.t;
      case _i105.ProductSearchRebuildJobRow:
        return _i105.ProductSearchRebuildJobRow.t;
      case _i106.ProductSubCategoryRow:
        return _i106.ProductSubCategoryRow.t;
      case _i108.ProductVariantRow:
        return _i108.ProductVariantRow.t;
      case _i110.RefundRecordRow:
        return _i110.RefundRecordRow.t;
      case _i113.SubCategoryRow:
        return _i113.SubCategoryRow.t;
      case _i115.SupportIssueRow:
        return _i115.SupportIssueRow.t;
      case _i116.UserAddressRow:
        return _i116.UserAddressRow.t;
      case _i117.UserCartItemRow:
        return _i117.UserCartItemRow.t;
      case _i118.UserFcmTokenRow:
        return _i118.UserFcmTokenRow.t;
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
