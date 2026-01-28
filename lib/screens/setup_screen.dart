import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/responsive.dart';
import 'home_screen.dart';

class SetupScreen extends StatefulWidget {
  final int pageIndex;

  const SetupScreen({
    super.key,
    this.pageIndex = 0,
  });

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late PageController _pageController;
  late int _currentPage;
  DateTime? _lastPeriodDate;
  int _cycleLength = 28;
  int _periodLength = 5;

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
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Завершение setup - переход на Home
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 5)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _lastPeriodDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildPage(index);
        },
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildSetup1();
      case 1:
        return _buildSetup2();
      case 2:
        return _buildSetup3();
      case 3:
        return _buildSetup4();
      default:
        return const SizedBox();
    }
  }

  Widget _buildSetup1() {
    final isSmallScreen = Responsive.isSmallScreen(context);
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.getResponsiveValue(
            context,
            mobile: 16,
            tablet: 24,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              SizedBox(height: isSmallScreen ? 20 : 38),
              Center(
                child: SvgPicture.asset(
                  'assets/images/Clever_AIcontent.svg',
                  width: 48,
                  height: 48,
                  placeholderBuilder: (context) => const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(color: Colors.grey),
                  ),
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(width: 48, height: 48);
                  },
                ),
              ),
              SizedBox(height: isSmallScreen ? 60 : 138),
              Text(
                'Let\'s set it up',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(
                    context,
                    mobile: 16,
                    tablet: 18,
                  ),
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              Text(
                'When did her last period start?',
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
              SizedBox(height: isSmallScreen ? 16 : 20),
              Text(
                'This date marks Day 1 of her current cycle — the first day of bleeding. If you\'re unsure, just pick the most recent day she mentioned her period started. You can always adjust it later in the app settings.',
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
              SizedBox(height: Responsive.getResponsiveValue(context, mobile: 30, tablet: 40)),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.getResponsiveValue(context, mobile: 22, tablet: 24),
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFA0A0A0)),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _lastPeriodDate != null
                            ? DateFormat('MMM dd, yyyy').format(_lastPeriodDate!)
                            : 'Last period start date',
                        style: TextStyle(
                          fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                          color: _lastPeriodDate != null
                              ? const Color(0xFF222222)
                              : const Color(0xFFA0A0A0),
                        ),
                      ),
                      const Icon(Icons.calendar_today, size: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Responsive.getResponsiveValue(context, mobile: 40, tablet: 60)),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _previousPage,
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _lastPeriodDate != null ? _nextPage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      minimumSize: const Size(109, 56),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.chevron_right, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetup2() {
    final isSmallScreen = Responsive.isSmallScreen(context);
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.getResponsiveValue(context, mobile: 16, tablet: 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              SizedBox(height: isSmallScreen ? 20 : 38),
              Center(
                child: SvgPicture.asset(
                  'assets/images/Clever_AIcontent.svg',
                  width: 48,
                  height: 48,
                  placeholderBuilder: (context) => const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(color: Colors.grey),
                  ),
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(width: 48, height: 48);
                  },
                ),
              ),
              SizedBox(height: isSmallScreen ? 60 : 138),
              Text(
                'Let\'s set it up',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              Text(
                'What\'s her cycle length?',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, mobile: 24, tablet: 28),
                  height: 1.33,
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              Text(
                'Most cycles are 28 days, but they can range from 21-35 days. If you\'re unsure, start with 28 days - you can always adjust this later in the app settings.',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, mobile: 20, tablet: 22),
                  height: 1.2,
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: Responsive.getResponsiveValue(context, mobile: 40, tablet: 60)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_cycleLength > 21) {
                      setState(() => _cycleLength--);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Text(
                  '$_cycleLength',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveFontSize(context, mobile: 32, tablet: 36),
                    height: 1.25,
                    color: const Color(0xFF222222),
                  ),
                ),
                SizedBox(width: Responsive.getResponsiveValue(context, mobile: 30, tablet: 40)),
                IconButton(
                  onPressed: () {
                    if (_cycleLength < 35) {
                      setState(() => _cycleLength++);
                    }
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.getResponsiveValue(context, mobile: 40, tablet: 60)),
            Padding(
              padding: EdgeInsets.only(
                bottom: Responsive.getResponsiveValue(context, mobile: 16, tablet: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _previousPage,
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
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
                        Responsive.getResponsiveValue(context, mobile: 109, tablet: 120),
                        Responsive.isSmallScreen(context) ? 50 : 56,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetup3() {
    final isSmallScreen = Responsive.isSmallScreen(context);
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.getResponsiveValue(context, mobile: 16, tablet: 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              SizedBox(height: isSmallScreen ? 20 : 38),
              Center(
                child: SvgPicture.asset(
                  'assets/images/Clever_AIcontent.svg',
                  width: 48,
                  height: 48,
                  placeholderBuilder: (context) => const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(color: Colors.grey),
                  ),
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(width: 48, height: 48);
                  },
                ),
              ),
              SizedBox(height: isSmallScreen ? 60 : 138),
              Text(
                'Let\'s set it up',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              Text(
                'How long does her period last?',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, mobile: 24, tablet: 28),
                  height: 1.33,
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              Text(
                'A period usually lasts 3–7 days, when the body naturally sheds the uterine lining. This phase can affect her energy and mood, so tracking it helps Clever give more accurate tips.',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, mobile: 20, tablet: 22),
                  height: 1.2,
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: Responsive.getResponsiveValue(context, mobile: 40, tablet: 60)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (_periodLength > 3) {
                      setState(() => _periodLength--);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                SizedBox(width: Responsive.getResponsiveValue(context, mobile: 30, tablet: 40)),
                Text(
                  '$_periodLength',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveFontSize(context, mobile: 32, tablet: 36),
                    height: 1.25,
                    color: const Color(0xFF222222),
                  ),
                ),
                SizedBox(width: Responsive.getResponsiveValue(context, mobile: 30, tablet: 40)),
                IconButton(
                  onPressed: () {
                    if (_periodLength < 7) {
                      setState(() => _periodLength++);
                    }
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.getResponsiveValue(context, mobile: 40, tablet: 60)),
            Padding(
              padding: EdgeInsets.only(
                bottom: Responsive.getResponsiveValue(context, mobile: 16, tablet: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _previousPage,
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
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
                        Responsive.getResponsiveValue(context, mobile: 109, tablet: 120),
                        Responsive.isSmallScreen(context) ? 50 : 56,
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetup4() {
    final isSmallScreen = Responsive.isSmallScreen(context);
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.getResponsiveValue(context, mobile: 16, tablet: 24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              SizedBox(height: isSmallScreen ? 20 : 38),
              Center(
                child: SvgPicture.asset(
                  'assets/images/Clever_AIcontent.svg',
                  width: 48,
                  height: 48,
                  placeholderBuilder: (context) => const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(color: Colors.grey),
                  ),
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(width: 48, height: 48);
                  },
                ),
              ),
              SizedBox(height: isSmallScreen ? 60 : 138),
              Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              Text(
                'You are all set up!',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, mobile: 24, tablet: 28),
                  height: 1.33,
                  color: const Color(0xFF222222),
                ),
              ),
              SizedBox(height: Responsive.getResponsiveValue(context, mobile: 40, tablet: 60)),
              Padding(
                padding: EdgeInsets.only(
                  bottom: Responsive.getResponsiveValue(context, mobile: 16, tablet: 20),
                ),
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.getResponsiveValue(context, mobile: 24, tablet: 32),
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
                    'Let\'s Go!',
                    style: TextStyle(
                      fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }
}

