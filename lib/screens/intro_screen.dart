import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/logo.dart';
import 'onboarding_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = Responsive.isSmallScreen(context);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image - покрывает весь экран, включая системные панели
          Positioned.fill(
            child: Image.asset(
              'assets/images/intro_bg.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          // Overlay image - на весь экран по ширине
          Positioned.fill(
            child: Image.asset(
              'assets/images/intro_overlay.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          // Content - обернут в SafeArea, чтобы не перекрывался системными панелями
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.getResponsiveValue(
                  context,
                  mobile: 13,
                  tablet: 20,
                ),
                vertical: Responsive.getResponsiveValue(
                  context,
                  mobile: 40,
                  tablet: 96,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo "Clever" сверху
                  const Logo(isWhite: true),
                  SizedBox(height: Responsive.getResponsiveValue(context, mobile: 20, tablet: 40)),
                  Text(
                    'The smart way to understand her cycle, moods,\nand energy — so you can connect deeper every day.',
                    style: TextStyle(
                      fontSize: Responsive.getResponsiveFontSize(
                        context,
                        mobile: 16,
                        tablet: 18,
                      ),
                      height: 1.25,
                      color: Colors.white,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: Responsive.getResponsiveValue(
                        context,
                        mobile: double.infinity,
                        tablet: 343,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const OnboardingScreen(pageIndex: 0),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF222222),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.getResponsiveValue(
                              context,
                              mobile: 24,
                              tablet: 24,
                            ),
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          minimumSize: Size(
                            Responsive.getResponsiveValue(
                              context,
                              mobile: double.infinity,
                              tablet: 343,
                            ),
                            isSmallScreen ? 50 : 56,
                          ),
                        ),
                        child: Text(
                          'Get started',
                          style: TextStyle(
                            fontSize: Responsive.getResponsiveFontSize(
                              context,
                              mobile: 16,
                              tablet: 18,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

