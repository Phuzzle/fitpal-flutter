import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/schedule.dart';
import '../services/exercise_service.dart';
import '../services/storage_service.dart';

class NewScheduleScreen extends StatefulWidget {
  @override
  _NewScheduleScreenState createState() => _NewScheduleScreenState();
}

class _NewScheduleScreenState extends State<NewScheduleScreen> {
  final ExerciseService _exerciseService = ExerciseService();
  final StorageService _storageService = StorageService();
  bool _isLoading = true;
  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    await _exerciseService.loadExercises();
    setState(() {
      _exercises = _exerciseService.exercises;
      _isLoading = false;
    });
  }

  // Implement exercise selection based on rules
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Create New Schedule'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Schedule'),
      ),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          final exercise = _exercises[index];
          return ListTile(
            title: Text(exercise.name),
            subtitle: Text('${exercise.muscleGroup} - ${exercise.equipment}'),
            trailing: Icon(exercise.isBodyWeight ? Icons.person : Icons.fitness_center),
            onTap: () {
              // TODO: Implement exercise selection logic
              print('Selected exercise: ${exercise.name}');
            },
          );
        },
      ),
    );
  }

  void _saveSchedule(Schedule newSchedule) async {
    Schedule? existingSchedule = await _storageService.getSchedule('default');
    if (existingSchedule != null) {
      // Show warning dialog
      bool confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Overwrite Existing Schedule'),
          content: Text('Creating a new schedule will overwrite the existing one. Continue?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Overwrite'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    // Save the new schedule
    await _storageService.saveSchedule(newSchedule);

    // Navigate back to home
    Navigator.pop(context);
  }
}
