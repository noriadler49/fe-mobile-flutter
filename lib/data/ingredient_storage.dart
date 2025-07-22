import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class IngredientRepository {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/ingredients.json');
  }

  static Future<List<Map<String, String>>> loadIngredients() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> json = jsonDecode(contents);
        return json.map((e) => Map<String, String>.from(e)).toList();
      }
    } catch (e) {
      print('Error loading ingredients: $e');
    }
    return [
      {"id": "1", "name": "Tomato"},
      {"id": "2", "name": "Onion"},
    ];
  }

  static Future<void> saveIngredients(List<Map<String, String>> ingredients) async {
    try {
      final file = await _localFile;
      await file.writeAsString(jsonEncode(ingredients));
    } catch (e) {
      print('Error saving ingredients: $e');
    }
  }
}