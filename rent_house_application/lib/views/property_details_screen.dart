import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/GetPostedProperty.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final GetPostedProperty property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final imageBaseUrl = "http://10.0.2.2:8080/api/user/image/paths/";

    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Horizontal scrollable images
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: property.imageUrls.length,
                itemBuilder: (context, index) {
                  final imgUrl = "$imageBaseUrl${property.imageUrls[index]}";
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 300,
                    child: Image.network(
                      imgUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, _) =>
                      const Icon(Icons.broken_image),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "${property.title} (${property.category})",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              "৳ ${property.rentAmount}/month",
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 8),

            Text(
              "Location: ${property.section}, ${property.thana}, ${property.district}, ${property.division}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            Text("Available From: ${property.availableFrom}"),
            Text("Posted On: ${property.datePosted}"),

            const SizedBox(height: 16),
            const Divider(),

            const Text(
              "Description:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              property.description,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}