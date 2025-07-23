import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded user data, matching signup_screen.dart and my_cart.dart
    const String userName = 'Quan';
    const String address = 'No.1 Lmain Street';
    const String phoneNumber = '+84 123456789';

    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
=======
        title: const Text('User Profile', style: TextStyle(color: Colors.white)),
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.redAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.red),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.red),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.red),
              title: const Text('Order History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/orderHistory');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.red),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support, color: Colors.red),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
            ),
            if (isLoggedIn)
              ListTile(
<<<<<<< HEAD
                leading: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.red,
                ),
=======
                leading: const Icon(Icons.admin_panel_settings, color: Colors.red),
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
                title: const Text('Admin Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin/dashboard');
                },
              ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16),
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
                          const Icon(Icons.person, color: Colors.red, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Name: $userName',
<<<<<<< HEAD
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
=======
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.home, color: Colors.red, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Address: $address',
<<<<<<< HEAD
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
=======
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.red, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Phone: $phoneNumber',
<<<<<<< HEAD
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
=======
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    isLoggedIn = false; // Simulate logout
<<<<<<< HEAD
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
=======
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(200, 48),
                  ),
                  child: const Text(
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
<<<<<<< HEAD
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
=======
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
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
<<<<<<< HEAD
}
=======
}
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
