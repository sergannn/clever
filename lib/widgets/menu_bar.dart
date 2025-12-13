import 'package:flutter/material.dart';

class AppMenuBar extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChanged;

  const AppMenuBar({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MenuItem(
            icon: Icons.home,
            label: 'Home',
            isActive: activeTab == 'home',
            onTap: () => onTabChanged('home'),
          ),
          const SizedBox(width: 64),
          _MenuItem(
            icon: Icons.calendar_today,
            label: 'Calendar',
            isActive: activeTab == 'calendar',
            onTap: () => onTabChanged('calendar'),
          ),
          const SizedBox(width: 64),
          _MenuItem(
            icon: Icons.book,
            label: 'Guide',
            isActive: activeTab == 'guide',
            onTap: () => onTabChanged('guide'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? const Color(0xFF222222) : const Color(0xFF7C7C7C),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? const Color(0xFF222222) : const Color(0xFF7C7C7C),
            ),
          ),
        ],
      ),
    );
  }
}

