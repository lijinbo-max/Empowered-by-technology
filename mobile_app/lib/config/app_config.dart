import 'dart:io' show Platform;

class AppConfig {
  static const String productionUrl = 'https://api.example.com';
  static const String developmentUrl = 'http://localhost:8501';
  
  // 通过环境变量控制开发/生产模式
  // 设置环境变量 FLUTTER_ENV=production 使用生产环境
  static bool get isDevelopment {
    const env = String.fromEnvironment('FLUTTER_ENV', defaultValue: 'development');
    return env != 'production';
  }
  
  static String get baseUrl => isDevelopment ? developmentUrl : productionUrl;
  
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  
  // 调试模式下强制使用开发环境（仅用于开发测试）
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(() {
      inDebugMode = true;
      return true;
    }());
    return inDebugMode;
  }
}