import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class SimpleAuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  static Future<bool> register(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final List<dynamic> users = jsonDecode(usersJson);

      // Check if user exists
      final exists = users.any((u) => u['email'] == email);
      if (exists) return false;

      // Add new user
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
      );
      
      users.add(user.toMap());
      await prefs.setString(_usersKey, jsonEncode(users));
      await prefs.setString(_currentUserKey, jsonEncode(user.toMap()));
      
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  static Future<User?> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '[]';
      final List<dynamic> users = jsonDecode(usersJson);

      final userMap = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );

      if (userMap != null) {
        final user = User.fromMap(userMap);
        await prefs.setString(_currentUserKey, jsonEncode(user.toMap()));
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);
      if (userJson != null) {
        return User.fromMap(jsonDecode(userJson));
      }
      return null;
    } catch (e) {
      debugPrint('Get current user error: $e');
      return null;
    }
  }
}