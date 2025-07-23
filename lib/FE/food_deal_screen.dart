import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class FoodDealScreen extends StatefulWidget {
  FoodDealScreen({super.key});

  @override
  _FoodDealScreenState createState() => _FoodDealScreenState();
}

class _FoodDealScreenState extends State<FoodDealScreen> {
  final List<Map<String, String>> foodDeals = [
    {"title": "From A", "image": "assets/spaghetti.png", "price": "\$8"},
    {"title": "From B", "image": "assets/burger.png", "price": "\$6"},
    {"title": "From C", "image": "assets/pizza.png", "price": "\$9"},
  ];
  bool _isSearchBarVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header using the template from main.dart
            buildHeader(
              title: 'MENU',
              rightIcons: [
                Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                SizedBox(width: 4),
                Icon(Icons.menu, color: Colors.white, size: 20),
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
                itemCount: foodDeals.length,
                itemBuilder: (context, index) {
                  final food = foodDeals[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/foodDetail',
                        arguments: {
                          'name': food['title']!,
                          'price': food['price']!,
                          'image': food['image']!,
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
                            child: Image.asset(
                              food['image']!,
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  food['title']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  food['price']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text("Ingredients: etc."),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/foodDetail',
                                      arguments: {
                                        'name': food['title']!,
                                        'price': food['price']!,
                                        'image': food['image']!,
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/'); // Home
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
<<<<<<< HEAD
          if (index == 3) {
=======
                    if (index == 3) {
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
            if (isLoggedIn) {
              Navigator.pushNamed(context, '/userProfile');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          }
<<<<<<< HEAD
          ; // Account → Login
=======
>>>>>>> c76f56cfac719ef30c420db6b7b2b482a0fd8ddb
        },
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
