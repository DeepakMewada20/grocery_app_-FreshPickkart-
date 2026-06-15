import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/product_detail_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/bogo_offer_utils.dart';
import 'package:freshpickkat_flutter/services/share_service.dart';
import 'package:freshpickkat_flutter/utils/protected_navigation_helper.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/widgets/bogo_selection_bottomsheet.dart';
import 'package:freshpickkat_flutter/widgets/network_banner_widget.dart';
import 'package:freshpickkat_flutter/widgets/product_offer_badge.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String? initialVariantId;

  const ProductDetailScreen({
    super.key,
    required this.product,
    this.initialVariantId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final AuthController _authController = AuthController.instance;
  final ProductProviderController _productProviderController =
      ProductProviderController.instance;
  final CartController _cartController = CartController.instance;
  final Client _client = ServerpodClient().client;
  late final ProductDetailController _controller;
  late final String _controllerTag;
  late String _selectedVariantId;
  bool _isDescriptionExpanded = false;
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;
  StreamSubscription? _cartSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the initial product
    _controllerTag =
        'product_detail_${widget.product.productId}_${UniqueKey()}';
    _selectedVariantId =
        widget.initialVariantId ?? inferProductVariantId(widget.product);
    _controller = Get.put(
      ProductDetailController(widget.product),
      tag: _controllerTag,
    );
    _cartSubscription = _cartController.cartItems.listen((_) {
      _syncSelectedVariantFromCart();
    });
    _recordProductView();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cartSubscription?.cancel();
    Get.delete<ProductDetailController>(tag: _controllerTag);
    super.dispose();
  }

  void _syncSelectedVariantFromCart() {
    if (!mounted) return;
    final cartItem = _cartController.cartItems.firstWhereOrNull(
      (item) => item.product.productId == widget.product.productId,
    );
    if (cartItem == null) return;
    final actualVariantId =
        cartItem.variantId ?? inferProductVariantId(widget.product);
    if (actualVariantId != _selectedVariantId) {
      setState(() => _selectedVariantId = actualVariantId);
    }
  }

  void _incrementQuantity(Product product) {
    _cartController.addItem(product, variantId: _selectedVariantId);
  }

  void _decrementQuantity(Product product) {
    _cartController.removeItem(product, variantId: _selectedVariantId);
  }

  Future<void> _handleAddToCart(Product product) async {
    ProtectedNavigationHelper.executeProtectedAction(
      onLoggedIn: () async {
        _cartController.suspendPricingRefresh();
        _incrementQuantity(product);
        await _showBogoSelectionIfNeeded(product);
        _cartController.resumePricingRefresh();
      },
      productToAdd: product,
    );
  }

  Future<void> _showBogoSelectionIfNeeded(Product product) async {
    if (!isBogoProduct(product) || product.productId == null) return;
    final offer = await BogoController.instance.fetchOfferForProduct(
      product.productId!,
      variantId: _selectedVariantId,
    );

    final freeProductIds = (offer?.freeProductIds.isNotEmpty == true
            ? offer!.freeProductIds
            : product.bogoFreeProductIds) ??
        const <String>[];

    final cartItem = _cartItemForProduct(product);
    if (cartItem?.bogoFreeProductId != null) return;

    final isEligible =
        offer == null ||
        (isBogoTriggerVariantEligible(
              widget.product,
              offer: offer,
              selectedVariantId: _selectedVariantId,
            ) &&
            isBogoTriggerQuantityEligible(offer, cartItem?.quantity ?? 0));

    if (isEligible && freeProductIds.length == 1) {
      _cartController.setBogoSelection(
        product.productId!,
        freeProductIds.first,
        triggerVariantId: _selectedVariantId,
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Get.bottomSheet(
        BogoSelectionBottomSheet(
          triggerProductId: product.productId!,
          triggerVariantId: _selectedVariantId,
          freeProductIds: freeProductIds,
        ),
        isScrollControlled: true,
      );
    });
  }

  Future<void> _openBogoSelectionSheet(Product product) async {
    if (!isBogoProduct(product) || product.productId == null) return;
    final offer = await BogoController.instance.fetchOfferForProduct(
      product.productId!,
      variantId: _selectedVariantId,
    );
    final freeProductIds = (offer?.freeProductIds.isNotEmpty == true
            ? offer!.freeProductIds
            : product.bogoFreeProductIds) ??
        const <String>[];
    Get.bottomSheet(
      BogoSelectionBottomSheet(
        triggerProductId: product.productId!,
        triggerVariantId: _selectedVariantId,
        freeProductIds: freeProductIds,
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _recordProductView() async {
    final productId = widget.product.productId;
    if (productId == null || productId.trim().isEmpty) return;
    try {
      await _client.productRanking.recordProductView(productId);
    } catch (e) {
      AppLogger.error('ProductDetail', 'Record view: $e');
    }
  }

  dynamic _cartItemForProduct(Product product) {
    return _cartController.cartItems.firstWhereOrNull(
      (item) =>
          item.product.productId == product.productId &&
          (item.variantId ?? 'default') == _selectedVariantId,
    );
  }

  Product? _selectedBogoFreeProduct(Product product) {
    final selectedId = _cartItemForProduct(product)?.bogoFreeProductId;
    if (selectedId == null) return null;
    return _productProviderController.allProducts.firstWhereOrNull(
      (item) => item.productId == selectedId,
    );
  }

  String _selectedBogoFreeQuantity(
    Product triggerProduct,
    Product freeProduct,
  ) {
    return BogoController.instance.freeProductQuantityLabel(
      triggerProduct.productId ?? '',
      freeProduct.productId ?? '',
      fallback: freeProduct.quantity,
    );
  }

  void _onScroll() {
    const collapseThreshold = 200.0;
    final opacity =
        (_scrollController.offset / collapseThreshold).clamp(0.0, 1.0);
    if (opacity != _appBarOpacity) {
      setState(() => _appBarOpacity = opacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final product = _controller.product.value;
      final displayProduct = applyVariantToProduct(
        product,
        variantId: _selectedVariantId,
      );
      final variants = sortedProductVariants(product);
      final cs = Theme.of(context).colorScheme;
      final offerTheme =
          Theme.of(context).extension<AppOfferTheme>() ??
          AppOfferTheme.fallback(Theme.of(context).brightness);
      final selectedFreeProduct = _selectedBogoFreeProduct(displayProduct);
      final cartItem = _cartItemForProduct(displayProduct);
      final selectedQuantity = cartItem?.quantity ?? 0;
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black.withValues(alpha: _appBarOpacity),
          elevation: _appBarOpacity * 2,
          title: Opacity(
            opacity: _appBarOpacity,
            child: Text(
              displayProduct.productName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: 44,
          leadingWidth: 42,
          leading: Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey.withValues(alpha: 0.5),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () => ShareService.instance.shareProduct(
                  displayProduct,
                  context: context,
                ),
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: AppResponsive.constrainContent(
            context: context,
            maxWidth: AppResponsive.maxDetailWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    final screenHeight = MediaQuery.sizeOf(context).height;
                    final imageHeight = AppResponsive.isLandscape(context)
                        ? (screenHeight * 0.58).clamp(220.h, 360.h).toDouble()
                        : constraints.maxWidth.clamp(280.w, 500.h).toDouble();
                    return Container(
                      height: imageHeight,
                      width: double.infinity,
                      color: Colors.white,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),

                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((product.countryOfOrigin ?? '').trim().isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.public_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: Text(
                                  'Country of Origin: ${product.countryOfOrigin}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  displayProduct.productName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 3,
                                  minFontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  productFullQuantityLabel(displayProduct),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // We need to pass the *current* product to the cart controller
                          Obx(
                            () => _buildAddButton(
                              displayProduct,
                              _cartController.getProductQuantity(
                                product.productId,
                                variantId: _selectedVariantId,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (variants.length > 1)
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: variants
                              .map(
                                (variant) => ChoiceChip(
                                  label: Text(
                                    formatQuantityString(
                                      variant.quantityValue,
                                      variant.quantityUnit,
                                    ),
                                  ),
                                  selected:
                                      variant.variantId == _selectedVariantId,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedVariantId = variant.variantId;
                                    });
                                  },
                                  selectedColor: const Color(0xFF1B8A4C),
                                  labelStyle: TextStyle(
                                    color:
                                        variant.variantId == _selectedVariantId
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  backgroundColor: Colors.white10,
                                  side: BorderSide(
                                    color:
                                        variant.variantId == _selectedVariantId
                                        ? const Color(0xFF1B8A4C)
                                        : Colors.white24,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      if (variants.length > 1) SizedBox(height: 12.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              '₹${displayProduct.price.formatPrice}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'M.R.P: ₹${displayProduct.realPrice.formatPrice}',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            if (hasProductOffer(displayProduct)) ...[
                              SizedBox(width: 12.w),
                              Text(
                                buildProductOfferLabel(displayProduct),
                                style: TextStyle(
                                  color: productOfferColor(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isBogoProduct(displayProduct))
                        Container(
                          margin: EdgeInsets.only(top: 12.h),
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: offerTheme.badgeSoft,
                            borderRadius: BorderRadius.circular(18.r),
                            border: Border.all(color: offerTheme.badgeBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BOGO free product',
                                style: TextStyle(
                                  color: offerTheme.badge,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                selectedQuantity == 0
                                    ? 'Add this item to choose 1 free product from ${displayProduct.bogoFreeProductIds?.length ?? 0} options.'
                                    : selectedFreeProduct == null
                                    ? 'Choose your free product now.'
                                    : 'Selected free product for this offer.',
                                style: TextStyle(
                                  color: cs.onSurface,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (selectedQuantity > 0) ...[
                                SizedBox(height: 12.h),
                                if (selectedFreeProduct != null)
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          width: 54.r,
                                          height: 54.r,
                                          color: cs.surface,
                                          child: Image.network(
                                            selectedFreeProduct.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.broken_image_outlined,
                                                    color: cs.onSurface
                                                        .withValues(
                                                          alpha: 0.4,
                                                        ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              selectedFreeProduct.productName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: cs.onSurface,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              _selectedBogoFreeQuantity(
                                                displayProduct,
                                                selectedFreeProduct,
                                              ),
                                              style: TextStyle(
                                                color: cs.onSurface.withValues(
                                                  alpha: 0.68,
                                                ),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 12.h),
                                FilledButton.tonalIcon(
                                  onPressed: () =>
                                      _openBogoSelectionSheet(displayProduct),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: offerTheme.badge,
                                    foregroundColor: offerTheme.onBadge,
                                  ),
                                  icon: const Icon(
                                    Icons.card_giftcard_outlined,
                                  ),
                                  label: Text(
                                    selectedFreeProduct == null
                                        ? 'Choose Free Product'
                                        : 'Change Free Product',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      if (displayProduct.isFreeDelivery)
                        Padding(
                          padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                color: productOfferColor(context),
                                size: 20.r,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Free Delivery',
                                style: TextStyle(
                                  color: productOfferColor(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 4.h),
                      const Text(
                        '(Inclusive of all taxes)',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      SizedBox(height: 12.h),
                      const Divider(color: Colors.white24),
                      SizedBox(height: 16.h),
                      _buildDescriptionSection(displayProduct),
                      SizedBox(height: 16.h),
                      const Divider(color: Colors.white24),
                      SizedBox(height: 16.h),
                      Text(
                        'Related Products',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildRelatedProducts(displayProduct),

                      // 🎯 Product Page Banners
                      Obx(() {
                        final banners =
                            BannerController.instance.productPageBanners;
                        if (banners.isEmpty) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Special Deals For You',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              NetworkBannerWidget(
                                height: AppResponsive.bannerHeight(
                                  context,
                                  ratio: 0.34,
                                  min: 124,
                                  max: 170,
                                ),
                                banners: banners,
                                autoScrollInterval: const Duration(seconds: 4),
                                autoScrollDuration: const Duration(
                                  milliseconds: 500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(() {
          if (_authController.isLoggedIn) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            top: false,
            child: GestureDetector(
              onTap: () {
                ProtectedNavigationHelper.navigateTo(
                  routeName: Get.currentRoute,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white, size: 22.r),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: AutoSizeText(
                        'Subscribe Now',
                        maxLines: 1,
                        minFontSize: 13,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildAddButton(Product product, int quantity) {
    if (!product.isAvailable) {
      return SizedBox(
        height: 36.h.clamp(34.0, 42.0),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: AutoSizeText(
            'Not Available',
            maxLines: 1,
            minFontSize: 11,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }
    if (quantity == 0) {
      return SizedBox(
        height: 36.h.clamp(34.0, 42.0),
        child: OutlinedButton(
          onPressed: () => _handleAddToCart(product),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1B8A4C),
            side: const BorderSide(color: Color(0xFF1B8A4C), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
          ),
          child: AutoSizeText(
            '+ Add',
            maxLines: 1,
            minFontSize: 11,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
        ),
      );
    } else {
      return Container(
        height: 36.h.clamp(34.0, 42.0),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1B8A4C),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _decrementQuantity(product),
              borderRadius: BorderRadius.circular(4.r),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Icon(Icons.remove, color: Colors.white, size: 18.r),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '$quantity',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(width: 4.w),
            InkWell(
              onTap: () => _incrementQuantity(product),
              borderRadius: BorderRadius.circular(4.r),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Icon(Icons.add, color: Colors.white, size: 18.r),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDescriptionSection(Product product) {
    final hasShort = product.shortDescription != null &&
        product.shortDescription!.trim().isNotEmpty;
    final hasLong =
        product.description != null && product.description!.trim().isNotEmpty;
    final cs = Theme.of(context).colorScheme;

    if (!hasShort && !hasLong) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text(
          'There is no short and long description for this product',
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.5),
            fontSize: 14.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasShort) ...[
            Text(
              'Description',
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              product.shortDescription!,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.7),
                fontSize: 14.sp,
              ),
            ),
            if (hasLong) SizedBox(height: 16.h),
          ],
          if (hasLong) ...[
            if (!hasShort)
              Text(
                'Description',
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: () {
                setState(() {
                  _isDescriptionExpanded = !_isDescriptionExpanded;
                });
              },
              borderRadius: BorderRadius.circular(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.description!,
                    maxLines: _isDescriptionExpanded ? null : 2,
                    overflow: _isDescriptionExpanded
                        ? null
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.7),
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isDescriptionExpanded ? 'Show less' : 'Read more',
                        style: TextStyle(
                          color: cs.primary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        _isDescriptionExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: cs.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRelatedProducts(Product currentProduct) {
    // Filter related products by category
    final relatedProducts = _productProviderController.allProducts
        .where(
          (p) =>
              p.category == currentProduct.category &&
              p.productId != currentProduct.productId,
        )
        .toList();

    if (relatedProducts.isEmpty) {
      return const Text(
        'No related products found',
        style: TextStyle(color: Colors.white54),
      );
    }

    return SizedBox(
      height: AppResponsive.horizontalProductListHeight(context),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: relatedProducts.length,
        itemBuilder: (context, index) {
          final p = relatedProducts[index];
          return Container(
            width: AppResponsive.horizontalCardWidth(context),
            margin: EdgeInsets.only(right: 12.w),
            child: ProductCard(
              key: ValueKey(p.productId),
              product: p,
              enableHero: false,
              onTap: () {
                _controller.updateProduct(p);
                setState(() {
                  _selectedVariantId = inferProductVariantId(p);
                });
              },
              onAddPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
