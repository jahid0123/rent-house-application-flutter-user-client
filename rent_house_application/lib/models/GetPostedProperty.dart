class GetPostedProperty {
  final int id;
  final String category; // changed from Map to String
  final String title;
  final String description;
  final bool isAvailable;
  final int rentAmount;
  final String datePosted;
  final String availableFrom;
  final String district;
  final String division;
  final String thana;
  final String section;
  final List<String> imageUrls;

  GetPostedProperty({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.isAvailable,
    required this.rentAmount,
    required this.datePosted,
    required this.availableFrom,
    required this.district,
    required this.division,
    required this.thana,
    required this.section,
    required this.imageUrls,
  });

  factory GetPostedProperty.fromJson(Map<String, dynamic> json) {
    return GetPostedProperty(
      id: json['id'],
      category: json['category'], // category is String
      title: json['title'],
      description: json['description'],
      isAvailable: json['isAvailable'],
      rentAmount: json['rentAmount'],
      datePosted: json['datePosted'],
      availableFrom: json['availableFrom'],
      district: json['district'],
      division: json['division'],
      thana: json['thana'],
      section: json['section'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
    );
  }
}
