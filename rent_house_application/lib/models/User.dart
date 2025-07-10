class User {

  final String name;
  final String email;
  final String phone;
  final int creditBalance; // if using credit system (e.g. house posting)

  User({

    required this.name,
    required this.email,
    required this.phone,
    required this.creditBalance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(

      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      creditBalance: json['creditBalance'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'name': name,
      'email': email,
      'phone': phone,
      'creditBalance': creditBalance,
    };
  }
}
