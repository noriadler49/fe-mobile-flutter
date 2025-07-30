import 'package:fe_mobile_flutter/FE/models1/dish.dart';

class TblIngredient {
  final int ingredientId;
  final String ingredientName;

  // Optional: list of related dishes
  final List<TblDish>? dishes;

  TblIngredient({
    required this.ingredientId,
    required this.ingredientName,
    this.dishes,
  });

  factory TblIngredient.fromJson(Map<String, dynamic> json) {
    return TblIngredient(
      ingredientId: json['ingredientId'],
      ingredientName: json['ingredientName'],
      dishes: json['dishes'] != null
          ? List<TblDish>.from(
              json['dishes'].map((dish) => TblDish.fromJson(dish)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
      'ingredientName': ingredientName,
      'dishes': dishes?.map((dish) => dish.toJson()).toList(),
    };
  }
}
