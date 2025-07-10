class MyUnlockProperty {
  final int unlockId;
  final int postId;
  final int creditsUsed;
  final String dateUnlocked;
  final String contactNumber;
  final String contactPerson;
  final String availableFrom;
  final String category;
  final String title;
  final String description;
  final bool isAvailable;
  final int rentAmount;
  final String adPostedDate;
  final String division;
  final String district;
  final String thana;
  final String section;
  final String roadNumber;
  final String houseNumber;
  final String address;

  MyUnlockProperty({
    required this.unlockId,
    required this.postId,
    required this.creditsUsed,
    required this.dateUnlocked,
    required this.contactNumber,
    required this.contactPerson,
    required this.availableFrom,
    required this.category,
    required this.title,
    required this.description,
    required this.isAvailable,
    required this.rentAmount,
    required this.adPostedDate,
    required this.division,
    required this.district,
    required this.thana,
    required this.section,
    required this.roadNumber,
    required this.houseNumber,
    required this.address,
  });

  factory MyUnlockProperty.fromJson(Map<String, dynamic> json) {
    return MyUnlockProperty(
      unlockId: json['unlockId'],
      postId: json['postId'],
      creditsUsed: json['creditsUsed'],
      dateUnlocked: json['dateUnlocked'],
      contactNumber: json['contactNumber'],
      contactPerson: json['contactPerson'],
      availableFrom: json['availableFrom'],
      category: json['category'],
      title: json['title'],
      description: json['description'],
      isAvailable: json['isAvailable'],
      rentAmount: json['rentAmount'],
      adPostedDate: json['adPostedDate'],
      division: json['division'],
      district: json['district'],
      thana: json['thana'],
      section: json['section'],
      roadNumber: json['roadNumber'],
      houseNumber: json['houseNumber'],
      address: json['address'],
    );
  }
}
