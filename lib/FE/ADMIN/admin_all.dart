import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: AllOrdersScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  final _fromController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simplified header
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
                    'Tất cả đơn hàng',
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _fromController,
                          decoration: InputDecoration(labelText: 'From:'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _dateController,
                          decoration: InputDecoration(labelText: 'Date'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('PDF'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
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
                    "Danh sách đơn hàng:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      TableRow(
                        children: [
                          Padding(padding: EdgeInsets.all(8.0), child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8.0), child: Text("Tên hàng", style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('From', style: TextStyle(fontWeight: FontWeight.bold))),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(padding: EdgeInsets.all(8.0), child: Text('1')),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('Pizza...')),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('AB')),
                          Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.edit)),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(padding: EdgeInsets.all(8.0), child: Text('2')),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('etc')),
                          Padding(padding: EdgeInsets.all(8.0), child: Text('el')),
                          Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.edit)),
                        ],
                      ),
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