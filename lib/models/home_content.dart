class HomeContent {
  final int id;
  final String? image;
  final String title;
  final String description;
  final String? phase;
  final String? day;
  final String? dayOfCycle;
  final int order;

  HomeContent({
    required this.id,
    this.image,
    required this.title,
    required this.description,
    this.phase,
    this.day,
    this.dayOfCycle,
    required this.order,
  });

  factory HomeContent.fromJson(Map<String, dynamic> json) {
    return HomeContent(
      id: json['id'] as int,
      image: json['image'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      phase: json['phase'] as String?,
      day: json['day'] as String?,
      dayOfCycle: json['day_of_cycle'] as String?,
      order: json['order'] as int,
    );
  }
}

