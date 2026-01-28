class User {
  final int id;
  final String name;
  final String email;
  final String? lastPeriodStartDate;
  final int? averageCycleLength;
  final int? averagePeriodLength;
  final String timezone;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.lastPeriodStartDate,
    this.averageCycleLength,
    this.averagePeriodLength,
    this.timezone = 'UTC',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      lastPeriodStartDate: json['last_period_start_date'] as String?,
      averageCycleLength: json['average_cycle_length'] as int?,
      averagePeriodLength: json['average_period_length'] as int?,
      timezone: json['timezone'] as String? ?? 'UTC',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'last_period_start_date': lastPeriodStartDate,
      'average_cycle_length': averageCycleLength,
      'average_period_length': averagePeriodLength,
      'timezone': timezone,
    };
  }
}
