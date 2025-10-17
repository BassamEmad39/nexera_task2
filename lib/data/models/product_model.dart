class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  double get discountedPrice {
    return price - (price * discountPercentage / 100);
  }

  bool get hasDiscount => discountPercentage > 0;

  bool get isOutOfStock => stock <= 0;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? 'No Description',
      price: (json['price'] ?? 0.0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      brand: json['brand']?.toString() ?? 'No Brand',
      category: json['category']?.toString() ?? 'No Category',
      thumbnail: json['thumbnail']?.toString() ?? '',
      images: List<String>.from(json['images']?.map((x) => x.toString()) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
    };
  }
}