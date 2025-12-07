class UserProfile {
  final String? id;
  final String userId;
  final String name;
  final double height; // in cm
  final double weight; // in kg
  final String gender;
  final int age;

  UserProfile({
    this.id,
    required this.userId,
    required this.name,
    required this.height,
    required this.weight,
    required this.gender,
    required this.age,
  });

  // BMI Calculation
  double get bmi {
    if (height <= 0) return 0;
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  // Suggested Daily Calorie Intake (Mifflin-St Jeor Equation)
  double get suggestedCalories {
    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }
    return bmr * 1.2; 
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'name': name,
      'height': height,
      'weight': weight,
      'gender': gender,
      'age': age,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id']?.toString(),
      userId: map['userId']?.toString() ?? '',
      name: map['name'] ?? '',
      height: (map['height'] ?? 0.0).toDouble(),
      weight: (map['weight'] ?? 0.0).toDouble(),
      gender: map['gender'] ?? 'Male',
      age: map['age'] ?? 0,
    );
  }
}
