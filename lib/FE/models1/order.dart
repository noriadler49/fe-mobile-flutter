import 'package:fe_mobile_flutter/FE/models1/account.dart';
import 'package:fe_mobile_flutter/FE/models1/orderitem.dart';

class TblOrder {
  final int orderId;
  final double? orderTotalPrice;
  final int? accountId;
  final String? orderStatus;
  final String? voucherCode;
  String? phoneNumber; // Thêm
  String? orderAddress; // Thêm
  String? paymentMethod;

  final DateTime? orderCreatedAt;
  DateTime? orderUpdatedAt;
  // Relationships (optional)
  final TblAccount? account;
  final List<TblOrderItem>? tblOrderItems;

  TblOrder({
    required this.orderId,
    this.orderTotalPrice,
    this.accountId,
    this.orderStatus,
    this.voucherCode,
    this.phoneNumber,
    this.orderAddress,
    this.paymentMethod,
    this.orderCreatedAt,
    this.orderUpdatedAt,
    this.account,
    this.tblOrderItems,
  });

  factory TblOrder.fromJson(Map<String, dynamic> json) {
    return TblOrder(
      orderId: json['orderId'],
      orderTotalPrice: json['orderTotalPrice'] != null
          ? (json['orderTotalPrice'] as num).toDouble()
          : null,
      accountId: json['accountId'],
      orderStatus: json['orderStatus'],
      voucherCode: json['voucherCode'],
      phoneNumber: json['phoneNumber'],
      orderAddress: json['orderAddress'],
      paymentMethod: json['paymentMethod'],
      orderCreatedAt: json['orderCreatedAt'] != null
          ? DateTime.parse(json['orderCreatedAt'])
          : null,
      orderUpdatedAt: json['orderUpdatedAt'] != null
          ? DateTime.parse(json['orderUpdatedAt'])
          : null,
      account: json['account'] != null
          ? TblAccount.fromJson(json['account'])
          : null,
      tblOrderItems: json['tblOrderItems'] != null
          ? List<TblOrderItem>.from(
              json['tblOrderItems'].map((item) => TblOrderItem.fromJson(item)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderTotalPrice': orderTotalPrice,
      'accountId': accountId,
      'orderStatus': orderStatus,
      'voucherCode': voucherCode,
      'orderCreatedAt': orderCreatedAt?.toIso8601String(),
      'account': account?.toJson(),
      'tblOrderItems': tblOrderItems?.map((item) => item.toJson()).toList(),
    };
  }
}
