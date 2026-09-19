enum PropertyType {
  villa('Villa'),
  apartment('Appartement'),
  house('Maison'),
  land('Terrain'),
  office('Bureau');

  final String label;
  const PropertyType(this.label);
}

class Property {
  final String id;
  final String title;
  final String location;
  final String district;
  final double price;
  final PropertyType type;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final int parking;
  final List<String> images;
  final String description;
  final List<String> amenities;
  final bool isFeatured;
  final bool isFavorite;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewsCount;

  const Property({
    required this.id,
    required this.title,
    required this.location,
    required this.district,
    required this.price,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.parking,
    required this.images,
    required this.description,
    required this.amenities,
    this.isFeatured = false,
    this.isFavorite = false,
    required this.latitude,
    required this.longitude,
    this.rating = 4.9,
    this.reviewsCount = 28,
  });

  String get mainImage => images.isNotEmpty ? images.first : '';

  Property copyWith({
    String? id,
    String? title,
    String? location,
    String? district,
    double? price,
    PropertyType? type,
    int? bedrooms,
    int? bathrooms,
    double? area,
    int? parking,
    List<String>? images,
    String? description,
    List<String>? amenities,
    bool? isFeatured,
    bool? isFavorite,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewsCount,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      district: district ?? this.district,
      price: price ?? this.price,
      type: type ?? this.type,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      parking: parking ?? this.parking,
      images: images ?? this.images,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      isFeatured: isFeatured ?? this.isFeatured,
      isFavorite: isFavorite ?? this.isFavorite,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }
}
