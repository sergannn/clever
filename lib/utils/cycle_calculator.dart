/// Cycle calculator by ТЗ formulas.
/// current_day = ((today - last_period_start_date) mod cycle_length) + 1
/// Phases: menstrual 1..period_length, follicular until 45%, ovulatory 45–50%, luteal rest.
class CycleCalculator {
  static const String phaseMenstrual = 'menstrual';
  static const String phaseFollicular = 'follicular';
  static const String phaseOvulatory = 'ovulatory';
  static const String phaseLuteal = 'luteal';

  /// [lastPeriodStart] YYYY-MM-DD or DateTime.
  /// [today] default is now (device date, start of day).
  /// Returns 1..cycleLength or null if invalid.
  static int? currentDay(
    Object lastPeriodStart,
    int cycleLength,
    [DateTime? today,
  ]) {
    final start = _toDate(lastPeriodStart);
    if (start == null) return null;
    final end = today ?? DateTime.now();
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    if (endDay.isBefore(startDay)) return null;
    final daysDiff = endDay.difference(startDay).inDays;
    return (daysDiff % cycleLength) + 1;
  }

  static DateTime? _toDate(Object v) {
    if (v is DateTime) return v;
    if (v is String) {
      final d = DateTime.tryParse(v);
      return d;
    }
    return null;
  }

  /// Phase by ТЗ: menstrual 1–period_length, follicular to 45%, ovulatory 45–50%, luteal rest.
  static String phaseForDay(int dayOfCycle, int cycleLength, int periodLength) {
    final pct = (dayOfCycle / cycleLength) * 100;
    if (dayOfCycle <= periodLength) return phaseMenstrual;
    if (pct < 45) return phaseFollicular;
    if (pct < 50) return phaseOvulatory;
    return phaseLuteal;
  }

  /// Returns phase percent (0..100) for the given day.
  static double phasePercent(int dayOfCycle, int cycleLength) {
    return (dayOfCycle / cycleLength) * 100;
  }
}
