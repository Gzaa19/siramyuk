import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isLoggedIn = false;
  String? _currentUser;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  // Demo users for local authentication
  final Map<String, String> _users = {
    'user@example.com': 'password123',
    'admin@siramyuk.com': 'admin123',
    'demo': 'demo',
  };

  bool login(String email, String password) {
    _errorMessage = null;

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan password tidak boleh kosong';
      notifyListeners();
      return false;
    }

    if (_users.containsKey(email) && _users[email] == password) {
      _isLoggedIn = true;
      _currentUser = email;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Email atau password salah';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  bool register(String email, String password, String confirmPassword) {
    _errorMessage = null;

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan password tidak boleh kosong';
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Password tidak cocok';
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password minimal 6 karakter';
      notifyListeners();
      return false;
    }

    if (_users.containsKey(email)) {
      _errorMessage = 'Email sudah terdaftar';
      notifyListeners();
      return false;
    }

    _users[email] = password;
    _isLoggedIn = true;
    _currentUser = email;
    notifyListeners();
    return true;
  }

  void resetPassword(String email) {
    _errorMessage = null;
    if (_users.containsKey(email)) {
      // In a real app, this would send an email
      // For local demo, just show success
      _errorMessage = 'Link reset password telah dikirim ke $email';
    } else {
      _errorMessage = 'Email tidak terdaftar';
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
