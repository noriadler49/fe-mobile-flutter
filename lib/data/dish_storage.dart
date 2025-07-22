import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DishRepository {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/dishes.json');
  }

  static Future<List<Map<String, String>>> loadDishes() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> json = jsonDecode(contents);
        return json.map((e) => Map<String, String>.from(e)).toList();
      }
    } catch (e) {
      print('Error loading dishes: $e');
    }
    return [
      {"id": "1", "name": "Dish 1", "image": "/assets/burger.jpg", "price": "10.99"},
      {"id": "2", "name": "Dish 2", "image": "/assets/burger.jpg", "price": "12.99"},
    ];
  }

  static Future<void> saveDishes(List<Map<String, String>> dishes) async {
    try {
      final file = await _localFile;
      await file.writeAsString(jsonEncode(dishes));
    } catch (e) {
      print('Error saving dishes: $e');
    }
  }
}