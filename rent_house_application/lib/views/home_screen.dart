import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_house_application/views/property_details_screen.dart';
import '../models/GetPostedProperty.dart';
import '../services/auth_service.dart';
import '../services/property_service.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<GetPostedProperty>> futureProperties;
  final PropertyService _propertyService = PropertyService();
  final AuthService _authService = AuthService();
  final String imageBaseUrl = "http://10.0.2.2:8080/api/user/image/paths/";

  // Search controllers
  final TextEditingController searchController = TextEditingController();
  final TextEditingController thanaController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureProperties = _propertyService.fetchPostedProperties();
  }

  Future<void> handleUnlock(int propertyId) async {
    bool isLoggedIn = await _authService.isLoggedIn();

    if (!isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }

    bool success = await _propertyService.unlockProperty(propertyId);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? "✅ Property Unlocked!"
            : "❌ Failed to unlock. Try again."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Rentals"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: const Icon(Icons.login),
          )
        ],
      ),
      body: FutureBuilder<List<GetPostedProperty>>(
        future: futureProperties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No properties found."));
          }

          List<GetPostedProperty> properties = snapshot.data!;

          // Apply filters
          List<GetPostedProperty> filtered = properties.where((p) {
            final query = searchController.text.toLowerCase().trim();

            if (query.isEmpty) return true;

            final isNumeric = int.tryParse(query);
            if (isNumeric != null) {
              // If number, match rentAmount
              return p.rentAmount <= isNumeric;
            }

            // If text, match title, thana, section
            return p.title.toLowerCase().contains(query) ||
                p.thana.toLowerCase().contains(query) ||
                p.category.toLowerCase().contains(query) ||
                p.description.toLowerCase().contains(query) ||
                p.section.toLowerCase().contains(query);
          }).toList();


          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: "Search by Title",
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                            errorBuilder: (ctx, err, _) =>
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
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("${prop.thana}, ${prop.division}"),
                                Text("৳ ${prop.rentAmount}/month",
                                    style:
                                    const TextStyle(color: Colors.green)),
                                Text("Description: ${prop.description.replaceAll(RegExp(r'(\r\n|\n|\r)'), ' ')}"),
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
                                            builder: (context) =>
                                                PropertyDetailsScreen(
                                                    property: prop),
                                          ),
                                        );
                                      },
                                      icon:
                                      const Icon(Icons.info_outline_rounded),
                                      label: const Text("View Details"),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await handleUnlock(prop.id);
                                      },
                                      icon: const Icon(Icons.lock_open),
                                      label: const Text("Unlock"),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange),
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
              ],
            ),
          );
        },
      ),
    );
  }
}