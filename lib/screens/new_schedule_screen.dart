import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/exercise_service.dart';

class NewScheduleScreen extends StatefulWidget {
  @override
  _NewScheduleScreenState createState() => _NewScheduleScreenState();
}

class _NewScheduleScreenState extends State<NewScheduleScreen> {
  final ExerciseService _exerciseService = ExerciseService();
  bool _isLoading = true;
  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    await _exerciseService.loadExercises();
    setState(() {
      _exercises = _exerciseService.exercises;
      _isLoading = false;
    });
  }

  // Implement exercise selection based on rules
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Create New Schedule'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // TODO: Implement UI for selecting exercises per day based on rules

    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Schedule'),
      ),
      body: Center(
        child: Text('Exercise Selection UI Goes Here'),
      ),
    );
  }
}
