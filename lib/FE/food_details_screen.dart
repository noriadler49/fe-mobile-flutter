import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/services/dish_service.dart';
import 'package:fe_mobile_flutter/FE/models1/dish_dto.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fe_mobile_flutter/FE/services/cart_item_service.dart';
import 'package:fe_mobile_flutter/FE/models1/cartitem.dart';

class FoodDetailsScreen extends StatefulWidget {
  final int dishId;
  final String? image;

  const FoodDetailsScreen({Key? key, required this.dishId, this.image})
    : super(key: key);

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  final CartItemService _cartService = CartItemService();
  int _quantity = 1;
  DishDto? _dish;
  bool _isLoading = true;
  bool _isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchDishDetail();
  }

  Future<void> _fetchDishDetail() async {
    try {
      final dish = await DishService().fetchDishById(widget.dishId);
      setState(() {
        _dish = dish;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching dish: $e');
    }
  }

  Future<bool> checkIsLoggedIn() async {
    final accountId = await AuthStatus.getCurrentAccountId();
    return accountId != null;
  }

  Future<void> _addToCart() async {
    if (_quantity < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Quantity must be at least 1"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final accountId = prefs.getInt('accountId');

    if (accountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please login to add to cart"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await _cartService.addToCart(
      dishId: widget.dishId,
      quantity: _quantity,
      accountId: accountId,
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added to cart successfully"),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800), // ngắn thôi
        ),
      );

      await Future.delayed(
        Duration(milliseconds: 300),
      ); // chờ snack hiển thị xíu
      try {
        Navigator.pushNamed(context, '/cart');
      } catch (e) {
        print("Navigation error: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add to cart"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // HEADER
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
                        IconButton(
                          icon: Icon(Icons.menu, color: Colors.white, size: 20),
                          onPressed: () {
                            print('Menu tapped');
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

                    // CONTENT
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/${_dish?.dishImageUrl ?? widget.image ?? 'default.png'}',
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            _dish?.dishName ?? 'Dish Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\$${_dish?.dishPrice?.toStringAsFixed(2) ?? '0.00'}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Description: ${_dish?.dishDescription ?? 'No description available.'}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Ingredients: ${_dish?.ingredientNames ?? 'Not specified.'}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _quantity > 1
                                    ? () => setState(() => _quantity--)
                                    : null,
                                icon: Icon(Icons.remove),
                              ),
                              Text(
                                '$_quantity',
                                style: TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _quantity++),
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _addToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(200, 48),
                            ),
                            child: Text("Add to Cart"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

      // BOTTOM NAVIGATION
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
