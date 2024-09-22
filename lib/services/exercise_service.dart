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
