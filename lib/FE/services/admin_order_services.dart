import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/FE/models1/order.dart';
import 'package:fe_mobile_flutter/FE/models1/orderitem.dart';

class AdminOrderService {
  static const String baseUrl = 'http://10.0.2.2:5065/api/Orders'; // Adjust if needed

  // Fetch all orders for admin
  static Future<List<TblOrder>> getAllOrders() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TblOrder.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  // Approve an order
  static Future<bool> approveOrder(int orderId) async {
    try {
      final response = await http.put(Uri.parse('$baseUrl/approve/$orderId'));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to approve order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error approving order: $e');
    }
  }

  // Fetch orders by user ID for admin
  static Future<List<TblOrder>> getOrdersByUser(int accountId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$accountId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => TblOrder.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user orders: $e');
    }
  }
}