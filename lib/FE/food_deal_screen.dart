import 'package:flutter/material.dart';


class FoodDealScreen extends StatelessWidget {
  final List<Map<String, String>> foodDeals = [
    {"title": "From A", "image": "🍝", "price": "\$8"},
    {"title": "From B", "image": "🍔", "price": "\$6"},
    {"title": "From C", "image": "🍕", "price": "\$9"},
  ];

  FoodDealScreen({super.key}); // ❌ Không dùng const /dùng data demo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food Deal"), backgroundColor: Colors.red),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: foodDeals.length,
          itemBuilder: (context, index) {
            final food = foodDeals[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Text(food["image"]!, style: TextStyle(fontSize: 40)),
                title: Text(food["title"]!),
                subtitle: Text("Ingredients: etc."),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(food["price"]!),
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
            );
          },
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
          if (index == 0) Navigator.pop(context);
        },
      ),
    );
  }
}
