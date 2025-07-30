import 'package:fe_mobile_flutter/FE/models1/dish.dart';

class TblCategory {
  final int categoryId;
  final String categoryName;

  // Optional: list of related dishes
  final List<TblDish>? tblDishes;

  TblCategory({
    required this.categoryId,
    required this.categoryName,
    this.tblDishes,
  });

  factory TblCategory.fromJson(Map<String, dynamic> json) {
    return TblCategory(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      tblDishes: json['tblDishes'] != null
          ? List<TblDish>.from(
              json['tblDishes'].map((dish) => TblDish.fromJson(dish)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'tblDishes': tblDishes?.map((dish) => dish.toJson()).toList(),
    };
  }
}
