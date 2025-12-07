import 'package:flutter/material.dart';
import 'services/database/database_helper.dart';

class DebugDBViewer extends StatefulWidget {
  const DebugDBViewer({super.key});

  @override
  State<DebugDBViewer> createState() => _DebugDBViewerState();
}

class _DebugDBViewerState extends State<DebugDBViewer> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> profiles = [];
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final usersData = await DatabaseHelper.instance.getAllUsers();
    final profilesData = await DatabaseHelper.instance.getAllProfiles();
    final recordsData = await DatabaseHelper.instance.getAllRecords();
    
    setState(() {
      users = usersData;
      profiles = profilesData;
      records = recordsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Viewer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Users (${users.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...users.map((user) => Card(child: ListTile(title: Text('${user['name']} - ${user['email']}')))),
            const SizedBox(height: 20),
            Text('Profiles (${profiles.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...profiles.map((profile) => Card(child: ListTile(title: Text('${profile['name']} - ${profile['age']}y')))),
            const SizedBox(height: 20),
            Text('Records (${records.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...records.map((record) => Card(child: ListTile(title: Text('${record['date']} - ${record['steps']} steps')))),
          ],
        ),
      ),
    );
  }
}