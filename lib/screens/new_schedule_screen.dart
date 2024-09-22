import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/schedule.dart';
import '../services/exercise_service.dart';
import '../services/storage_service.dart';

class NewScheduleScreen extends StatefulWidget {
  @override
  _NewScheduleScreenState createState() => _NewScheduleScreenState();
}

class _NewScheduleScreenState extends State<NewScheduleScreen> {
  final ExerciseService _exerciseService = ExerciseService();
  final StorageService _storageService = StorageService();
  bool _isLoading = true;
  List<Exercise> _exercises = [];
  Map<String, List<Exercise>> _selectedExercises = {
    'Day 1': [],
    'Day 2': [],
    'Day 3': [],
    'Day 4': [],
    'Day 5': [],
  };

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

  bool _canSelectExercise(String day, Exercise exercise) {
    final dayRules = {
      'Day 1': [
        {'muscleGroup': 'pec dominant compound', 'count': 1},
        {'muscleGroup': 'horizontal back dominant compound', 'count': 1},
        {'muscleGroup': 'shoulder dominant compound', 'count': 1},
        {'muscleGroup': 'vertical back dominant compound', 'count': 1},
      ],
      'Day 2': [
        {'muscleGroup': 'knee dominant compound', 'count': 1},
        {'muscleGroup': 'hip dominant accessory', 'count': 1},
        {'muscleGroup': 'quad dominant accessory', 'count': 1},
        {'muscleGroup': 'calf', 'count': 1},
      ],
      'Day 3': [
        {'muscleGroup': 'shoulder dominant compound', 'count': 1},
        {'muscleGroup': 'vertical back dominant compound', 'count': 1},
        {'muscleGroup': 'pec dominant compound', 'count': 1},
        {'muscleGroup': 'horizontal back dominant compound', 'count': 1},
      ],
      'Day 4': [
        {'muscleGroup': 'hip dominant compound', 'count': 1},
        {'muscleGroup': 'knee dominant compound', 'count': 1},
        {'muscleGroup': 'hip dominant accessory', 'count': 1},
        {'muscleGroup': 'calf', 'count': 1},
      ],
      'Day 5': [
        {'muscleGroup': 'vanity lift', 'count': 6},
      ],
    };

    final rules = dayRules[day]!;
    final selectedCount = _selectedExercises[day]!.where((e) => e.muscleGroup == exercise.muscleGroup).length;
    final rule = rules.firstWhere((r) => r['muscleGroup'] == exercise.muscleGroup, orElse: () => {'count': 0});
    return selectedCount < (rule['count'] as int);
  }

  void _toggleExerciseSelection(String day, Exercise exercise) {
    setState(() {
      if (_selectedExercises[day]!.contains(exercise)) {
        _selectedExercises[day]!.remove(exercise);
      } else if (_canSelectExercise(day, exercise)) {
        _selectedExercises[day]!.add(exercise);
      }
    });
  }

  bool _isScheduleComplete() {
    return _selectedExercises.values.every((dayExercises) => dayExercises.isNotEmpty);
  }

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

    final groupedExercises = _exercises.fold<Map<String, List<Exercise>>>(
      {},
      (map, exercise) {
        if (!map.containsKey(exercise.muscleGroup)) {
          map[exercise.muscleGroup] = [];
        }
        map[exercise.muscleGroup]!.add(exercise);
        return map;
      },
    );

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create New Schedule'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Day 1'),
              Tab(text: 'Day 2'),
              Tab(text: 'Day 3'),
              Tab(text: 'Day 4'),
              Tab(text: 'Day 5'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (var day in ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'])
              ListView(
                children: groupedExercises.entries.map((entry) {
                  return ExpansionTile(
                    title: Text(entry.key),
                    children: entry.value.map((exercise) {
                      final isSelected = _selectedExercises[day]!.contains(exercise);
                      final canSelect = _canSelectExercise(day, exercise);
                      return ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(exercise.muscleGroup),
                        trailing: Icon(
                          isSelected ? Icons.check_box : (canSelect ? Icons.check_box_outline_blank : Icons.block),
                          color: isSelected ? Colors.green : (canSelect ? Colors.grey : Colors.red),
                        ),
                        onTap: canSelect ? () => _toggleExerciseSelection(day, exercise) : null,
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isScheduleComplete() ? () => _saveSchedule(Schedule(id: 'default', weeklySchedule: _selectedExercises)) : null,
          child: Icon(Icons.save),
          backgroundColor: _isScheduleComplete() ? Theme.of(context).primaryColor : Colors.grey,
        ),
      ),
    );
  }

  void _saveSchedule(Schedule newSchedule) async {
    Schedule? existingSchedule = await _storageService.getSchedule('default');
    if (existingSchedule != null) {
      // Show warning dialog
      bool confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Overwrite Existing Schedule'),
          content: Text('Creating a new schedule will overwrite the existing one. Continue?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Overwrite'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    // Save the new schedule
    await _storageService.saveSchedule(newSchedule);

    // Navigate back to home
    Navigator.pop(context);
  }
}
