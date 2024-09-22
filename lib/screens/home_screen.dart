import 'package:flutter/material.dart';
import 'new_schedule_screen.dart';
import 'existing_schedule_screen.dart';
import 'progress_adjustment_screen.dart';
import 'reminder_screen.dart';
import 'workout_analytics_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Create New Schedule'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewScheduleScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Open Existing Schedule'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExistingScheduleScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Adjust Progress'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProgressAdjustmentScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('Set Workout Reminders'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderScreen()),
                );
              },
            ),
            ElevatedButton(
              child: Text('View Workout Analytics'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutAnalyticsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
