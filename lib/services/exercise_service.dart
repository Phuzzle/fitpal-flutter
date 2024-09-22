import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/exercise.dart';

class ExerciseService {
  List<Exercise> _exercises = [];

  Future<List<Exercise>> loadExercises() async {
    try {
      final String response = await rootBundle.loadString('assets/exercises.json');
      final List<dynamic> data = json.decode(response);
      _exercises = data.map((json) => Exercise(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        muscleGroup: json['muscleGroup']?.toString() ?? '',
        equipment: json['equipment']?.toString() ?? '',
        isBodyWeight: json['isBodyWeight'] ?? false,
      )).toList();
      return _exercises;
    } catch (e) {
      print('Error loading exercises: $e');
      return [];
    }
  }

  List<Exercise> get exercises => _exercises;

  // For testing purposes, you can keep this method
  Future<void> loadDummyExercises() async {
    _exercises = [
      Exercise(id: '1', name: 'Push-ups', muscleGroup: 'Chest', equipment: 'Bodyweight', isBodyWeight: true),
      Exercise(id: '2', name: 'Squats', muscleGroup: 'Legs', equipment: 'Bodyweight', isBodyWeight: true),
      Exercise(id: '3', name: 'Pull-ups', muscleGroup: 'Back', equipment: 'Pull-up Bar', isBodyWeight: true),
    ];
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
  }
}
