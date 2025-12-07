import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../models/health_record.dart';
import '../services/database/database_helper.dart';

class HealthProvider with ChangeNotifier {
  UserProfile? _userProfile;
  List<HealthRecord> _healthRecords = [];
  HealthRecord? _todayRecord;
  String? _currentUserId;

  UserProfile? get userProfile => _userProfile;
  List<HealthRecord> get healthRecords => _healthRecords;
  HealthRecord? get todayRecord => _todayRecord;

  HealthProvider();

  void initializeForUser(String userId) {
    setCurrentUserId(userId);
    loadProfile(userId);
    loadRecords(userId);
  }

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    print('Set current user ID: $userId');
  }

  Future<void> _testDatabaseConnection() async {
    final isConnected = await DatabaseHelper.instance.testConnection();
    if (!isConnected) {
      debugPrint('Warning: Database connection failed');
    } else {
      debugPrint('Database connection successful');
      await DatabaseHelper.instance.getDatabasePath();
    }
  }

  Future<void> loadProfile([String? userId]) async {
    if (userId == null) return;
    final data = await DatabaseHelper.instance.getProfile(userId);
    if (data != null) {
      _userProfile = UserProfile.fromMap(data);
    }
    notifyListeners();
  }

  Future<void> saveProfile(UserProfile profile) async {
    await DatabaseHelper.instance.insertProfile(profile.toMap());
    await loadProfile(_currentUserId); 
  }

  Future<void> loadRecords([String? userId]) async {
    if (userId == null) return;
    
    try {
      final data = await DatabaseHelper.instance.getRecords(userId);
      _healthRecords = data.map((e) => HealthRecord.fromMap(e)).toList();
      print('Loaded ${_healthRecords.length} records for user $userId');
      
      await loadTodayRecord(userId);
      notifyListeners();
    } catch (e) {
      print('Error loading records: $e');
    }
  }
  
  Future<void> loadTodayRecord([String? userId]) async {
    if (userId == null) return;
    
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final data = await DatabaseHelper.instance.getRecordByDate(userId, today);
    if (data != null) {
        _todayRecord = HealthRecord.fromMap(data);
    } else {
        _todayRecord = null;
    }
    notifyListeners();
  }

  Future<void> addRecord(HealthRecord record) async {
    try {
      print('Adding record for user: ${record.userId}');
      print('Record data: ${record.toMap()}');
      await DatabaseHelper.instance.insertRecord(record.toMap());
      print('Record inserted successfully');
      
      // Reload records immediately
      if (_currentUserId != null) {
        await loadRecords(_currentUserId);
      }
      
      print('Total records after insert: ${_healthRecords.length}');
    } catch (e) {
      print('Error adding record: $e');
      rethrow;
    }
  }

  Future<void> updateRecord(HealthRecord record) async {
    await DatabaseHelper.instance.updateRecord(record.toMap());
    await loadRecords(_currentUserId);
  }

  Future<void> deleteRecord(String id) async {
    await DatabaseHelper.instance.deleteRecord(id);
    await loadRecords(_currentUserId);
  }
  
  List<HealthRecord> filterRecords(String query) {
      if (query.isEmpty) return _healthRecords;
      return _healthRecords.where((record) => record.date.contains(query)).toList();
  }

  Map<String, int> getWeeklySummary() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekRecords = _healthRecords.where((r) {
      final date = DateTime.parse(r.date);
      return date.isAfter(weekStart.subtract(const Duration(days: 1))) && date.isBefore(now.add(const Duration(days: 1)));
    }).toList();
    
    return {
      'steps': weekRecords.fold(0, (sum, r) => sum + r.steps),
      'calories': weekRecords.fold(0, (sum, r) => sum + r.caloriesBurned),
      'water': weekRecords.fold(0, (sum, r) => sum + r.waterIntake),
    };
  }

  Map<String, int> getMonthlySummary() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthRecords = _healthRecords.where((r) {
      final date = DateTime.parse(r.date);
      return date.isAfter(monthStart.subtract(const Duration(days: 1))) && date.isBefore(now.add(const Duration(days: 1)));
    }).toList();
    
    return {
      'steps': monthRecords.fold(0, (sum, r) => sum + r.steps),
      'calories': monthRecords.fold(0, (sum, r) => sum + r.caloriesBurned),
      'water': monthRecords.fold(0, (sum, r) => sum + r.waterIntake),
    };
  }

  Map<String, int> getYearlySummary() {
    final now = DateTime.now();
    final yearStart = DateTime(now.year, 1, 1);
    final yearRecords = _healthRecords.where((r) {
      final date = DateTime.parse(r.date);
      return date.isAfter(yearStart.subtract(const Duration(days: 1))) && date.isBefore(now.add(const Duration(days: 1)));
    }).toList();
    
    return {
      'steps': yearRecords.fold(0, (sum, r) => sum + r.steps),
      'calories': yearRecords.fold(0, (sum, r) => sum + r.caloriesBurned),
      'water': yearRecords.fold(0, (sum, r) => sum + r.waterIntake),
    };
  }

  void clearData() {
    _userProfile = null;
    _healthRecords = [];
    _todayRecord = null;
    _currentUserId = null;
    notifyListeners();
  }
}