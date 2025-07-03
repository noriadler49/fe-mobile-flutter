import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class FoodDealDetails extends StatelessWidget {
  final String foodName = "Spaghetti + Meat + Tomato Sauce";
  final double price = 5.99;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Detail"), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Image.network(
              'https://via.placeholder.com/150',
            ), // Thay bằng ảnh thực nếu cần
            SizedBox(height: 10),
            Text("\$$price", style: TextStyle(fontSize: 24, color: Colors.red)),
            Text(foodName, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("From A to Customer's Address"),
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
