import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/models/dish_model.dart';
import 'package:fe_mobile_flutter/models/ingredient_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';
  static const String dishesEndpoint = '/dishes';
  static const String ingredientsEndpoint = '/ingredients/';

  // Dish-related methods (unchanged)
  static Future<List<Dish>> fetchDishes() async {
    final response = await http.get(Uri.parse('$baseUrl$dishesEndpoint'));
    print('Fetch URL: $baseUrl$dishesEndpoint, Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Dish.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load dishes: Status ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<Dish> createDish(Dish dish, String imageUrl) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$dishesEndpoint/dishes'));
    request.fields['name'] = dish.name;
    request.fields['description'] = dish.description ?? '';
    request.fields['price'] = dish.price.toString();
    request.fields['category_id'] = dish.categoryId.toString();
    if (imageUrl.isNotEmpty) {
      request.fields['image_url'] = imageUrl;
    }
    print('Create URL: $baseUrl$dishesEndpoint/dishes, Fields: ${request.fields}');
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print('Create Response: Status ${response.statusCode}, Body: $responseBody');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Dish.fromJson(json.decode(responseBody));
    } else {
      throw Exception('Failed to create dish: Status ${response.statusCode}, Body: $responseBody');
    }
  }

  static Future<Dish> updateDish(int id, Dish dish, String imageUrl) async {
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl$dishesEndpoint/dishes/$id'));
    request.fields['name'] = dish.name;
    request.fields['description'] = dish.description ?? '';
    request.fields['price'] = dish.price.toString();
    request.fields['category_id'] = dish.categoryId.toString();
    if (imageUrl.isNotEmpty) {
      request.fields['image_url'] = imageUrl;
    }
    print('Update URL: $baseUrl$dishesEndpoint/dishes/$id, Fields: ${request.fields}');
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print('Update Response: Status ${response.statusCode}, Body: $responseBody');
    if (response.statusCode == 200) {
      return Dish.fromJson(json.decode(responseBody));
    } else {
      throw Exception('Failed to update dish: Status ${response.statusCode}, Body: $responseBody');
    }
  }

  static Future<void> deleteDish(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$dishesEndpoint/dishes/$id'),
    );
    print('Delete URL: $baseUrl$dishesEndpoint/dishes/$id, Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete dish: Status ${response.statusCode}, Body: ${response.body}');
    }
  }





  // Ingredient-related methods
  static Future<List<Ingredient>> fetchIngredients({String query = ''}) async {
    final uri = Uri.parse('$baseUrl$ingredientsEndpoint').replace(queryParameters: {'query': query});
    final response = await http.get(uri);
    print('Fetch Ingredients URL: $uri, Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Ingredient.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ingredients: Status ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<Ingredient> createIngredient(Ingredient ingredient) async {
    final response = await http.post(
      Uri.parse('$baseUrl$ingredientsEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'IngredientName': ingredient.name}),
    );
    print('Create Ingredient URL: $baseUrl$ingredientsEndpoint, Body: ${json.encode({'IngredientName': ingredient.name})}, Status: ${response.statusCode}, Response: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Ingredient.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create ingredient: Status ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<Ingredient> updateIngredient(int id, Ingredient ingredient) async {
    final response = await http.put(
      Uri.parse('$baseUrl$ingredientsEndpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'IngredientName': ingredient.name}),
    );
    print('Update Ingredient URL: $baseUrl$ingredientsEndpoint/$id, Body: ${json.encode({'IngredientName': ingredient.name})}, Status: ${response.statusCode}, Response: ${response.body}');
    if (response.statusCode == 200) {
      return Ingredient.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update ingredient: Status ${response.statusCode}, Body: ${response.body}');
    }
  }

  static Future<void> deleteIngredient(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$ingredientsEndpoint$id'),
    );
    print('Delete Ingredient URL: $baseUrl$ingredientsEndpoint/$id, Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete ingredient: Status ${response.statusCode}, Body: ${response.body}');
    }
  }
}