import 'package:flutter/material.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    final String foodName = "Spaghetti + Meat + Tomato Sauce";
    final double price = 5.99;

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart"), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              leading: Image.network('https://via.placeholder.com/50'), //check
              title: Text(foodName),
              subtitle: Text("\$$price"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
                  Text("1"),
                  IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Total: \$$price",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text("Continue shop"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/checkout',
                      arguments: {
                        'userName':
                            'Quan', // example name, replace with actual user data
                        'phoneNumber': '+84 123456789', // example phone
                        'address': 'No.1 Lmain Street', // example address
                        'cartItems': [
                          {
                            'shop': 'Pizza Shop',
                            'name': 'Spaghetti',
                            'ingredients': 'Spaghetti + Meat + Tomato Sauce',
                            'price': 5.99,
                            'quantity': 1,
                            'image': 'https://via.placeholder.com/50',
                          },
                        ],
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Buy"),
                ),
              ],
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
          if (index == 1) print('Cart tapped');
          if (index == 2) print('Like tapped');
          if (index == 3)
            Navigator.pushNamed(context, '/login'); // Account → Login
        },
      ),
    );
  }
}
