import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'setup_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = Responsive.isSmallScreen(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.getResponsiveValue(context, mobile: 16, tablet: 24),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isSmallScreen ? 20 : 38),
                Center(
                  child: Image.asset(
                    'assets/images/signup_favicon.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(width: 32, height: 32);
                    },
                  ),
                ),
                SizedBox(height: isSmallScreen ? 40 : 107),
                Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                    color: const Color(0xFF222222),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 39),
                Text(
                  'Let\'s create your Clever Account',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveFontSize(context, mobile: 20, tablet: 24),
                    height: 1.2,
                    color: const Color(0xFF222222),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 40 : 100),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SetupScreen(pageIndex: 0)),
                    );
                  },
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
                    minimumSize: Size(double.infinity, isSmallScreen ? 50 : 56),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/apple_icon.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(width: 20, height: 20);
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sign up with Apple',
                        style: TextStyle(
                          fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                      color: const Color(0xFFA0A0A0),
                    ),
                    children: [
                      const TextSpan(text: 'By continuing, you agree to our '),
                      TextSpan(
                        text: 'Terms of Use ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF222222),
                          fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                        ),
                      ),
                      const TextSpan(text: 'and acknowledge our '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF222222),
                          fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                        ),
                      ),
                      const TextSpan(
                          text: ', which outlines how we use your personal information.'),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                        color: const Color(0xFFA0A0A0),
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF222222),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

