import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/cycle_calculator.dart';
import '../widgets/app_header.dart';
import '../widgets/menu_bar.dart' as menu;
import '../services/auth_storage_service.dart';
import 'home_screen.dart';
import 'guide_screen.dart';
import 'account_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  String _activeTab = 'calendar';
  DateTime _viewMonth;
  CycleSettings? _settings;

  _CalendarScreenState() : _viewMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await AuthStorageService.getCycleSettings();
    if (!mounted) return;
    setState(() => _settings = settings);
  }

  void _navigateToTab(String tab) {
    if (tab == 'home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (tab == 'guide') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GuideScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              onProfileTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccountScreen()),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.getResponsiveValue(context, mobile: 17, tablet: 24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Responsive.getResponsiveValue(context, mobile: 20, tablet: 40)),
                    Text(
                      'Tracker',
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                        color: const Color(0xFFA0A0A0),
                      ),
                    ),
                    SizedBox(height: Responsive.getResponsiveValue(context, mobile: 16, tablet: 20)),
                    if (_settings == null || !_settings!.hasMinimum)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Complete setup to see cycle phases on the calendar.',
                          style: TextStyle(
                            fontSize: Responsive.getResponsiveFontSize(context, mobile: 14, tablet: 16),
                            color: const Color(0xFF888888),
                          ),
                        ),
                      ),
                    _CalendarCard(
                      viewMonth: _viewMonth,
                      settings: _settings,
                      onPrevMonth: () {
                        setState(() {
                          _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
                        });
                      },
                      onNextMonth: () {
                        setState(() {
                          _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _PhaseLegend(periodLength: _settings?.periodLength ?? 5, cycleLength: _settings?.cycleLength ?? 28),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            menu.AppMenuBar(
              activeTab: _activeTab,
              onTabChanged: _navigateToTab,
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final DateTime viewMonth;
  final CycleSettings? settings;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const _CalendarCard({
    required this.viewMonth,
    required this.settings,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFFDADADA)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: const Color(0xFF222222),
                onPressed: onPrevMonth,
              ),
              Text(
                '${_monthNames[viewMonth.month - 1]} ${viewMonth.year}',
                style: const TextStyle(
                  fontSize: 24,
                  height: 1.33,
                  color: Color(0xFF222222),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: const Color(0xFF222222),
                onPressed: onNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((day) => SizedBox(
                      width: 40,
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          _CalendarGrid(viewMonth: viewMonth, settings: settings),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime viewMonth;
  final CycleSettings? settings;

  const _CalendarGrid({required this.viewMonth, required this.settings});

  @override
  Widget build(BuildContext context) {
    final year = viewMonth.year;
    final month = viewMonth.month;
    final first = DateTime(year, month, 1);
    final last = DateTime(year, month + 1, 0);
    final startWeekday = first.weekday;
    final daysInMonth = last.day;
    final leadingEmpty = startWeekday - 1;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final total = rows * 7;

    final cycleLength = settings?.cycleLength ?? 28;
    final periodLength = settings?.periodLength ?? 5;
    DateTime? cycleStart;
    if (settings?.lastPeriodStartDate != null) {
      cycleStart = DateTime.tryParse(settings!.lastPeriodStartDate!);
    }
    final today = DateTime.now();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: total,
      itemBuilder: (context, index) {
        if (index < leadingEmpty) {
          return const SizedBox.shrink();
        }
        final dayOfMonth = index - leadingEmpty + 1;
        if (dayOfMonth > daysInMonth) {
          return const SizedBox.shrink();
        }
        final date = DateTime(year, month, dayOfMonth);
        int? dayOfCycle;
        String phase = 'follicular';
        if (cycleStart != null) {
          dayOfCycle = CycleCalculator.currentDay(
            cycleStart,
            cycleLength,
            date,
          );
          if (dayOfCycle != null) {
            phase = CycleCalculator.phaseForDay(dayOfCycle, cycleLength, periodLength);
          }
        }
        final isCurrent = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
        final day = _CalendarDay(
          dayOfMonth,
          phase,
          isCurrent: isCurrent,
          dayOfCycle: dayOfCycle,
        );
        return _DayWidget(day: day);
      },
    );
  }
}

class _DayWidget extends StatelessWidget {
  final _CalendarDay day;

  const _DayWidget({required this.day});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color textColor;

    switch (day.phase) {
      case 'menstrual':
        bgColor = const Color(0xFFFDEFEF);
        borderColor = const Color(0xFFE95E5E);
        textColor = const Color(0xFFE95E5E);
        break;
      case 'follicular':
        bgColor = const Color(0xFFF3F9F0);
        borderColor = const Color(0xFF86BF6D);
        textColor = const Color(0xFF86BF6D);
        break;
      case 'ovulation':
      case 'ovulatory':
        bgColor = const Color(0xFFFCF7E7);
        borderColor = const Color(0xFFE4B20E);
        textColor = const Color(0xFFE4B20E);
        break;
      case 'luteal':
        bgColor = const Color(0xFFF5EEFE);
        borderColor = const Color(0xFF9654F4);
        textColor = const Color(0xFF9654F4);
        break;
      default:
        bgColor = Colors.white;
        borderColor = Colors.grey;
        textColor = Colors.black;
    }

    if (day.isCurrent) {
      bgColor = const Color(0xFFD45656);
      textColor = const Color(0xFFFDEFEF);
      borderColor = const Color(0xFFD45656);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          '${day.number}',
          style: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _CalendarDay {
  final int number;
  final String phase;
  final bool isCurrent;
  final int? dayOfCycle;

  _CalendarDay(this.number, this.phase, {this.isCurrent = false, this.dayOfCycle});
}

class _PhaseLegend extends StatelessWidget {
  final int periodLength;
  final int cycleLength;

  const _PhaseLegend({this.periodLength = 5, this.cycleLength = 28});

  @override
  Widget build(BuildContext context) {
    final follicularEnd = (cycleLength * 0.45).floor();
    final ovulatoryEnd = (cycleLength * 0.50).floor();
    return Column(
      children: [
        _LegendItem(
          color: const Color(0xFFE95E5E),
          label: 'Menstrual Phase',
          days: 'Days 1–$periodLength',
        ),
        const SizedBox(height: 16),
        _LegendItem(
          color: const Color(0xFF86BF6D),
          label: 'Follicular Phase',
          days: 'Days ${periodLength + 1}–$follicularEnd',
        ),
        const SizedBox(height: 16),
        _LegendItem(
          color: const Color(0xFFE4B20E),
          label: 'Ovulation Phase',
          days: 'Days ${follicularEnd + 1}–$ovulatoryEnd',
        ),
        const SizedBox(height: 16),
        _LegendItem(
          color: const Color(0xFF9654F4),
          label: 'Luteal Phase',
          days: 'Days ${ovulatoryEnd + 1}–$cycleLength',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String days;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF222222),
              ),
            ),
          ],
        ),
        Text(
          days,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF888888),
          ),
        ),
      ],
    );
  }
}

