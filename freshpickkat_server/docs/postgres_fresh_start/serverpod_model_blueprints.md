# Serverpod Model Blueprints

These are Serverpod-compatible table model blueprints. They are intentionally stored as documentation instead of active protocol files so the current Firestore runtime remains untouched.

## Catalog

```yaml
class: AppUserRow
serverOnly: true
table: app_user
fields:
  id: UuidValue?, defaultPersist=random
  firebaseUid: String?
  phoneNumber: String
  name: String?
  email: String?
  role: String, default='customer'
  status: String, default='active'
  deactivatedAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
indexes:
  app_user_firebase_uid_idx:
    fields: firebaseUid
    unique: true
```

```yaml
class: UserAddressRow
serverOnly: true
table: user_address
fields:
  id: UuidValue?, defaultPersist=random
  user: AppUserRow?, relation(parent=app_user, onDelete=Restrict)
  label: String?
  recipientName: String?
  phoneNumber: String?
  streetLine1: String
  streetLine2: String?
  landmark: String?
  city: String
  state: String
  postalCode: String
  country: String
  latitude: double?
  longitude: double?
  isDefault: bool, default=false
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
```

```yaml
class: CategoryRow
serverOnly: true
table: category
fields:
  id: UuidValue?, defaultPersist=random
  name: String
  slug: String
  imageUrl: String?
  displayOrder: int, default=0
  status: String, default='active'
  deactivatedAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
indexes:
  category_slug_idx:
    fields: slug
    unique: true
```

```yaml
class: SubCategoryRow
serverOnly: true
table: sub_category
fields:
  id: UuidValue?, defaultPersist=random
  category: CategoryRow?, relation(parent=category, onDelete=Restrict)
  name: String
  slug: String
  imageUrl: String?
  displayOrder: int, default=0
  status: String, default='active'
  deactivatedAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
indexes:
  sub_category_category_slug_idx:
    fields: categoryId, slug
    unique: true
```

```yaml
class: ProductRow
serverOnly: true
table: product
fields:
  id: UuidValue?, defaultPersist=random
  category: CategoryRow?, relation(parent=category, onDelete=Restrict)
  name: String
  slug: String
  shortDescription: String?
  description: String?
  primaryImageUrl: String?
  countryOfOrigin: String?
  baseUnit: String?
  baseQuantity: double?
  quantityDescription: String?
  mostSearchCount: int, default=0
  mostPurchaseCount: int, default=0
  status: String, default='active'
  deactivatedAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
indexes:
  product_slug_idx:
    fields: slug
    unique: true
```

```yaml
class: ProductVariantRow
serverOnly: true
table: product_variant
fields:
  id: UuidValue?, defaultPersist=random
  product: ProductRow?, relation(parent=product, onDelete=Cascade)
  label: String
  sku: String?
  quantityValue: double
  quantityUnit: String
  quantityDescription: String?
  salePrice: double
  listPrice: double
  isAvailable: bool, default=true
  isDefault: bool, default=false
  sortOrder: int, default=0
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
indexes:
  product_variant_sku_idx:
    fields: sku
    unique: true
```

```yaml
class: ProductSubCategoryRow
serverOnly: true
table: product_sub_category
fields:
  id: UuidValue?, defaultPersist=random
  product: ProductRow?, relation(parent=product, onDelete=Cascade)
  subCategory: SubCategoryRow?, relation(parent=sub_category, onDelete=Restrict)
  createdAt: DateTime, defaultModel=now
indexes:
  product_sub_category_unique_idx:
    fields: productId, subCategoryId
    unique: true
```

## Merchandising

```yaml
class: BannerRow
serverOnly: true
table: banner
fields:
  id: UuidValue?, defaultPersist=random
  title: String
  imageUrl: String
  actionType: String
  externalUrl: String?
  linkedProduct: ProductRow?, relation(parent=product, optional, onDelete=Restrict)
  linkedCategory: CategoryRow?, relation(parent=category, optional, onDelete=Restrict)
  linkedSubCategory: SubCategoryRow?, relation(parent=sub_category, optional, onDelete=Restrict)
  priority: int, default=0
  startsAt: DateTime
  endsAt: DateTime
  status: String, default='active'
  deactivatedAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
```

```yaml
class: BannerPlacementRow
serverOnly: true
table: banner_placement
fields:
  id: UuidValue?, defaultPersist=random
  banner: BannerRow?, relation(parent=banner, onDelete=Cascade)
  placementKey: String
  createdAt: DateTime, defaultModel=now
indexes:
  banner_placement_unique_idx:
    fields: bannerId, placementKey
    unique: true
```

