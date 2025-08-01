import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/FE/models1/order.dart';

class OrderService {
  final String baseUrl = "http://10.0.2.2:5065/api/orders";

  Future<void> placeOrder(
    int accountId,
    // List<Map<String, dynamic>> selectedCartItemIds,
    List<Map<String, dynamic>> selectedCartItems,
    String? voucherCode,
      {String? phoneNumber, String? orderAddress, String? paymentMethod}
  ) async {
    final url = Uri.parse('$baseUrl/ord');

    final body = {
      'accountId': accountId,
      'selectedCartItemIds': selectedCartItems, // <-- đây là List<Map>
      'voucherCode': voucherCode,
          'phoneNumber': phoneNumber,
    'orderAddress': orderAddress,
    'paymentMethod': paymentMethod,
    };
    print("✅ Đang gửi order với: ${jsonEncode(body)}");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Order success: ${response.body}");
      return;
    } else {
      print(
        "❌ Order failed with status ${response.statusCode}: ${response.body}",
      );
      throw Exception('Order failed: ${response.body}');
    }
  }

  // Place order for selected cart items (POST /placebyone)
  Future<Map<String, dynamic>?> placeOrderBySelectedItems({
    required int accountId,
    required List<int> cartItemIds,
    String? voucherCode,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/placebyone'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'accountId': accountId,
        'cartItemIds': cartItemIds,
        'voucherCode': voucherCode,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to place order (selected items): ${response.body}");
      return null;
    }
  }

  // Place order for all items in cart (POST /placebyall?accountId=X&voucherCode=Y)
  Future<Map<String, dynamic>?> placeOrderByAll({
    required int accountId,
    String? voucherCode,
  }) async {
    final uri = Uri.parse('$baseUrl/placebyall').replace(
      queryParameters: {
        'accountId': accountId.toString(),
        if (voucherCode != null) 'voucherCode': voucherCode,
      },
    );

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Failed to place order (all items): ${response.body}");
      return null;
    }
  }

  // Approve an order (PUT /approve/{id})
  Future<bool> approveOrder(int orderId) async {
    final response = await http.put(Uri.parse('$baseUrl/approve/$orderId'));

    if (response.statusCode == 200) {
      return true;
    } else {
      print("Failed to approve order: ${response.body}");
      return false;
    }
  }

  // Get all orders (GET /)
  Future<List<TblOrder>> getAllOrders() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TblOrder.fromJson(json)).toList();
    } else {
      print("Failed to fetch all orders: ${response.body}");
      return [];
    }
  }

  // Get orders by user (GET /user/{accountId})
  Future<List<TblOrder>> getOrdersByUser(int accountId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$accountId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TblOrder.fromJson(json)).toList();
    } else {
      print("Failed to fetch user's orders: ${response.body}");
      return [];
    }
  }
}
