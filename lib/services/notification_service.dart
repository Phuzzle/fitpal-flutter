import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/workout_reminder.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<WorkoutReminder> _reminders = [];

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(WorkoutReminder reminder) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'workout_reminder_channel',
      'Workout Reminder',
      channelDescription: 'Reminds you to do your workout',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      reminder.time.hour,
      reminder.time.minute,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      int.parse(reminder.id),
      reminder.title,
      'Time for your workout!',
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    _reminders.add(reminder);
  }

  void cancelNotification(String id) {
    _flutterLocalNotificationsPlugin.cancel(int.parse(id));
    _reminders.removeWhere((reminder) => reminder.id == id);
  }

  List<WorkoutReminder> getReminders() {
    return _reminders;
  }
}
