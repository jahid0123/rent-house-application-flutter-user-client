import 'package:flutter/material.dart';
import 'package:rent_house_application/views/user_home_screen.dart';
import '../models/CreditPackage.dart';
import '../services/credit_service.dart';

class CreditPackageScreen extends StatefulWidget {
  const CreditPackageScreen({super.key});

  @override
  State<CreditPackageScreen> createState() => _CreditPackageScreenState();
}

class _CreditPackageScreenState extends State<CreditPackageScreen> {
  late Future<List<CreditPackage>> futureCreditPackages;
  final CreditService creditService = CreditService();

  @override
  void initState() {
    super.initState();
    futureCreditPackages = creditService.getAllCreditPackages();
  }

  Future<void> _buyPackage(CreditPackage pkg) async {
    final success = await creditService.buyPackage(pkg.id);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Package bought successfully!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserHomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to buy package.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credit Packages"),
      ),
      body: FutureBuilder<List<CreditPackage>>(
        future: futureCreditPackages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No credit packages available."));
          }

          final packages = snapshot.data!;
          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final pkg = packages[index];
              return Card(

                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pkg.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 6),
                      Text("Credits: ${pkg.creditAmount}",
                          style: const TextStyle(fontSize: 16)),
                      Text("Price: \$${pkg.price.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 16, color: Colors.green)),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => _buyPackage(pkg),
                          icon: const Icon(Icons.shopping_cart_checkout),
                          label: const Text("Buy Package"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lime,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                        ),
                      ),
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

