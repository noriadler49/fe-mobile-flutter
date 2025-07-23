import 'package:flutter/material.dart';
import 'package:fe_mobile_flutter/data/ingredient_storage.dart'; // Adjust import based on your structure

class ManageIngredientsScreen extends StatefulWidget {
  const ManageIngredientsScreen({super.key});

  @override
  _ManageIngredientsScreenState createState() =>
      _ManageIngredientsScreenState();
}

class _ManageIngredientsScreenState extends State<ManageIngredientsScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  List<Map<String, String>> ingredients = [
    {"id": "1", "name": "Tomato"},
    {"id": "2", "name": "Onion"},
  ];
  bool _isEditing = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  // Load ingredients from JSON file
  Future<void> _loadIngredients() async {
    final ingredientsData = await IngredientRepository.loadIngredients();
    setState(() {
      ingredients = ingredientsData;
    });
  }

  // Handle adding or updating an ingredient
  Future<void> _addOrUpdateIngredient() async {
    final name = _nameController.text.trim();

    // Basic validation
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in the ingredient name')),
      );
      return;
    }

    setState(() {
      if (_isEditing && _editingId != null) {
        // Update existing ingredient
        final index = ingredients.indexWhere(
          (ingredient) => ingredient['id'] == _editingId,
        );
        if (index != -1) {
          ingredients[index] = {'id': _editingId!, 'name': name};
        }
        _isEditing = false;
        _editingId = null;
      } else {
        // Add new ingredient
        final newId = (ingredients.length + 1).toString();
        ingredients.add({'id': newId, 'name': name});
      }
      // Clear form
      _nameController.clear();
      _idController.clear();
    });

    // Save to JSON
    await IngredientRepository.saveIngredients(ingredients);
  }

  // Handle edit button click
  void _editIngredient(String id) {
    final ingredient = ingredients.firstWhere(
      (ingredient) => ingredient['id'] == id,
    );
    setState(() {
      _nameController.text = ingredient['name']!;
      _idController.text = ingredient['id']!; // Optional, for display only
      _isEditing = true;
      _editingId = id;
    });
  }

  // Handle delete button click
  Future<void> _deleteIngredient(String id) async {
    setState(() {
      ingredients.removeWhere((ingredient) => ingredient['id'] == id);
    });
    // Save updated list to JSON
    await IngredientRepository.saveIngredients(ingredients);
    // Show confirmation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Ingredient deleted successfully')));
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
                          _isEditing
                              ? 'Edit Ingredient'
                              : 'Quản lý nguyên liệu',
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
                        labelText: 'Ingredient Name:',
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(labelText: 'Ingredient ID:'),
                      enabled: false, // Disabled since ID is auto-generated
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addOrUpdateIngredient,
                      child: Text(_isEditing ? 'Update' : 'Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
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
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: {
                        0: FlexColumnWidth(1),
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
                              child: Text(
                                "Ingredient Name",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                    child: Text(ingredient['id']!),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(ingredient['name']!),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () => _editIngredient(
                                            ingredient['id']!,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _deleteIngredient(
                                            ingredient['id']!,
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
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/');
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) print('Like tapped');
          if (index == 3) Navigator.pushNamed(context, '/login');
        },
      ),
    );
  }
}
