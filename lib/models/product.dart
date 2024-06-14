class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String banner;
  final List<String> images;
  final String categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.banner,
    required this.images,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      price: double.tryParse(data['price'] ?? '0') ?? 0,
      description: data['description'] ?? '',
      banner: data['banner'] ?? '',
      images: data['images'] ?? [],
      categoryId: data['category_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'banner': banner,
      'images': images,
      'category_id': categoryId,
    };
  }
}
