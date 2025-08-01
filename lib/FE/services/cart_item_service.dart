import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/FE/models1/cartitem.dart';

class CartItemService {
  final String baseUrl = "http://10.0.2.2:5065/api/cartitems";

  // Get cart items by accountId
  Future<List<TblCartItem>> getCartItemsByAccountId(int accountId) async {
    final response = await http.get(Uri.parse('$baseUrl/$accountId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TblCartItem.fromJson(json)).toList();
    } else {
      print("Failed to fetch cart items: ${response.body}");
      return [];
    }
  }
  Future<bool> updateQuantity(int cartItemId, int newQuantity) async {
  final response = await http.put(
    Uri.parse('$baseUrl/updateQuantity'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'cartItemId': cartItemId,
      'quantity': newQuantity,
    }),
  );
  return response.statusCode == 200;
}

  // Add item to cart
  Future<TblCartItem?> addToCart({
    required int dishId,
    required int quantity,
    required int accountId,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'dishId': dishId,
        'quantity': quantity,
        'accountId': accountId,
      }),
    );

    if (response.statusCode == 201) {
      return TblCartItem.fromJson(jsonDecode(response.body));
    } else {
      print("Failed to add to cart: ${response.body}");
      return null;
    }
  }

  // Remove item from cart by cartItemId
  Future<bool> removeCartItem(int cartItemId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$cartItemId'));

    if (response.statusCode == 204) {
      return true;
    } else {
      print("Failed to remove cart item: ${response.body}");
      return false;
    }
  }
}
