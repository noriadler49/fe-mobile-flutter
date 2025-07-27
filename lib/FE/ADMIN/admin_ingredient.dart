import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/models/ingredient_model.dart';
import 'package:fe_mobile_flutter/services/api_service.dart';
import 'package:fe_mobile_flutter/fe/admin/admin_search_button.dart';
import 'package:fe_mobile_flutter/FE/auth_status.dart';

class ManageIngredientsScreen extends StatefulWidget {
  const ManageIngredientsScreen({super.key});

  @override
  _ManageIngredientsScreenState createState() => _ManageIngredientsScreenState();
}

class _ManageIngredientsScreenState extends State<ManageIngredientsScreen> {
  final _nameController = TextEditingController();
  List<Ingredient> ingredients = [];
  List<Ingredient> allIngredients = [];

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients({String query = ''}) async {
    try {
      final fetchedIngredients = await ApiService.fetchIngredients(query: query);
      setState(() {
        ingredients = fetchedIngredients;
        allIngredients = List.from(ingredients);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading ingredients: $e')),
      );
    }
  }

  Future<void> _addIngredient() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in the ingredient name')),
      );
      return;
    }

    try {
      await ApiService.createIngredient(Ingredient(name: name));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingredient added successfully')),
      );
      _nameController.clear();
      await _loadIngredients();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteIngredient(int id) async {
    try {
      await ApiService.deleteIngredient(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingredient deleted successfully')),
      );
      await _loadIngredients();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting ingredient: $e')),
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
                          'Quản lý nguyên liệu',
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
                      decoration: InputDecoration(
                        labelText: 'Ingredient Name',
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addIngredient,
                      child: Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadIngredients,
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
                      "Danh sách nguyên liệu:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Table(
                      key: ValueKey(ingredients.length),
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: {
                        0: FlexColumnWidth(0.5),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
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
                                label: 'Ingredient Name',
                                onSearch: (value) async {
                                  await _loadIngredients(query: value);
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
                        ...ingredients
                            .map(
                              (ingredient) => TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(ingredient.id?.toString() ?? 'N/A'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(ingredient.name),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _deleteIngredient(
                                            ingredient.id!,
                                          ),
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