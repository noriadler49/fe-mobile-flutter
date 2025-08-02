import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_mobile_flutter/FE/services/account_service.dart';
import 'package:fe_mobile_flutter/FE/services/order_service.dart';
import 'package:fe_mobile_flutter/FE/services/vourcherservice.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String userName = '';
  String phoneNumber = '';
  String address = '';
  String? voucherCode;
  int? accountId;
  double? voucherDiscountPercentage;
  double discountAmount = 0;
  double totalBeforeDiscount = 0;
  String selectedPaymentMethod = 'Cash';
  final accountService = AccountService();
  final orderService = OrderService();
  bool hasLoadedArguments = false;
  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasLoadedArguments) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      print("🟡 args received in CheckoutScreen: $args");

      if (args != null) {
        voucherCode = args['voucherCode']?.toString();
        accountId = args['accountId'];
        print("✅ Voucher code received in CheckoutScreen: $voucherCode");

        if (voucherCode != null && voucherCode!.isNotEmpty) {
          _loadVoucher(voucherCode!);
        }
      } else {
        print("❌ ModalRoute arguments are null in CheckoutScreen");
      }
      hasLoadedArguments = true;
    }
  }

  void _loadVoucher(String code) async {
    try {
      final voucher = await VourcherService().validateVoucher(code);
      if (voucher != null) {
        print(
          "✅ Voucher percentage received from service: ${voucher.voucherDiscountPercentage}",
        );

        setState(() {
          voucherDiscountPercentage = voucher.voucherDiscountPercentage;
          discountAmount =
              totalBeforeDiscount * (voucherDiscountPercentage! / 100);
        });
      } else {
        print("❌ Voucher not found or invalid");
        setState(() {
          voucherDiscountPercentage = 0;
          discountAmount = 0;
        });
      }
    } catch (e) {
      print("❌ Error loading voucher: $e");
      setState(() {
        voucherDiscountPercentage = 0;
        discountAmount = 0;
      });
    }
  }

  void _navigateToAddressScreen() async {
    final result = await Navigator.pushNamed(context, '/address');

    if (result != null && result is Map<String, String>) {
      setState(() {
        userName = result['name']!;
        phoneNumber = result['phone']!;
        address = result['address']!;
      });
    }
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final accountId = prefs.getInt('accountId');

    if (accountId != null) {
      final account = await accountService.getAccountById(accountId);

      if (account != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('accountUsername', account.accountUsername ?? '');
        setState(() {
          userName = account.accountUsername ?? '';
          phoneNumber = account.phoneNumber ?? '';
          address = account.address ?? '';
        });
      }
    }
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    totalBeforeDiscount = widget.cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    if (voucherDiscountPercentage != null && voucherDiscountPercentage! > 0) {
      discountAmount = totalBeforeDiscount * (voucherDiscountPercentage! / 100);
    } else {
      discountAmount = 0;
    }

    // ✅ Tổng cuối cùng
    final double finalTotal = totalBeforeDiscount - discountAmount;

    double total = widget.cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('$userName | $phoneNumber'),
              subtitle: Text('Address: $address'),
              trailing: IconButton(
                icon: Icon(Icons.edit_location_alt),
                onPressed: _navigateToAddressScreen,
              ),
            ),
          ),

          // Cart items
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 16),
              children: [
                // Danh sách sản phẩm trong giỏ hàng
                ...widget.cartItems.map((item) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Image.asset(
                        item['image'] ?? 'assets/default.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['name'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shop: ${item['shop'] ?? 'Unknown'}'),
                          Text('Ingredients: ${item['ingredients'] ?? ''}'),
                          Text('\$${item['price']} x${item['quantity']}'),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                // Phần chọn phương thức thanh toán
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Method",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: selectedPaymentMethod,
                        items: ['Cash', 'VnPay', 'PayPal'].map((method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Phần chi tiết thanh toán
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Details Payment",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 6),
                      _buildDetailRow(
                        "Bill of Food",
                        "\$${totalBeforeDiscount.toStringAsFixed(2)}",
                      ),
                      if (voucherCode != null &&
                          voucherCode!.isNotEmpty &&
                          discountAmount > 0) ...[
                        _buildDetailRow("Voucher Code", voucherCode!),
                        _buildDetailRow(
                          "Voucher Discount",
                          "-\$${discountAmount.toStringAsFixed(2)}",
                        ),
                      ],

                      Divider(),
                      _buildDetailRow(
                        "Total Payment",
                        "\$${finalTotal.toStringAsFixed(2)}",
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Payment: \$${finalTotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final accountId = prefs.getInt('accountId');

                    if (accountId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Account not found. Please login again.",
                          ),
                        ),
                      );
                      return;
                    }

                    final selectedCartItemIds = widget.cartItems
                        .map((item) => item['cartItemId'])
                        .toList();

                    final cartItemsWithQuantity = widget.cartItems
                        .map(
                          (item) => {
                            'cartItemId': item['cartItemId'],
                            'quantity': item['quantity'],
                          },
                        )
                        .toList();

                    try {
                      await orderService.placeOrder(
                        accountId,
                        cartItemsWithQuantity,
                        voucherCode,
                        phoneNumber: phoneNumber,
                        orderAddress: address,
                        paymentMethod: selectedPaymentMethod,
                      );

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Order Successful"),
                          content: Text("Your order has been placed!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/orderFollow',
                                  (route) => false,
                                );
                                // Go to Home and remove all previous routes
                              },
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("❌ Order failed: $e")),
                      );
                    }
                  },

                  child: Text('Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
