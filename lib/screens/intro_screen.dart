import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/responsive.dart';
import '../services/auth_storage_service.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

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
                  // Логотип по центру вверху
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Надпись "Clever" слева
                            Text(
                              'Clever',
                              style: TextStyle(
                                fontSize: Responsive.getResponsiveFontSize(
                                  context,
                                  mobile: 24,
                                  tablet: 28,
                                ),
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // SVG логотип справа
                            SvgPicture.asset(
                              'assets/images/Clever_AIcontent.svg',
                              width: 24,
                              height: 24,
                              placeholderBuilder: (context) => const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  '•',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // Текст "smart..." под логотипом
                        const SizedBox(height: 16),
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
                      ],
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
                        onPressed: () async {
                          if (!context.mounted) return;
                          final token = await AuthStorageService.getToken();
                          final settings = await AuthStorageService.getCycleSettings();
                          if (context.mounted) {
                            if (token != null && token.isNotEmpty && settings.hasMinimum) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const HomeScreen()),
                              );
                            } else {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const OnboardingScreen(pageIndex: 0),
                                ),
                              );
                            }
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

