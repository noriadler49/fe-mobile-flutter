import 'package:flutter/material.dart';
import 'auth_status.dart'; // If you need to check isLoggedIn

class FoodDetailsScreen extends StatelessWidget {
  final String name;
  final String price;
  final String image;

  FoodDetailsScreen({
    required this.name,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Detail"), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              image,
              style: TextStyle(fontSize: 100),
            ), // You can replace with image.network if using image URLs
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Price: $price",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            SizedBox(height: 10),
            Text("Ingredients: etc."),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (!isLoggedIn) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.pushNamed(context, '/cart');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Add to Cart"),
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
          if (index == 0) Navigator.pushNamed(context, '/');
        },
      ),
    );
  }
}
