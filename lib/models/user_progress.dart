import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserProgress {
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
import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 2)
class UserProgress extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String scheduleId;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final Map<String, dynamic> exerciseData;

  UserProgress({
    required this.id,
    required this.scheduleId,
    required this.date,
    required this.exerciseData,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduleId': scheduleId,
      'date': date,
      'exerciseData': exerciseData,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      id: json['id'],
      scheduleId: json['scheduleId'],
      date: json['date'],
      exerciseData: json['exerciseData'],
    );
  }
}