```yaml
class: CouponRow
serverOnly: true
table: coupon
fields:
  id: UuidValue?, defaultPersist=random
  code: String
  description: String?
  couponType: String
  discountValue: double?
  minOrderAmount: double, default=0
  maxDiscountAmount: double?
  maxUsageTotal: int?
  maxUsagePerUser: int?
  usedCount: int, default=0
  startsAt: DateTime
  endsAt: DateTime
  status: String, default='active'
  deactivatedAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
indexes:
  coupon_code_idx:
    fields: code
    unique: true
```

```yaml
class: CouponProductScopeRow
serverOnly: true
table: coupon_product_scope
fields:
  id: UuidValue?, defaultPersist=random
  coupon: CouponRow?, relation(parent=coupon, onDelete=Cascade)
  product: ProductRow?, relation(parent=product, onDelete=Restrict)
  createdAt: DateTime, defaultModel=now
indexes:
  coupon_product_scope_unique_idx:
    fields: couponId, productId
    unique: true
```

```yaml
class: CategoryOfferRow
serverOnly: true
table: category_offer
fields:
  id: UuidValue?, defaultPersist=random
  category: CategoryRow?, relation(parent=category, onDelete=Restrict)
  name: String
  description: String?
  discountType: String
  discountValue: double
  maxDiscountAmount: double?
  minOrderAmount: double?
  priority: int, default=0
  startsAt: DateTime
  endsAt: DateTime
  status: String, default='active'
  deactivatedAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
```

```yaml
class: ComboOfferRow
serverOnly: true
table: combo_offer
fields:
  id: UuidValue?, defaultPersist=random
  name: String
  description: String?
  discountType: String
  discountValue: double
  minQuantityPerProduct: int, default=1
  maxUsagePerUser: int?
  maxUsageTotal: int?
  usedCount: int, default=0
  priority: int, default=0
  startsAt: DateTime
  endsAt: DateTime
  status: String, default='active'
  deactivatedAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
```

```yaml
class: ComboOfferItemRow
serverOnly: true
table: combo_offer_item
fields:
  id: UuidValue?, defaultPersist=random
  comboOffer: ComboOfferRow?, relation(parent=combo_offer, onDelete=Cascade)
  product: ProductRow?, relation(parent=product, onDelete=Restrict)
  productVariant: ProductVariantRow?, relation(parent=product_variant, optional, onDelete=Restrict)
  quantity: int
  sortOrder: int, default=0
  createdAt: DateTime, defaultModel=now
```

```yaml
class: BogoOfferRow
serverOnly: true
table: bogo_offer
fields:
  id: UuidValue?, defaultPersist=random
  triggerProduct: ProductRow?, relation(parent=product, onDelete=Restrict)
  triggerVariant: ProductVariantRow?, relation(parent=product_variant, optional, onDelete=Restrict)
  minTriggerQuantity: int, default=1
  triggerBaseQuantity: double?
  triggerBaseUnit: String?
  title: String
  startsAt: DateTime
  endsAt: DateTime
  status: String, default='active'
  deactivatedAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
```

```yaml
class: BogoOfferRewardRow
serverOnly: true
table: bogo_offer_reward
fields:
  id: UuidValue?, defaultPersist=random
  bogoOffer: BogoOfferRow?, relation(parent=bogo_offer, onDelete=Cascade)
  rewardProduct: ProductRow?, relation(parent=product, onDelete=Restrict)
  rewardVariant: ProductVariantRow?, relation(parent=product_variant, optional, onDelete=Restrict)
  quantity: int, default=1
  createdAt: DateTime, defaultModel=now
```

## Orders and Payments

```yaml
class: CustomerOrderRow
serverOnly: true
table: customer_order
fields:
  id: UuidValue?, defaultPersist=random
  user: AppUserRow?, relation(parent=app_user, onDelete=Restrict)
  orderNumber: String
  orderStatus: String
  paymentStatus: String
  refundStatus: String
  coupon: CouponRow?, relation(parent=coupon, optional, onDelete=Restrict)
  itemCount: int
  totalAmount: double
  discountAmount: double
  deliveryFee: double
  finalAmount: double
  placedAt: DateTime?
  confirmedAt: DateTime?
  packedAt: DateTime?
  outForDeliveryAt: DateTime?
  deliveredAt: DateTime?
  cancelledAt: DateTime?
  cancellationReason: String?
  deliveryOtp: String?
  orderedAt: DateTime, defaultModel=now
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
indexes:
  customer_order_order_number_idx:
    fields: orderNumber
    unique: true
```

```yaml
class: OrderAddressRow
serverOnly: true
table: order_address
fields:
  id: UuidValue?, defaultPersist=random
  order: CustomerOrderRow?, relation(parent=customer_order, onDelete=Cascade)
  recipientName: String?
  phoneNumber: String?
  streetLine1: String
  streetLine2: String?
  landmark: String?
  city: String
  state: String
  postalCode: String
  country: String
  latitude: double?
  longitude: double?
  createdAt: DateTime, defaultModel=now
indexes:
  order_address_order_idx:
    fields: orderId
    unique: true
```

