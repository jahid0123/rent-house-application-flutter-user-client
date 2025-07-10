import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/PurchaseHistory.dart';
import '../services/credit_service.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  late Future<List<PurchaseHistory>> futureHistory;
  final CreditService _creditService = CreditService();

  @override
  void initState() {
    super.initState();
    futureHistory = _creditService.getPurchaseHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Purchase History")),
      body: FutureBuilder<List<PurchaseHistory>>(
        future: futureHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No purchase history found."));
          }

          final historyList = snapshot.data!;
          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final h = historyList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(
                    Icons.credit_score_outlined,
                    color: Colors.green,
                  ),
                  title: Text(
                    h.packageName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Credits: ${h.creditsPurchased}"),
                      Text("Date: ${h.datePurchased.split('T').first}"),
                    ],
                  ),
                  trailing: Text(
                    "৳ ${h.amountPaid.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
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
