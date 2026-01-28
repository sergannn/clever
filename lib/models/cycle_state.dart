/// Current cycle state (from API or local calculation).
class CycleState {
  final int? currentDay;
  final String? phase;
  final int? cycleLength;
  final int? periodLength;
  final double? phasePercent;
  final String timezone;

  CycleState({
    this.currentDay,
    this.phase,
    this.cycleLength,
    this.periodLength,
    this.phasePercent,
    this.timezone = 'UTC',
  });

  factory CycleState.fromJson(Map<String, dynamic> json) {
    return CycleState(
      currentDay: json['current_day'] as int?,
      phase: json['phase'] as String?,
      cycleLength: json['cycle_length'] as int?,
      periodLength: json['period_length'] as int?,
      phasePercent: (json['phase_percent'] as num?)?.toDouble(),
      timezone: json['timezone'] as String? ?? 'UTC',
    );
  }

  bool get hasData => currentDay != null && phase != null;
}
