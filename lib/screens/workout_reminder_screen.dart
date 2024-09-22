import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/user_profile.dart';

class WorkoutReminderScreen extends StatefulWidget {
  @override
  _WorkoutReminderScreenState createState() => _WorkoutReminderScreenState();
}

class _WorkoutReminderScreenState extends State<WorkoutReminderScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  UserProfile? _userProfile;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _initNotifications();
  }

  void _loadUserProfile() async {
    DocumentSnapshot snapshot = await _firestore.collection('users')
        .doc(_firestore.currentUser!.uid)
        .get();
    setState(() {
      _userProfile = UserProfile.fromMap(snapshot.data() as Map<String, dynamic>);
      _reminderTime = TimeOfDay.fromDateTime(
          DateTime.fromMillisecondsSinceEpoch(_userProfile!.reminderTime));
    });
  }

  void _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  void _setReminder(TimeOfDay time) async {
    final now = DateTime.now();
    final reminderDateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    await _firestore.collection('users')
        .doc(_firestore.currentUser!.uid)
        .update({'reminderTime': reminderDateTime.millisecondsSinceEpoch});

    await _notificationsPlugin.zonedSchedule(
      0,
      'Workout Reminder',
      'Time to work out!',
      _getTrigger(reminderDateTime),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_reminder_channel',
          'Workout Reminder Channel',
          channelDescription: 'Reminds you to work out',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    setState(() {
      _reminderTime = time;
    });
  }

  TzonedSchedule _getTrigger(DateTime reminderDateTime) {
    return TzonedSchedule(
      reminderDateTime,
      const Duration(seconds: 0),
      const PeriodicTimeZoneRule(
        startZone: null,
        endZone: null,
        startOffset: Duration(seconds: 0),
        endOffset: Duration(seconds: 0),
        period: Duration(days: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Reminder'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_userProfile != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Reminder: ${_reminderTime?.format(context) ?? 'Not Set'}',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: _reminderTime ?? TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        _setReminder(selectedTime);
                      }
                    },
                    child: Text('Set Reminder'),
                  ),
                ],
              ),
            if (_userProfile == null)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
