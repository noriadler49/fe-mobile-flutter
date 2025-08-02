class DishDtoAdmin {
  final int? id;
  final String name;
  final String? dishImageUrl;
  final String? description;
  final double? price;
  final int? categoryId;
  final String? categoryName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<int>? ingredientIds;

  DishDtoAdmin({
    this.id,
    required this.name,
    this.dishImageUrl,
    this.description,
    this.price,
    this.categoryId,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
    this.ingredientIds,
  });

  factory DishDtoAdmin.fromJson(Map<String, dynamic> json) => DishDtoAdmin(
    id: json['dishId'],
    name: json['dishName'],
    dishImageUrl: json['dishImageUrl'],
    description: json['dishDescription'],
    price: json['price'] != null
        ? double.tryParse(json['price'].toString()) ?? 0.0
        : 0.0,
    categoryId: json['categoryId'] ?? 1,
    categoryName: json['categoryName'],
    createdAt: json['dishCreatedAt'] != null
        ? DateTime.parse(json['dishCreatedAt'])
        : null,
    updatedAt: json['dishUpdatedAt'] != null
        ? DateTime.parse(json['dishUpdatedAt'])
        : null,
    ingredientIds: (json['ingredientIds'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList(),
  );

  Map<String, dynamic> toJson() {
    return {
      'dishId': id,
      'dishName': name,
      'dishImageUrl': dishImageUrl,
      'dishDescription': description,
      'price': price,
      'categoryId': categoryId,
      'ingredientIds': ingredientIds,
    };
  }
}
