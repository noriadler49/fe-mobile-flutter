import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fe_mobile_flutter/FE/models1/vourcher.dart';

class VourcherService {
  final String baseUrl = "http://10.0.2.2:5065/api/vourchers";

  // Validate a voucher code
  Future<TblVourcher?> validateVoucher(String code) async {
    final response = await http.get(Uri.parse('$baseUrl/$code'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return TblVourcher.fromJson(data);
    } else if (response.statusCode == 404) {
      return null; // voucher not found
    } else {
      throw Exception("Failed to validate voucher");
    }
  }

  // Create a new voucher
  Future<TblVourcher> createVoucher(TblVourcher voucher) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(voucher.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return TblVourcher.fromJson(data);
    } else {
      throw Exception("Failed to create voucher");
    }
  }
}
