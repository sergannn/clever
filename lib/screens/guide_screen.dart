import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/app_header.dart';
import '../widgets/menu_bar.dart' as menu;
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'account_screen.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  String _activeTab = 'guide';
  String _selectedChip = 'All';

  final List<String> _chips = [
    'All',
    'Today',
    'Menstrual phase',
    'Follicular phase',
    'Ovulation phase',
    'Luteal phase',
  ];

  void _navigateToTab(String tab) {
    if (tab == 'home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (tab == 'calendar') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CalendarScreen()),
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.getResponsiveValue(context, mobile: 16, tablet: 24),
                vertical: Responsive.getResponsiveValue(context, mobile: 32, tablet: 52),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _chips.map((chip) {
                    final isActive = chip == _selectedChip;
                    return Padding(
                      padding: EdgeInsets.only(
                        right: Responsive.getResponsiveValue(context, mobile: 8, tablet: 12),
                      ),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedChip = chip),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.getResponsiveValue(context, mobile: 12, tablet: 16),
                            vertical: Responsive.getResponsiveValue(context, mobile: 6, tablet: 8),
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF222222)
                                : Colors.transparent,
                            border: Border.all(color: const Color(0xFF222222)),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            chip,
                            style: TextStyle(
                              fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFF222222),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.getResponsiveValue(context, mobile: 16, tablet: 24),
                ),
                child: Column(
                  children: [
                    _GuideArticle(
                      imagePath: 'assets/images/guide_article.jpg',
                      title:
                          'Today\'s the first day — offer a heating pad and her favorite comfort food.',
                      description:
                          'Her period just started. Extra patience and comfort foods can work wonders today...',
                      phase: 'Menstrual Phase',
                    ),
                    const SizedBox(height: 40),
                    _GuideArticle(
                      imagePath: 'assets/images/guide_article.jpg',
                      title:
                          'Today\'s the first day — offer a heating pad and her favorite comfort food.',
                      description:
                          'Her period just started. Extra patience and comfort foods can work wonders today...',
                      phase: 'Menstrual Phase',
                    ),
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

class _GuideArticle extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String phase;

  const _GuideArticle({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 288,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            height: 1.2,
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            height: 1.25,
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              phase,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF888888),
              ),
            ),
            const Text(
              'Read more',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF222222),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

