import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../services/api_service.dart';
import '../services/auth_storage_service.dart';
import 'setup_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Enter email and password');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ApiService.login(email, password);
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.success) {
      final settings = await AuthStorageService.getCycleSettings();
      if (!context.mounted) return;
      if (settings.hasMinimum) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SetupScreen(pageIndex: 0)),
        );
      }
    } else {
      setState(() => _error = result.error ?? 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = Responsive.isSmallScreen(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.getResponsiveValue(
              context,
              mobile: 16,
              tablet: 24,
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isSmallScreen ? 20 : 38),
                Center(
                  child: Image.asset(
                    'assets/images/login_favicon.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(width: 32, height: 32);
                    },
                  ),
                ),
                SizedBox(height: isSmallScreen ? 40 : 60),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveFontSize(
                      context,
                      mobile: 16,
                      tablet: 18,
                    ),
                    color: const Color(0xFF222222),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 24),
                Text(
                  'Welcome back to Clever',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveFontSize(
                      context,
                      mobile: 20,
                      tablet: 24,
                    ),
                    height: 1.2,
                    color: const Color(0xFF222222),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 32),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 18,
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: Color(0xFFE95E5E),
                      fontSize: 14,
                    ),
                  ),
                ],
                SizedBox(height: isSmallScreen ? 24 : 32),
                ElevatedButton(
                  onPressed: _loading ? null : _loginWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.getResponsiveValue(
                        context,
                        mobile: 24,
                        tablet: 32,
                      ),
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    minimumSize: Size(double.infinity, isSmallScreen ? 50 : 56),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Log in with email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => const SetupScreen(pageIndex: 0)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF222222),
                    side: const BorderSide(color: Color(0xFF222222)),
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.getResponsiveValue(
                        context,
                        mobile: 24,
                        tablet: 32,
                      ),
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
                        'assets/images/google_icon.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(width: 20, height: 20);
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Log in with Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(
                          context,
                          mobile: 16,
                          tablet: 18,
                        ),
                        color: const Color(0xFFA0A0A0),
                      ),
                      children: [
                        const TextSpan(text: 'Don\'t have an account yet? '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: Responsive.getResponsiveFontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                ),
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
