import 'exercise.dart';

class Schedule {
  final String id;
  final Map<String, List<Exercise>> weeklySchedule; // e.g., Day 1: [Exercise1, Exercise2]

  Schedule({
    required this.id,
    required this.weeklySchedule,
  });
}
