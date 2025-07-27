
import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/models/user_model.dart';
import 'package:fe_mobile_flutter/services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Icon(Icons.star, color: Colors.red, size: 80),
                SizedBox(height: 30),
                buildInputField(Icons.person, "Username", usernameController,
                    validator: (value) => value!.isEmpty ? 'Username is required' : null),
                buildInputField(Icons.home, "Address", addressController),
                buildInputField(Icons.phone, "Phone Number", phoneController,
                    validator: (value) => value!.isEmpty ? 'Phone is required' : null),
                buildInputField(Icons.lock, "Password", passwordController, obscure: true,
                    validator: (value) => value!.length < 6 ? 'Password must be at least 6 chars' : null),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            try {
                              final user = User(
                                accountUsername: usernameController.text.trim(),
                                accountPassword: passwordController.text.trim(),
                                phoneNumber: phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
                                address: addressController.text.trim().isNotEmpty ? addressController.text.trim() : null,
                              );
                              await ApiService.register(user);
                              Navigator.pushNamed(context, '/login');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
      ),
    );
  }

  Widget buildInputField(IconData icon, String label, TextEditingController controller,
      {bool obscure = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }
}
