import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class CommunityService {
  static String get baseUrl => AppConfig.baseUrl;

  static String? _lastErrorMessage;

  static String? get lastErrorMessage => _lastErrorMessage;

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
        return '未授权，请重新登录';
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

  Future<List<dynamic>> getPosts() async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/community/posts'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        Duration(seconds: AppConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        _setErrorMessage('登录已过期，请重新登录');
        return [];
      } else {
        final errorMessage = _parseErrorResponse(response.statusCode, response.body);
        _setErrorMessage(errorMessage);
        return [];
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('TimeoutException')) {
        _setErrorMessage('连接超时，请检查网络连接');
      } else if (errorMessage.contains('SocketException')) {
        _setErrorMessage('无法连接到服务器，请检查网络连接');
      } else {
        _setErrorMessage('获取帖子列表失败: $errorMessage');
      }
      return [];
    }
  }

  Future<bool> createPost(String title, String content) async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/community/posts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'title': title,
          'content': content,
        }),
      ).timeout(
        Duration(seconds: AppConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _setErrorMessage('登录已过期，请重新登录');
        return false;
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
        _setErrorMessage('发布帖子失败: $errorMessage');
      }
      return false;
    }
  }

  Future<bool> commentPost(int postId, String content) async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/community/comments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'post_id': postId,
          'content': content,
        }),
      ).timeout(
        Duration(seconds: AppConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _setErrorMessage('登录已过期，请重新登录');
        return false;
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
        _setErrorMessage('评论帖子失败: $errorMessage');
      }
      return false;
    }
  }

  Future<bool> likePost(int postId) async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/community/like'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'post_id': postId,
        }),
      ).timeout(
        Duration(seconds: AppConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        _setErrorMessage('登录已过期，请重新登录');
        return false;
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
        _setErrorMessage('点赞帖子失败: $errorMessage');
      }
      return false;
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}