import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/database/database_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userData = await DatabaseHelper.instance.loginUser(email, password);
      if (userData != null) {
        _currentUser = User.fromMap(userData);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = User(name: name, email: email, password: password);
      final userId = await DatabaseHelper.instance.registerUser(user.toMap());
      
      if (userId != null) {
        _currentUser = User(id: userId.toString(), name: name, email: email, password: password);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email already exists or registration failed';
      }
    } catch (e) {
      _errorMessage = 'Registration error: $e';
      debugPrint('Registration error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}