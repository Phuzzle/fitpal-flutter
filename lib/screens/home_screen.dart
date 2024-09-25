import 'package:flutter/material.dart';
import 'new_schedule_screen.dart';
import 'existing_schedule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Create New Schedule'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewScheduleScreen()),
                );
              },
            ),
            ElevatedButton(
              child: const Text('Open Existing Schedule'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExistingScheduleScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
