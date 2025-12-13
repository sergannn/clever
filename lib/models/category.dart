class Category {
  final int id;
  final String name;
  final String slug;
  final int order;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.order,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      order: json['order'] as int,
    );
  }
}

