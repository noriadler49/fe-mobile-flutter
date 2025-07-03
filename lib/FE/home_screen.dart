import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> foods = [
    {"name": "Spaghetti", "price": "\$8", "image": "🍝"},
    {"name": "Burger", "price": "\$6", "image": "🍔"},
    {"name": "Pizza", "price": "\$9", "image": "🍕"},
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Welcome to Our FOS'),
        actions: [
          Icon(Icons.search),
          SizedBox(width: 10),
          Icon(Icons.menu),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Hungry? Then ready to Order",
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Feature List",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the FoodDetailsScreen when a card is tapped
                    Navigator.pushNamed(
                      context,
                      '/foodDetail',
                      arguments: {
                        'name': food['name']!, //  !  makes it String
                        'price': food['price']!,
                        'image': food['image']!,
                      },
                    );
                  },
                  child: Card(
                    child: Container(
                      width: 120,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(food["image"]!, style: TextStyle(fontSize: 30)),
                          Text(food["name"]!),
                          Text(food["price"]!),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.red),
              onPressed: () {
                Navigator.pushNamed(context, '/deals');
              },
            ),
          ),
        ],
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
          if (index == 0) return; // Home
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3)
            Navigator.pushNamed(context, '/login'); // Account → Login
        },
      ),
    );
  }
}
