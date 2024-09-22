import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/exercise.dart';

class ExerciseService {
  List<Exercise> _exercises = [];

  Future<List<Exercise>> loadExercises() async {
    final String response = await rootBundle.loadString('assets/exercises.json');
    final List<dynamic> data = json.decode(response);
    _exercises = data.map((json) => Exercise(
      id: json['id'],
      name: json['name'],
      muscleGroup: json['muscleGroup'],
      isBodyWeight: json['isBodyWeight'],
    )).toList();
    return _exercises;
  }

  List<Exercise> get exercises => _exercises;
}
import '../models/exercise.dart';

class ExerciseService {
  List<Exercise> exercises = [];

  Future<void> loadExercises() async {
    // TODO: Implement actual loading logic, possibly from a database or API
    // For now, we'll just add some dummy data
    exercises = [
      Exercise(name: 'Push-ups', muscleGroup: 'Chest', equipment: 'Bodyweight'),
      Exercise(name: 'Squats', muscleGroup: 'Legs', equipment: 'Bodyweight'),
      Exercise(name: 'Pull-ups', muscleGroup: 'Back', equipment: 'Pull-up Bar'),
      // Add more exercises as needed
    ];
    
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
  }
}
