import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'package:fe_mobile_flutter/FE/services/dish_service.dart';
import 'package:fe_mobile_flutter/FE/models1/dish.dart';
import 'package:fe_mobile_flutter/FE/models1/dish_dto.dart';

class FoodDealScreen extends StatefulWidget {
  FoodDealScreen({super.key});

  @override
  _FoodDealScreenState createState() => _FoodDealScreenState();
}

Future<bool> checkIsLoggedIn() async {
  final accountId = await AuthStatus.getCurrentAccountId();
  return accountId != null; // logged in if there's an ID saved
}

class _FoodDealScreenState extends State<FoodDealScreen> {
  List<DishDto> foods = [];
  List<DishDto> allFoods = [];
  bool _isSearchBarVisible = false;
  @override
  void initState() {
    super.initState();
    loadDishes();
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
      print("Error loading food deals: $e");
    }
  }

  Widget _buildFoodImage(String? imagePath) {
    if (imagePath != null && imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: MediaQuery.of(context).size.width * 0.85,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 200,
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
      return Image.asset(
        'assets/$imagePath',
        width: MediaQuery.of(context).size.width * 0.85,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          );
        },
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 200,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header using the template from main.dart
            buildHeader(
              title: 'MENU',
              rightIcons: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 23,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
                SizedBox(width: 4),
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.white, size: 23),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                SizedBox(width: 4),
              ],
              isSearchBarVisible: _isSearchBarVisible,
              onSearchPressed: () {
                setState(() {
                  _isSearchBarVisible = !_isSearchBarVisible;
                });
              },
              searchHintText: 'Search menu...',
            ),
            // Food Deals Section
            Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/foodDetail',
                        arguments: {
                          'dishId': food.dishId,
                          'image':
                              food.dishImageUrl ??
                              '', // (tùy chọn nếu muốn dùng ảnh trước khi load xong)
                        },
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8.0,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: _buildFoodImage(food.dishImageUrl),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  food.dishName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '\$${food.dishPrice?.toString() ?? ''}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Description: ${food.dishDescription ?? 'N/A'}",
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/foodDetail',
                                      arguments: {
                                        'dishId': food.dishId,
                                        'image':
                                            food.dishImageUrl ??
                                            '', // (tùy chọn nếu muốn dùng ảnh trước khi load xong)
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text("Buy now"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3) {
            if (await checkIsLoggedIn()) {
              Navigator.pushNamed(context, '/userProfile');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          }
        },
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
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
              Navigator.pushNamed(context, '');
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
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
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
