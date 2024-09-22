import 'exercise.dart';

class Workout {
  final String id;
  final List<Exercise> exercises;
  final DateTime date;

  Workout({
    required this.id,
    required this.exercises,
    required this.date,
  });
}
