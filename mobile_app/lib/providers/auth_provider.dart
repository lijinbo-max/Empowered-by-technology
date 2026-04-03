import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  String? _userId;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  String? get userId => _userId;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _errorMessage = null;
    notifyListeners();
    
    final success = await AuthService.login(email, password);
    
    if (success) {
      _isLoggedIn = true;
      _token = AuthService.token;
      _userId = AuthService.userId;
      notifyListeners();
      return true;
    } else {
      _errorMessage = AuthService.lastErrorMessage ?? '登录失败，请稍后重试';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _errorMessage = null;
    notifyListeners();
    
    final success = await AuthService.register(email, password);
    
    if (success) {
      return true;
    } else {
      _errorMessage = AuthService.lastErrorMessage ?? '注册失败，请稍后重试';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isLoggedIn = false;
    _token = null;
    _userId = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    final userInfo = await AuthService.getUserInfo();
    if (userInfo != null) {
      _userId = userInfo['id']?.toString();
      notifyListeners();
    }
    return userInfo;
  }

  void setToken(String token) {
    _token = token;
    _isLoggedIn = true;
    _errorMessage = null;
    notifyListeners();
  }

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}