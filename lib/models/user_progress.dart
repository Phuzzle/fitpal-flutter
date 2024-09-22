import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 1)
class UserProgress extends HiveObject {
  @HiveField(0)
  final String exerciseId;

  @HiveField(1)
  int sets;

  @HiveField(2)
  int reps;

  @HiveField(3)
  double weight;

  @HiveField(4)
  DateTime lastUpdated;

  UserProgress({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.lastUpdated,
  });

  void updateProgress({int? newSets, int? newReps, double? newWeight}) {
    if (newSets != null) sets = newSets;
    if (newReps != null) reps = newReps;
    if (newWeight != null) weight = newWeight;
    lastUpdated = DateTime.now();
  }
}
