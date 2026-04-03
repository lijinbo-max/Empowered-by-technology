import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtils {
  // 处理HTTP响应
  static Future<Map<String, dynamic>?> handleResponse(http.Response response) async {
    try {
      final data = json.decode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        print('HTTP Error: ${response.statusCode} - ${data['message'] ?? 'Unknown error'}');
        return null;
      }
    } catch (e) {
      print('Error parsing response: $e');
      return null;
    }
  }

  // 构建请求头
  static Map<String, String> buildHeaders({String? token}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // 处理网络错误
  static String handleNetworkError(dynamic error) {
    if (error is http.ClientException) {
      return '网络连接失败，请检查网络设置';
    } else if (error is FormatException) {
      return '数据解析失败';
    } else if (error is TimeoutException) {
      return '网络请求超时';
    } else {
      return '未知错误，请稍后重试';
    }
  }
}

// 自定义超时异常
class TimeoutException implements Exception {
  final String message;

  TimeoutException([this.message = 'Request timed out']);

  @override
  String toString() => message;
}