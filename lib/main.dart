import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';
import 'FE/home_screen.dart';
import 'FE/food_deal_screen.dart';
import 'FE/food_deal_details.dart';
import 'FE/food_details_screen.dart';
import 'FE/my_cart.dart';
import 'FE/signup_screen.dart';
import 'FE/login_screen.dart';
import 'FE/checkout_screen.dart';
import 'FE/address_screen.dart';
import 'FE/don_hang.dart';
import 'FE/order_detail.dart';
import 'FE/user_profile.dart';
import 'FE/ADMIN/admin_dashboard.dart';
import 'FE/ADMIN/admin_all.dart';
import 'FE/ADMIN/admin_add.dart';
import 'FE/ADMIN/admin_ingredient.dart';
import 'FE/models1/dish_dto.dart';
import 'FE/order_follow.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initialRoute = '/';

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await checkIsLoggedIn();
    if (!mounted) return;
    setState(() {
      _initialRoute = isLoggedIn ? '/' : '/login';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOS Food App',
      debugShowCheckedModeBanner: false,
      initialRoute: _initialRoute,
      routes: {
        '/': (context) => HomeScreen(),
        '/deals': (context) => FoodDealScreen(),
        '/details': (context) => FoodDealDetails(),
        '/cart': (context) => MyCart(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/address': (context) => AddressScreen(),
        // '/orderHistory': (context) => OrderPage(),
        '/orderFollow': (context) => OrderFollowScreen(),
        '/userProfile': (context) => UserProfileScreen(),
        '/admin/dashboard': (context) => AdminDashboardScreen(),
        '/admin/orders': (context) => AllOrdersScreen(),
        '/admin/add': (context) => AdminAddDishScreen(),
        '/admin/ingredients': (context) => ManageIngredientsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/foodDetail') {
          final args = settings.arguments as Map<String, dynamic>;
          final int foodId = args['dishId'];
          final String? image = args['image'];
          return MaterialPageRoute(
            builder: (context) =>
                FoodDetailsScreen(dishId: foodId, image: image),
          );
        }

        if (settings.name == '/checkout') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => CheckoutScreen(
              cartItems: List<Map<String, dynamic>>.from(args['cartItems']),
            ),
          );
        }

        if (settings.name == '/orderDetails') {
          final args = Map<String, dynamic>.from(settings.arguments as Map);
          return MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
              orderId: args['orderId'],
              date: args['date'],
              items: List<Map<String, dynamic>>.from(args['items']),
              address: args['address'],
              status: args['status'],
            ),
          );
        }
        return null;
      },
    );
  }
}
