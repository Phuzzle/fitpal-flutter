import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/schedule.dart';
import 'day_selection_screen.dart';

class ExistingScheduleScreen extends StatelessWidget {
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    // Fetch all schedules from storage
    // For simplicity, assume a single schedule with id 'default'

    Schedule? schedule = _storageService.getSchedule('default');

    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Schedule'),
      ),
      body: schedule == null
          ? Center(
              child: Text('No existing schedule found.'),
            )
          : ListTile(
              title: Text('Default Schedule'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DaySelectionScreen(schedule: schedule),
                  ),
                );
              },
            ),
    );
  }
}
