import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/FE/models1/dishdto_admin.dart';

class AdminDishService {
  static const String baseUrl = "http://10.0.2.2:5065/api/admin/dishes";

  static Future<List<DishDtoAdmin>> fetchDishes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print("Response body: ${response.body}");
      return jsonData.map((e) => DishDtoAdmin.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load dishes');
    }
  }

  static Future<DishDtoAdmin> createDish(
    DishDtoAdmin dish,
    File? image,
    String? imageUrl,
    
  ) async {
    final Map<String, dynamic> dishJson = dish.toJson();

    // Nếu bạn cần upload ảnh thật, dùng multipart
    // Ở đây chỉ dùng URL
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dishJson),
    );

    if (response.statusCode == 201) {
      return DishDtoAdmin.fromJson(json.decode(response.body));
    } else {
      print("Error creating dish: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to create dish');
    }
  }

  static Future<DishDtoAdmin> updateDish(
    int id,
    DishDtoAdmin dish,
    File? image,
    String? imageUrl,
  ) async {
    final Map<String, dynamic> dishJson = dish.toJson();
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dishJson),
    );

    if (response.statusCode == 204) {
      return dish;
    } else {
      print("Error creating dish: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to update dish');
    }
  }

  static Future<void> deleteDish(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete dish');
    }
  }
}
