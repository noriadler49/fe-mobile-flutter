import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/FE/models1/account.dart';

class AccountService {
  final String baseUrl = "http://10.0.2.2:5065/api/accounts";

  // Register
  Future<TblAccount?> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'accountUsername': username,
        'accountPassword': password,
      }),
    );

    if (response.statusCode == 201) {
      return TblAccount.fromJson(jsonDecode(response.body));
    } else {
      print("Registration failed: ${response.body}");
      return null;
    }
  }

  // Login
  Future<TblAccount?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'accountUsername': username,
        'accountPassword': password,
      }),
    );

    if (response.statusCode == 200) {
      return TblAccount.fromJson(jsonDecode(response.body));
    } else {
      print("Login failed: ${response.body}");
      return null;
    }
  }

  // Get Account by ID
  Future<TblAccount?> getAccount(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return TblAccount.fromJson(jsonDecode(response.body));
    } else {
      print("Get account failed: ${response.body}");
      return null;
    }
  }

  // Get all accounts (admin use case)
  Future<List<TblAccount>> getAllAccounts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TblAccount.fromJson(json)).toList();
    } else {
      print("Failed to fetch accounts: ${response.body}");
      return [];
    }
  }
}
