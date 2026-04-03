import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class AuthService {
  static String get baseUrl => AppConfig.baseUrl;

  static String? _lastErrorMessage;
  static String? _token;
  static String? _userId;

  static String? get lastErrorMessage => _lastErrorMessage;
  static String? get token => _token;
  static String? get userId => _userId;

  static void _clearErrorMessage() {
    _lastErrorMessage = null;
  }

  static void _setErrorMessage(String message) {
    _lastErrorMessage = message;
  }

  static String _parseErrorResponse(int statusCode, String body) {
    try {
      final data = json.decode(body);
      if (data['error'] != null) {
        return data['error'];
      } else if (data['message'] != null) {
        return data['message'];
      } else if (data['detail'] != null) {
        return data['detail'];
      }
    } catch (e) {
      // JSON解析失败，使用默认错误消息
    }

    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '用户名或密码错误';
      case 403:
        return '没有权限访问';
      case 404:
        return '请求的资源不存在';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务暂时不可用';
      default:
        return '请求失败，请稍后重试';
    }
  }

  static Future<bool> login(String email, String password) async {
    _clearErrorMessage();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        Duration(seconds: AppConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          _token = data['token'];
          _userId = data['user_id']?.toString();
          await _saveToken(data['token']);
          return true;
        } else {
          _setErrorMessage('登录响应中缺少token');
          return false;
        }
      } else {
        final errorMessage = _parseErrorResponse(response.statusCode, response.body);
        _setErrorMessage(errorMessage);
        return false;
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('TimeoutException')) {
        _setErrorMessage('连接超时，请检查网络连接');
      } else if (errorMessage.contains('SocketException')) {
        _setErrorMessage('无法连接到服务器，请检查网络连接');
      } else {
        _setErrorMessage('登录失败: $errorMessage');
      }
      return false;
    }
  }

  static Future<bool> register(String email, String password) async {
    _clearErrorMessage();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        Duration(seconds: AppConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        // 注册成功后自动登录
        final loginSuccess = await login(email, password);
        return loginSuccess;
      } else {
        final errorMessage = _parseErrorResponse(response.statusCode, response.body);
        _setErrorMessage(errorMessage);
        return false;
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('TimeoutException')) {
        _setErrorMessage('连接超时，请检查网络连接');
      } else if (errorMessage.contains('SocketException')) {
        _setErrorMessage('无法连接到服务器，请检查网络连接');
      } else {
        _setErrorMessage('注册失败: $errorMessage');
      }
      return false;
    }
  }

  static Future<void> logout() async {
    await _removeToken();
    _token = null;
    _userId = null;
  }

  static Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        Duration(seconds: AppConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        await _removeToken();
        _setErrorMessage('登录已过期，请重新登录');
        return null;
      } else {
        final errorMessage = _parseErrorResponse(response.statusCode, response.body);
        _setErrorMessage(errorMessage);
        return null;
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('TimeoutException')) {
        _setErrorMessage('连接超时，请检查网络连接');
      } else if (errorMessage.contains('SocketException')) {
        _setErrorMessage('无法连接到服务器，请检查网络连接');
      } else {
        _setErrorMessage('获取用户信息失败: $errorMessage');
      }
      return null;
    }
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}