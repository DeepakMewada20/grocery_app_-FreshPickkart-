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
import 'address.dart' as _i5;
import 'admin_analytics.dart' as _i6;
import 'admin_audit_log_entry.dart' as _i7;
import 'admin_audit_log_row.dart' as _i8;
import 'admin_auth_result.dart' as _i9;
import 'admin_dashboard_stats.dart' as _i10;
import 'admin_top_product.dart' as _i11;
import 'app_user.dart' as _i12;
import 'app_user_row.dart' as _i13;
import 'applied_coupon_info.dart' as _i14;
import 'applied_offer_info.dart' as _i15;
import 'banner.dart' as _i16;
import 'banner_linked_product_row.dart' as _i17;
import 'banner_page.dart' as _i18;
import 'banner_placement_row.dart' as _i19;
import 'banner_row.dart' as _i20;
import 'basket_suggestion.dart' as _i21;
import 'basket_suggestion_action.dart' as _i22;
import 'basket_suggestion_result.dart' as _i23;
import 'best_coupon_result.dart' as _i24;
import 'bogo_free_product.dart' as _i25;
import 'bogo_offer.dart' as _i26;
import 'bogo_offer_page.dart' as _i27;
import 'bogo_offer_reward_row.dart' as _i28;
import 'bogo_offer_row.dart' as _i29;
import 'cart_item.dart' as _i30;
import 'cart_item_input.dart' as _i31;
import 'cart_pricing_result.dart' as _i32;
import 'category.dart' as _i33;
import 'category_offer.dart' as _i34;
import 'category_offer_page.dart' as _i35;
import 'category_offer_product_exclusion_row.dart' as _i36;
import 'category_offer_product_scope_row.dart' as _i37;
import 'category_offer_row.dart' as _i38;
import 'category_row.dart' as _i39;
import 'checkout_result.dart' as _i40;
import 'combo_offer.dart' as _i41;
import 'combo_offer_item_row.dart' as _i42;
import 'combo_offer_page.dart' as _i43;
import 'combo_offer_row.dart' as _i44;
import 'combo_product_item.dart' as _i45;
import 'coupon.dart' as _i46;
import 'coupon_display.dart' as _i47;
import 'coupon_product_scope_row.dart' as _i48;
import 'coupon_row.dart' as _i49;
import 'coupon_validation_result.dart' as _i50;
import 'customer_order_row.dart' as _i51;
import 'delivery_config.dart' as _i52;
import 'delivery_config_row.dart' as _i53;
import 'delivery_pricing_result.dart' as _i54;
import 'delivery_rule.dart' as _i55;
import 'delivery_rule_page.dart' as _i56;
import 'delivery_rule_row.dart' as _i57;
import 'delivery_slab.dart' as _i58;
import 'delivery_slab_row.dart' as _i59;
import 'free_delivery_rule.dart' as _i60;
import 'free_delivery_rule_page.dart' as _i61;
import 'free_delivery_rule_row.dart' as _i62;
import 'free_item_info.dart' as _i63;
import 'idempotency_record_row.dart' as _i64;
import 'order.dart' as _i65;
import 'order_address_row.dart' as _i66;
import 'order_item.dart' as _i67;
import 'order_item_row.dart' as _i68;
import 'order_page.dart' as _i69;
import 'order_tracking_data.dart' as _i70;
import 'order_tracking_row.dart' as _i71;
import 'payment_action_result.dart' as _i72;
import 'payment_order_result.dart' as _i73;
import 'payment_transaction_row.dart' as _i74;
import 'payment_verify_result.dart' as _i75;
import 'pricing_line_item.dart' as _i76;
import 'product.dart' as _i77;
import 'product_page.dart' as _i78;
import 'product_ranking_item.dart' as _i79;
import 'product_row.dart' as _i80;
import 'product_search_document_row.dart' as _i81;
import 'product_search_rebuild_job_row.dart' as _i82;
import 'product_sub_category_row.dart' as _i83;
import 'product_variant.dart' as _i84;
import 'product_variant_row.dart' as _i85;
import 'refund_record.dart' as _i86;
import 'refund_record_row.dart' as _i87;
import 'sub_category.dart' as _i88;
import 'sub_category_row.dart' as _i89;
import 'user_address_row.dart' as _i90;
import 'user_cart_item_row.dart' as _i91;
import 'package:freshpickkat_server/src/generated/app_user.dart' as _i92;
import 'package:freshpickkat_server/src/generated/admin_audit_log_entry.dart'
    as _i93;
import 'package:freshpickkat_server/src/generated/banner.dart' as _i94;
import 'package:freshpickkat_server/src/generated/bogo_offer.dart' as _i95;
import 'package:freshpickkat_server/src/generated/category.dart' as _i96;
import 'package:freshpickkat_server/src/generated/category_offer.dart' as _i97;
import 'package:freshpickkat_server/src/generated/combo_offer.dart' as _i98;
import 'package:freshpickkat_server/src/generated/cart_item_input.dart' as _i99;
import 'package:freshpickkat_server/src/generated/coupon.dart' as _i100;
import 'package:freshpickkat_server/src/generated/coupon_display.dart' as _i101;
import 'package:freshpickkat_server/src/generated/delivery_rule.dart' as _i102;
import 'package:freshpickkat_server/src/generated/order.dart' as _i103;
import 'package:freshpickkat_server/src/generated/applied_offer_info.dart'
    as _i104;
import 'package:freshpickkat_server/src/generated/product.dart' as _i105;
import 'package:freshpickkat_server/src/generated/product_ranking_item.dart'
    as _i106;
