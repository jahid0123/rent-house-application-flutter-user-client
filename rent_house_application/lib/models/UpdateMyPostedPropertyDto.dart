class UpdateMyPostedPropertyDto {
  final int postId;
  final String contactNumber;
  final String contactPerson;
  final String availableFrom;
  final String category;
  final String title;
  final String description;
  final int rentAmount;
  final String division;
  final String district;
  final String thana;
  final String section;
  final String roadNumber;
  final String houseNumber;
  final String address;

  UpdateMyPostedPropertyDto({
    required this.postId,
    required this.contactNumber,
    required this.contactPerson,
    required this.availableFrom,
    required this.category,
    required this.title,
    required this.description,
    required this.rentAmount,
    required this.division,
    required this.district,
    required this.thana,
    required this.section,
    required this.roadNumber,
    required this.houseNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'contactNumber': contactNumber,
    'contactPerson': contactPerson,
    'availableFrom': availableFrom,
    'category': category,
    'title': title,
    'description': description,
    'rentAmount': rentAmount,
    'division': division,
    'district': district,
    'thana': thana,
    'section': section,
    'roadNumber': roadNumber,
    'houseNumber': houseNumber,
    'address': address,
  };
}
