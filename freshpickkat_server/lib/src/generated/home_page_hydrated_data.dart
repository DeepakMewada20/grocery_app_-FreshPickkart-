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
import 'banner.dart' as _i2;
import 'product.dart' as _i3;
import 'bogo_offer.dart' as _i4;
import 'combo_offer.dart' as _i5;
import 'delivery_pricing_result.dart' as _i6;
import 'category.dart' as _i7;
import 'sub_category.dart' as _i8;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i9;

abstract class HomePageHydratedData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  HomePageHydratedData._({
    required this.topImageBanners,
    required this.topBanners,
    required this.middleBanners,
    required this.products,
    required this.trendingProducts,
    required this.bestSellersProducts,
    required this.mostViewedProducts,
    required this.frequentlyReorderedProducts,
    required this.activeBogoOffers,
    required this.activeComboOffers,
    this.deliveryOffer,
    required this.categories,
    required this.subCategories,
  });

  factory HomePageHydratedData({
    required List<_i2.Banner> topImageBanners,
    required List<_i2.Banner> topBanners,
    required List<_i2.Banner> middleBanners,
    required List<_i3.Product> products,
    required List<_i3.Product> trendingProducts,
    required List<_i3.Product> bestSellersProducts,
    required List<_i3.Product> mostViewedProducts,
    required List<_i3.Product> frequentlyReorderedProducts,
    required List<_i4.BogoOffer> activeBogoOffers,
    required List<_i5.ComboOffer> activeComboOffers,
    _i6.DeliveryPricingResult? deliveryOffer,
    required List<_i7.Category> categories,
    required List<_i8.SubCategory> subCategories,
  }) = _HomePageHydratedDataImpl;

  factory HomePageHydratedData.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return HomePageHydratedData(
      topImageBanners: _i9.Protocol().deserialize<List<_i2.Banner>>(
        jsonSerialization['topImageBanners'],
      ),
      topBanners: _i9.Protocol().deserialize<List<_i2.Banner>>(
        jsonSerialization['topBanners'],
      ),
      middleBanners: _i9.Protocol().deserialize<List<_i2.Banner>>(
        jsonSerialization['middleBanners'],
      ),
      products: _i9.Protocol().deserialize<List<_i3.Product>>(
        jsonSerialization['products'],
      ),
      trendingProducts: _i9.Protocol().deserialize<List<_i3.Product>>(
        jsonSerialization['trendingProducts'],
      ),
      bestSellersProducts: _i9.Protocol().deserialize<List<_i3.Product>>(
        jsonSerialization['bestSellersProducts'],
      ),
      mostViewedProducts: _i9.Protocol().deserialize<List<_i3.Product>>(
        jsonSerialization['mostViewedProducts'],
      ),
      frequentlyReorderedProducts: _i9.Protocol()
          .deserialize<List<_i3.Product>>(
            jsonSerialization['frequentlyReorderedProducts'],
          ),
      activeBogoOffers: _i9.Protocol().deserialize<List<_i4.BogoOffer>>(
        jsonSerialization['activeBogoOffers'],
      ),
      activeComboOffers: _i9.Protocol().deserialize<List<_i5.ComboOffer>>(
        jsonSerialization['activeComboOffers'],
      ),
      deliveryOffer: jsonSerialization['deliveryOffer'] == null
          ? null
          : _i9.Protocol().deserialize<_i6.DeliveryPricingResult>(
              jsonSerialization['deliveryOffer'],
            ),
      categories: _i9.Protocol().deserialize<List<_i7.Category>>(
        jsonSerialization['categories'],
      ),
      subCategories: _i9.Protocol().deserialize<List<_i8.SubCategory>>(
        jsonSerialization['subCategories'],
      ),
    );
  }

  List<_i2.Banner> topImageBanners;

  List<_i2.Banner> topBanners;

  List<_i2.Banner> middleBanners;

  List<_i3.Product> products;

  List<_i3.Product> trendingProducts;

  List<_i3.Product> bestSellersProducts;

  List<_i3.Product> mostViewedProducts;

  List<_i3.Product> frequentlyReorderedProducts;

  List<_i4.BogoOffer> activeBogoOffers;

  List<_i5.ComboOffer> activeComboOffers;

  _i6.DeliveryPricingResult? deliveryOffer;

  List<_i7.Category> categories;

  List<_i8.SubCategory> subCategories;

  /// Returns a shallow copy of this [HomePageHydratedData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HomePageHydratedData copyWith({
    List<_i2.Banner>? topImageBanners,
    List<_i2.Banner>? topBanners,
    List<_i2.Banner>? middleBanners,
    List<_i3.Product>? products,
    List<_i3.Product>? trendingProducts,
    List<_i3.Product>? bestSellersProducts,
    List<_i3.Product>? mostViewedProducts,
    List<_i3.Product>? frequentlyReorderedProducts,
    List<_i4.BogoOffer>? activeBogoOffers,
    List<_i5.ComboOffer>? activeComboOffers,
    _i6.DeliveryPricingResult? deliveryOffer,
    List<_i7.Category>? categories,
    List<_i8.SubCategory>? subCategories,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HomePageHydratedData',
      'topImageBanners': topImageBanners.toJson(valueToJson: (v) => v.toJson()),
      'topBanners': topBanners.toJson(valueToJson: (v) => v.toJson()),
      'middleBanners': middleBanners.toJson(valueToJson: (v) => v.toJson()),
      'products': products.toJson(valueToJson: (v) => v.toJson()),
      'trendingProducts': trendingProducts.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'bestSellersProducts': bestSellersProducts.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'mostViewedProducts': mostViewedProducts.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'frequentlyReorderedProducts': frequentlyReorderedProducts.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'activeBogoOffers': activeBogoOffers.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'activeComboOffers': activeComboOffers.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      if (deliveryOffer != null) 'deliveryOffer': deliveryOffer?.toJson(),
      'categories': categories.toJson(valueToJson: (v) => v.toJson()),
      'subCategories': subCategories.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HomePageHydratedData',
      'topImageBanners': topImageBanners.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'topBanners': topBanners.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'middleBanners': middleBanners.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'products': products.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'trendingProducts': trendingProducts.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'bestSellersProducts': bestSellersProducts.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'mostViewedProducts': mostViewedProducts.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'frequentlyReorderedProducts': frequentlyReorderedProducts.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'activeBogoOffers': activeBogoOffers.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'activeComboOffers': activeComboOffers.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (deliveryOffer != null)
        'deliveryOffer': deliveryOffer?.toJsonForProtocol(),
      'categories': categories.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'subCategories': subCategories.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HomePageHydratedDataImpl extends HomePageHydratedData {
  _HomePageHydratedDataImpl({
    required List<_i2.Banner> topImageBanners,
    required List<_i2.Banner> topBanners,
    required List<_i2.Banner> middleBanners,
    required List<_i3.Product> products,
    required List<_i3.Product> trendingProducts,
    required List<_i3.Product> bestSellersProducts,
    required List<_i3.Product> mostViewedProducts,
    required List<_i3.Product> frequentlyReorderedProducts,
    required List<_i4.BogoOffer> activeBogoOffers,
    required List<_i5.ComboOffer> activeComboOffers,
    _i6.DeliveryPricingResult? deliveryOffer,
    required List<_i7.Category> categories,
    required List<_i8.SubCategory> subCategories,
  }) : super._(
         topImageBanners: topImageBanners,
         topBanners: topBanners,
         middleBanners: middleBanners,
         products: products,
         trendingProducts: trendingProducts,
         bestSellersProducts: bestSellersProducts,
         mostViewedProducts: mostViewedProducts,
         frequentlyReorderedProducts: frequentlyReorderedProducts,
         activeBogoOffers: activeBogoOffers,
         activeComboOffers: activeComboOffers,
         deliveryOffer: deliveryOffer,
         categories: categories,
         subCategories: subCategories,
       );

  /// Returns a shallow copy of this [HomePageHydratedData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HomePageHydratedData copyWith({
    List<_i2.Banner>? topImageBanners,
    List<_i2.Banner>? topBanners,
    List<_i2.Banner>? middleBanners,
    List<_i3.Product>? products,
    List<_i3.Product>? trendingProducts,
    List<_i3.Product>? bestSellersProducts,
    List<_i3.Product>? mostViewedProducts,
    List<_i3.Product>? frequentlyReorderedProducts,
    List<_i4.BogoOffer>? activeBogoOffers,
    List<_i5.ComboOffer>? activeComboOffers,
    Object? deliveryOffer = _Undefined,
    List<_i7.Category>? categories,
    List<_i8.SubCategory>? subCategories,
  }) {
    return HomePageHydratedData(
      topImageBanners:
          topImageBanners ??
          this.topImageBanners.map((e0) => e0.copyWith()).toList(),
      topBanners:
          topBanners ?? this.topBanners.map((e0) => e0.copyWith()).toList(),
      middleBanners:
          middleBanners ??
          this.middleBanners.map((e0) => e0.copyWith()).toList(),
      products: products ?? this.products.map((e0) => e0.copyWith()).toList(),
      trendingProducts:
          trendingProducts ??
          this.trendingProducts.map((e0) => e0.copyWith()).toList(),
      bestSellersProducts:
          bestSellersProducts ??
          this.bestSellersProducts.map((e0) => e0.copyWith()).toList(),
      mostViewedProducts:
          mostViewedProducts ??
          this.mostViewedProducts.map((e0) => e0.copyWith()).toList(),
      frequentlyReorderedProducts:
          frequentlyReorderedProducts ??
          this.frequentlyReorderedProducts.map((e0) => e0.copyWith()).toList(),
      activeBogoOffers:
          activeBogoOffers ??
          this.activeBogoOffers.map((e0) => e0.copyWith()).toList(),
      activeComboOffers:
          activeComboOffers ??
          this.activeComboOffers.map((e0) => e0.copyWith()).toList(),
      deliveryOffer: deliveryOffer is _i6.DeliveryPricingResult?
          ? deliveryOffer
          : this.deliveryOffer?.copyWith(),
      categories:
          categories ?? this.categories.map((e0) => e0.copyWith()).toList(),
      subCategories:
          subCategories ??
          this.subCategories.map((e0) => e0.copyWith()).toList(),
    );
  }
}
