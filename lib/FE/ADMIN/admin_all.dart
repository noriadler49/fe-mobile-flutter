import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/data/order_storage.dart'; // Adjust import based on your structure
import 'package:fe_mobile_flutter/fe/admin/admin_search_button.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  _AllOrdersScreenState createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  final _fromController = TextEditingController();
  final _dateController = TextEditingController();
  List<Map<String, String>> orders = [
    {"id": "1", "itemName": "Pizza", "from": "AB", "date": "2025-07-20"},
    {"id": "2", "itemName": "Burger", "from": "EL", "date": "2025-07-21"},
  ];
  List<Map<String, String>> allOrders = []; // original full list

  bool _isEditing = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // Load orders from JSON file
  Future<void> _loadOrders() async {
    final ordersData = await OrderRepository.loadOrders();
    setState(() {
      orders = ordersData;
      allOrders = ordersData;
    });
  }

  // Handle adding or updating an order
  Future<void> _addOrUpdateOrder() async {
    final from = _fromController.text.trim();
    final date = _dateController.text.trim();

    // Basic validation
    if (from.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    setState(() {
      if (_isEditing && _editingId != null) {
        // Update existing order
        final index = orders.indexWhere((order) => order['id'] == _editingId);
        if (index != -1) {
          orders[index] = {
            'id': _editingId!,
            'itemName': orders[index]['itemName']!, // Keep itemName unchanged
            'from': from,
            'date': date,
          };
        }
        _isEditing = false;
        _editingId = null;
      } else {
        // Add new order
        final newId = (orders.length + 1).toString();
        orders.add({
          'id': newId,
          'itemName': 'New Order', // Default itemName, editable elsewhere
          'from': from,
          'date': date,
        });
      }
      // Clear form
      _fromController.clear();
      _dateController.clear();
    });

    // Save to JSON
    await OrderRepository.saveOrders(orders);
  }

  // Handle edit button click
  void _editOrder(String id) {
    final order = orders.firstWhere((order) => order['id'] == id);
    setState(() {
      _fromController.text = order['from']!;
      _dateController.text = order['date']!;
      _isEditing = true;
      _editingId = id;
    });
  }

  // Handle delete button click
  Future<void> _deleteOrder(String id) async {
    setState(() {
      orders.removeWhere((order) => order['id'] == id);
    });
    // Save updated list to JSON
    await OrderRepository.saveOrders(orders);
    // Show confirmation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Order deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      'Admin Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.list_alt, color: Colors.red),
                    title: Text('All Orders'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/orders');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_circle, color: Colors.red),
                    title: Text('Add Dish'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/add');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.kitchen, color: Colors.red),
                    title: Text('Manage Ingredients'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin/ingredients');
                    },
                  ),
                ],
              ),
            ),

            // Bottom-fixed Admin Dashboard option
            Divider(),
            ListTile(
              leading: Icon(Icons.admin_panel_settings, color: Colors.red),
              title: Text('Admin Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin/dashboard');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.redAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Builder(
                          builder: (BuildContext context) {
                            return IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                        Text(
                          _isEditing ? 'Edit Order' : 'Tất cả đơn hàng',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: {
                        0: FlexColumnWidth(0.6),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1.4),
                      },
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FilterButtonWithPopup(
                                label: 'Item Name',
                                onSearch: (value) async {
                                  if (value.isEmpty) {
                                    await _loadOrders(); // ✅ reload or restore full list
                                  } else {
                                    setState(() {
                                      orders = allOrders
                                          .where(
                                            (order) => order['itemName']!
                                                .toLowerCase()
                                                .contains(value.toLowerCase()),
                                          )
                                          .toList();
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FilterButtonWithPopup(
                                label: 'From',
                                onSearch: (value) async {
                                  if (value.isEmpty) {
                                    await _loadOrders(); // ✅ reload or restore full list
                                  } else {
                                    setState(() {
                                      orders = allOrders
                                          .where(
                                            (order) => order['from']!
                                                .toLowerCase()
                                                .contains(value.toLowerCase()),
                                          )
                                          .toList();
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Thao tác',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        ...orders
                            .map(
                              (order) => TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(order['id']!),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(order['itemName']!),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(order['from']!),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () =>
                                              _editOrder(order['id']!),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _deleteOrder(order['id']!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) async {
          if (index == 0) return;
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3) {
            if (await AuthStatus.isLoggedIn()) {
              Navigator.pushNamed(context, '/userProfile');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          }
        },
      ),
    );
  }
}
