import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../models/health_record.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, provider, child) {
        final records = provider.healthRecords;
        
        // Sort records by date
        records.sort((a, b) => a.date.compareTo(b.date));

        if (records.isEmpty) {
            return const Center(child: Text('No data for reports'));
        }

        // Take last 7 records for weekly view
        final weeklyRecords = records.length > 7 ? records.sublist(records.length - 7) : records;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Reports (Last 7 Entries)'),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Steps'),
                  Tab(text: 'Calories'),
                  Tab(text: 'Water'),
                  Tab(text: 'Sleep'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildChart(weeklyRecords, (r) => r.steps.toDouble(), Colors.green, 'Steps'),
                _buildChart(weeklyRecords, (r) => r.caloriesBurned.toDouble(), Colors.orange, 'Calories'),
                _buildChart(weeklyRecords, (r) => r.waterIntake.toDouble(), Colors.blue, 'Water'),
                _buildChart(weeklyRecords, (r) => r.sleepHours, Colors.deepPurple, 'Sleep'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChart(List<HealthRecord> records, double Function(HealthRecord) getValue, Color color, String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
           Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           const SizedBox(height: 20),
           Expanded(
             child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: records.map((e) => getValue(e)).reduce((a, b) => a > b ? a : b) * 1.2,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < records.length) {
                             // Show only Day part of date
                             return Padding(
                               padding: const EdgeInsets.only(top: 5.0),
                               child: Text(records[index].date.substring(5), style: const TextStyle(fontSize: 10)),
                             );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: records.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: getValue(e.value),
                          color: color,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
             ),
           ),
        ],
      ),
    );
  }
}
