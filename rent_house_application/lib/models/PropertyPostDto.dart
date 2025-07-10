class PropertyPostDto {
  late final int? userID;
  final String category;
  final String title;
  final String description;
  final String address;
  final String contactPerson;
  final String contactNumber;
  final String area;
  final String availableFrom; // format: yyyy-MM-dd
  final int rentAmount;
  final String division;
  final String district;
  final String thana;
  final String section;
  final String roadNumber;
  final String houseNumber;

  PropertyPostDto({
    required this.userID,
    required this.category,
    required this.title,
    required this.description,
    required this.address,
    required this.contactPerson,
    required this.contactNumber,
    required this.area,
    required this.availableFrom,
    required this.rentAmount,
    required this.division,
    required this.district,
    required this.thana,
    required this.section,
    required this.roadNumber,
    required this.houseNumber,
  });

  Map<String, dynamic> toJson() => {
    "userID": userID,
    "category": category,
    "title": title,
    "description": description,
    "address": address,
    "contactPerson": contactPerson,
    "contactNumber": contactNumber,
    "area": area,
    "availableFrom": availableFrom,
    "rentAmount": rentAmount,
    "division": division,
    "district": district,
    "thana": thana,
    "section": section,
    "roadNumber": roadNumber,
    "houseNumber": houseNumber,
  };
}
