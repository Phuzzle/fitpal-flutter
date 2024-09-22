import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'workout_session_screen.dart';
import '../models/schedule.dart';
import '../models/exercise.dart';

class DaySelectionScreen extends StatelessWidget {
  final Schedule schedule;
  final StorageService storageService = StorageService();

  DaySelectionScreen({required this.schedule});

  @override
  Widget build(BuildContext context) {
    List<String> days = schedule.weeklySchedule.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Day to Exercise'),
      ),
      body: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          String day = days[index];
          return ListTile(
            title: Text(day),
            onTap: () {
              // Check if day is already completed
              // For simplicity, navigate to workout session
              List<Exercise> exercises = schedule.weeklySchedule[day]!;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutSessionScreen(exercises: exercises),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
