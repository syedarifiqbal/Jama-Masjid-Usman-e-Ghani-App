class Category {
  final int? id;
  final String name;
  final String? description;
  final bool active;

  Category({
    this.id,
    required this.name,
    this.description,
    required this.active,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    print(json);
    return Category(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      active: json['active'],
    );
  }
}
