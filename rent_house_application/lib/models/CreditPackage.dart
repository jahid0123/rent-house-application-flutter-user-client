class CreditPackage {
  final int id;
  final String name;
  final int creditAmount;
  final double price;

  CreditPackage({
    required this.id,
    required this.name,
    required this.creditAmount,
    required this.price,
  });

  factory CreditPackage.fromJson(Map<String, dynamic> json) {
    return CreditPackage(
      id: json['id'],
      name: json['name'],
      creditAmount: json['creditAmount'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
