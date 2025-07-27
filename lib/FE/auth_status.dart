import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/services/api_service.dart';

class AuthStatus {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<int?> getCurrentAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('accountId');
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userRole',
    ); // Returns "admin" or "user", or null if not set
  }

  static Future<void> clearAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('accountId');
    await prefs.remove('userRole');
  }

  static Future<void> setUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  static Future<void> setUserLoggedIn(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', loggedIn);
  }

  static Future<void> setAccountId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountId', id);
  }
}
