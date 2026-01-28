import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/cycle_calculator.dart';
import '../widgets/app_header.dart';
import '../widgets/menu_bar.dart' as menu;
import '../services/api_service.dart';
import '../services/auth_storage_service.dart';
import '../models/home_content.dart';
import '../models/cycle_state.dart';
import 'account_screen.dart';
import 'calendar_screen.dart';
import 'guide_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _activeTab = 'home';
  String _selectedChip = 'Today';
  List<HomeContent> _contents = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  CycleState? _cycleState;

  @override
  void initState() {
    super.initState();
    _loadCycleStateAndContents();
  }

  Future<void> _loadCycleStateAndContents() async {
    setState(() {
      _isLoading = true;
      _cycleState = null;
    });

    CycleState? state;
    final token = await AuthStorageService.getToken();
    if (token != null && token.isNotEmpty) {
      state = await ApiService.getCycleState();
    }
    if (state == null || !state.hasData) {
      final settings = await AuthStorageService.getCycleSettings();
      if (settings.hasMinimum) {
        final cycleLength = settings.cycleLength!;
        final periodLength = settings.periodLength!;
        final day = CycleCalculator.currentDay(
          settings.lastPeriodStartDate!,
          cycleLength,
        );
        if (day != null) {
          state = CycleState(
            currentDay: day,
            phase: CycleCalculator.phaseForDay(day, cycleLength, periodLength),
            cycleLength: cycleLength,
            periodLength: periodLength,
            phasePercent: CycleCalculator.phasePercent(day, cycleLength),
            timezone: settings.timezone,
          );
        }
      }
    }

    String? phase = state?.phase;
    int? relativeDay = state?.currentDay;
    final contents = await ApiService.getHomeContents(
      phase: phase,
      relativeDayPosition: relativeDay,
    );
    if (!mounted) return;
    setState(() {
      _cycleState = state;
      _contents = contents;
      _isLoading = false;
    });
  }

  String _displayPhase() {
    if (_cycleState?.phase != null) {
      final p = _cycleState!.phase!;
      return '${p[0].toUpperCase()}${p.substring(1)} Phase';
    }
    if (_contents.isNotEmpty && _contents[_currentIndex].phase != null) {
      final p = _contents[_currentIndex].phase!;
      return '${p[0].toUpperCase()}${p.substring(1)} Phase';
    }
    return 'Menstrual Phase';
  }

  String _displayDay() {
    if (_cycleState?.currentDay != null) return 'Day ${_cycleState!.currentDay}';
    if (_contents.isNotEmpty && _contents[_currentIndex].day != null) {
      return _contents[_currentIndex].day!;
    }
    return 'Day 1';
  }

  String _displayDayOfCycle() {
    if (_cycleState?.currentDay != null && _cycleState?.cycleLength != null) {
      return 'Day ${_cycleState!.currentDay} of ${_cycleState!.cycleLength}';
    }
    if (_contents.isNotEmpty && _contents[_currentIndex].dayOfCycle != null) {
      return _contents[_currentIndex].dayOfCycle!;
    }
    return 'Day 1 of 28';
  }

  void _nextTip() {
    if (_contents.isNotEmpty) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _contents.length;
      });
    }
  }

  void _navigateToTab(String tab) {
    if (tab == 'calendar') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CalendarScreen()),
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.getResponsiveValue(
                  context,
                  mobile: 17,
                  tablet: 24,
                ),
                vertical: Responsive.getResponsiveValue(
                  context,
                  mobile: 32,
                  tablet: 52,
                ),
              ),
              child: Row(
                children: [
                  _Chip(
                    label: 'Today',
                    isActive: _selectedChip == 'Today',
                    onTap: () => setState(() => _selectedChip = 'Today'),
                  ),
                  SizedBox(width: Responsive.getResponsiveValue(context, mobile: 8, tablet: 12)),
                  _Chip(
                    label: 'Tomorrow',
                    isActive: _selectedChip == 'Tomorrow',
                    onTap: () => setState(() => _selectedChip = 'Tomorrow'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  // Фотография на всю ширину экрана
                  SizedBox(
                    width: double.infinity,
                    height: Responsive.getResponsiveValue(
                      context,
                      mobile: 220,
                      tablet: 288,
                    ),
                    child: _contents.isNotEmpty && _contents[_currentIndex].image != null
                        ? Image.network(
                            _contents[_currentIndex].image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/home_phase.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/home_phase.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                  // Остальной контент с padding
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.getResponsiveValue(
                          context,
                          mobile: 17,
                          tablet: 24,
                        ),
                      ),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _contents.isEmpty
                              ? Center(
                                  child: Text(
                                    'No content available',
                                    style: TextStyle(
                                      fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                                      color: const Color(0xFF888888),
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: Responsive.getResponsiveValue(context, mobile: 20, tablet: 27)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _displayPhase(),
                                          style: TextStyle(
                                            fontSize: Responsive.getResponsiveFontSize(
                                              context,
                                              mobile: 24,
                                              tablet: 28,
                                            ),
                                            height: 1.33,
                                            color: const Color(0xFF222222),
                                          ),
                                        ),
                                        Text(
                                          _displayDay(),
                                          style: TextStyle(
                                            fontSize: Responsive.getResponsiveFontSize(
                                              context,
                                              mobile: 16,
                                              tablet: 18,
                                            ),
                                            color: const Color(0xFF222222),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Responsive.getResponsiveValue(context, mobile: 8, tablet: 10)),
                                    Text(
                                      _displayDayOfCycle(),
                                      style: TextStyle(
                                        fontSize: Responsive.getResponsiveFontSize(
                                          context,
                                          mobile: 16,
                                          tablet: 18,
                                        ),
                                        color: const Color(0xFF222222),
                                      ),
                                    ),
                                    SizedBox(height: Responsive.getResponsiveValue(context, mobile: 20, tablet: 29)),
                                    Text(
                                      _contents[_currentIndex].shortText ?? _contents[_currentIndex].description,
                                      style: TextStyle(
                                        fontSize: Responsive.getResponsiveFontSize(
                                          context,
                                          mobile: 20,
                                          tablet: 22,
                                        ),
                                        height: 1.2,
                                        color: const Color(0xFF222222),
                                      ),
                                    ),
                                //    SizedBox(height: Responsive.getResponsiveValue(context, mobile: 120, tablet: 140)),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: _contents.length > 1 ? _nextTip : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF222222),
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Responsive.getResponsiveValue(context, mobile: 24, tablet: 24),
                                            vertical: 18,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          minimumSize: Size(
                                            Responsive.getResponsiveValue(context, mobile: 134, tablet: 150),
                                            Responsive.isSmallScreen(context) ? 50 : 56,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Next Tip',
                                              style: TextStyle(
                                                fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.chevron_right, size: 20),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Responsive.getResponsiveValue(context, mobile: 120, tablet: 140)),
                                  ],
                                ),
                    ),
                  ),
                ],
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

class _Chip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF222222) : Colors.transparent,
          border: Border.all(color: const Color(0xFF222222)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? Colors.white : const Color(0xFF222222),
          ),
        ),
      ),
    );
  }
}

