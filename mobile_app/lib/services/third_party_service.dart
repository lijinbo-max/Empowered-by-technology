import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ThirdPartyService {
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

  Future<bool> connectLinkedIn(String code) async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/third-party/linkedin/connect'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'code': code,
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
        _setErrorMessage('连接LinkedIn失败: $errorMessage');
      }
      return false;
    }
  }

  Future<List<dynamic>> getLinkedInJobs() async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/third-party/linkedin/jobs'),
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
        _setErrorMessage('获取LinkedIn职位失败: $errorMessage');
      }
      return [];
    }
  }

  Future<List<dynamic>> getIndeedJobs(String keyword) async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return [];
      }

      final encodedKeyword = Uri.encodeComponent(keyword);
      final response = await http.get(
        Uri.parse('$baseUrl/api/third-party/indeed/jobs?keyword=$encodedKeyword'),
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
        _setErrorMessage('获取Indeed职位失败: $errorMessage');
      }
      return [];
    }
  }

  Future<Map<String, dynamic>?> startCareerAssessment(String type) async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return null;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/third-party/assessment/start'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'type': type,
        }),
      ).timeout(
        Duration(seconds: AppConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
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
        _setErrorMessage('开始职业测评失败: $errorMessage');
      }
      return null;
    }
  }

  Future<bool> submitAssessmentAnswers(int assessmentId, Map<String, dynamic> answers) async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/third-party/assessment/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'assessment_id': assessmentId,
          'answers': answers,
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
        _setErrorMessage('提交测评答案失败: $errorMessage');
      }
      return false;
    }
  }

  Future<List<dynamic>> getSkillCertifications() async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/third-party/certification/list'),
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
        _setErrorMessage('获取技能认证失败: $errorMessage');
      }
      return [];
    }
  }

  Future<List<dynamic>> searchOnlineCourses(String keyword) async {
    _clearErrorMessage();
    try {
      final token = await _getToken();
      if (token == null) {
        _setErrorMessage('未登录，请先登录');
        return [];
      }

      final encodedKeyword = Uri.encodeComponent(keyword);
      final response = await http.get(
        Uri.parse('$baseUrl/api/third-party/learning/courses?keyword=$encodedKeyword'),
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
        _setErrorMessage('搜索在线课程失败: $errorMessage');
      }
      return [];
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}