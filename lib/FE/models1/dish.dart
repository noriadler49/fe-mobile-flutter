import 'package:fe_mobile_flutter/FE/models1/category.dart';
import 'package:fe_mobile_flutter/FE/models1/cartitem.dart';
import 'package:fe_mobile_flutter/FE/models1/orderitem.dart';
import 'package:fe_mobile_flutter/FE/models1/ingredient.dart';

class TblDish {
  final int dishId;
  final String dishName;
  final String? dishImageUrl;
  final String? dishDescription;
  final double? dishPrice;
  final int? categoryId;
  final DateTime? dishCreatedAt;
  final DateTime? dishUpdatedAt;

  // Relationships (optional, include if your JSON contains them)
  final TblCategory? category;
  final List<TblCartItem>? tblCartItems;
  final List<TblOrderItem>? tblOrderItems;
  final List<TblIngredient>? ingredients;

  TblDish({
    required this.dishId,
    required this.dishName,
    this.dishImageUrl,
    this.dishDescription,
    this.dishPrice,
    this.categoryId,
    this.dishCreatedAt,
    this.dishUpdatedAt,
    this.category,
    this.tblCartItems,
    this.tblOrderItems,
    this.ingredients,
  });

  factory TblDish.fromJson(Map<String, dynamic> json) {
    return TblDish(
      dishId: json['dishId'],
      dishName: json['dishName'],
      dishImageUrl: json['dishImageUrl'],
      dishDescription: json['dishDescription'],
      dishPrice: json['dishPrice'] != null
          ? (json['dishPrice'] as num).toDouble()
          : null,
      categoryId: json['categoryId'],
      dishCreatedAt: json['dishCreatedAt'] != null
          ? DateTime.parse(json['dishCreatedAt'])
          : null,
      dishUpdatedAt: json['dishUpdatedAt'] != null
          ? DateTime.parse(json['dishUpdatedAt'])
          : null,
      category: json['category'] != null
          ? TblCategory.fromJson(json['category'])
          : null,
      tblCartItems: json['tblCartItems'] != null
          ? List<TblCartItem>.from(
              json['tblCartItems'].map((item) => TblCartItem.fromJson(item)),
            )
          : null,
      tblOrderItems: json['tblOrderItems'] != null
          ? List<TblOrderItem>.from(
              json['tblOrderItems'].map((item) => TblOrderItem.fromJson(item)),
            )
          : null,
      ingredients: json['ingredients'] != null
          ? List<TblIngredient>.from(
              json['ingredients'].map((item) => TblIngredient.fromJson(item)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'dishName': dishName,
      'dishImageUrl': dishImageUrl,
      'dishDescription': dishDescription,
      'dishPrice': dishPrice,
      'categoryId': categoryId,
      'dishCreatedAt': dishCreatedAt?.toIso8601String(),
      'dishUpdatedAt': dishUpdatedAt?.toIso8601String(),
      'category': category?.toJson(),
      'tblCartItems': tblCartItems?.map((item) => item.toJson()).toList(),
      'tblOrderItems': tblOrderItems?.map((item) => item.toJson()).toList(),
      'ingredients': ingredients?.map((item) => item.toJson()).toList(),
    };
  }
}
