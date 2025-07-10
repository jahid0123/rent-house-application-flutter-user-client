import 'package:flutter/material.dart';
import 'package:rent_house_application/views/edit_my_property_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/MyPostPropertyResponseDto.dart';
import '../services/property_service.dart';
import 'my_property_details_screen.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  final PropertyService _propertyService = PropertyService();
  late Future<List<MyPostPropertyResponseDto>> futureMyProperties;


  // Replace this with your correct local IP if testing on a real device
  final String imageBaseUrl = "http://10.0.2.2:8080/api/user/image/paths/";

  @override
  void initState() {
    super.initState();
    _loadMyProperties();
  }

  Future<void> _loadMyProperties() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("id");
    if (userId != null) {
      setState(() {
        futureMyProperties = _propertyService.fetchMyPostedProperties(userId);
      });
    }
  }

  void _editProperty(MyPostPropertyResponseDto prop) {
    Navigator.pushNamed(context, "/edit_property", arguments: prop);
  }

  void _viewDetails(MyPostPropertyResponseDto prop) {
    Navigator.pushNamed(context, "/property_details", arguments: prop);
  }

  void _deleteProperty(int propertyId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Property"),
        content: const Text("Are you sure you want to delete this property?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _propertyService.deleteMyPostedProperty(propertyId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? "✅ Property deleted successfully" : "❌ Failed to delete property",
          ),
        ),
      );

      if (success) {
        _loadMyProperties(); // Reload properties list
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Properties")),
      body: FutureBuilder<List<MyPostPropertyResponseDto>>(
        future: futureMyProperties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("You haven't posted any properties yet."));
          }

          final properties = snapshot.data!;

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final prop = properties[index];

              final imageUrl = prop.imageUrls.isNotEmpty
                  ? "$imageBaseUrl${prop.imageUrls.first}"
                  : "https://via.placeholder.com/300x180.png?text=No+Image";

              // Debugging
              print("🖼️ Image URL: $imageUrl");

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
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 180,
                          child: Center(child: Icon(Icons.broken_image, size: 40)),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(prop.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("${prop.thana}, ${prop.division}"),
                          Text("৳ ${prop.rentAmount}/month", style: const TextStyle(color: Colors.green)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.visibility),
                                label: const Text("View"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MyPropertyDetailsScreen(property: prop),
                                      ),
                                    );
                                  },
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.edit),
                                label: const Text("Edit"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditMyPropertyScreen(property: prop),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.delete),
                                label: const Text("Delete"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () => _deleteProperty(prop.id),
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
          );
        },
      ),
    );
  }
}
