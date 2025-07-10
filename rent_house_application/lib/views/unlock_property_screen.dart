import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/MyUnlockProperty.dart';
import '../services/property_service.dart';

class UnlockPropertyScreen extends StatefulWidget {
  const UnlockPropertyScreen({super.key});

  @override
  State<UnlockPropertyScreen> createState() => _UnlockPropertyScreenState();
}

class _UnlockPropertyScreenState extends State<UnlockPropertyScreen> {
  final PropertyService _propertyService = PropertyService();
  late Future<List<MyUnlockProperty>> futureUnlocks;

  @override
  void initState() {
    super.initState();
    futureUnlocks = _propertyService.fetchUnlockedProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unlocked Properties")),
      body: FutureBuilder<List<MyUnlockProperty>>(
        future: futureUnlocks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No unlocked properties yet."));
          }

          final properties = snapshot.data!;
          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final prop = properties[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${prop.title} (${prop.category})",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("📍 ${prop.address}, ${prop.section}, ${prop.thana}, ${prop.division}"),
                      Text("Rent: ৳${prop.rentAmount}/month"),
                      Text("Available from: ${prop.availableFrom}"),
                      const SizedBox(height: 6),
                      Text("👤 Contact: ${prop.contactPerson}"),
                      Text("📞 Phone: ${prop.contactNumber}"),
                      Text("🔓 Unlocked on: ${prop.dateUnlocked}"),
                      Text("💳 Credit used: ${prop.creditsUsed}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
