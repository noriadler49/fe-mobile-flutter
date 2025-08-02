import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/FE/models1/ingredient.dart';

class IngredientService {
  final String baseUrl = "http://10.0.2.2:5065/api/admin/ingredient";

  Future<List<TblIngredient>> getIngredients({String? query}) async {
    final url = query != null && query.isNotEmpty
        ? Uri.parse('$baseUrl?query=$query')
        : Uri.parse(baseUrl);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => TblIngredient.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load ingredients");
    }
  }

  Future<TblIngredient> createIngredient(String name) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ingredientName': name}),
    );

    if (response.statusCode == 201) {
      return TblIngredient.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create ingredient');
    }
  }

  Future<void> deleteIngredient(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        // Thành công
        print('Xóa thành công');
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Xóa thất bại');
      }
    } catch (e) {
      print('Lỗi khi xóa: $e');
      rethrow; // hoặc truyền thông báo lỗi ra ngoài UI
    }
  }

  Future<void> updateIngredient(TblIngredient ingredient) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${ingredient.ingredientId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(ingredient.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update ingredient');
    }
  }
}
