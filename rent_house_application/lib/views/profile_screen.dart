import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  final String baseUrl = "http://10.0.2.2:8080/api/user/info";

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final userId = prefs.getInt("id");

    if (token == null || userId == null) return;

    final response = await http.get(
      Uri.parse("$baseUrl?userId=$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _user = User.fromJson(data);
      });
    } else {
      print("❌ Failed to load user profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 45,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            Text("👤 Name: ${_user!.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("📧 Email: ${_user!.email}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("📱 Phone: ${_user!.phone}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("💳 Credit Balance: ৳${_user!.creditBalance}", style: const TextStyle(fontSize: 18, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
