import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/CreditPackage.dart';
import '../models/PurchaseHistory.dart';

class CreditService {
  final String baseUrl = "http://10.0.2.2:8080";

  Future<List<CreditPackage>> getAllCreditPackages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final response = await http.get(
      Uri.parse('$baseUrl/api/user/all/credit/package'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      return jsonData.map((item) => CreditPackage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load credit packages');
    }
  }

  Future<bool> buyPackage(int creditPackageId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    int? userId = prefs.getInt("id");

    if (userId == null || token == null || token.isEmpty) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/api/user/buy/package'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userId': userId, 'creditPackageId': creditPackageId}),
    );

    return response.statusCode == 202;
  }


  Future<List<PurchaseHistory>> getPurchaseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final userId = prefs.getInt("id");

    final response = await http.get(
      Uri.parse("$baseUrl/api/user/buy/package/me?id=$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => PurchaseHistory.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load purchase history");
    }
  }
}
