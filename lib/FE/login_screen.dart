import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

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
            buildInputField(Icons.person, "Username", userController),
            buildInputField(Icons.lock, "Password", passController, obscure: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                isLoggedIn = true; // giả lập đăng nhập thành công
                Navigator.pushNamed(context, '/'); // về menu
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

  Widget buildInputField(IconData icon, String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
