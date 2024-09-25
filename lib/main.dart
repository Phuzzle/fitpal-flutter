import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/progress_adjustment_screen.dart';
import 'services/storage_service.dart';
import 'models/schedule.dart';
import 'models/exercise.dart';
import 'models/user_progress.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(UserProgressAdapter());
  
  // Initialize storage service
  StorageService storageService = StorageService();
  await storageService.init();
  runApp(WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatelessWidget {
  const WorkoutTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/progress': (context) => ProgressAdjustmentScreen(),
      },
    );
  }
}
