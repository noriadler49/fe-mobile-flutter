import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/models/dish_model.dart';
import 'package:fe_mobile_flutter/services/api_service.dart';
import 'package:fe_mobile_flutter/fe/admin/admin_search_button.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class AdminAddDishScreen extends StatefulWidget {
  const AdminAddDishScreen({super.key});

  @override
  _AdminAddDishScreenState createState() => _AdminAddDishScreenState();
}

class _AdminAddDishScreenState extends State<AdminAddDishScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imgUrlController = TextEditingController();
  List<Dish> dishes = [];
  List<Dish> allDishes = [];
  bool _isEditing = false;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _loadDishes();
  }

  Future<void> _loadDishes() async {
    try {
      final loadedDishes = await ApiService.fetchDishes();
      setState(() {
        dishes = loadedDishes;
        allDishes = List.from(loadedDishes);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading dishes: $e')),
      );
    }
  }

  Future<void> _addOrUpdateDish() async {
    final name = _nameController.text.trim();
    final price = _priceController.text.trim();
    final imgUrl = _imgUrlController.text.trim();

    if (name.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in name and price fields')),
      );
      return;
    }
    final priceValue = double.tryParse(price);
    if (priceValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Price must be a valid number')),
      );
      return;
    }

    try {
      final dish = Dish(
        id: _isEditing ? _editingId : null,
        name: name,
        imageUrl: imgUrl.isEmpty ? null : imgUrl,
        description: '', // Placeholder
        price: priceValue,
        categoryId: 1, // Placeholder, adjust as needed
      );

      if (_isEditing && _editingId != null) {
        print('Updating dish with ID: $_editingId, name: $name, price: $priceValue, imgUrl: $imgUrl');
        final updatedDish = await ApiService.updateDish(_editingId!, dish, imgUrl);
        print('Update response: $updatedDish');
        // Refresh the table by fetching the latest data
        await _loadDishes();
      } else {
        final createdDish = await ApiService.createDish(dish, imgUrl);
        setState(() {
          dishes.add(createdDish);
          allDishes.add(createdDish);
        });
      }
      _nameController.clear();
      _priceController.clear();
      _imgUrlController.clear();
      setState(() {
        _isEditing = false;
        _editingId = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _editDish(int? id) {
    if (id == null) return;
    final dish = dishes.firstWhere((dish) => dish.id == id);
    setState(() {
      _nameController.text = dish.name;
      _priceController.text = dish.price.toString();
      _imgUrlController.text = dish.imageUrl ?? '';
      _isEditing = true;
      _editingId = id;
    });
  }

  Future<void> _deleteDish(int? id) async {
    if (id == null) return;
    try {
      await ApiService.deleteDish(id);
      setState(() {
        dishes.removeWhere((dish) => dish.id == id);
        allDishes.removeWhere((dish) => dish.id == id);
      });
      await _loadDishes();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dish deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting dish: $e')),
      );
    }
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
                          _isEditing ? 'Edit Dish' : 'Add Dish',
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
                      decoration: InputDecoration(labelText: 'Image URL:'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addOrUpdateDish,
                      child: Text(_isEditing ? 'Update' : 'Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadDishes,
                      child: Text('Refresh'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Table(
                      key: ValueKey(dishes.length), // Force rebuild on list change
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
                                label: 'Dish Name',
                                onSearch: (value) async {
                                  if (value.isEmpty) {
                                    await _loadDishes();
                                  } else {
                                    setState(() {
                                      dishes = allDishes
                                          .where((dish) => dish.name
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
                                          .toList();
                                    });
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FilterButtonWithPopup(
                                label: 'Price',
                                onSearch: (value) async {
                                  if (value.isEmpty) {
                                    await _loadDishes();
                                  } else {
                                    setState(() {
                                      dishes = allDishes
                                          .where((dish) => dish.price
                                              .toString()
                                              .toLowerCase()
                                              .contains(value.toLowerCase()))
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
                        ...dishes.map((dish) => TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(dish.id?.toString() ?? 'N/A'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(dish.name),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(dish.price.toStringAsFixed(2)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => _editDish(dish.id),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deleteDish(dish.id),
                                      ),
                                    ],
                                  ),
                                ),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Like'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/admin/dashboard');
          if (index == 1) Navigator.pushNamed(context, '');
          if (index == 2) print('Like tapped');
          if (index == 3) {
            if (isLoggedIn) {
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