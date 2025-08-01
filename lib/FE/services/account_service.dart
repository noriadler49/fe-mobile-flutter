import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/FE/models1/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AccountService {
  final String baseUrl = "http://10.0.2.2:5065/api/accounts";

  Future<TblAccount?> register(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'accountUsername': username,
              'accountPassword': password,
            }),
          )
          .timeout(Duration(seconds: 10));
      print('Register: Status ${response.statusCode}, Body ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TblAccount.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Registration failed: Username might be taken');
      }
    } catch (e) {
      print('Register error: $e');
      throw Exception(
        'Registration error: ${e.toString().contains('Timeout') ? 'Timeout, check network' : e}',
      );
    }
  }

  Future<TblAccount?> getAccountById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'), // giả sử endpoint này
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TblAccount.fromJson(data);
    } else {
      return null;
    }
  }

  Future<TblAccount?> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'accountUsername': username,
              'accountPassword': password,
            }),
          )
          .timeout(Duration(seconds: 10));
      print('Login: Status ${response.statusCode}, Body ${response.body}');
      if (response.statusCode == 200) {
        final account = TblAccount.fromJson(jsonDecode(response.body));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('accountId', account.accountId);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userRole', account.accountRole ?? 'user');
        return account;
      } else {
        throw Exception('Login failed: Invalid credentials');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception(
        'Login error: ${e.toString().contains('Timeout') ? 'Timeout, check network' : e}',
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all preferences for safety
      print('Logout: Cleared all SharedPreferences');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Logout error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<TblAccount?> getProfile(int accountId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/$accountId'),
          ) // Changed from /profile/$accountId
          .timeout(Duration(seconds: 10));
      print(
        'Get Profile: Status ${response.statusCode}, Body ${response.body}',
      );
      if (response.statusCode == 200) {
        return TblAccount.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load profile: ${response.body}');
      }
    } catch (e) {
      print('Get Profile error: $e');
      throw Exception(
        'Profile load error: ${e.toString().contains('Timeout') ? 'Timeout, check network' : e}',
      );
    }
  }

  Future<TblAccount?> updateProfile(int accountId, TblAccount user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update-info'), // ✅ đúng endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accountId': accountId,
          'accountUsername': user.accountUsername,
          'phoneNumber': user.phoneNumber,
          'address': user.address,
        }),
      );
      print('Update Profile: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return user;
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('Update Profile error: $e');
      throw Exception('Update profile error: $e');
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

  Future<bool> updateAccountInfo(
    int accountId,
    String username,
    String phone,
    String address,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update-info'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accountId': accountId,
          'accountUsername': username,
          'phoneNumber': phone,
          'address': address,
        }),
      );

      print("Update Info: ${response.statusCode} - ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Update info error: $e");
      return false;
    }
  }

  Future<bool> updatePassword(
    int accountId,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update-password/$accountId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      print("Update Password: ${response.statusCode} - ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("Update password error: $e");
      return false;
    }
  }
}
