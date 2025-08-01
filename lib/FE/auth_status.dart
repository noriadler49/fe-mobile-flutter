import 'package:shared_preferences/shared_preferences.dart';

class AuthStatus {
  static Future<bool> checkIsLoggedIn() async {
    final accountId = await getCurrentAccountId();
    return accountId != null;
  }
  
  static Future<int?> getCurrentAccountId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('accountId');
    } catch (e) {
      print('Error getting accountId: $e');
      return null;
    }
  }

  static Future<void> clearAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accountId');
    await prefs.remove('isLoggedIn');
    await prefs.remove('userRole');
  }

  static Future<void> setUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }
}
