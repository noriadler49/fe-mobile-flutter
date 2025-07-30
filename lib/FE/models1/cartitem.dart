import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/services/api_service.dart';
import 'package:fe_mobile_flutter/FE/models1/account.dart';
import 'package:fe_mobile_flutter/FE/models1/dish.dart';

class TblCartItem {
  final int cartItemId;
  final int? dishId;
  final int? cartItemQuantity;
  final int? accountId;

  // Relationships (optional depending on how you want to use them)
  final TblAccount? account;
  final TblDish? dish;

  TblCartItem({
    required this.cartItemId,
    this.dishId,
    this.cartItemQuantity,
    this.accountId,
    this.account,
    this.dish,
  });

  factory TblCartItem.fromJson(Map<String, dynamic> json) {
    return TblCartItem(
      cartItemId: json['cartItemId'],
      dishId: json['dishId'],
      cartItemQuantity: json['cartItemQuantity'],
      accountId: json['accountId'],
      account: json['account'] != null
          ? TblAccount.fromJson(json['account'])
          : null,
      dish: json['dish'] != null ? TblDish.fromJson(json['dish']) : null,
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
