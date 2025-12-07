import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../health_records/add_record_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, provider, child) {
        final today = provider.todayRecord;
        final profile = provider.userProfile;

        return Scaffold(
          appBar: AppBar(title: const Text('Dashboard')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profile != null) ...[
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('BMI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(profile.bmi.toStringAsFixed(1), style: const TextStyle(fontSize: 24, color: Colors.blue)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('${profile.suggestedCalories.toInt()} kcal', style: const TextStyle(fontSize: 24, color: Colors.orange)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Today's Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    if (today == null)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddRecordPage()),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Today\'s Data'),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard('Steps', '${today?.steps ?? 0}', Icons.directions_walk, Colors.green),
                    _buildStatCard('Calories', '${today?.caloriesBurned ?? 0} kcal', Icons.local_fire_department, Colors.orange),
                    _buildStatCard('Water', '${today?.waterIntake ?? 0} ml', Icons.local_drink, Colors.blue),
                    _buildStatCard('Sleep', '${today?.sleepHours ?? 0} hrs', Icons.bed, Colors.deepPurple),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: SizedBox(height: 100, child: _buildSummaryCard('Weekly', provider.getWeeklySummary(), Colors.blue))),
                    const SizedBox(width: 10),
                    Expanded(child: SizedBox(height: 100, child: _buildSummaryCard('Monthly', provider.getMonthlySummary(), Colors.green))),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(height: 100, child: _buildSummaryCard('Yearly', provider.getYearlySummary(), Colors.orange)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String period, Map<String, int> summary, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(period, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
            Text('Steps: ${summary['steps']}', style: const TextStyle(fontSize: 11)),
            Text('Calories: ${summary['calories']}', style: const TextStyle(fontSize: 11)),
            Text('Water: ${summary['water']} ml', style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
