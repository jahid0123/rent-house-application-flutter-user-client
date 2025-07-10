class MyPostPropertyResponseDto {
  final int id;
  final String contactNumber;
  final String contactPerson;
  final String availableFrom;
  final String category;
  final String title;
  final String description;
  final bool isAvailable;
  final int rentAmount;
  final String datePosted;
  final String division;
  final String district;
  final String thana;
  final String section;
  final String roadNumber;
  final String houseNumber;
  final String address;
  final List<String> imageUrls;

  MyPostPropertyResponseDto({
    required this.id,
    required this.contactNumber,
    required this.contactPerson,
    required this.availableFrom,
    required this.category,
    required this.title,
    required this.description,
    required this.isAvailable,
    required this.rentAmount,
    required this.datePosted,
    required this.division,
    required this.district,
    required this.thana,
    required this.section,
    required this.roadNumber,
    required this.houseNumber,
    required this.address,
    required this.imageUrls,
  });

  factory MyPostPropertyResponseDto.fromJson(Map<String, dynamic> json) {
    return MyPostPropertyResponseDto(
      id: json['id'],
      contactNumber: json['contactNumber'],
      contactPerson: json['contactPerson'],
      availableFrom: json['availableFrom'],
      category: json['category'],
      title: json['title'],
      description: json['description'],
      isAvailable: json['isAvailable'],
      rentAmount: json['rentAmount'],
      datePosted: json['datePosted'],
      division: json['division'],
      district: json['district'],
      thana: json['thana'],
      section: json['section'],
      roadNumber: json['roadNumber'],
      houseNumber: json['houseNumber'],
      address: json['address'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
    );
  }
}
