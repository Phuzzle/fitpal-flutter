import 'package:hive/hive.dart';
import '../models/schedule.dart';
import '../models/user_progress.dart';

class StorageService {
  static const String scheduleBox = 'schedules';
  static const String progressBox = 'progress';

  Future<void> init() async {
    await Hive.openBox<Schedule>(scheduleBox);
    await Hive.openBox<UserProgress>(progressBox);
  }

  // Schedule operations
  Future<void> saveSchedule(Schedule schedule) async {
    var box = Hive.box<Schedule>(scheduleBox);
    await box.put(schedule.id, schedule);
  }

  Schedule? getSchedule(String id) {
    var box = Hive.box<Schedule>(scheduleBox);
    return box.get(id);
  }

  // UserProgress operations
  Future<void> saveProgress(UserProgress progress) async {
    var box = Hive.box<UserProgress>(progressBox);
    await box.put(progress.exerciseId, progress);
  }

  UserProgress? getProgress(String exerciseId) {
    var box = Hive.box<UserProgress>(progressBox);
    return box.get(exerciseId);
  }

  List<UserProgress> getProgressList() {
    var box = Hive.box<UserProgress>(progressBox);
    return box.values.toList();
  }
}
