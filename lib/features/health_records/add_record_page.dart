import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/health_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/health_record.dart';

class AddRecordPage extends StatefulWidget {
  final HealthRecord? record;

  const AddRecordPage({super.key, this.record});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _stepsController;
  late TextEditingController _caloriesController;
  late TextEditingController _waterController;
  late TextEditingController _sleepController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.record?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _stepsController = TextEditingController(text: widget.record?.steps.toString() ?? '');
    _caloriesController = TextEditingController(text: widget.record?.caloriesBurned.toString() ?? '');
    _waterController = TextEditingController(text: widget.record?.waterIntake.toString() ?? '');
    _sleepController = TextEditingController(text: widget.record?.sleepHours.toString() ?? '');
  }

  @override
  void dispose() {
    _dateController.dispose();
    _stepsController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();
    _sleepController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.id;
      if (userId == null) return;
      
      final record = HealthRecord(
        id: widget.record?.id,
        userId: userId.toString(),
        date: _dateController.text,
        steps: int.tryParse(_stepsController.text) ?? 0,
        caloriesBurned: int.tryParse(_caloriesController.text) ?? 0,
        waterIntake: int.tryParse(_waterController.text) ?? 0,
        sleepHours: double.tryParse(_sleepController.text) ?? 0.0,
      );

      print('Saving record: ${record.toMap()}');
      
      if (widget.record == null) {
        await Provider.of<HealthProvider>(context, listen: false).addRecord(record);
      } else {
        await Provider.of<HealthProvider>(context, listen: false).updateRecord(record);
      }
      
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'Add Record' : 'Edit Record'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today, color: Colors.teal),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) => value!.isEmpty ? 'Select date' : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _stepsController,
                  decoration: const InputDecoration(labelText: 'Steps', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter steps' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _caloriesController,
                  decoration: const InputDecoration(labelText: 'Calories Burned', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter calories' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _waterController,
                  decoration: const InputDecoration(labelText: 'Water Intake (ml)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter water intake' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _sleepController,
                  decoration: const InputDecoration(labelText: 'Sleep Hours', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter sleep hours' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveRecord,
                    child: const Text('Save Record'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}