import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/services/account_service.dart';
import 'package:fe_mobile_flutter/FE/models1/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final AccountService _accountService = AccountService();
  bool _isLoading = false;

  void _showTopNotification(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(8),
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Future<void> _handleLogin() async {
    String username = userController.text.trim();
    String password = passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter both username and password"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      TblAccount? account = await _accountService.login(username, password);

      if (account != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('accountId', account.accountId);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userRole', account.accountRole ?? 'user');

        // Format role và username
        String roleFirstWord = (account.accountRole ?? 'user').split(' ').first;
        String usernameFirstWord = account.accountUsername.split(' ').first;

        String formattedRole =
            roleFirstWord[0].toUpperCase() +
            roleFirstWord.substring(1).toLowerCase();
        String formattedUsername =
            usernameFirstWord[0].toUpperCase() +
            usernameFirstWord.substring(1).toLowerCase();

        // ✅ Show top notification
        _showTopNotification(
          context,
          "Welcome, $formattedRole $formattedUsername",
        );

        await Future.delayed(const Duration(milliseconds: 1000));

        if (account.accountRole == 'admin') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/admin/dashboard',
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid username or password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: userController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text("Login"),
                  ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text("Register?"),
            ),
          ],
        ),
      ),
    );
  }
}
