import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'package:fe_mobile_flutter/models/user_model.dart';
import 'package:fe_mobile_flutter/services/api_service.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user;
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final accountId = await AuthStatus.getCurrentAccountId();
    if (accountId == null) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
      return;
    }
    setState(() => _isLoading = true);
    try {
      user = await ApiService.getProfile(accountId);
      if (user != null) {
        phoneController.text = user!.phoneNumber ?? '';
        addressController.text = user!.address ?? '';
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e'), backgroundColor: Colors.red),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (user == null) {
      return Container(); // Will redirect to login in _loadProfile
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: FutureBuilder<bool>(
          future: AuthStatus.isLoggedIn(),
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
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
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
                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
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
                if (user?.accountRole == 'admin')
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings, color: Colors.red),
                    title: Text('Admin Dashboard'),
                    onTap: () => Navigator.pushNamed(context, '/admin/dashboard'),
                  ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.red, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'Username: ${user?.accountUsername}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.red, size: 24),
                          SizedBox(width: 12),
                          Flexible(
                            child: TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.red, size: 24),
                          SizedBox(width: 12),
                          Flexible(
                            child: TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                hintText: 'Address',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (phoneController.text.isNotEmpty || addressController.text.isNotEmpty) {
                      setState(() => _isLoading = true);
                      try {
                        final updatedUser = User(
                          accountId: user!.accountId,
                          accountUsername: user!.accountUsername,
                          accountPassword: '', // Not updated
                          phoneNumber: phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
                          address: addressController.text.trim().isNotEmpty ? addressController.text.trim() : null,
                          accountRole: user!.accountRole, // Preserve role
                        );
                        user = await ApiService.updateProfile(user!.accountId!, updatedUser);
                        phoneController.text = user?.phoneNumber ?? '';
                        addressController.text = user?.address ?? '';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profile updated!'), backgroundColor: Colors.green),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating profile: $e'), backgroundColor: Colors.red),
                        );
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(200, 48),
                  ),
                  child: Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Logout'),
                        content: Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await ApiService.logout(context);
                            },
                            child: Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(200, 48),
                  ),
                  child: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Highlight Account tab
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3) Navigator.pushNamed(context, '/userProfile');
        },
      ),
    );
  }
}