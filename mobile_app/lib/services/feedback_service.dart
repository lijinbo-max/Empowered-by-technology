import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class FeedbackService {
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

  Future<bool> submitFeedback(String type, String content) async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/feedback'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'type': type,
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
        _setErrorMessage('提交反馈失败: $errorMessage');
      }
      return false;
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}