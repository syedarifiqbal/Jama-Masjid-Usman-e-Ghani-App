class TransactionType {
  final int? id;
  final String name;
  final String? description;
  final bool active;

  TransactionType({
    this.id,
    required this.name,
    this.description,
    required this.active,
  });

  factory TransactionType.fromJson(Map<String, dynamic> json) {
    print(json);
    return TransactionType(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      active: json['active'],
    );
  }
}
