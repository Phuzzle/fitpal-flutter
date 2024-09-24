import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/progression_service.dart';
import '../services/storage_service.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final List<Exercise> exercises;

  WorkoutSessionScreen({required this.exercises});

  @override
  _WorkoutSessionScreenState createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  final ProgressionService _progressionService = ProgressionService();
  final StorageService _storageService = StorageService();
  Map<String, bool> _completedExercises = {};
  Map<String, TextEditingController> _weightControllers = {};

  @override
  void initState() {
    super.initState();
    widget.exercises.forEach((ex) {
      _completedExercises[ex.id] = false;
      var progress = _progressionService.getProgress(ex);
      _weightControllers[ex.id] = TextEditingController(text: progress.weight.toString());
    });
  }

  @override
  void dispose() {
    _weightControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _toggleCompletion(String exerciseId) {
    setState(() {
      _completedExercises[exerciseId] = !_completedExercises[exerciseId]!;
    });
  }

  void _saveWorkout() async {
    widget.exercises.forEach((ex) {
      if (_completedExercises[ex.id] == true) {
        var progress = _progressionService.getProgress(ex);
        double newWeight = double.tryParse(_weightControllers[ex.id]!.text) ?? progress.weight;
        progress.updateProgress(weight: newWeight);
        _progressionService.updateProgress(ex);
        _storageService.saveProgress(progress);
      }
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Session'),
      ),
      body: ListView.builder(
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          final exercise = widget.exercises[index];
          final progress = _progressionService.getProgress(exercise);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Sets: ${progress.sets}, Reps: ${progress.reps}'),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightControllers[exercise.id],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
                          ),
                          enabled: !exercise.isBodyWeight,
                        ),
                      ),
                      SizedBox(width: 16),
                      Checkbox(
                        value: _completedExercises[exercise.id],
                        onChanged: (bool? value) {
                          _toggleCompletion(exercise.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text('Save Workout'),
          onPressed: _saveWorkout,
        ),
      ),
    );
  }
}
