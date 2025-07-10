import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rent_house_application/views/unlock_property_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/GetPostedProperty.dart';
import '../models/user.dart';
import '../services/property_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'property_details_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  User? _user;
  final PropertyService _propertyService = PropertyService();
  final AuthService _authService = AuthService();
  late Future<List<GetPostedProperty>> futureProperties;
  final TextEditingController searchController = TextEditingController();
  final String imageBaseUrl = "http://10.0.2.2:8080/api/user/image/paths/";

  @override
  void initState() {
    super.initState();
    futureProperties = _propertyService.fetchPostedProperties();
    _loadUserInfo();
    futureProperties = _propertyService.fetchPostedProperties();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final userId = prefs.getInt("id");

    if (token == null || userId == null) return;

    final response = await http.get(
      Uri.parse("http://10.0.2.2:8080/api/user/info?userId=$userId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userInfo = User.fromJson(data);

      setState(() {
        _user = userInfo;
      });

      prefs.setString("name", userInfo.name);
      prefs.setString("email", userInfo.email);
      prefs.setInt("creditBalance", userInfo.creditBalance);
    } else {
      print("❌ Failed to load user info: ${response.body}");
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _unlockProperty(int propertyId) async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (!isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    final success = await _propertyService.unlockProperty(propertyId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "✅ Property Unlocked!" : "❌ Failed to unlock."),
      ),
    );

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UnlockPropertyScreen()),
      );
    }
  }

  void _navigateTo(String routeName) {
    Navigator.pop(context);
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("User Home")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_user?.name ?? "User"),
              accountEmail: Text(_user?.email ?? "user@example.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              // otherAccountsPictures: [
              //   Padding(
              //     padding: const EdgeInsets.all(0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         const Text(
              //           "Credit Balance",
              //           style: TextStyle(fontSize: 12, color: Colors.white70),
              //         ),
              //         Text(
              //           _user?.creditBalance.toString() ?? "0",
              //           style: const TextStyle(
              //             fontSize: 16,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ],
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => _navigateTo("/profile"),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Post Property"),
              onTap: () => _navigateTo("/post_property"),
            ),
            ListTile(
              leading: const Icon(Icons.home_work),
              title: const Text("My Properties"),
              onTap: () => _navigateTo("/my_property"),
            ),
            ListTile(
              leading: const Icon(Icons.lock_open),
              title: const Text("Unlock Property"),
              onTap: () => _navigateTo("/unlock_property"),
            ),
            ListTile(
              leading: const Icon(Icons.backpack),
              title: const Text("Buy Package"),
              onTap: () => _navigateTo("/credit_package"),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Purchase History"),
              onTap: () => _navigateTo("/purchase_history"),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => _navigateTo("/settings"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<GetPostedProperty>>(
          future: futureProperties,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No properties found."));
            }

            final query = searchController.text.toLowerCase().trim();
            final properties = snapshot.data!;
            final filtered = properties.where((p) {
              if (query.isEmpty) return true;
              final priceQuery = int.tryParse(query);
              if (priceQuery != null) return p.rentAmount <= priceQuery;
              return p.title.toLowerCase().contains(query) ||
                  p.thana.toLowerCase().contains(query) ||
                  p.section.toLowerCase().contains(query);
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: "Search by title, thana, section or price",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final prop = filtered[index];
                      final imageUrl = prop.imageUrls.isNotEmpty
                          ? "$imageBaseUrl${prop.imageUrls.first}"
                          : "https://via.placeholder.com/300x180.png?text=No+Image";

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${prop.title} (${prop.category})",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("${prop.thana}, ${prop.division}"),
                                  Text(
                                    "৳ ${prop.rentAmount}/month",
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  Text("Available from: ${prop.availableFrom}"),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PropertyDetailsScreen(
                                                    property: prop,
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.info_outline),
                                        label: const Text("View Details"),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            _unlockProperty(prop.id),
                                        icon: const Icon(Icons.lock_open),
                                        label: const Text("Unlock"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
