import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final String foodName = "Spaghetti + Meat + Tomato Sauce";
  final double price = 5.99;
  int quantity = 1;

  Future<bool> checkIsLoggedIn() async {
    final accountId = await AuthStatus.getCurrentAccountId();
    return accountId != null; // logged in if there's an ID saved
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/spaghetti.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      foodName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "\$${price.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: _decrementQuantity,
                          icon: Icon(Icons.remove, color: Colors.red),
                        ),
                        Text("$quantity", style: TextStyle(fontSize: 16)),
                        IconButton(
                          onPressed: _incrementQuantity,
                          icon: Icon(Icons.add, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Total: \$${(price * quantity).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(150, 48),
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text(
                        "Continue shop",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/checkout',
                          arguments: {
                            'userName': 'Quan',
                            'phoneNumber': '+84 123456789',
                            'address': 'No.1 Lmain Street',
                            'cartItems': [
                              {
                                'shop': 'Pizza Shop',
                                'name': 'Spaghetti',
                                'ingredients':
                                    'Spaghetti + Meat + Tomato Sauce',
                                'price': 5.99,
                                'quantity': quantity,
                                'image': 'https://via.placeholder.com/50',
                              },
                            ],
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(150, 48),
                      ),
                      child: Text(
                        "Buy",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Color(0xFFB0BEC5),
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
            bool loggedIn = await AuthStatus.checkIsLoggedIn();
            if (loggedIn) {
              Navigator.pushNamed(context, '/userProfile');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          }
        },
      ),
    );
  }
}
