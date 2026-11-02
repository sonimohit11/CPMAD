class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'] as Map<String, dynamic>? ?? {};
    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? 'Untitled product',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Other',
      image: json['image']?.toString() ?? '',
      rating: (ratingJson['rate'] as num?)?.toDouble() ?? 0,
      ratingCount: (ratingJson['count'] as num?)?.toInt() ?? 0,
    );
  }
}
