import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/app_header.dart';
import '../widgets/menu_bar.dart' as menu;
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
                    _CalendarCard(),
                    const SizedBox(height: 20),
                    _PhaseLegend(),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
                onPressed: () {},
              ),
              const Text(
                'September',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.33,
                  color: Color(0xFF222222),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {},
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
          _CalendarGrid(),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final List<_CalendarDay> days = [
    _CalendarDay(1, 'menstrual'),
    _CalendarDay(2, 'menstrual'),
    _CalendarDay(3, 'menstrual'),
    _CalendarDay(4, 'menstrual'),
    _CalendarDay(5, 'menstrual', isCurrent: true),
    _CalendarDay(6, 'follicular'),
    _CalendarDay(7, 'follicular'),
    _CalendarDay(8, 'follicular'),
    _CalendarDay(9, 'follicular'),
    _CalendarDay(10, 'follicular'),
    _CalendarDay(11, 'follicular'),
    _CalendarDay(12, 'follicular'),
    _CalendarDay(13, 'follicular'),
    _CalendarDay(14, 'ovulation'),
    _CalendarDay(15, 'ovulation'),
    _CalendarDay(16, 'luteal'),
    _CalendarDay(17, 'luteal'),
    _CalendarDay(18, 'luteal'),
    _CalendarDay(19, 'luteal'),
    _CalendarDay(20, 'luteal'),
    _CalendarDay(21, 'luteal'),
    _CalendarDay(22, 'luteal'),
    _CalendarDay(23, 'luteal'),
    _CalendarDay(24, 'luteal'),
    _CalendarDay(25, 'luteal'),
    _CalendarDay(26, 'luteal'),
    _CalendarDay(27, 'luteal'),
    _CalendarDay(28, 'luteal'),
    _CalendarDay(29, 'follicular'),
    _CalendarDay(30, 'follicular'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
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

  _CalendarDay(this.number, this.phase, {this.isCurrent = false});
}

class _PhaseLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LegendItem(
          color: const Color(0xFFE95E5E),
          label: 'Menstrual Phase',
          days: 'Days 1–5',
        ),
        const SizedBox(height: 16),
        _LegendItem(
          color: const Color(0xFF86BF6D),
          label: 'Follicular Phase',
          days: 'Days 6–13',
        ),
        const SizedBox(height: 16),
        _LegendItem(
          color: const Color(0xFFE4B20E),
          label: 'Ovulation Phase',
          days: 'Days 14–15',
        ),
        const SizedBox(height: 16),
        _LegendItem(
          color: const Color(0xFF9654F4),
          label: 'Luteal Phase',
          days: 'Days 16–28',
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

