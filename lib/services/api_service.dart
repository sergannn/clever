import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/guide_article.dart';
import '../models/home_content.dart';
import '../models/category.dart';

class ApiService {
  // TODO: Замените на ваш реальный URL при необходимости
  static const String baseUrl = 'https://health.panfilius.ru/api/v1';

  static Future<List<GuideArticle>> getGuideArticles({String? categorySlug}) async {
    try {
      final url = categorySlug != null && categorySlug != 'all' && categorySlug != 'All'
          ? '$baseUrl/guide-articles/$categorySlug'
          : '$baseUrl/guide-articles';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> articlesJson = data['data'];
          return articlesJson.map((json) => GuideArticle.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching guide articles: $e');
      return [];
    }
  }

  static Future<List<HomeContent>> getHomeContents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/home-contents'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> contentsJson = data['data'];
          return contentsJson.map((json) => HomeContent.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching home contents: $e');
      return [];
    }
  }

  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> categoriesJson = data['data'];
          return categoriesJson.map((json) => Category.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}

