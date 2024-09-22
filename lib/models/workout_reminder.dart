import 'package:flutter/material.dart';

class WorkoutReminder {
  final String id;
  final String title;
  final TimeOfDay time;

  WorkoutReminder({
    required this.id,
    required this.title,
    required this.time,
  });
}
