
import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _isLoading = false;

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: usernameController,
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          try {
                            final user = await ApiService.login(
                              usernameController.text.trim(),
                              passController.text.trim(),
                            );
                            Navigator.pushNamed(context, '/');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
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
      ),
    );
  }
}
