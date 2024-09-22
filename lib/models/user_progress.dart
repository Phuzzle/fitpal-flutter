import 'exercise.dart';

class UserProgress {
  final String exerciseId;
  int sets;
  int reps;
  double weight;

  UserProgress({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  void updateProgress({int? newSets, int? newReps, double? newWeight}) {
    if (newSets != null) sets = newSets;
    if (newReps != null) reps = newReps;
    if (newWeight != null) weight = newWeight;
  }
}
import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 1)
class UserProgress extends HiveObject {
  @HiveField(0)
  final String exerciseId;

  @HiveField(1)
  final int completedSets;

  @HiveField(2)
  final DateTime lastUpdated;

  UserProgress({
    required this.exerciseId,
    required this.completedSets,
    required this.lastUpdated,
  });
}
