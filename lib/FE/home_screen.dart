import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/fe/admin/admin_search_button.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userRole;
  List<Map<String, String>> foods = [
    {"name": "Spaghetti", "price": "\$8", "image": "assets/spaghetti.png"},
    {"name": "Burger", "price": "\$6", "image": "assets/burger.png"},
    {"name": "Pizza", "price": "\$9", "image": "assets/pizza.png"},
  ];
  List<Map<String, String>> allFoods = [];
  final PageController _pageController = PageController(viewportFraction: 0.85);
  bool _isSearchBarVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allFoods = List.from(foods);
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await AuthStatus.getUserRole();
    if (mounted) {
      setState(() {
        _userRole = role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                if (_userRole == 'admin')
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings, color: Colors.red),
                    title: Text('Admin Dashboard'),
                    onTap: () => Navigator.pushNamed(context, '/admin/dashboard'),
                  ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout'),
                  onTap: () async {
                    await AuthStatus.clearAuthState();
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Drawer toggle
              buildHeader(
                title: 'MENU',
                rightIcons: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ],
                isSearchBarVisible: _isSearchBarVisible,
                onSearchPressed: () {
                  setState(() {
                    _isSearchBarVisible = !_isSearchBarVisible;
                  });
                },
                searchHintText: 'Search menu...',
              ),
              // Welcome Box
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Welcome to Our FOS',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Hungry? Then ready to Order',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // Food Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Feature List",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 280,
                      child: PageView(
                        controller: _pageController,
                        physics: ClampingScrollPhysics(),
                        children: foods.map((food) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/foodDetail',
                                arguments: {
                                  'name': food['name']!,
                                  'price': food['price']!,
                                  'image': food['image']!,
                                },
                              );
                            },
                            child: _buildFoodItem(
                              context,
                              food['image']!,
                              food['name']!,
                              food['price']!.replaceAll('\$', ''),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.red),
                    onPressed: () {
                      Navigator.pushNamed(context, '/deals');
                    },
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
        currentIndex: 0, // Default to Home
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) async {
          if (index == 0) return;
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3) {
            final isLoggedIn = await AuthStatus.isLoggedIn();
            if (isLoggedIn) {
              final accountId = await AuthStatus.getCurrentAccountId();
              if (accountId != null) {
                Navigator.pushNamed(context, '/userProfile');
              } else {
                Navigator.pushNamed(context, '/login');
              }
            } else {
              Navigator.pushNamed(context, '/login');
            }
          }
        },
      ),
    );
  }

  Widget _buildFoodItem(
    BuildContext context,
    String imagePath,
    String title,
    String price,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$$price',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String title,
    required List<Widget> rightIcons,
    required bool isSearchBarVisible,
    required VoidCallback onSearchPressed,
    String? searchHintText,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: Icon(Icons.menu, color: Colors.white, size: 20),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white, size: 20),
                    onPressed: onSearchPressed,
                  ),
                ],
              ),
              Row(children: rightIcons),
            ],
          ),
          if (isSearchBarVisible) ...[
            SizedBox(height: 8),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                final query = value.toLowerCase();
                setState(() {
                  foods = allFoods.where((food) {
                    return food['name']!.toLowerCase().contains(query);
                  }).toList();
                });
              },
              decoration: InputDecoration(
                hintText: searchHintText ?? 'Search...',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}