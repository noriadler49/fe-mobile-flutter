class DishDto {
  final int dishId;
  final String dishName;
  final String? dishImageUrl; // ✅ Sửa tên thuộc tính viết đúng kiểu camelCase
  final double? dishPrice;
  final String? dishDescription;
  final int? categoryId;
  final String? categoryName;
  final List<String>? ingredientNames;

  DishDto({
    required this.dishId,
    required this.dishName,
    this.dishImageUrl,
    this.dishPrice,
    this.dishDescription,
    this.categoryId,
    this.categoryName,
    this.ingredientNames,
  });

  factory DishDto.fromJson(Map<String, dynamic> json) {
    return DishDto(
      dishId: json['dishId'],
      dishName: json['dishName'],
      dishImageUrl: json['dishImageUrl'],
      dishPrice: json['dishPrice'] != null
          ? (json['dishPrice'] as num).toDouble()
          : null,
      dishDescription: json['dishDescription'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      ingredientNames: json['ingredientNames'] != null
          ? List<String>.from(json['ingredientNames'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'dishName': dishName,
      'dishImageUrl': dishImageUrl,
      'dishPrice': dishPrice,
      'dishDescription': dishDescription,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'ingredientNames': ingredientNames,
    };
  }
}
