import 'package:flutter/material.dart';
import 'logo.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const AppHeader({
    super.key,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 17, right: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Logo(),
          if (onProfileTap != null)
            GestureDetector(
              onTap: onProfileTap,
              child: const Icon(
                Icons.account_circle,
                size: 24,
                color: Color(0xFF222222),
              ),
            ),
        ],
      ),
    );
  }
}

