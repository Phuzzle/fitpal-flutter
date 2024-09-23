import 'package:hive/hive.dart';
import '../models/schedule.dart';
import '../models/user_progress.dart';

class StorageService {
  static const String scheduleBox = 'schedules';
  static const String progressBox = 'progress';

  Future<void> init() async {
    print("StorageService: Initializing Hive boxes");
    await Hive.openBox<Schedule>(scheduleBox);
    await Hive.openBox<UserProgress>(progressBox);
    print("StorageService: Hive boxes initialized");
  }

  // Schedule operations
  Future<void> saveSchedule(Schedule schedule) async {
    print("StorageService: Saving schedule with id: ${schedule.id}");
    var box = Hive.box<Schedule>(scheduleBox);
    await box.put(schedule.id, schedule);
    print("StorageService: Schedule saved successfully");
  }

  Schedule? getSchedule(String id) {
    print("StorageService: Getting schedule with id: $id");
    var box = Hive.box<Schedule>(scheduleBox);
    var schedule = box.get(id);
    print("StorageService: Retrieved schedule: ${schedule != null ? 'found' : 'not found'}");
    return schedule;
  }

  // UserProgress operations
  Future<void> saveProgress(UserProgress progress) async {
    print("StorageService: Saving progress for exercise id: ${progress.exerciseId}");
    var box = Hive.box<UserProgress>(progressBox);
    await box.put(progress.exerciseId, progress);
    print("StorageService: Progress saved successfully");
  }

  UserProgress? getProgress(String exerciseId) {
    print("StorageService: Getting progress for exercise id: $exerciseId");
    var box = Hive.box<UserProgress>(progressBox);
    var progress = box.get(exerciseId);
    print("StorageService: Retrieved progress: ${progress != null ? 'found' : 'not found'}");
    return progress;
  }

  List<UserProgress> getProgressList() {
    print("StorageService: Getting all progress entries");
    var box = Hive.box<UserProgress>(progressBox);
    var progressList = box.values.toList();
    print("StorageService: Retrieved ${progressList.length} progress entries");
    return progressList;
  }
}
