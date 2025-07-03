import 'package:flutter/material.dart';

<<<<<<< HEAD
import 'package:fe_mobile/FE/auth_status.dart';

import 'FE/home_screen.dart';
import 'FE/food_deal_screen.dart';
import 'FE/food_deal_details.dart';
import 'FE/food_details_screen.dart'; // <- new
import 'FE/my_cart.dart';
import 'FE/signup_screen.dart';
import 'FE/login_screen.dart';

// bool isLoggedIn = false; // Temporary flag

=======
>>>>>>> fa09a65295c49b1edae43ba7d51002379a294e82
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOS Food App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/deals': (context) => FoodDealScreen(),
        '/details': (context) => FoodDealDetails(),

        '/cart': (context) => MyCart(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/foodDetail') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => FoodDetailsScreen(
              name: args['name']!,
              price: args['price']!,
              image: args['image']!,
            ),
          );
        }
        return null; // or you could return a 404 page
      },
    );
  }
}
// import 'package:flutter/material.dart';
// import 'FE/checkout_screen.dart';
// import 'FE/address_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Food Order App',
//       theme: ThemeData(primarySwatch: Colors.red),
//       home: CheckoutScreen(
//         userName: "Quan",
//         phoneNumber: "+84 123456789",
//         address: "No.1 Lmain Street",
//         cartItems: [
//           {
//             'shop': 'Pizza Shop',
//             'name': 'Pizza',
//             'ingredients': 'Tomato + Meat',
//             'price': 5.99,
//             'quantity': 1,
//             'image': 'https://cdn-icons-png.flaticon.com/512/1404/1404945.png',
//           },
//           {
//             'shop': 'Burger Place',
//             'name': 'Burger',
//             'ingredients': 'Vegetable + Meat + Sauce',
//             'price': 5.99,
//             'quantity': 1,
//             'image': 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
//           },
//         ],
//       ),
//       routes: {
//         '/address': (context) => AddressScreen(), // ✅ Add this
//       },
//     );
//   }
// }
=======
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  bool _isSearchBarVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Decorative Header with Search Bar
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'MENU',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.white, size: 20),
                          onPressed: () {
                            setState(() {
                              _isSearchBarVisible = !_isSearchBarVisible;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                        SizedBox(width: 4),
                        Icon(Icons.menu, color: Colors.white, size: 20),
                      ],
                    ),
                  ],
                ),
                if (_isSearchBarVisible) ...[
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search menu...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
                    // Welcome Box
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 4),
            ),
            child: Column(
              children: [
                Text(
                  'Welcome to Our FOS',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Text(
                  'Hungry? Then ready to Order',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          ),
          // Food Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TODAY\'S MENU',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _buildFoodItem(context, 'assets/spaghetti.png', 'Spaghetti', '10'),
                        _buildFoodItem(context, 'assets/burger.png', 'Burger', '8'),
                        _buildFoodItem(context, 'assets/pizza.png', 'Pizza', '12'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(BuildContext context, String imagePath, String title, String price) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                width: MediaQuery.of(context).size.width * 0.85,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$$price',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
>>>>>>> fa09a65295c49b1edae43ba7d51002379a294e82