```yaml
class: OrderItemRow
serverOnly: true
table: order_item
fields:
  id: UuidValue?, defaultPersist=random
  order: CustomerOrderRow?, relation(parent=customer_order, onDelete=Cascade)
  product: ProductRow?, relation(parent=product, onDelete=Restrict)
  productVariant: ProductVariantRow?, relation(parent=product_variant, optional, onDelete=Restrict)
  comboOffer: ComboOfferRow?, relation(parent=combo_offer, optional, onDelete=Restrict)
  bogoOffer: BogoOfferRow?, relation(parent=bogo_offer, optional, onDelete=Restrict)
  productNameSnapshot: String
  productImageUrlSnapshot: String?
  variantLabelSnapshot: String?
  quantity: int
  unitPrice: double
  totalPrice: double
  isFreeItem: bool, default=false
  createdAt: DateTime, defaultModel=now
```

```yaml
class: PaymentTransactionRow
serverOnly: true
table: payment_transaction
fields:
  id: UuidValue?, defaultPersist=random
  order: CustomerOrderRow?, relation(parent=customer_order, onDelete=Restrict)
  user: AppUserRow?, relation(parent=app_user, onDelete=Restrict)
  idempotencyKey: String
  gatewayName: String
  gatewayOrderId: String?
  gatewayPaymentId: String?
  amount: double
  currencyCode: String, default='INR'
  paymentStatus: String
  gatewayStatus: String?
  failureReason: String?
  paidAt: DateTime?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
indexes:
  payment_transaction_idempotency_idx:
    fields: idempotencyKey
    unique: true
  payment_transaction_gateway_order_idx:
    fields: gatewayOrderId
    unique: true
  payment_transaction_gateway_payment_idx:
    fields: gatewayPaymentId
    unique: true
```

```yaml
class: IdempotencyRecordRow
serverOnly: true
table: idempotency_record
fields:
  id: UuidValue?, defaultPersist=random
  scope: String
  idempotencyKey: String
  user: AppUserRow?, relation(parent=app_user, optional, onDelete=Restrict)
  order: CustomerOrderRow?, relation(parent=customer_order, optional, onDelete=Restrict)
  paymentTransaction: PaymentTransactionRow?, relation(parent=payment_transaction, optional, onDelete=Restrict)
  requestHash: String?
  responseReference: String?
  createdAt: DateTime, defaultModel=now
  expiresAt: DateTime?
indexes:
  idempotency_scope_key_idx:
    fields: scope, idempotencyKey
    unique: true
```

```yaml
class: RefundRecordRow
serverOnly: true
table: refund_record
fields:
  id: UuidValue?, defaultPersist=random
  order: CustomerOrderRow?, relation(parent=customer_order, onDelete=Restrict)
  paymentTransaction: PaymentTransactionRow?, relation(parent=payment_transaction, onDelete=Restrict)
  user: AppUserRow?, relation(parent=app_user, onDelete=Restrict)
  gatewayRefundId: String?
  amount: double
  refundStatus: String
  failureReason: String?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
indexes:
  refund_record_gateway_refund_idx:
    fields: gatewayRefundId
    unique: true
```

```yaml
class: AdminAuditLogRow
serverOnly: true
table: admin_audit_log
fields:
  id: UuidValue?, defaultPersist=random
  actorUser: AppUserRow?, relation(parent=app_user, optional, onDelete=Restrict)
  action: String
  entityType: String
  entityId: UuidValue?
  metadata: Map<String, String>?
  createdAt: DateTime, defaultModel=now
```

## Search

```yaml
class: ProductSearchDocumentRow
serverOnly: true
table: product_search_document
fields:
  id: UuidValue?, defaultPersist=random
  product: ProductRow?, relation(parent=product, onDelete=Cascade)
  searchText: String
  builtAt: DateTime, defaultModel=now
  sourceCreatedAt: DateTime
  sourceUpdatedAt: DateTime
indexes:
  product_search_document_product_idx:
    fields: productId
    unique: true
```

```yaml
class: ProductSearchRebuildJobRow
serverOnly: true
table: product_search_rebuild_job
fields:
  id: UuidValue?, defaultPersist=random
  product: ProductRow?, relation(parent=product, onDelete=Cascade)
  reason: String
  jobStatus: String, default='pending'
  attemptCount: int, default=0
  scheduledAt: DateTime, defaultModel=now
  startedAt: DateTime?
  finishedAt: DateTime?
  lastError: String?
  createdAt: DateTime, defaultModel=now
  updatedAt: DateTime, defaultModel=now
```
