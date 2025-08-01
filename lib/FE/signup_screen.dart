import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'package:fe_mobile_flutter/FE/models1/account.dart';
import 'package:fe_mobile_flutter/FE/services/account_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

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
  final AccountService _accountService = AccountService();

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final account = await _accountService.register(
          usernameController.text.trim(),
          passwordController.text.trim(),
        );
        if (account != null) {
          // Update profile with phone and address if provided
          if (phoneController.text.isNotEmpty || addressController.text.isNotEmpty) {
            final updatedAccount = TblAccount(
              accountId: account.accountId,
              accountUsername: account.accountUsername,
              accountPassword: '',
              accountRole: account.accountRole,
              phoneNumber: phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
              address: addressController.text.trim().isNotEmpty ? addressController.text.trim() : null,
            );
            await _accountService.updateProfile(account.accountId, updatedAccount);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration successful! Please log in.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        } else {
          throw Exception('Registration failed');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ),
      drawer: Drawer(
        child: FutureBuilder<bool>(
          future: AuthStatus.checkIsLoggedIn(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!) {
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.red),
                    title: Text('Home'),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.login, color: Colors.red),
                    title: Text('Log In'),
                    onTap: () => Navigator.pushNamed(context, '/login'),
                  ),
                ],
              );
            }
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.redAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.red),
                  title: Text('Home'),
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart, color: Colors.red),
                  title: Text('Cart'),
                  onTap: () => Navigator.pushNamed(context, '/cart'),
                ),
                ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red),
                  title: Text('Favorites'),
                  onTap: () => Navigator.pushNamed(context, '/favorites'),
                ),
                ListTile(
                  leading: Icon(Icons.history, color: Colors.red),
                  title: Text('Order History'),
                  onTap: () => Navigator.pushNamed(context, '/orderHistory'),
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.red),
                  title: Text('Settings'),
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
                ListTile(
                  leading: Icon(Icons.contact_support, color: Colors.red),
                  title: Text('Contact Us'),
                  onTap: () => Navigator.pushNamed(context, '/contact'),
                ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(Icons.star, color: Colors.red, size: 80),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  buildInputField(
                    Icons.person,
                    'Username',
                    usernameController,
                    validator: (value) =>
                        value!.isEmpty ? 'Username is required' : null,
                  ),
                  buildInputField(
                    Icons.home,
                    'Address (Optional)',
                    addressController,
                  ),
                  buildInputField(
                    Icons.phone,
                    'Phone Number',
                    phoneController,
                    validator: (value) =>
                        value!.isEmpty ? 'Phone is required' : null,
                  ),
                  buildInputField(
                    Icons.lock,
                    'Password',
                    passwordController,
                    obscure: true,
                    validator: (value) => value!.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _handleSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(200, 48),
                            ),
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'By signing up, you agree to our\nTerms and Conditions of Use',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Already have an account? Log In',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // No specific tab selected for signup
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) async {
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          } else if (index == 1) {
            Navigator.pushNamed(context, '/cart');
          } else if (index == 2) {
            print('Like tapped');
          } else if (index == 3) {
            bool loggedIn = await AuthStatus.checkIsLoggedIn();
            Navigator.pushNamed(context, loggedIn ? '/userProfile' : '/login');
          }
        },
      ),
    );
  }

  Widget buildInputField(
    IconData icon,
    String label,
    TextEditingController controller, {
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.red),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        validator: validator,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}