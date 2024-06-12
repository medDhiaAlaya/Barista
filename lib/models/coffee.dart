class Coffee {
  final String id;
  final String name;
  final String description;
  final String image;
  final String admin;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.admin,
  });

  factory Coffee.fromJson(Map<String, dynamic> data) {
    return Coffee(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      admin: data['admin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'admin': admin,
    };
  }
}
