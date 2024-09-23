import 'package:hive/hive.dart';
import 'exercise.dart';

part 'schedule.g.dart';

@HiveType(typeId: 0)
class Schedule extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Map<String, List<Exercise>> weeklySchedule;

  Schedule({
    required this.id,
    required this.weeklySchedule,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weeklySchedule': weeklySchedule.map((key, value) => MapEntry(key, value.map((e) => e.toJson()).toList())),
    };
  }
}
