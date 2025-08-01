import 'package:fe_mobile_flutter/FE/models1/dish.dart';
import 'package:fe_mobile_flutter/FE/models1/order.dart';

class TblOrderItem {
  final int orderItemId;
  final int? dishId;
  final int? orderItemQuantity;
  final double? orderItemPrice;
  final int? orderId;

  // Relationships (optional)
  final TblDish? dish;
  final TblOrder? order;

  TblOrderItem({
    required this.orderItemId,
    this.dishId,
    this.orderItemQuantity,
    this.orderItemPrice,
    this.orderId,
    this.dish,
    this.order,
  });

  factory TblOrderItem.fromJson(Map<String, dynamic> json) {
    return TblOrderItem(
      orderItemId: json['orderItemId'],
      dishId: json['dishId'],
      orderItemQuantity: json['orderItemQuantity'],
      orderItemPrice: json['orderItemPrice'] != null
          ? (json['orderItemPrice'] as num).toDouble()
          : null,
      orderId: json['orderId'],
      dish: json['dish'] != null ? TblDish.fromJson(json['dish']) : null,
      order: json['order'] != null ? TblOrder.fromJson(json['order']) : null,
    );
  }

  get quantity => null;

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'dishId': dishId,
      'orderItemQuantity': orderItemQuantity,
      'orderItemPrice': orderItemPrice,
      'orderId': orderId,
      'dish': dish?.toJson(),
      'order': order?.toJson(),
    };
  }
}
