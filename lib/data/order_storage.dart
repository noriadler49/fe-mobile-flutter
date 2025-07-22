import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OrderRepository {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/orders.json');
  }

  static Future<List<Map<String, String>>> loadOrders() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> json = jsonDecode(contents);
        return json.map((e) => Map<String, String>.from(e)).toList();
      }
    } catch (e) {
      print('Error loading orders: $e');
    }
    return [
      {"id": "1", "itemName": "Pizza", "from": "AB", "date": "2025-07-20"},
      {"id": "2", "itemName": "Burger", "from": "EL", "date": "2025-07-21"},
    ];
  }

  static Future<void> saveOrders(List<Map<String, String>> orders) async {
    try {
      final file = await _localFile;
      await file.writeAsString(jsonEncode(orders));
    } catch (e) {
      print('Error saving orders: $e');
    }
  }
}