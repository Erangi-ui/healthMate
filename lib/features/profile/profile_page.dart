import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  String _gender = 'Male';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HealthProvider>(context, listen: false);
    final profile = provider.userProfile;

    _nameController = TextEditingController(text: profile?.name ?? '');
    _heightController = TextEditingController(text: profile?.height.toString() ?? '');
    _weightController = TextEditingController(text: profile?.weight.toString() ?? '');
    _ageController = TextEditingController(text: profile?.age.toString() ?? '');
    _gender = profile?.gender ?? 'Male';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.id;
      if (userId == null) return;
      
      final profile = UserProfile(
        id: Provider.of<HealthProvider>(context, listen: false).userProfile?.id,
        userId: userId.toString(),
        name: _nameController.text,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        gender: _gender,
        age: int.parse(_ageController.text),
      );

      Provider.of<HealthProvider>(context, listen: false).saveProfile(profile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final profile = provider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      decoration: const InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter height' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter weight' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter age' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                      items: ['Male', 'Female']
                          .map((label) => DropdownMenuItem(
                                value: label,
                                child: Text(label),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Save Profile'),
                ),
              ),
              const SizedBox(height: 20),
              if (profile != null) ...[
                const Divider(),
                Text('BMI: ${profile.bmi.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Suggested Calories: ${profile.suggestedCalories.toStringAsFixed(0)} kcal/day',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text('Logged in as: ${authProvider.currentUser?.name ?? 'Unknown'}'),
                subtitle: Text(authProvider.currentUser?.email ?? ''),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    authProvider.logout();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
