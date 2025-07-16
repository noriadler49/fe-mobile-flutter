import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';


void main() {
  runApp(MyOrderApp());
}

class MyOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: OrderPage());
  }
}

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // number of tabs
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Đơn hàng', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Đang đến'),
              Tab(text: 'Deal hôm qua'),
              Tab(text: 'Lịch sử'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Đang đến
            ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/orderDetails',
                      arguments: {
                        'orderId': 'abcxyz1',
                        'date': '2025-07-16',
                        'items': [
                          {
                            'name': 'Pizza 4P\'s',
                            'price': 5.99,
                            'quantity': 1,
                            'image': 'assets/pizza.png',
                            'ingredients': 'Pizza Crust + Meat + Tomato Sauce',
                          },
                        ],
                        'address': 'No.1 Lmain Street',
                        'status': 'Ordered',
                      },
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(16.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/pizza.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pizza 4P\'s',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Pizza Crust + Meat + Toma...',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      '\$5.99',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (!isLoggedIn) {
                                  Navigator.pushNamed(context, '/login');
                                } else {
                                  Navigator.pushNamed(context, '/cart', arguments: {
                                    'cartItems': [
                                      {
                                        'name': 'Pizza 4P\'s',
                                        'price': 5.99,
                                        'quantity': 1,
                                        'image': 'assets/pizza.png',
                                        'ingredients': 'Pizza Crust + Meat + Tomato Sauce',
                                      },
                                    ],
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text('Buy again'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('etc.')),
                  ),
                ),
              ],
            ),
            // Tab 2: Deal hôm qua
            ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/orderDetails',
                      arguments: {
                        'orderId': 'abcxyz2',
                        'date': '2025-07-15',
                        'items': [
                          {
                            'name': 'Pizza 4P\'s',
                            'price': 5.99,
                            'quantity': 1,
                            'image': 'assets/pizza.png',
                            'ingredients': 'Pizza Crust + Meat + Tomato Sauce',
                          },
                        ],
                        'address': 'No.2 Example St.',
                        'status': 'Delivered',
                      },
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(16.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/pizza.png',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pizza 4P\'s',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Pizza Crust + Meat + Toma...',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      '\$5.99',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (!isLoggedIn) {
                                  Navigator.pushNamed(context, '/login');
                                } else {
                                  Navigator.pushNamed(context, '/cart', arguments: {
                                    'cartItems': [
                                      {
                                        'name': 'Pizza 4P\'s',
                                        'price': 5.99,
                                        'quantity': 1,
                                        'image': 'assets/pizza.png',
                                        'ingredients': 'Pizza Crust + Meat + Tomato Sauce',
                                      },
                                    ],
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text('Buy again'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('etc.')),
                  ),
                ),
              ],
            ),
            // Tab 3: Lịch sử
            Center(
              child: Text('You no buy shit, go buy something'),
            ),
          ],
        ),
      ),
    );
  }
}