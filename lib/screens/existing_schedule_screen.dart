import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/schedule.dart';
import 'day_selection_screen.dart';

class ExistingScheduleScreen extends StatefulWidget {
  @override
  _ExistingScheduleScreenState createState() => _ExistingScheduleScreenState();
}

class _ExistingScheduleScreenState extends State<ExistingScheduleScreen> {
  final StorageService _storageService = StorageService();
  List<Schedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    List<Schedule> schedules = await _storageService.getAllSchedules();
    setState(() {
      _schedules = schedules;
    });
  }

  Future<void> _deleteSchedule(String id) async {
    await _storageService.deleteSchedule(id);
    _loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Schedules'),
      ),
      body: _schedules.isEmpty
          ? Center(
              child: Text('No existing schedules found.'),
            )
          : ListView.builder(
              itemCount: _schedules.length,
              itemBuilder: (context, index) {
                Schedule schedule = _schedules[index];
                return ListTile(
                  title: Text('Schedule ${schedule.id}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DaySelectionScreen(schedule: schedule),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteSchedule(schedule.id),
                  ),
                );
              },
            ),
    );
  }
}
