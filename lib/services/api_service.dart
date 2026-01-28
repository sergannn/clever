import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/guide_article.dart';
import '../models/home_content.dart';
import '../models/category.dart';
import '../models/user.dart';
import '../models/cycle_state.dart';
import 'auth_storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://health.panfilius.ru/api/v1';

  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthStorageService.getToken();
    if (token == null || token.isEmpty) return {};
    return {'Authorization': 'Bearer $token'};
  }

  /// Register: name, email, password, password_confirmation; optional cycle fields.
  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? lastPeriodStartDate,
    int? averageCycleLength,
    int? averagePeriodLength,
    String? timezone,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    if (lastPeriodStartDate != null) body['last_period_start_date'] = lastPeriodStartDate;
    if (averageCycleLength != null) body['average_cycle_length'] = averageCycleLength;
    if (averagePeriodLength != null) body['average_period_length'] = averagePeriodLength;
    if (timezone != null) body['timezone'] = timezone;

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(body),
    );
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final d = data['data'] as Map<String, dynamic>;
      final user = User.fromJson(d['user'] as Map<String, dynamic>);
      final token = d['token'] as String;
      await AuthStorageService.setToken(token);
      await AuthStorageService.setUser(user);
      if (user.lastPeriodStartDate != null && user.averageCycleLength != null && user.averagePeriodLength != null) {
        await AuthStorageService.setCycleSettings(
          lastPeriodStartDate: user.lastPeriodStartDate,
          cycleLength: user.averageCycleLength,
          periodLength: user.averagePeriodLength,
          timezone: user.timezone,
        );
      }
      return AuthResponse(success: true, user: user);
    }
    return AuthResponse(
      success: false,
      error: (data['message'] as String?) ?? (data['errors'] != null ? jsonEncode(data['errors']) : 'Registration failed'),
    );
  }

  /// Login with email and password.
  static Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final d = data['data'] as Map<String, dynamic>;
      final user = User.fromJson(d['user'] as Map<String, dynamic>);
      final token = d['token'] as String;
      await AuthStorageService.setToken(token);
      await AuthStorageService.setUser(user);
      if (user.lastPeriodStartDate != null && user.averageCycleLength != null && user.averagePeriodLength != null) {
        await AuthStorageService.setCycleSettings(
          lastPeriodStartDate: user.lastPeriodStartDate,
          cycleLength: user.averageCycleLength,
          periodLength: user.averagePeriodLength,
          timezone: user.timezone,
        );
      }
      return AuthResponse(success: true, user: user);
    }
    return AuthResponse(
      success: false,
      error: (data['message'] as String?) ?? 'Invalid email or password',
    );
  }

  static Future<void> logout() async {
    final headers = await _authHeaders();
    try {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Accept': 'application/json', ...headers},
      );
    } catch (_) {}
    await AuthStorageService.clearAll();
  }

  static Future<User?> getUser() async {
    final headers = await _authHeaders();
    if (headers.isEmpty) return null;
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {...headers, 'Accept': 'application/json'},
    );
    if (response.statusCode != 200) return null;
    final data = json.decode(response.body) as Map<String, dynamic>;
    final d = data['data'] as Map<String, dynamic>?;
    if (d == null) return null;
    final user = User.fromJson(d['user'] as Map<String, dynamic>);
    await AuthStorageService.setUser(user);
    return user;
  }

  static Future<bool> updateUser({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    String? lastPeriodStartDate,
    int? averageCycleLength,
    int? averagePeriodLength,
    String? timezone,
  }) async {
    final headers = await _authHeaders();
    if (headers.isEmpty) return false;
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;
    if (passwordConfirmation != null) body['password_confirmation'] = passwordConfirmation;
    if (lastPeriodStartDate != null) body['last_period_start_date'] = lastPeriodStartDate;
    if (averageCycleLength != null) body['average_cycle_length'] = averageCycleLength;
    if (averagePeriodLength != null) body['average_period_length'] = averagePeriodLength;
    if (timezone != null) body['timezone'] = timezone;

    final response = await http.put(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json', ...headers},
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) return false;
    final data = json.decode(response.body) as Map<String, dynamic>;
    final d = data['data'] as Map<String, dynamic>?;
    if (d != null && d['user'] != null) {
      await AuthStorageService.setUser(User.fromJson(d['user'] as Map<String, dynamic>));
    }
    return true;
  }

  static Future<bool> deleteAccount(String password) async {
    final headers = await _authHeaders();
    if (headers.isEmpty) return false;
    final response = await http.delete(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json', ...headers},
      body: jsonEncode({'password': password}),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      await AuthStorageService.clearAll();
      return true;
    }
    return false;
  }

  static Future<CycleState?> getCycleState() async {
    final headers = await _authHeaders();
    if (headers.isEmpty) return null;
    final response = await http.get(
      Uri.parse('$baseUrl/cycle-state'),
      headers: {...headers, 'Accept': 'application/json'},
    );
    if (response.statusCode != 200) return null;
    final data = json.decode(response.body) as Map<String, dynamic>;
    final d = data['data'] as Map<String, dynamic>?;
    if (d == null) return null;
    return CycleState.fromJson(d);
  }

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

  /// Tips filtered by phase and/or relative_day_position. Sends Bearer if token exists.
  static Future<List<HomeContent>> getHomeContents({
    String? phase,
    int? relativeDayPosition,
  }) async {
    try {
      final query = <String>[];
      if (phase != null && phase.isNotEmpty) query.add('phase=$phase');
      if (relativeDayPosition != null) query.add('relative_day_position=$relativeDayPosition');
      final qs = query.isEmpty ? '' : '?${query.join('&')}';
      final headers = await _authHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/home-contents$qs'),
        headers: {'Accept': 'application/json', ...headers},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> contentsJson = data['data'] as List<dynamic>;
          return contentsJson.map((j) => HomeContent.fromJson(j as Map<String, dynamic>)).toList();
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

class AuthResponse {
  final bool success;
  final User? user;
  final String? error;

  AuthResponse({required this.success, this.user, this.error});
}

