class GuideArticle {
  final int id;
  final String? image;
  final String title;
  final String description;
  final String? phase;
  final String? category;
  final String? categorySlug;
  final int order;

  GuideArticle({
    required this.id,
    this.image,
    required this.title,
    required this.description,
    this.phase,
    this.category,
    this.categorySlug,
    required this.order,
  });

  factory GuideArticle.fromJson(Map<String, dynamic> json) {
    return GuideArticle(
      id: json['id'] as int,
      image: json['image'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      phase: json['phase'] as String?,
      category: json['category'] as String?,
      categorySlug: json['category_slug'] as String?,
      order: json['order'] as int,
    );
  }
}

