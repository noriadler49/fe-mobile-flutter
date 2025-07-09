import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: AdminAddDishScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AdminAddDishScreen extends StatefulWidget {
  const AdminAddDishScreen({super.key});

  @override
  _AdminAddDishScreenState createState() => _AdminAddDishScreenState();
}

class _AdminAddDishScreenState extends State<AdminAddDishScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imgUrlController = TextEditingController();
  final List<Map<String, String>> dishes = [
    {"id": "1", "name": "Dish 1", "image": "/assets/burger.jpg"},
    {"id": "2", "name": "Dish 2", "image": "/assets/burger.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simplified header without search toggle
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.redAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Dish',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.menu, color: Colors.white, size: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name:'),
                  ),
                  TextField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price:'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _imgUrlController,
                    decoration: InputDecoration(labelText: 'IMGURL:'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {}, // Empty function, button does nothing
                    child: Text('Add'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dish Available:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        children: [
                          Padding(padding: EdgeInsets.all(8.0), child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8.0), child: Text("Dish's Name", style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      ...dishes.map((dish) => TableRow(
                        children: [
                          Padding(padding: EdgeInsets.all(8.0), child: Text(dish['id']!)),
                          Padding(padding: EdgeInsets.all(8.0), child: Text(dish['name']!)),
                          Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.edit)),
                        ],
                      )).toList(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/home');
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3) Navigator.pushNamed(context, '/login');
        },
      ),
    );
  }
}