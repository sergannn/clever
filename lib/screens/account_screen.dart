import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/app_header.dart';
import '../widgets/menu_bar.dart' as menu;
import 'home_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _dailyReminders = true;
  bool _phaseUpdates = false;
  bool _cleverNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              onProfileTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.getResponsiveValue(context, mobile: 16, tablet: 24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Responsive.getResponsiveValue(context, mobile: 40, tablet: 72)),
                    Text(
                      'Your Account',
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                        color: const Color(0xFF222222),
                      ),
                    ),
                    SizedBox(height: Responsive.getResponsiveValue(context, mobile: 24, tablet: 44)),
                    _AccountInfo(),
                    const SizedBox(height: 40),
                    _PremiumCard(),
                    const SizedBox(height: 40),
                    _NotificationsSection(
                      dailyReminders: _dailyReminders,
                      phaseUpdates: _phaseUpdates,
                      cleverNotifications: _cleverNotifications,
                      onDailyRemindersChanged: (value) =>
                          setState(() => _dailyReminders = value),
                      onPhaseUpdatesChanged: (value) =>
                          setState(() => _phaseUpdates = value),
                      onCleverNotificationsChanged: (value) =>
                          setState(() => _cleverNotifications = value),
                    ),
                    const SizedBox(height: 40),
                    _DeleteAccountSection(),
                    const SizedBox(height: 40),
                    _ContactSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            menu.AppMenuBar(
              activeTab: 'home',
              onTabChanged: (tab) {
                if (tab == 'home') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(label: 'Plan:', value: 'Free'),
        const SizedBox(height: 8),
        _InfoRow(label: 'Email:', value: 'john@gmail.com'),
        const SizedBox(height: 8),
        _InfoRow(label: 'Status:', value: 'Active'),
        const SizedBox(height: 8),
        _InfoRow(label: 'Member since:', value: 'Jan 2024'),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 101,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF888888),
            ),
          ),
        ),
        const SizedBox(width: 45),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF222222),
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
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
          double.infinity,
          Responsive.isSmallScreen(context) ? 50 : 56,
        ),
      ),
      child: Text(
        'Share your feedback',
        style: TextStyle(
          fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  final bool dailyReminders;
  final bool phaseUpdates;
  final bool cleverNotifications;
  final ValueChanged<bool> onDailyRemindersChanged;
  final ValueChanged<bool> onPhaseUpdatesChanged;
  final ValueChanged<bool> onCleverNotificationsChanged;

  const _NotificationsSection({
    required this.dailyReminders,
    required this.phaseUpdates,
    required this.cleverNotifications,
    required this.onDailyRemindersChanged,
    required this.onPhaseUpdatesChanged,
    required this.onCleverNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 40),
        const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF888888),
          ),
        ),
        _NotificationItem(
          title: 'Daily reminders',
          description: 'Today\'s tips and phase updates',
          value: dailyReminders,
          onChanged: onDailyRemindersChanged,
        ),
        const SizedBox(height: 20),
        _NotificationItem(
          title: 'Phase updates',
          description: 'New phase notification',
          value: phaseUpdates,
          onChanged: onPhaseUpdatesChanged,
        ),
        const SizedBox(height: 20),
        _NotificationItem(
          title: 'Clever notifications',
          description: 'Product updates and clever news',
          value: cleverNotifications,
          onChanged: onCleverNotificationsChanged,
        ),
      ],
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationItem({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.2,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF222222),
        ),
      ],
    );
  }
}

class _DeleteAccountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delete Account',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF888888),
          ),
        ),
        const Divider(height: 40),
        const Text(
          'You can delete your Clever account at any time. This action is permanent and can\'t be undone.',
          style: TextStyle(
            fontSize: 16,
            height: 1.25,
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE95E5E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            minimumSize: const Size(153, 56),
          ),
          child: const Text(
            'Delete Account',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Information and contacts',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF888888),
          ),
        ),
        const Divider(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 9,
          mainAxisSpacing: 8,
          childAspectRatio: 4,
          children: const [
            _ContactLink('clever.day'),
            _ContactLink('Data Privacy'),
            _ContactLink('LinkedIn'),
            _ContactLink('Legal Notice'),
            _ContactLink('Instagram'),
            _ContactLink('hi@clever.day'),
          ],
        ),
      ],
    );
  }
}

class _ContactLink extends StatelessWidget {
  final String text;

  const _ContactLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF222222),
      ),
    );
  }
}

