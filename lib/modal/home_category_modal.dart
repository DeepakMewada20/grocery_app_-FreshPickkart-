class HomeCategoryModal {
  String homePageCategoryName;
  List<Map<String, String>> homePageCategoryItem;

  // Constructor
  HomeCategoryModal({
    required this.homePageCategoryName,
    required this.homePageCategoryItem,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'homePageCategoryName': homePageCategoryName,
      'homePageCategoryItem': homePageCategoryItem,
    };
  }

  // Create object from JSON
  factory HomeCategoryModal.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModal(
      homePageCategoryName: json['homePageCategoryName'] as String,
      homePageCategoryItem: List<Map<String, String>>.from(
        (json['homePageCategoryItem'] as List).map(
          (item) => Map<String, String>.from(item as Map),
        ),
      ),
    );
  }
}
