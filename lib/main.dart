import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
                        _buildFoodItem(context, 'assets/spaghetti.png', 'Spaghetti'),
                        _buildFoodItem(context, 'assets/burger.png', 'Burger'),
                        _buildFoodItem(context, 'assets/pizza.png', 'Pizza'),
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

  Widget _buildFoodItem(BuildContext context, String imagePath, String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}