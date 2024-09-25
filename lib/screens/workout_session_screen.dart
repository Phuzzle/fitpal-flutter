import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/progression_service.dart';
import '../services/storage_service.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final List<Exercise> exercises;

  const WorkoutSessionScreen({super.key, required this.exercises});

  @override
  _WorkoutSessionScreenState createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  final ProgressionService _progressionService = ProgressionService();
  final StorageService _storageService = StorageService();
  final Map<String, bool> _completedExercises = {};

  @override
  void initState() {
    super.initState();
    // Initialize completion map
    for (var ex in widget.exercises) {
      _completedExercises[ex.id] = false;
    }
  }

  void _toggleCompletion(String exerciseId) {
    setState(() {
      _completedExercises[exerciseId] = !_completedExercises[exerciseId]!;
    });
  }

  void _saveWorkout() async {
    // Save workout details to storage
    // Update progression
    for (var ex in widget.exercises) {
      if (_completedExercises[ex.id] == true) {
        _progressionService.updateProgress(ex);
        var progress = _progressionService.getProgress(ex);
        _storageService.saveProgress(progress);
      }
    }

    // Navigate back to home
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Session'),
        ),
        body: ListView.builder(
          itemCount: widget.exercises.length,
          itemBuilder: (context, index) {
            final exercise = widget.exercises[index];
            final progress = _progressionService.getProgress(exercise);
            return ListTile(
              title: Text(exercise.name),
              subtitle: Text(
                  'Sets: ${progress.sets}, Reps: ${progress.reps}, Weight: ${exercise.isBodyWeight ? 'Bodyweight' : '${progress.weight} kg'}'),
              trailing: Checkbox(
                value: _completedExercises[exercise.id],
                onChanged: (bool? value) {
                  _toggleCompletion(exercise.id);
                },
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _saveWorkout,
            child: Text('Save Workout'),
          ),
        ));
  }
}
