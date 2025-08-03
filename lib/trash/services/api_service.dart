import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/trash/models/user_model.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:fe_mobile_flutter/trash/models/dish_model.dart';
import 'package:fe_mobile_flutter/trash/models/ingredient_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';
  static const String dishesEndpoint = '/dishes';
  static const String ingredientsEndpoint = '/ingredients/';
  static const String authEndpoint = '/auth';

  // Existing dish methods (unchanged)
  static Future<List<Dish>> fetchDishes() async {
    final response = await http.get(Uri.parse('$baseUrl$dishesEndpoint'));
    print(
      'Fetch URL: $baseUrl$dishesEndpoint, Status: ${response.statusCode}, Body: ${response.body}',
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Dish.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load dishes: Status ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  static Future<Dish> createDish(
    Dish dish,
    File? image,
    String? imageUrl,
  ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$dishesEndpoint/dishes'),
    );
    request.fields['name'] = dish.name;
    request.fields['description'] = dish.description ?? '';
    request.fields['price'] = dish.price.toString();
    request.fields['category_id'] = dish.categoryId.toString();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      request.fields['image_url'] = imageUrl;
    }
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }
    print(
      'Create URL: $baseUrl$dishesEndpoint/dishes, Fields: ${request.fields}, Files: ${request.files}',
    );
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print(
      'Create Response: Status ${response.statusCode}, Body: $responseBody',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Dish.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
        'Failed to create dish: Status ${response.statusCode}, Body: $responseBody',
      );
    }
  }

  static Future<Dish> updateDish(
    int id,
    Dish dish,
    File? image,
    String? imageUrl,
  ) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl$dishesEndpoint/dishes/$id'),
    );
    request.fields['name'] = dish.name;
    request.fields['description'] = dish.description ?? '';
    request.fields['price'] = dish.price.toString();
    request.fields['category_id'] = dish.categoryId.toString();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      request.fields['image_url'] = imageUrl;
    }
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }
    print(
      'Update URL: $baseUrl$dishesEndpoint/dishes/$id, Fields: ${request.fields}, Files: ${request.files}',
    );
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print(
      'Update Response: Status ${response.statusCode}, Body: $responseBody',
    );
    if (response.statusCode == 200) {
      return Dish.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
        'Failed to update dish: Status ${response.statusCode}, Body: $responseBody',
      );
    }
  }

  static Future<void> deleteDish(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$dishesEndpoint/dishes/$id'),
    );
    print(
      'Delete URL: $baseUrl$dishesEndpoint/dishes/$id, Status: ${response.statusCode}, Body: ${response.body}',
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete dish: Status ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // Existing ingredient methods (unchanged)
  static Future<List<Ingredient>> fetchIngredients({String query = ''}) async {
    final uri = Uri.parse(
      '$baseUrl$ingredientsEndpoint',
    ).replace(queryParameters: {'query': query});
    final response = await http.get(uri);
    print(
      'Fetch Ingredients URL: $uri, Status: ${response.statusCode}, Body: ${response.body}',
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Ingredient.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load ingredients: Status ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  static Future<Ingredient> createIngredient(Ingredient ingredient) async {
    final response = await http.post(
      Uri.parse('$baseUrl$ingredientsEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'IngredientName': ingredient.name}),
    );
    print(
      'Create Ingredient URL: $baseUrl$ingredientsEndpoint, Body: ${json.encode({'IngredientName': ingredient.name})}, Status: ${response.statusCode}, Response: ${response.body}',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Ingredient.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to create ingredient: Status ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  static Future<Ingredient> updateIngredient(
    int id,
    Ingredient ingredient,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl$ingredientsEndpoint/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'IngredientName': ingredient.name}),
    );
    print(
      'Update Ingredient URL: $baseUrl$ingredientsEndpoint/$id, Body: ${json.encode({'IngredientName': ingredient.name})}, Status: ${response.statusCode}, Response: ${response.body}',
    );
    if (response.statusCode == 200) {
      return Ingredient.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to update ingredient: Status ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  static Future<void> deleteIngredient(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$ingredientsEndpoint/$id'),
    );
    print(
      'Delete Ingredient URL: $baseUrl$ingredientsEndpoint/$id, Status: ${response.statusCode}, Body: ${response.body}',
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete ingredient: Status ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // Auth methods
  static Future<User> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$authEndpoint/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );
      print(
        'Register URL: $baseUrl$authEndpoint/register, Body: ${json.encode(user.toJson())}, Status: ${response.statusCode}, Response: ${response.body}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = User.fromJson(json.decode(response.body));
        await _saveAuthState(
          userData.accountId!,
          true,
        ); // Save login state with accountId
        return userData;
      } else {
        throw Exception(
          'Registration failed: Username might be taken, try again!',
        );
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  static Future<User> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$authEndpoint/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'AccountUsername': username,
          'AccountPassword': password,
        }),
      );
      print(
        'Login URL: $baseUrl$authEndpoint/login, Body: ${json.encode({'AccountUsername': username, 'AccountPassword': password})}, Status: ${response.statusCode}, Response: ${response.body}',
      );
      if (response.statusCode == 200) {
        final userData = User.fromJson(json.decode(response.body));
        await _saveAuthState(
          userData.accountId!,
          true,
          role: userData.accountRole,
        ); // Save role
        return userData;
      } else {
        throw Exception('Login failed: Invalid credentials');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  static Future<void> logout(BuildContext context) async {
    try {
      await _saveAuthState(null, false); // Clear auth state
      print('Logout triggered, isLoggedIn set to false');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Helper method to save/load auth state
  static Future<void> _saveAuthState(
    int? accountId,
    bool isLoggedIn, {
    String? role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (isLoggedIn && accountId != null) {
      await prefs.setInt('accountId', accountId);
      await prefs.setBool('isLoggedIn', true);
      if (role != null) {
        await prefs.setString('userRole', role);
      }
    } else {
      await prefs.remove('accountId');
      await prefs.remove('isLoggedIn');
      await prefs.remove('userRole');
    }
  }

  static Future<bool> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<int?> getCurrentAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('accountId');
  }

  // Existing profile methods (unchanged but updated to use dynamic accountId)
  static Future<User> getProfile(int accountId) async {
    final url = Uri.parse('$baseUrl$authEndpoint/profile/$accountId');
    final response = await http.get(url);
    print(
      'Get Profile URL: $url, Status: ${response.statusCode}, Response: ${response.body}',
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load profile: Status ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  static Future<User> updateProfile(int accountId, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl$authEndpoint/profile/$accountId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'AccountUsername': user.accountUsername,
        'PhoneNumber': user.phoneNumber,
        'Address': user.address,
      }),
    );
    print(
      'Update Profile URL: $baseUrl$authEndpoint/profile/$accountId, Body: ${json.encode({'AccountUsername': user.accountUsername, 'PhoneNumber': user.phoneNumber, 'Address': user.address})}, Status: ${response.statusCode}, Response: ${response.body}',
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update profile: Try again later!');
    }
  }
}
