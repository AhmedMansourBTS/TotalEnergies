class CategoryModel {
  final int categoryId;
  final String categoryName;
  final String categoryLatName;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryLatName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      categoryLatName: json['categoryLatName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryLatName': categoryLatName,
    };
  }
}
