import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/models1/account.dart';
import 'package:fe_mobile_flutter/FE/models1/dish.dart';
import 'package:fe_mobile_flutter/FE/models1/dish_dto.dart';
// class TblCartItem {
//   final int cartItemId;
//   final int? dishId;
//   final int? cartItemQuantity;
//   final int? accountId;

//   final TblAccount? account;
//   final TblDish? dish;

//   TblCartItem({
//     required this.cartItemId,
//     this.dishId,
//     this.cartItemQuantity,
//     this.accountId,
//     this.account,
//     this.dish,
//   });

//   /// ✅ Corrected copyWith
//   TblCartItem copyWith({
//     int? cartItemId,
//     int? dishId,
//     int? cartItemQuantity,
//     int? accountId,
//     TblAccount? account,
//     TblDish? dish,
//   }) {
//     return TblCartItem(
//       cartItemId: cartItemId ?? this.cartItemId,
//       dishId: dishId ?? this.dishId,
//       cartItemQuantity: cartItemQuantity ?? this.cartItemQuantity,
//       accountId: accountId ?? this.accountId,
//       account: account ?? this.account,
//       dish: dish ?? this.dish,
//     );
//   }

//   factory TblCartItem.fromJson(Map<String, dynamic> json) {
//     // Nếu có key "dish" và nó là Map, parse theo kiểu object
//     if (json['dish'] != null && json['dish'] is Map<String, dynamic>) {
//       return TblCartItem(
//         cartItemId: json['cartItemId'],
//         dishId: json['dishId'],
//         cartItemQuantity: json['quantity'],
//         accountId: json['accountId'],
//         dish: TblDish.fromJson(json['dish']),
//       );
//     }

//     // Trường hợp còn lại (kiểu flatted CartItemDto từ BE)
//     return TblCartItem(
//       cartItemId: json['cartItemId'],
//       dishId: json['dishId'],
//       cartItemQuantity: json['quantity'],
//       accountId: json['accountId'],
//       dish: TblDish(
//         dishId: json['dishId'],
//         dishName: json['dishName'] ?? 'Unknown',
//         dishPrice: (json['dishPrice'] as num).toDouble(),
//         dishImageUrl: json['dishImageUrl'] ?? 'default.png',
//       ),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'cartItemId': cartItemId,
//       'dishId': dishId,
//       'cartItemQuantity': cartItemQuantity,
//       'accountId': accountId,
//       'account': account?.toJson(),
//       'dish': dish?.toJson(),
//     };
//   }
// }
class TblCartItem {
  final int cartItemId;
  final int? dishId;
  final int? cartItemQuantity;
  final int? accountId;

  final TblAccount? account;
  final DishDto? dish;

  TblCartItem({
    required this.cartItemId,
    this.dishId,
    this.cartItemQuantity,
    this.accountId,
    this.account,
    this.dish,
  });

  TblCartItem copyWith({
    int? cartItemId,
    int? dishId,
    int? cartItemQuantity,
    int? accountId,
    TblAccount? account,
    DishDto? dish,
  }) {
    return TblCartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      dishId: dishId ?? this.dishId,
      cartItemQuantity: cartItemQuantity ?? this.cartItemQuantity,
      accountId: accountId ?? this.accountId,
      account: account ?? this.account,
      dish: dish ?? this.dish,
    );
  }

  factory TblCartItem.fromJson(Map<String, dynamic> json) {
    if (json['dish'] != null && json['dish'] is Map<String, dynamic>) {
      return TblCartItem(
        cartItemId: json['cartItemId'],
        dishId: json['dishId'],
        cartItemQuantity: json['quantity'],
        accountId: json['accountId'],
        dish: DishDto.fromJson(json['dish']),
      );
    }

    return TblCartItem(
      cartItemId: json['cartItemId'],
      dishId: json['dishId'],
      cartItemQuantity: json['quantity'],
      accountId: json['accountId'],
      dish: DishDto(
        dishId: json['dishId'],
        dishName: json['dishName'] ?? 'Unknown',
        dishPrice: (json['dishPrice'] as num).toDouble(),
        dishImageUrl: json['dishImageUrl'] ?? 'default.png',
        dishDescription: json['dishDescription'],
        categoryId: json['categoryId'],
        categoryName: json['categoryName'],
        ingredientNames: json['ingredientNames'] != null
            ? List<String>.from(json['ingredientNames'])
            : null,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'dishId': dishId,
      'cartItemQuantity': cartItemQuantity,
      'accountId': accountId,
      'account': account?.toJson(),
      'dish': dish?.toJson(),
    };
  }
}
