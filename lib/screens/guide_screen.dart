import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../widgets/app_header.dart';
import '../widgets/menu_bar.dart' as menu;
import '../services/api_service.dart';
import '../models/guide_article.dart';
import '../models/category.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'account_screen.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  String _activeTab = 'guide';
  String _selectedCategorySlug = 'all';
  List<GuideArticle> _articles = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadArticles();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.getCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final articles = await ApiService.getGuideArticles(
        categorySlug: _selectedCategorySlug == 'all' ? null : _selectedCategorySlug,
      );
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onChipSelected(String slug) {
    setState(() {
      _selectedCategorySlug = slug;
    });
    _loadArticles();
  }

  void _navigateToTab(String tab) {
    if (tab == 'home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (tab == 'calendar') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CalendarScreen()),
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
              padding: EdgeInsets.only(
                left: Responsive.getResponsiveValue(context, mobile: 16, tablet: 24),
                right: 0,
                top: Responsive.getResponsiveValue(context, mobile: 32, tablet: 52),
                bottom: Responsive.getResponsiveValue(context, mobile: 32, tablet: 52),
              ),
              child: _isLoadingCategories
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((category) {
                          final isActive = category.slug == _selectedCategorySlug;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: Responsive.getResponsiveValue(context, mobile: 8, tablet: 12),
                            ),
                            child: GestureDetector(
                              onTap: () => _onChipSelected(category.slug),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Responsive.getResponsiveValue(context, mobile: 12, tablet: 16),
                                  vertical: Responsive.getResponsiveValue(context, mobile: 6, tablet: 8),
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF222222)
                                      : Colors.transparent,
                                  border: Border.all(color: const Color(0xFF222222)),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                                    color: isActive
                                        ? Colors.white
                                        : const Color(0xFF222222),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _articles.isEmpty
                      ? Center(
                          child: Text(
                            'No articles found',
                            style: TextStyle(
                              fontSize: Responsive.getResponsiveFontSize(context, mobile: 16, tablet: 18),
                              color: const Color(0xFF888888),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ..._articles.map((article) => Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: _GuideArticle(
                                      article: article,
                                    ),
                                  )),
                              const SizedBox(height: 100),
                            ],
                          ),
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

class _GuideArticle extends StatelessWidget {
  final GuideArticle article;

  const _GuideArticle({
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Фотография на всю ширину
        SizedBox(
          width: double.infinity,
          height: 288,
          child: article.image != null
              ? Image.network(
                  article.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/guide_article.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.asset(
                  'assets/images/guide_article.jpg',
                  fit: BoxFit.cover,
                ),
        ),
        // Текст с отступами
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.getResponsiveValue(context, mobile: 16, tablet: 24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.2,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                article.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.25,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.phase ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const Text(
                    'Read more',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

