class PurchaseHistory {
  final String packageName;
  final int creditsPurchased;
  final double amountPaid;
  final String datePurchased;

  PurchaseHistory({
    required this.packageName,
    required this.creditsPurchased,
    required this.amountPaid,
    required this.datePurchased,
  });

  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
      packageName: json['packageName'],
      creditsPurchased: json['creditsPurchased'],
      amountPaid: (json['amountPaid'] as num).toDouble(),
      datePurchased: json['datePurchased'],
    );
  }
}
