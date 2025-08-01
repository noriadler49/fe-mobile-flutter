import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/fe/admin/admin_search_button.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON parsing if needed

import 'package:fe_mobile_flutter/FE/services/dish_service.dart';
import 'package:fe_mobile_flutter/FE/models1/dish.dart';
import 'package:fe_mobile_flutter/FE/models1/dish_dto.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DishDto> foods = [];
  List<DishDto> allFoods = [];
  final PageController _pageController = PageController(viewportFraction: 0.85);
  bool _isSearchBarVisible = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isCheckingAuth = false;
  @override
  void initState() {
    super.initState();
    loadDishes(); // fetch real dish data
  }

  Future<void> loadDishes() async {
    try {
      final dishService = DishService();
      final dishList = await dishService.fetchAllDishes();
      setState(() {
        foods = dishList;
        allFoods = List.from(dishList);
      });
    } catch (e) {
      print('Error loading dishes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
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
              leading: Icon(Icons.restaurant_menu, color: Colors.red),
              title: Text('Menu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/deals');
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.red),
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.red),
              title: Text('Order History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/orderFollow');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.red),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/userProfile');
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_support, color: Colors.red),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/contact');
              },
            ),
          ],
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
                        children: foods.map((dish) {
                          return GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(
                              //   context,
                              //   '/foodDetail',
                              //   arguments:
                              //       // dish,
                              //       {
                              //         'name': dish.dishName,
                              //         'price': dish.dishPrice?.toString() ?? '',
                              //         'image':
                              //             dish.dishImageUrl ??
                              //             '', // You may need default image fallback
                              //         'description': dish.dishDescription ?? '',
                              //       },
                              // );
                              Navigator.pushNamed(
                                context,
                                '/foodDetail',
                                arguments: {
                                  'dishId': dish.dishId,
                                  'image':
                                      dish.dishImageUrl ??
                                      '', // (tùy chọn nếu muốn dùng ảnh trước khi load xong)
                                },
                              );
                            },
                            child: _buildFoodItem(
                              context,
                              dish.dishImageUrl, // truyền thẳng URL hoặc tên file
                              dish.dishName,
                              dish.dishPrice?.toString() ?? '',
                              dish.dishDescription ?? '',
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) async {
          if (index == 0) return;
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3) {
            setState(() => _isCheckingAuth = true);
            try {
              bool loggedIn = await AuthStatus.checkIsLoggedIn();
              print('Navigating: loggedIn = $loggedIn');
              if (loggedIn) {
                Navigator.pushNamed(context, '/userProfile');
              } else {
                Navigator.pushNamed(context, '/login');
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error checking auth: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            } finally {
              setState(() => _isCheckingAuth = false);
            }
          }
        },
      ),
    );
  }

  Widget _buildFoodItem(
    BuildContext context,
    String? imagePath,
    String title,
    String price,
    String description,
  ) {
    Widget imageWidget;

    if (imagePath != null && imagePath.startsWith('http')) {
      imageWidget = Image.network(
        imagePath,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 100,
            width: 100,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else if (imagePath != null && imagePath.isNotEmpty) {
      imageWidget = Image.asset(
        'assets/$imagePath',
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 100,
            width: 100,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          );
        },
      );
    } else {
      imageWidget = Container(
        height: 100,
        width: 100,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: imageWidget,
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
                  SizedBox(height: 6),
                  Text(
                    description.length > 60
                        ? '${description.substring(0, 60)}...'
                        : description,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
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
                  foods = allFoods.where((dish) {
                    return dish.dishName.toLowerCase().contains(query);
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
