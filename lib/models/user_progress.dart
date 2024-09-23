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

  @HiveField(4)
  final String exerciseId;

  UserProgress({
    required this.id,
    required this.scheduleId,
    required this.date,
    required this.exerciseData,
    required this.exerciseId,
  });

  int get sets => exerciseData['sets'] as int;
  int get reps => exerciseData['reps'] as int;
  double get weight => exerciseData['weight'] as double;

  set sets(int value) => exerciseData['sets'] = value;
  set reps(int value) => exerciseData['reps'] = value;
  set weight(double value) => exerciseData['weight'] = value;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduleId': scheduleId,
      'date': date,
      'exerciseData': exerciseData,
      'exerciseId': exerciseId,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      id: json['id'],
      scheduleId: json['scheduleId'],
      date: json['date'],
      exerciseData: json['exerciseData'],
      exerciseId: json['exerciseId'],
    );
  }
}
