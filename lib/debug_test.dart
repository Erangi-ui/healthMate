import 'package:flutter/material.dart';
import 'services/database/database_helper.dart';
import 'models/user.dart';

class DebugTest extends StatelessWidget {
  const DebugTest({super.key});

  Future<void> testRegistration() async {
    try {
      print('Testing database connection...');
      final isConnected = await DatabaseHelper.instance.testConnection();
      print('Database connected: $isConnected');

      if (isConnected) {
        print('Testing user registration...');
        final user = User(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        final userId = await DatabaseHelper.instance.registerUser(user.toMap());
        print('Registration result: $userId');

        if (userId != null) {
          print('Registration successful! User ID: $userId');
          
          // Test login
          final loginResult = await DatabaseHelper.instance.loginUser('test@example.com', 'password123');
          print('Login test result: $loginResult');
        } else {
          print('Registration failed - user might already exist');
        }
      }
    } catch (e) {
      print('Test error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: testRegistration,
          child: const Text('Test Registration'),
        ),
      ),
    );
  }
}