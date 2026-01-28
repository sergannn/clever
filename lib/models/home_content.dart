/// Tip by ТЗ: phase, relative_day_position, short_text, guide_ref.
class HomeContent {
  final int id;
  final String? image;
  final String title;
  final String description;
  final String? shortText;
  final String? phase;
  final String? day;
  final String? dayOfCycle;
  final int? relativeDayPosition;
  final int? guideRef;
  final int order;

  HomeContent({
    required this.id,
    this.image,
    required this.title,
    required this.description,
    this.shortText,
    this.phase,
    this.day,
    this.dayOfCycle,
    this.relativeDayPosition,
    this.guideRef,
    required this.order,
  });

  factory HomeContent.fromJson(Map<String, dynamic> json) {
    return HomeContent(
      id: json['id'] as int,
      image: json['image'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      shortText: json['short_text'] as String?,
      phase: json['phase'] as String?,
      day: json['day'] as String?,
      dayOfCycle: json['day_of_cycle'] as String?,
      relativeDayPosition: json['relative_day_position'] as int?,
      guideRef: json['guide_ref'] as int?,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}

