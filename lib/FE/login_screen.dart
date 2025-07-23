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
            TextField(
              controller: userController,
              decoration: InputDecoration(labelText: "Account ID"),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = userController.text.trim();
                String password = passController.text.trim();
                // isLoggedIn = true; // giả lập đăng nhập thành công
                // Navigator.pushNamed(context, '/cart'); // về giỏ hàng
                String? route = checkLogin(username, password);

                if (route != null) {
                  Navigator.pushNamed(context, route);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Invalid username or password"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text("Login"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
