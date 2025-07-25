class Dish {
  final int? id;
  final String name;
  final String? imageUrl;
  final String? description;
  final double price;
  final int categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Dish({
    this.id,
    required this.name,
    this.imageUrl,
    this.description,
    required this.price,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['DishId'] != null ? json['DishId'] as int : null,
      name: json['DishName'] ?? '',
      imageUrl: json['DishImageUrl'],
      description: json['DishDescription'],
      price: double.parse(json['DishPrice'].toString()),
      categoryId: json['CategoryId'],
      createdAt: json['DishCreatedAt'] != null ? DateTime.parse(json['DishCreatedAt']) : null,
      updatedAt: json['DishUpdatedAt'] != null ? DateTime.parse(json['DishUpdatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DishName': name,
      'DishImageUrl': imageUrl,
      'DishDescription': description,
      'DishPrice': price,
      'CategoryId': categoryId,
    };
  }
}