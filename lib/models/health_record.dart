class HealthRecord {
  final String? id;
  final String userId;
  final String date;
  final int steps;
  final int caloriesBurned;
  final int waterIntake;
  final double sleepHours;

  HealthRecord({
    this.id,
    required this.userId,
    required this.date,
    required this.steps,
    required this.caloriesBurned,
    required this.waterIntake,
    required this.sleepHours,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'date': date,
      'steps': steps,
      'caloriesBurned': caloriesBurned,
      'waterIntake': waterIntake,
      'sleepHours': sleepHours,
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id']?.toString(),
      userId: map['userId']?.toString() ?? '',
      date: map['date'] ?? '',
      steps: map['steps'] ?? 0,
      caloriesBurned: map['caloriesBurned'] ?? 0,
      waterIntake: map['waterIntake'] ?? 0,
      sleepHours: map['sleepHours'] is int 
          ? (map['sleepHours'] as int).toDouble() 
          : (map['sleepHours'] ?? 0.0),
    );
  }
}