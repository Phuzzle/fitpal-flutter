import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/workout_reminder.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final NotificationService _notificationService = NotificationService();
  List<WorkoutReminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() {
    setState(() {
      _reminders = _notificationService.getReminders();
    });
  }

  void _addReminder() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        TimeOfDay time = TimeOfDay.now();

        return AlertDialog(
          title: const Text('Add Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextButton(
                child: const Text('Select Time'),
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );
                  if (selectedTime != null) {
                    setState(() {
                      time = selectedTime;
                    });
                  }
                },
              ),
              Text('${time.hour}:${time.minute}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final reminder = WorkoutReminder(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                  time: time,
                );
                _notificationService.scheduleNotification(reminder);
                setState(() {
                  _reminders.add(reminder);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Reminders'),
      ),
      body: ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          return ListTile(
            title: Text(reminder.title),
            subtitle: Text('${reminder.time.hour}:${reminder.time.minute}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _notificationService.cancelNotification(reminder.id);
                setState(() {
                  _reminders.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: Icon(Icons.add),
      ),
    );
  }
}
