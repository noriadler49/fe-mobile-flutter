import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Icon(Icons.star, color: Colors.red, size: 80),
              SizedBox(height: 30),
              buildInputField(Icons.person, "Full Name", nameController),
              buildInputField(Icons.home, "Address", addressController),
              buildInputField(Icons.phone, "Phone Number", phoneController),
              buildInputField(Icons.lock, "Password", passwordController, obscure: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.zero,
                  // ),
                ),
                child: Text("Create an account"),
              ),
              SizedBox(height: 10),
              Text(
                "By signing up, you agree to our\nTerms and Conditions of Use",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Already have an account? Log In"),
              )
            ],
          ),
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
