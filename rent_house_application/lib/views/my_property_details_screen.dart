import 'package:flutter/material.dart';
import '../models/MyPostPropertyResponseDto.dart';

class MyPropertyDetailsScreen extends StatelessWidget {
  final MyPostPropertyResponseDto property;
  final String imageBaseUrl = "http://10.0.2.2:8080/api/user/image/paths/";

  const MyPropertyDetailsScreen({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Property Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show images
            property.imageUrls.isNotEmpty
                ? SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: property.imageUrls.length,
                itemBuilder: (context, index) {
                  final imageUrl = "$imageBaseUrl${property.imageUrls[index]}";
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                      ),
                    ),
                  );
                },
              ),
            )
                : Image.network(
              "https://via.placeholder.com/300x180.png?text=No+Image",
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // Title and Category
            Text(
              "${property.title} (${property.category})",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Rent
            Text(
              "৳ ${property.rentAmount} per month",
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 8),

            // Available From
            Text("Available from: ${property.availableFrom}"),
            const SizedBox(height: 8),

            // Full Address
            Text("Address:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(
              "${property.address}, ${property.section}, ${property.thana}, ${property.district}, ${property.division}",
            ),
            const SizedBox(height: 12),

            // Contact Info
            Text("Contact Person: ${property.contactPerson}"),
            Text("Contact Number: ${property.contactNumber}"),
            const SizedBox(height: 12),

            // Description
            Text("Description:", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(property.description),
            const SizedBox(height: 12),

            // Status
            Text(
              property.isAvailable ? "Status: Available" : "Status: Not Available",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: property.isAvailable ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
