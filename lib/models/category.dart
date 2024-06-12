class Category {
  final String id;
  final String name;
  final String image;
  final String coffeeId;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.coffeeId,
  });

  factory Category.fromJson(Map<String, dynamic> data) {
    return Category(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      coffeeId: data['coffee_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'coffee_id': coffeeId,
    };
  }
}
