import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


const String baseUrl = 'http://192.168.1.131:5000/api';

class AuthService {
  static const String tokenKey = 'jwt_token';
   Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }
  static Future<http.Response> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? otp,
  }) {
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      if (otp != null) 'otp': otp,
    };
    return http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> login(String email, String password) {
    return http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  static Future<http.Response> forgotPassword({
    required String email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
  }) {
    final body = {
      'email': email,
      if (otp != null) 'otp': otp,
      if (newPassword != null) 'newPassword': newPassword,
      if (confirmPassword != null) 'confirmPassword': confirmPassword,
    };
    return http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
