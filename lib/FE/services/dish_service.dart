import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/FE/models1/dish.dart';
import 'package:fe_mobile_flutter/FE/models1/dish_dto.dart';

class DishService {
  final String baseUrl = "http://10.0.2.2:5065/api/dishes";

  // Get all dishes
  Future<List<DishDto>> fetchAllDishes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => DishDto.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load dishes");
    }
  }

  Future<DishDto> fetchDishById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DishDto.fromJson(jsonData);
    } else {
      throw Exception('Failed to load dish');
    }
  }

  // Get dishes by category
  Future<List<DishDto>> fetchDishesByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$categoryId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => DishDto.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load dishes for category $categoryId");
    }
  }

  // Create a new dish
  Future<DishDto> createDish(DishDto dto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode == 201) {
      return DishDto.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create dish");
    }
  }
}
