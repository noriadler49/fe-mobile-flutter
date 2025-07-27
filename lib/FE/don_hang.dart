// import 'package:flutter/material.dart';
// import 'package:fe_mobile_flutter/FE/auth_status.dart';

// void main() {
//   runApp(MyOrderApp());
// }

// class MyOrderApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: OrderPage());
//   }
// }

// class OrderPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3, // number of tabs
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text('Đơn hàng', style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.red,
//           actions: [
//             Builder(
//               builder: (BuildContext context) {
//                 return IconButton(
//                   icon: Icon(Icons.menu, color: Colors.white),
//                   onPressed: () {
//                     Scaffold.of(context).openDrawer();
//                   },
//                 );
//               },
//             ),
//           ],
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Đang đến'),
//               Tab(text: 'Deal hôm qua'),
//               Tab(text: 'Lịch sử'),
//             ],
//             indicatorColor: Colors.white,
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.white70,
//           ),
//         ),
//         drawer: Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.red, Colors.redAccent],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Text(
//                   'Menu',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.home, color: Colors.red),
//                 title: Text('Home'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/');
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.shopping_cart, color: Colors.red),
//                 title: Text('Cart'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/cart');
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.favorite, color: Colors.red),
//                 title: Text('Favorites'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/favorites');
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.person, color: Colors.red),
//                 title: Text('Account'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   Navigator.pushNamed(context, '/login');
//                 },
//               ),
//               if (isLoggedIn) ...[
//                 ListTile(
//                   leading: Icon(Icons.list_alt, color: Colors.red),
//                   title: Text('All Orders'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context, '/admin/orders');
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.add_circle, color: Colors.red),
//                   title: Text('Add Dish'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context, '/admin/add');
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.kitchen, color: Colors.red),
//                   title: Text('Manage Ingredients'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context, '/admin/ingredients');
//                   },
//                 ),
//               ],
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // Tab 1: Đang đến
//             ListView(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(
//                       context,
//                       '/orderDetails',
//                       arguments: {
//                         'orderId': 'abcxyz1',
//                         'date': '2025-07-16',
//                         'items': [
//                           {
//                             'name': 'Pizza 4P\'s',
//                             'price': 5.99,
//                             'quantity': 1,
//                             'image': 'assets/pizza.png',
//                             'ingredients': 'Pizza Crust + Meat + Tomato Sauce',
//                           },
//                         ],
//                         'address': 'No.1 Lmain Street',
//                         'status': 'Ordered',
//                       },
//                     );
//                   },
//                   child: Card(
//                     margin: EdgeInsets.all(16.0),
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 child: Image.asset(
//                                   'assets/pizza.png',
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(width: 16.0),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Pizza 4P\'s',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Pizza Crust + Meat + Toma...',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     Text(
//                                       '\$5.99',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16.0),
//                           Center(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (!isLoggedIn) {
//                                   Navigator.pushNamed(context, '/login');
//                                 } else {
//                                   Navigator.pushNamed(context, '/cart', arguments: {
//                                     'cartItems': [
//                                       {
//                                         'name': 'Pizza 4P\'s',
//                                         'price': 5.99,
//                                         'quantity': 1,
//                                         'image': 'assets/pizza.png',
//                                         'ingredients': 'Pizza Crust + Meat + Tomato Sauce',
//                                       },
//                                     ],
//                                   });
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               ),
//                               child: Text('Buy again'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   margin: EdgeInsets.all(16.0),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Center(child: Text('etc.')),
//                   ),
//                 ),
//               ],
//             ),
//             // Tab 2: Deal hôm qua
//             ListView(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(
//                       context,
//                       '/orderDetails',
//                       arguments: {
//                         'orderId': 'abcxyz2',
//                         'date': '2025-07-15',
//                         'items': [
//                           {
//                             'name': 'Pizza 4P\'s',
//                             'price': 5.99,
//                             'quantity': 1,
//                             'image': 'assets/pizza.png',
//                             'ingredients': 'Pizza Crust + Meat + Tomato Sauce',
//                           },
//                         ],
//                         'address': 'No.2 Example St.',
//                         'status': 'Delivered',
//                       },
//                     );
//                   },
//                   child: Card(
//                     margin: EdgeInsets.all(16.0),
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 child: Image.asset(
//                                   'assets/pizza.png',
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(width: 16.0),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Pizza 4P\'s',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       'Pizza Crust + Meat + Toma...',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     Text(
//                                       '\$5.99',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 16.0),
//                           Center(
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (!isLoggedIn) {
//                                   Navigator.pushNamed(context, '/login');
//                                 } else {
//                                   Navigator.pushNamed(context, '/cart', arguments: {
//                                     'cartItems': [
//                                       {
//                                         'name': 'Pizza 4P\'s',
//                                         'price': 5.99,
//                                         'quantity': 1,
//                                         'image': 'assets/pizza.png',
//                                         'ingredients': 'Pizza Crust + Meat + Tomato Sauce',
//                                       },
//                                     ],
//                                   });
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                               ),
//                               child: Text('Buy again'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Card(
//                   margin: EdgeInsets.all(16.0),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Center(child: Text('etc.')),
//                   ),
//                 ),
//               ],
//             ),
//             // Tab 3: Lịch sử
//             Center(
//               child: Text('You no buy shit, go buy something'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }