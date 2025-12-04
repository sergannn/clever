import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final int pageIndex;

  const OnboardingScreen({
    super.key,
    this.pageIndex = 0,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  late int _currentPage;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      imagePath: 'assets/images/onboarding_1.jpg',
      iconPath: 'assets/images/favicon.png',
      title: 'Understanding\nPeriods',
      description:
          'Menstruation is a natural monthly process where the uterine lining sheds. It typically lasts 3-7 days and affects every aspect of a woman\'s physical and emotional well-being.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/onboarding_2.jpg',
      iconPath: 'assets/images/favicon.png',
      title: 'The 4 Cycle\nPhases',
      description:
          'Every cycle has 4 distinct phases: Menstrual (days 1-5), Follicular (days 6-13), Ovulation (days 14-15), and Luteal (days 16-28). Each brings different energy levels and needs.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/onboarding_3.jpg',
      iconPath: 'assets/images/favicon.png',
      title: 'How Phases Affect Mood',
      description:
          'Hormonal fluctuations create predictable patterns. Energy peaks around ovulation, then gradually decreases. PMS symptoms often appear in the luteal phase.',
    ),
    OnboardingPage(
      imagePath: 'assets/images/onboarding_4.jpg',
      iconPath: 'assets/images/favicon.png',
      title: 'Why Tracking\nMatters',
      description:
          'Regular tracking helps predict needs and timing. Cycles can vary month to month, so consistent data creates better insights. Your support becomes more targeted and effective.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // После onboarding переходим на Login
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return _buildPage(_pages[index]);
        },
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    final imageHeight = Responsive.getResponsiveValue(
      context,
      mobile: 300,
      tablet: 448,
    );
    final isSmallScreen = Responsive.isSmallScreen(context);
    
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: imageHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      page.imagePath,
                      width: double.infinity,
                      height: imageHeight,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: imageHeight,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 48, color: Colors.grey),
                        );
                      },
                    ),
                    SafeArea(
                      bottom: false,
                      child: Positioned(
                        top: isSmallScreen ? 20 : 38,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Image.asset(
                            page.iconPath,
                            width: 32,
                            height: 32,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(width: 32, height: 32);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  Responsive.getResponsiveValue(
                    context,
                    mobile: 16,
                    tablet: 20,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      page.title,
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 18,
                        ),
                        height: 1.25,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),
                    Text(
                      page.description,
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
                    SizedBox(height: isSmallScreen ? 16 : 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(3),
                            color: index == _currentPage
                                ? const Color(0xFF222222)
                                : const Color(0xFFA0A0A0),
                            border: Border.all(
                              color: index == _currentPage
                                  ? const Color(0xFF222222)
                                  : const Color(0xFFA0A0A0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Responsive.getResponsiveValue(
                      context,
                      mobile: 100,
                      tablet: 120,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Кнопка всегда справа внизу
        Positioned(
          bottom: Responsive.getResponsiveValue(
            context,
            mobile: 20,
            tablet: 24,
          ),
          right: Responsive.getResponsiveValue(
            context,
            mobile: 16,
            tablet: 20,
          ),
          child: ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF222222),
              foregroundColor: Colors.white,
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
                  mobile: 109,
                  tablet: 120,
                ),
                isSmallScreen ? 50 : 56,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentPage < _pages.length - 1 ? 'Next' : 'Get started',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveFontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingPage {
  final String imagePath;
  final String iconPath;
  final String title;
  final String description;

  OnboardingPage({
    required this.imagePath,
    required this.iconPath,
    required this.title,
    required this.description,
  });
}

