class Ingredient {
  final int? id;
  final String name;

  Ingredient({
    this.id,
    required this.name,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['IngredientId'] != null ? json['IngredientId'] as int : null,
      name: json['IngredientName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IngredientName': name,
    };
  }
}