import 'package:freshpickkat_server/src/generated/sub_category.dart' as _i107;
import 'package:freshpickkat_server/src/generated/cart_item.dart' as _i108;
export 'address.dart';
export 'admin_analytics.dart';
export 'admin_audit_log_entry.dart';
export 'admin_audit_log_row.dart';
export 'admin_auth_result.dart';
export 'admin_dashboard_stats.dart';
export 'admin_top_product.dart';
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
export 'order.dart';
export 'order_address_row.dart';
export 'order_item.dart';
export 'order_item_row.dart';
export 'order_page.dart';
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
export 'sub_category.dart';
export 'sub_category_row.dart';
export 'user_address_row.dart';
export 'user_cart_item_row.dart';

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

    if (t == _i5.Address) {
      return _i5.Address.fromJson(data) as T;
    }
    if (t == _i6.AdminAnalytics) {
      return _i6.AdminAnalytics.fromJson(data) as T;
    }
    if (t == _i7.AdminAuditLogEntry) {
      return _i7.AdminAuditLogEntry.fromJson(data) as T;
    }
    if (t == _i8.AdminAuditLogRow) {
      return _i8.AdminAuditLogRow.fromJson(data) as T;
    }
    if (t == _i9.AdminAuthResult) {
      return _i9.AdminAuthResult.fromJson(data) as T;
    }
    if (t == _i10.AdminDashboardStats) {
      return _i10.AdminDashboardStats.fromJson(data) as T;
    }
    if (t == _i11.AdminTopProduct) {
      return _i11.AdminTopProduct.fromJson(data) as T;
    }
    if (t == _i12.AppUser) {
      return _i12.AppUser.fromJson(data) as T;
    }
    if (t == _i13.AppUserRow) {
      return _i13.AppUserRow.fromJson(data) as T;
    }
    if (t == _i14.AppliedCouponInfo) {
      return _i14.AppliedCouponInfo.fromJson(data) as T;
    }
    if (t == _i15.AppliedOfferInfo) {
      return _i15.AppliedOfferInfo.fromJson(data) as T;
    }
    if (t == _i16.Banner) {
      return _i16.Banner.fromJson(data) as T;
    }
    if (t == _i17.BannerLinkedProductRow) {
      return _i17.BannerLinkedProductRow.fromJson(data) as T;
    }
    if (t == _i18.BannerPage) {
      return _i18.BannerPage.fromJson(data) as T;
    }
    if (t == _i19.BannerPlacementRow) {
      return _i19.BannerPlacementRow.fromJson(data) as T;
    }
    if (t == _i20.BannerRow) {
      return _i20.BannerRow.fromJson(data) as T;
    }
    if (t == _i21.BasketSuggestion) {
      return _i21.BasketSuggestion.fromJson(data) as T;
    }
    if (t == _i22.BasketSuggestionAction) {
      return _i22.BasketSuggestionAction.fromJson(data) as T;
    }
    if (t == _i23.BasketSuggestionResult) {
      return _i23.BasketSuggestionResult.fromJson(data) as T;
    }
    if (t == _i24.BestCouponResult) {
      return _i24.BestCouponResult.fromJson(data) as T;
    }
    if (t == _i25.BogoFreeProduct) {
      return _i25.BogoFreeProduct.fromJson(data) as T;
    }
    if (t == _i26.BogoOffer) {
      return _i26.BogoOffer.fromJson(data) as T;
    }
    if (t == _i27.BogoOfferPage) {
      return _i27.BogoOfferPage.fromJson(data) as T;
    }
    if (t == _i28.BogoOfferRewardRow) {
      return _i28.BogoOfferRewardRow.fromJson(data) as T;
    }
    if (t == _i29.BogoOfferRow) {
      return _i29.BogoOfferRow.fromJson(data) as T;
    }
    if (t == _i30.CartItem) {
      return _i30.CartItem.fromJson(data) as T;
    }
    if (t == _i31.CartItemInput) {
      return _i31.CartItemInput.fromJson(data) as T;
    }
    if (t == _i32.CartPricingResult) {
      return _i32.CartPricingResult.fromJson(data) as T;
    }
    if (t == _i33.Category) {
      return _i33.Category.fromJson(data) as T;
    }
    if (t == _i34.CategoryOffer) {
      return _i34.CategoryOffer.fromJson(data) as T;
    }
    if (t == _i35.CategoryOfferPage) {
      return _i35.CategoryOfferPage.fromJson(data) as T;
    }
    if (t == _i36.CategoryOfferProductExclusionRow) {
      return _i36.CategoryOfferProductExclusionRow.fromJson(data) as T;
    }
    if (t == _i37.CategoryOfferProductScopeRow) {
      return _i37.CategoryOfferProductScopeRow.fromJson(data) as T;
    }
    if (t == _i38.CategoryOfferRow) {
      return _i38.CategoryOfferRow.fromJson(data) as T;
    }
    if (t == _i39.CategoryRow) {
      return _i39.CategoryRow.fromJson(data) as T;
    }
    if (t == _i40.CheckoutResult) {
      return _i40.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i41.ComboOffer) {
      return _i41.ComboOffer.fromJson(data) as T;
    }
    if (t == _i42.ComboOfferItemRow) {
      return _i42.ComboOfferItemRow.fromJson(data) as T;
    }
    if (t == _i43.ComboOfferPage) {
      return _i43.ComboOfferPage.fromJson(data) as T;
    }
    if (t == _i44.ComboOfferRow) {
      return _i44.ComboOfferRow.fromJson(data) as T;
    }
    if (t == _i45.ComboProductItem) {
      return _i45.ComboProductItem.fromJson(data) as T;
    }
    if (t == _i46.Coupon) {
      return _i46.Coupon.fromJson(data) as T;
    }
    if (t == _i47.CouponDisplay) {
      return _i47.CouponDisplay.fromJson(data) as T;
    }
    if (t == _i48.CouponProductScopeRow) {
      return _i48.CouponProductScopeRow.fromJson(data) as T;
    }
    if (t == _i49.CouponRow) {
      return _i49.CouponRow.fromJson(data) as T;
    }
    if (t == _i50.CouponValidationResult) {
      return _i50.CouponValidationResult.fromJson(data) as T;
    }
    if (t == _i51.CustomerOrderRow) {
      return _i51.CustomerOrderRow.fromJson(data) as T;
    }
    if (t == _i52.DeliveryConfig) {
      return _i52.DeliveryConfig.fromJson(data) as T;
    }
    if (t == _i53.DeliveryConfigRow) {
      return _i53.DeliveryConfigRow.fromJson(data) as T;
    }
    if (t == _i54.DeliveryPricingResult) {
      return _i54.DeliveryPricingResult.fromJson(data) as T;
    }
    if (t == _i55.DeliveryRule) {
      return _i55.DeliveryRule.fromJson(data) as T;
    }
    if (t == _i56.DeliveryRulePage) {
      return _i56.DeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i57.DeliveryRuleRow) {
      return _i57.DeliveryRuleRow.fromJson(data) as T;
    }
    if (t == _i58.DeliverySlab) {
      return _i58.DeliverySlab.fromJson(data) as T;
    }
    if (t == _i59.DeliverySlabRow) {
      return _i59.DeliverySlabRow.fromJson(data) as T;
    }
    if (t == _i60.FreeDeliveryRule) {
      return _i60.FreeDeliveryRule.fromJson(data) as T;
    }
    if (t == _i61.FreeDeliveryRulePage) {
      return _i61.FreeDeliveryRulePage.fromJson(data) as T;
    }
    if (t == _i62.FreeDeliveryRuleRow) {
      return _i62.FreeDeliveryRuleRow.fromJson(data) as T;
    }
    if (t == _i63.FreeItemInfo) {
      return _i63.FreeItemInfo.fromJson(data) as T;
    }
    if (t == _i64.IdempotencyRecordRow) {
      return _i64.IdempotencyRecordRow.fromJson(data) as T;
    }
    if (t == _i65.Order) {
      return _i65.Order.fromJson(data) as T;
    }
    if (t == _i66.OrderAddressRow) {
      return _i66.OrderAddressRow.fromJson(data) as T;
    }
    if (t == _i67.OrderItem) {
      return _i67.OrderItem.fromJson(data) as T;
    }
    if (t == _i68.OrderItemRow) {
      return _i68.OrderItemRow.fromJson(data) as T;
    }
    if (t == _i69.OrderPage) {
      return _i69.OrderPage.fromJson(data) as T;
    }
    if (t == _i70.OrderTrackingData) {
      return _i70.OrderTrackingData.fromJson(data) as T;
    }
    if (t == _i71.OrderTrackingRow) {
      return _i71.OrderTrackingRow.fromJson(data) as T;
    }
    if (t == _i72.PaymentActionResult) {
      return _i72.PaymentActionResult.fromJson(data) as T;
    }
    if (t == _i73.PaymentOrderResult) {
      return _i73.PaymentOrderResult.fromJson(data) as T;
    }
    if (t == _i74.PaymentTransactionRow) {
      return _i74.PaymentTransactionRow.fromJson(data) as T;
    }
    if (t == _i75.PaymentVerifyResult) {
      return _i75.PaymentVerifyResult.fromJson(data) as T;
    }
    if (t == _i76.PricingLineItem) {
      return _i76.PricingLineItem.fromJson(data) as T;
    }
    if (t == _i77.Product) {
      return _i77.Product.fromJson(data) as T;
    }
    if (t == _i78.ProductPage) {
      return _i78.ProductPage.fromJson(data) as T;
    }
    if (t == _i79.ProductRankingItem) {
      return _i79.ProductRankingItem.fromJson(data) as T;
    }
    if (t == _i80.ProductRow) {
      return _i80.ProductRow.fromJson(data) as T;
    }
    if (t == _i81.ProductSearchDocumentRow) {
      return _i81.ProductSearchDocumentRow.fromJson(data) as T;
    }
    if (t == _i82.ProductSearchRebuildJobRow) {
      return _i82.ProductSearchRebuildJobRow.fromJson(data) as T;
    }
    if (t == _i83.ProductSubCategoryRow) {
      return _i83.ProductSubCategoryRow.fromJson(data) as T;
    }
    if (t == _i84.ProductVariant) {
      return _i84.ProductVariant.fromJson(data) as T;
    }
    if (t == _i85.ProductVariantRow) {
      return _i85.ProductVariantRow.fromJson(data) as T;
    }
    if (t == _i86.RefundRecord) {
      return _i86.RefundRecord.fromJson(data) as T;
    }
    if (t == _i87.RefundRecordRow) {
      return _i87.RefundRecordRow.fromJson(data) as T;
    }
    if (t == _i88.SubCategory) {
      return _i88.SubCategory.fromJson(data) as T;
    }
    if (t == _i89.SubCategoryRow) {
      return _i89.SubCategoryRow.fromJson(data) as T;
    }
    if (t == _i90.UserAddressRow) {
      return _i90.UserAddressRow.fromJson(data) as T;
    }
    if (t == _i91.UserCartItemRow) {
      return _i91.UserCartItemRow.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Address?>()) {
      return (data != null ? _i5.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AdminAnalytics?>()) {
      return (data != null ? _i6.AdminAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AdminAuditLogEntry?>()) {
      return (data != null ? _i7.AdminAuditLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AdminAuditLogRow?>()) {
      return (data != null ? _i8.AdminAuditLogRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AdminAuthResult?>()) {
      return (data != null ? _i9.AdminAuthResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.AdminDashboardStats?>()) {
      return (data != null ? _i10.AdminDashboardStats.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.AdminTopProduct?>()) {
      return (data != null ? _i11.AdminTopProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.AppUser?>()) {
      return (data != null ? _i12.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.AppUserRow?>()) {
      return (data != null ? _i13.AppUserRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.AppliedCouponInfo?>()) {
      return (data != null ? _i14.AppliedCouponInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.AppliedOfferInfo?>()) {
      return (data != null ? _i15.AppliedOfferInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Banner?>()) {
      return (data != null ? _i16.Banner.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.BannerLinkedProductRow?>()) {
      return (data != null ? _i17.BannerLinkedProductRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.BannerPage?>()) {
      return (data != null ? _i18.BannerPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.BannerPlacementRow?>()) {
      return (data != null ? _i19.BannerPlacementRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.BannerRow?>()) {
      return (data != null ? _i20.BannerRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.BasketSuggestion?>()) {
      return (data != null ? _i21.BasketSuggestion.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.BasketSuggestionAction?>()) {
      return (data != null ? _i22.BasketSuggestionAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.BasketSuggestionResult?>()) {
      return (data != null ? _i23.BasketSuggestionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.BestCouponResult?>()) {
      return (data != null ? _i24.BestCouponResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.BogoFreeProduct?>()) {
      return (data != null ? _i25.BogoFreeProduct.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.BogoOffer?>()) {
      return (data != null ? _i26.BogoOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.BogoOfferPage?>()) {
      return (data != null ? _i27.BogoOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.BogoOfferRewardRow?>()) {
      return (data != null ? _i28.BogoOfferRewardRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.BogoOfferRow?>()) {
      return (data != null ? _i29.BogoOfferRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.CartItem?>()) {
      return (data != null ? _i30.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.CartItemInput?>()) {
      return (data != null ? _i31.CartItemInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.CartPricingResult?>()) {
      return (data != null ? _i32.CartPricingResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.Category?>()) {
      return (data != null ? _i33.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.CategoryOffer?>()) {
      return (data != null ? _i34.CategoryOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.CategoryOfferPage?>()) {
      return (data != null ? _i35.CategoryOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.CategoryOfferProductExclusionRow?>()) {
      return (data != null
              ? _i36.CategoryOfferProductExclusionRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i37.CategoryOfferProductScopeRow?>()) {
      return (data != null
              ? _i37.CategoryOfferProductScopeRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i38.CategoryOfferRow?>()) {
      return (data != null ? _i38.CategoryOfferRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.CategoryRow?>()) {
      return (data != null ? _i39.CategoryRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.CheckoutResult?>()) {
      return (data != null ? _i40.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.ComboOffer?>()) {
      return (data != null ? _i41.ComboOffer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.ComboOfferItemRow?>()) {
      return (data != null ? _i42.ComboOfferItemRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ComboOfferPage?>()) {
      return (data != null ? _i43.ComboOfferPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.ComboOfferRow?>()) {
      return (data != null ? _i44.ComboOfferRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.ComboProductItem?>()) {
      return (data != null ? _i45.ComboProductItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.Coupon?>()) {
      return (data != null ? _i46.Coupon.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.CouponDisplay?>()) {
      return (data != null ? _i47.CouponDisplay.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.CouponProductScopeRow?>()) {
      return (data != null ? _i48.CouponProductScopeRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.CouponRow?>()) {
      return (data != null ? _i49.CouponRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.CouponValidationResult?>()) {
      return (data != null ? _i50.CouponValidationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.CustomerOrderRow?>()) {
      return (data != null ? _i51.CustomerOrderRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.DeliveryConfig?>()) {
      return (data != null ? _i52.DeliveryConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.DeliveryConfigRow?>()) {
      return (data != null ? _i53.DeliveryConfigRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.DeliveryPricingResult?>()) {
      return (data != null ? _i54.DeliveryPricingResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.DeliveryRule?>()) {
      return (data != null ? _i55.DeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.DeliveryRulePage?>()) {
      return (data != null ? _i56.DeliveryRulePage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.DeliveryRuleRow?>()) {
      return (data != null ? _i57.DeliveryRuleRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.DeliverySlab?>()) {
      return (data != null ? _i58.DeliverySlab.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.DeliverySlabRow?>()) {
      return (data != null ? _i59.DeliverySlabRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.FreeDeliveryRule?>()) {
      return (data != null ? _i60.FreeDeliveryRule.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.FreeDeliveryRulePage?>()) {
      return (data != null ? _i61.FreeDeliveryRulePage.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.FreeDeliveryRuleRow?>()) {
      return (data != null ? _i62.FreeDeliveryRuleRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i63.FreeItemInfo?>()) {
      return (data != null ? _i63.FreeItemInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.IdempotencyRecordRow?>()) {
      return (data != null ? _i64.IdempotencyRecordRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i65.Order?>()) {
      return (data != null ? _i65.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.OrderAddressRow?>()) {
      return (data != null ? _i66.OrderAddressRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.OrderItem?>()) {
      return (data != null ? _i67.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.OrderItemRow?>()) {
      return (data != null ? _i68.OrderItemRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.OrderPage?>()) {
      return (data != null ? _i69.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.OrderTrackingData?>()) {
      return (data != null ? _i70.OrderTrackingData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.OrderTrackingRow?>()) {
      return (data != null ? _i71.OrderTrackingRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.PaymentActionResult?>()) {
      return (data != null ? _i72.PaymentActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.PaymentOrderResult?>()) {
      return (data != null ? _i73.PaymentOrderResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i74.PaymentTransactionRow?>()) {
      return (data != null ? _i74.PaymentTransactionRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i75.PaymentVerifyResult?>()) {
      return (data != null ? _i75.PaymentVerifyResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i76.PricingLineItem?>()) {
      return (data != null ? _i76.PricingLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i77.Product?>()) {
      return (data != null ? _i77.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.ProductPage?>()) {
      return (data != null ? _i78.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i79.ProductRankingItem?>()) {
      return (data != null ? _i79.ProductRankingItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i80.ProductRow?>()) {
      return (data != null ? _i80.ProductRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i81.ProductSearchDocumentRow?>()) {
      return (data != null
              ? _i81.ProductSearchDocumentRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i82.ProductSearchRebuildJobRow?>()) {
      return (data != null
              ? _i82.ProductSearchRebuildJobRow.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i83.ProductSubCategoryRow?>()) {
      return (data != null ? _i83.ProductSubCategoryRow.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i84.ProductVariant?>()) {
      return (data != null ? _i84.ProductVariant.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i85.ProductVariantRow?>()) {
      return (data != null ? _i85.ProductVariantRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i86.RefundRecord?>()) {
      return (data != null ? _i86.RefundRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i87.RefundRecordRow?>()) {
      return (data != null ? _i87.RefundRecordRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i88.SubCategory?>()) {
      return (data != null ? _i88.SubCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i89.SubCategoryRow?>()) {
      return (data != null ? _i89.SubCategoryRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i90.UserAddressRow?>()) {
      return (data != null ? _i90.UserAddressRow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i91.UserCartItemRow?>()) {
      return (data != null ? _i91.UserCartItemRow.fromJson(data) : null) as T;
    }
    if (t == List<_i11.AdminTopProduct>) {
      return (data as List)
              .map((e) => deserialize<_i11.AdminTopProduct>(e))
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
    if (t == List<_i30.CartItem>) {
      return (data as List).map((e) => deserialize<_i30.CartItem>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i30.CartItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i30.CartItem>(e))
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
    if (t == List<_i16.Banner>) {
      return (data as List).map((e) => deserialize<_i16.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i22.BasketSuggestionAction>) {
      return (data as List)
              .map((e) => deserialize<_i22.BasketSuggestionAction>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i22.BasketSuggestionAction>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i22.BasketSuggestionAction>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i21.BasketSuggestion>) {
      return (data as List)
              .map((e) => deserialize<_i21.BasketSuggestion>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i21.BasketSuggestion>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i21.BasketSuggestion>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i25.BogoFreeProduct>) {
      return (data as List)
              .map((e) => deserialize<_i25.BogoFreeProduct>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i25.BogoFreeProduct>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i25.BogoFreeProduct>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i26.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i26.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<_i15.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i15.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i63.FreeItemInfo>) {
      return (data as List)
              .map((e) => deserialize<_i63.FreeItemInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i76.PricingLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i76.PricingLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i34.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i45.ComboProductItem>) {
      return (data as List)
              .map((e) => deserialize<_i45.ComboProductItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i41.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i41.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i58.DeliverySlab>) {
      return (data as List)
              .map((e) => deserialize<_i58.DeliverySlab>(e))
              .toList()
          as T;
    }
    if (t == List<_i55.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i55.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i60.FreeDeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i60.FreeDeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i67.OrderItem>) {
      return (data as List).map((e) => deserialize<_i67.OrderItem>(e)).toList()
          as T;
    }
    if (t == List<_i65.Order>) {
      return (data as List).map((e) => deserialize<_i65.Order>(e)).toList()
          as T;
    }
    if (t == List<_i84.ProductVariant>) {
      return (data as List)
              .map((e) => deserialize<_i84.ProductVariant>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i84.ProductVariant>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i84.ProductVariant>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i77.Product>) {
      return (data as List).map((e) => deserialize<_i77.Product>(e)).toList()
          as T;
    }
    if (t == List<_i92.AppUser>) {
      return (data as List).map((e) => deserialize<_i92.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i93.AdminAuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i93.AdminAuditLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i94.Banner>) {
      return (data as List).map((e) => deserialize<_i94.Banner>(e)).toList()
          as T;
    }
    if (t == List<_i95.BogoOffer>) {
      return (data as List).map((e) => deserialize<_i95.BogoOffer>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i96.Category>) {
      return (data as List).map((e) => deserialize<_i96.Category>(e)).toList()
          as T;
    }
    if (t == List<_i97.CategoryOffer>) {
      return (data as List)
              .map((e) => deserialize<_i97.CategoryOffer>(e))
              .toList()
          as T;
    }
    if (t == List<_i98.ComboOffer>) {
      return (data as List).map((e) => deserialize<_i98.ComboOffer>(e)).toList()
          as T;
    }
    if (t == List<_i99.CartItemInput>) {
      return (data as List)
              .map((e) => deserialize<_i99.CartItemInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i100.Coupon>) {
      return (data as List).map((e) => deserialize<_i100.Coupon>(e)).toList()
          as T;
    }
    if (t == List<_i101.CouponDisplay>) {
      return (data as List)
              .map((e) => deserialize<_i101.CouponDisplay>(e))
              .toList()
          as T;
    }
    if (t == List<_i102.DeliveryRule>) {
      return (data as List)
              .map((e) => deserialize<_i102.DeliveryRule>(e))
              .toList()
          as T;
    }
    if (t == List<_i103.Order>) {
      return (data as List).map((e) => deserialize<_i103.Order>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i104.AppliedOfferInfo>) {
      return (data as List)
              .map((e) => deserialize<_i104.AppliedOfferInfo>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i99.CartItemInput>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i99.CartItemInput>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i105.Product>) {
      return (data as List).map((e) => deserialize<_i105.Product>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i106.ProductRankingItem>) {
      return (data as List)
              .map((e) => deserialize<_i106.ProductRankingItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i107.SubCategory>) {
      return (data as List)
              .map((e) => deserialize<_i107.SubCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i108.CartItem>) {
      return (data as List).map((e) => deserialize<_i108.CartItem>(e)).toList()
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
      _i5.Address => 'Address',
      _i6.AdminAnalytics => 'AdminAnalytics',
      _i7.AdminAuditLogEntry => 'AdminAuditLogEntry',
      _i8.AdminAuditLogRow => 'AdminAuditLogRow',
      _i9.AdminAuthResult => 'AdminAuthResult',
      _i10.AdminDashboardStats => 'AdminDashboardStats',
      _i11.AdminTopProduct => 'AdminTopProduct',
      _i12.AppUser => 'AppUser',
      _i13.AppUserRow => 'AppUserRow',
      _i14.AppliedCouponInfo => 'AppliedCouponInfo',
      _i15.AppliedOfferInfo => 'AppliedOfferInfo',
      _i16.Banner => 'Banner',
      _i17.BannerLinkedProductRow => 'BannerLinkedProductRow',
      _i18.BannerPage => 'BannerPage',
      _i19.BannerPlacementRow => 'BannerPlacementRow',
      _i20.BannerRow => 'BannerRow',
      _i21.BasketSuggestion => 'BasketSuggestion',
      _i22.BasketSuggestionAction => 'BasketSuggestionAction',
      _i23.BasketSuggestionResult => 'BasketSuggestionResult',
      _i24.BestCouponResult => 'BestCouponResult',
      _i25.BogoFreeProduct => 'BogoFreeProduct',
      _i26.BogoOffer => 'BogoOffer',
      _i27.BogoOfferPage => 'BogoOfferPage',
      _i28.BogoOfferRewardRow => 'BogoOfferRewardRow',
      _i29.BogoOfferRow => 'BogoOfferRow',
      _i30.CartItem => 'CartItem',
      _i31.CartItemInput => 'CartItemInput',
      _i32.CartPricingResult => 'CartPricingResult',
      _i33.Category => 'Category',
      _i34.CategoryOffer => 'CategoryOffer',
      _i35.CategoryOfferPage => 'CategoryOfferPage',
      _i36.CategoryOfferProductExclusionRow =>
        'CategoryOfferProductExclusionRow',
      _i37.CategoryOfferProductScopeRow => 'CategoryOfferProductScopeRow',
      _i38.CategoryOfferRow => 'CategoryOfferRow',
      _i39.CategoryRow => 'CategoryRow',
      _i40.CheckoutResult => 'CheckoutResult',
      _i41.ComboOffer => 'ComboOffer',
      _i42.ComboOfferItemRow => 'ComboOfferItemRow',
      _i43.ComboOfferPage => 'ComboOfferPage',
      _i44.ComboOfferRow => 'ComboOfferRow',
      _i45.ComboProductItem => 'ComboProductItem',
      _i46.Coupon => 'Coupon',
      _i47.CouponDisplay => 'CouponDisplay',
      _i48.CouponProductScopeRow => 'CouponProductScopeRow',
      _i49.CouponRow => 'CouponRow',
      _i50.CouponValidationResult => 'CouponValidationResult',
      _i51.CustomerOrderRow => 'CustomerOrderRow',
      _i52.DeliveryConfig => 'DeliveryConfig',
      _i53.DeliveryConfigRow => 'DeliveryConfigRow',
      _i54.DeliveryPricingResult => 'DeliveryPricingResult',
      _i55.DeliveryRule => 'DeliveryRule',
      _i56.DeliveryRulePage => 'DeliveryRulePage',
      _i57.DeliveryRuleRow => 'DeliveryRuleRow',
      _i58.DeliverySlab => 'DeliverySlab',
      _i59.DeliverySlabRow => 'DeliverySlabRow',
      _i60.FreeDeliveryRule => 'FreeDeliveryRule',
      _i61.FreeDeliveryRulePage => 'FreeDeliveryRulePage',
      _i62.FreeDeliveryRuleRow => 'FreeDeliveryRuleRow',
      _i63.FreeItemInfo => 'FreeItemInfo',
      _i64.IdempotencyRecordRow => 'IdempotencyRecordRow',
      _i65.Order => 'Order',
      _i66.OrderAddressRow => 'OrderAddressRow',
      _i67.OrderItem => 'OrderItem',
      _i68.OrderItemRow => 'OrderItemRow',
      _i69.OrderPage => 'OrderPage',
      _i70.OrderTrackingData => 'OrderTrackingData',
      _i71.OrderTrackingRow => 'OrderTrackingRow',
      _i72.PaymentActionResult => 'PaymentActionResult',
      _i73.PaymentOrderResult => 'PaymentOrderResult',
      _i74.PaymentTransactionRow => 'PaymentTransactionRow',
      _i75.PaymentVerifyResult => 'PaymentVerifyResult',
      _i76.PricingLineItem => 'PricingLineItem',
      _i77.Product => 'Product',
      _i78.ProductPage => 'ProductPage',
      _i79.ProductRankingItem => 'ProductRankingItem',
      _i80.ProductRow => 'ProductRow',
      _i81.ProductSearchDocumentRow => 'ProductSearchDocumentRow',
      _i82.ProductSearchRebuildJobRow => 'ProductSearchRebuildJobRow',
      _i83.ProductSubCategoryRow => 'ProductSubCategoryRow',
      _i84.ProductVariant => 'ProductVariant',
      _i85.ProductVariantRow => 'ProductVariantRow',
      _i86.RefundRecord => 'RefundRecord',
      _i87.RefundRecordRow => 'RefundRecordRow',
      _i88.SubCategory => 'SubCategory',
      _i89.SubCategoryRow => 'SubCategoryRow',
      _i90.UserAddressRow => 'UserAddressRow',
      _i91.UserCartItemRow => 'UserCartItemRow',
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
      case _i5.Address():
        return 'Address';
      case _i6.AdminAnalytics():
        return 'AdminAnalytics';
      case _i7.AdminAuditLogEntry():
        return 'AdminAuditLogEntry';
      case _i8.AdminAuditLogRow():
        return 'AdminAuditLogRow';
      case _i9.AdminAuthResult():
        return 'AdminAuthResult';
      case _i10.AdminDashboardStats():
        return 'AdminDashboardStats';
      case _i11.AdminTopProduct():
        return 'AdminTopProduct';
      case _i12.AppUser():
        return 'AppUser';
      case _i13.AppUserRow():
        return 'AppUserRow';
      case _i14.AppliedCouponInfo():
        return 'AppliedCouponInfo';
      case _i15.AppliedOfferInfo():
        return 'AppliedOfferInfo';
      case _i16.Banner():
        return 'Banner';
      case _i17.BannerLinkedProductRow():
        return 'BannerLinkedProductRow';
      case _i18.BannerPage():
        return 'BannerPage';
      case _i19.BannerPlacementRow():
        return 'BannerPlacementRow';
      case _i20.BannerRow():
        return 'BannerRow';
      case _i21.BasketSuggestion():
        return 'BasketSuggestion';
      case _i22.BasketSuggestionAction():
        return 'BasketSuggestionAction';
      case _i23.BasketSuggestionResult():
        return 'BasketSuggestionResult';
      case _i24.BestCouponResult():
        return 'BestCouponResult';
      case _i25.BogoFreeProduct():
        return 'BogoFreeProduct';
      case _i26.BogoOffer():
        return 'BogoOffer';
      case _i27.BogoOfferPage():
        return 'BogoOfferPage';
      case _i28.BogoOfferRewardRow():
        return 'BogoOfferRewardRow';
      case _i29.BogoOfferRow():
        return 'BogoOfferRow';
      case _i30.CartItem():
        return 'CartItem';
      case _i31.CartItemInput():
        return 'CartItemInput';
      case _i32.CartPricingResult():
        return 'CartPricingResult';
      case _i33.Category():
        return 'Category';
      case _i34.CategoryOffer():
        return 'CategoryOffer';
      case _i35.CategoryOfferPage():
        return 'CategoryOfferPage';
      case _i36.CategoryOfferProductExclusionRow():
        return 'CategoryOfferProductExclusionRow';
      case _i37.CategoryOfferProductScopeRow():
        return 'CategoryOfferProductScopeRow';
      case _i38.CategoryOfferRow():
        return 'CategoryOfferRow';
      case _i39.CategoryRow():
        return 'CategoryRow';
      case _i40.CheckoutResult():
        return 'CheckoutResult';
      case _i41.ComboOffer():
        return 'ComboOffer';
      case _i42.ComboOfferItemRow():
        return 'ComboOfferItemRow';
      case _i43.ComboOfferPage():
        return 'ComboOfferPage';
      case _i44.ComboOfferRow():
        return 'ComboOfferRow';
      case _i45.ComboProductItem():
        return 'ComboProductItem';
      case _i46.Coupon():
        return 'Coupon';
      case _i47.CouponDisplay():
        return 'CouponDisplay';
      case _i48.CouponProductScopeRow():
        return 'CouponProductScopeRow';
      case _i49.CouponRow():
        return 'CouponRow';
      case _i50.CouponValidationResult():
        return 'CouponValidationResult';
      case _i51.CustomerOrderRow():
        return 'CustomerOrderRow';
      case _i52.DeliveryConfig():
        return 'DeliveryConfig';
      case _i53.DeliveryConfigRow():
        return 'DeliveryConfigRow';
      case _i54.DeliveryPricingResult():
        return 'DeliveryPricingResult';
      case _i55.DeliveryRule():
        return 'DeliveryRule';
      case _i56.DeliveryRulePage():
        return 'DeliveryRulePage';
      case _i57.DeliveryRuleRow():
        return 'DeliveryRuleRow';
      case _i58.DeliverySlab():
        return 'DeliverySlab';
      case _i59.DeliverySlabRow():
        return 'DeliverySlabRow';
      case _i60.FreeDeliveryRule():
        return 'FreeDeliveryRule';
      case _i61.FreeDeliveryRulePage():
        return 'FreeDeliveryRulePage';
      case _i62.FreeDeliveryRuleRow():
        return 'FreeDeliveryRuleRow';
      case _i63.FreeItemInfo():
        return 'FreeItemInfo';
      case _i64.IdempotencyRecordRow():
        return 'IdempotencyRecordRow';
      case _i65.Order():
        return 'Order';
      case _i66.OrderAddressRow():
        return 'OrderAddressRow';
      case _i67.OrderItem():
        return 'OrderItem';
      case _i68.OrderItemRow():
        return 'OrderItemRow';
      case _i69.OrderPage():
        return 'OrderPage';
      case _i70.OrderTrackingData():
        return 'OrderTrackingData';
      case _i71.OrderTrackingRow():
        return 'OrderTrackingRow';
      case _i72.PaymentActionResult():
        return 'PaymentActionResult';
      case _i73.PaymentOrderResult():
        return 'PaymentOrderResult';
      case _i74.PaymentTransactionRow():
        return 'PaymentTransactionRow';
      case _i75.PaymentVerifyResult():
        return 'PaymentVerifyResult';
      case _i76.PricingLineItem():
        return 'PricingLineItem';
      case _i77.Product():
        return 'Product';
      case _i78.ProductPage():
        return 'ProductPage';
      case _i79.ProductRankingItem():
        return 'ProductRankingItem';
      case _i80.ProductRow():
        return 'ProductRow';
      case _i81.ProductSearchDocumentRow():
        return 'ProductSearchDocumentRow';
      case _i82.ProductSearchRebuildJobRow():
        return 'ProductSearchRebuildJobRow';
      case _i83.ProductSubCategoryRow():
        return 'ProductSubCategoryRow';
      case _i84.ProductVariant():
        return 'ProductVariant';
      case _i85.ProductVariantRow():
        return 'ProductVariantRow';
      case _i86.RefundRecord():
        return 'RefundRecord';
      case _i87.RefundRecordRow():
        return 'RefundRecordRow';
      case _i88.SubCategory():
        return 'SubCategory';
      case _i89.SubCategoryRow():
        return 'SubCategoryRow';
      case _i90.UserAddressRow():
        return 'UserAddressRow';
      case _i91.UserCartItemRow():
        return 'UserCartItemRow';
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
    if (dataClassName == 'Address') {
      return deserialize<_i5.Address>(data['data']);
    }
    if (dataClassName == 'AdminAnalytics') {
      return deserialize<_i6.AdminAnalytics>(data['data']);
    }
    if (dataClassName == 'AdminAuditLogEntry') {
      return deserialize<_i7.AdminAuditLogEntry>(data['data']);
    }
    if (dataClassName == 'AdminAuditLogRow') {
      return deserialize<_i8.AdminAuditLogRow>(data['data']);
    }
    if (dataClassName == 'AdminAuthResult') {
      return deserialize<_i9.AdminAuthResult>(data['data']);
    }
    if (dataClassName == 'AdminDashboardStats') {
      return deserialize<_i10.AdminDashboardStats>(data['data']);
    }
    if (dataClassName == 'AdminTopProduct') {
      return deserialize<_i11.AdminTopProduct>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i12.AppUser>(data['data']);
    }
    if (dataClassName == 'AppUserRow') {
      return deserialize<_i13.AppUserRow>(data['data']);
    }
    if (dataClassName == 'AppliedCouponInfo') {
      return deserialize<_i14.AppliedCouponInfo>(data['data']);
    }
    if (dataClassName == 'AppliedOfferInfo') {
      return deserialize<_i15.AppliedOfferInfo>(data['data']);
    }
    if (dataClassName == 'Banner') {
      return deserialize<_i16.Banner>(data['data']);
    }
    if (dataClassName == 'BannerLinkedProductRow') {
      return deserialize<_i17.BannerLinkedProductRow>(data['data']);
    }
    if (dataClassName == 'BannerPage') {
      return deserialize<_i18.BannerPage>(data['data']);
    }
    if (dataClassName == 'BannerPlacementRow') {
      return deserialize<_i19.BannerPlacementRow>(data['data']);
    }
    if (dataClassName == 'BannerRow') {
      return deserialize<_i20.BannerRow>(data['data']);
    }
    if (dataClassName == 'BasketSuggestion') {
      return deserialize<_i21.BasketSuggestion>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionAction') {
      return deserialize<_i22.BasketSuggestionAction>(data['data']);
    }
    if (dataClassName == 'BasketSuggestionResult') {
      return deserialize<_i23.BasketSuggestionResult>(data['data']);
    }
    if (dataClassName == 'BestCouponResult') {
      return deserialize<_i24.BestCouponResult>(data['data']);
    }
    if (dataClassName == 'BogoFreeProduct') {
      return deserialize<_i25.BogoFreeProduct>(data['data']);
    }
    if (dataClassName == 'BogoOffer') {
      return deserialize<_i26.BogoOffer>(data['data']);
    }
    if (dataClassName == 'BogoOfferPage') {
      return deserialize<_i27.BogoOfferPage>(data['data']);
    }
    if (dataClassName == 'BogoOfferRewardRow') {
      return deserialize<_i28.BogoOfferRewardRow>(data['data']);
    }
    if (dataClassName == 'BogoOfferRow') {
      return deserialize<_i29.BogoOfferRow>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i30.CartItem>(data['data']);
    }
    if (dataClassName == 'CartItemInput') {
      return deserialize<_i31.CartItemInput>(data['data']);
    }
    if (dataClassName == 'CartPricingResult') {
      return deserialize<_i32.CartPricingResult>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i33.Category>(data['data']);
    }
    if (dataClassName == 'CategoryOffer') {
      return deserialize<_i34.CategoryOffer>(data['data']);
    }
    if (dataClassName == 'CategoryOfferPage') {
      return deserialize<_i35.CategoryOfferPage>(data['data']);
    }
    if (dataClassName == 'CategoryOfferProductExclusionRow') {
      return deserialize<_i36.CategoryOfferProductExclusionRow>(data['data']);
    }
    if (dataClassName == 'CategoryOfferProductScopeRow') {
      return deserialize<_i37.CategoryOfferProductScopeRow>(data['data']);
    }
    if (dataClassName == 'CategoryOfferRow') {
      return deserialize<_i38.CategoryOfferRow>(data['data']);
    }
    if (dataClassName == 'CategoryRow') {
      return deserialize<_i39.CategoryRow>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i40.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'ComboOffer') {
      return deserialize<_i41.ComboOffer>(data['data']);
    }
    if (dataClassName == 'ComboOfferItemRow') {
      return deserialize<_i42.ComboOfferItemRow>(data['data']);
    }
    if (dataClassName == 'ComboOfferPage') {
      return deserialize<_i43.ComboOfferPage>(data['data']);
    }
    if (dataClassName == 'ComboOfferRow') {
      return deserialize<_i44.ComboOfferRow>(data['data']);
    }
    if (dataClassName == 'ComboProductItem') {
      return deserialize<_i45.ComboProductItem>(data['data']);
    }
    if (dataClassName == 'Coupon') {
      return deserialize<_i46.Coupon>(data['data']);
    }
    if (dataClassName == 'CouponDisplay') {
      return deserialize<_i47.CouponDisplay>(data['data']);
    }
    if (dataClassName == 'CouponProductScopeRow') {
      return deserialize<_i48.CouponProductScopeRow>(data['data']);
    }
    if (dataClassName == 'CouponRow') {
      return deserialize<_i49.CouponRow>(data['data']);
    }
    if (dataClassName == 'CouponValidationResult') {
      return deserialize<_i50.CouponValidationResult>(data['data']);
    }
    if (dataClassName == 'CustomerOrderRow') {
      return deserialize<_i51.CustomerOrderRow>(data['data']);
    }
    if (dataClassName == 'DeliveryConfig') {
      return deserialize<_i52.DeliveryConfig>(data['data']);
    }
    if (dataClassName == 'DeliveryConfigRow') {
      return deserialize<_i53.DeliveryConfigRow>(data['data']);
    }
    if (dataClassName == 'DeliveryPricingResult') {
      return deserialize<_i54.DeliveryPricingResult>(data['data']);
    }
    if (dataClassName == 'DeliveryRule') {
      return deserialize<_i55.DeliveryRule>(data['data']);
    }
    if (dataClassName == 'DeliveryRulePage') {
      return deserialize<_i56.DeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'DeliveryRuleRow') {
      return deserialize<_i57.DeliveryRuleRow>(data['data']);
    }
    if (dataClassName == 'DeliverySlab') {
      return deserialize<_i58.DeliverySlab>(data['data']);
    }
    if (dataClassName == 'DeliverySlabRow') {
      return deserialize<_i59.DeliverySlabRow>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRule') {
      return deserialize<_i60.FreeDeliveryRule>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRulePage') {
      return deserialize<_i61.FreeDeliveryRulePage>(data['data']);
    }
    if (dataClassName == 'FreeDeliveryRuleRow') {
      return deserialize<_i62.FreeDeliveryRuleRow>(data['data']);
    }
    if (dataClassName == 'FreeItemInfo') {
      return deserialize<_i63.FreeItemInfo>(data['data']);
    }
    if (dataClassName == 'IdempotencyRecordRow') {
      return deserialize<_i64.IdempotencyRecordRow>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i65.Order>(data['data']);
    }
    if (dataClassName == 'OrderAddressRow') {
      return deserialize<_i66.OrderAddressRow>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i67.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderItemRow') {
      return deserialize<_i68.OrderItemRow>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i69.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderTrackingData') {
      return deserialize<_i70.OrderTrackingData>(data['data']);
    }
    if (dataClassName == 'OrderTrackingRow') {
      return deserialize<_i71.OrderTrackingRow>(data['data']);
    }
    if (dataClassName == 'PaymentActionResult') {
      return deserialize<_i72.PaymentActionResult>(data['data']);
    }
    if (dataClassName == 'PaymentOrderResult') {
      return deserialize<_i73.PaymentOrderResult>(data['data']);
    }
    if (dataClassName == 'PaymentTransactionRow') {
      return deserialize<_i74.PaymentTransactionRow>(data['data']);
    }
    if (dataClassName == 'PaymentVerifyResult') {
      return deserialize<_i75.PaymentVerifyResult>(data['data']);
    }
    if (dataClassName == 'PricingLineItem') {
      return deserialize<_i76.PricingLineItem>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i77.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i78.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductRankingItem') {
      return deserialize<_i79.ProductRankingItem>(data['data']);
    }
    if (dataClassName == 'ProductRow') {
      return deserialize<_i80.ProductRow>(data['data']);
    }
    if (dataClassName == 'ProductSearchDocumentRow') {
      return deserialize<_i81.ProductSearchDocumentRow>(data['data']);
    }
    if (dataClassName == 'ProductSearchRebuildJobRow') {
      return deserialize<_i82.ProductSearchRebuildJobRow>(data['data']);
    }
    if (dataClassName == 'ProductSubCategoryRow') {
      return deserialize<_i83.ProductSubCategoryRow>(data['data']);
    }
    if (dataClassName == 'ProductVariant') {
      return deserialize<_i84.ProductVariant>(data['data']);
    }
    if (dataClassName == 'ProductVariantRow') {
      return deserialize<_i85.ProductVariantRow>(data['data']);
    }
    if (dataClassName == 'RefundRecord') {
      return deserialize<_i86.RefundRecord>(data['data']);
    }
    if (dataClassName == 'RefundRecordRow') {
      return deserialize<_i87.RefundRecordRow>(data['data']);
    }
    if (dataClassName == 'SubCategory') {
      return deserialize<_i88.SubCategory>(data['data']);
    }
    if (dataClassName == 'SubCategoryRow') {
      return deserialize<_i89.SubCategoryRow>(data['data']);
    }
    if (dataClassName == 'UserAddressRow') {
      return deserialize<_i90.UserAddressRow>(data['data']);
    }
    if (dataClassName == 'UserCartItemRow') {
      return deserialize<_i91.UserCartItemRow>(data['data']);
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
      case _i8.AdminAuditLogRow:
        return _i8.AdminAuditLogRow.t;
      case _i13.AppUserRow:
        return _i13.AppUserRow.t;
      case _i17.BannerLinkedProductRow:
        return _i17.BannerLinkedProductRow.t;
      case _i19.BannerPlacementRow:
        return _i19.BannerPlacementRow.t;
      case _i20.BannerRow:
        return _i20.BannerRow.t;
      case _i28.BogoOfferRewardRow:
        return _i28.BogoOfferRewardRow.t;
      case _i29.BogoOfferRow:
        return _i29.BogoOfferRow.t;
      case _i36.CategoryOfferProductExclusionRow:
        return _i36.CategoryOfferProductExclusionRow.t;
      case _i37.CategoryOfferProductScopeRow:
        return _i37.CategoryOfferProductScopeRow.t;
      case _i38.CategoryOfferRow:
        return _i38.CategoryOfferRow.t;
      case _i39.CategoryRow:
        return _i39.CategoryRow.t;
      case _i42.ComboOfferItemRow:
        return _i42.ComboOfferItemRow.t;
      case _i44.ComboOfferRow:
        return _i44.ComboOfferRow.t;
      case _i48.CouponProductScopeRow:
        return _i48.CouponProductScopeRow.t;
      case _i49.CouponRow:
        return _i49.CouponRow.t;
      case _i51.CustomerOrderRow:
        return _i51.CustomerOrderRow.t;
      case _i53.DeliveryConfigRow:
        return _i53.DeliveryConfigRow.t;
      case _i57.DeliveryRuleRow:
        return _i57.DeliveryRuleRow.t;
      case _i59.DeliverySlabRow:
        return _i59.DeliverySlabRow.t;
      case _i62.FreeDeliveryRuleRow:
        return _i62.FreeDeliveryRuleRow.t;
      case _i64.IdempotencyRecordRow:
        return _i64.IdempotencyRecordRow.t;
      case _i66.OrderAddressRow:
        return _i66.OrderAddressRow.t;
      case _i68.OrderItemRow:
        return _i68.OrderItemRow.t;
      case _i71.OrderTrackingRow:
        return _i71.OrderTrackingRow.t;
      case _i74.PaymentTransactionRow:
        return _i74.PaymentTransactionRow.t;
      case _i80.ProductRow:
        return _i80.ProductRow.t;
      case _i81.ProductSearchDocumentRow:
        return _i81.ProductSearchDocumentRow.t;
      case _i82.ProductSearchRebuildJobRow:
        return _i82.ProductSearchRebuildJobRow.t;
      case _i83.ProductSubCategoryRow:
        return _i83.ProductSubCategoryRow.t;
      case _i85.ProductVariantRow:
        return _i85.ProductVariantRow.t;
      case _i87.RefundRecordRow:
        return _i87.RefundRecordRow.t;
      case _i89.SubCategoryRow:
        return _i89.SubCategoryRow.t;
      case _i90.UserAddressRow:
        return _i90.UserAddressRow.t;
      case _i91.UserCartItemRow:
        return _i91.UserCartItemRow.t;
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
