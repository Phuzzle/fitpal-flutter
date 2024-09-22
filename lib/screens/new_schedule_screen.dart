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

  final Map<String, List<Map<String, dynamic>>> dayRules = {
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
    final rules = dayRules[day]!;
    final selectedCount = _selectedExercises[day]!.where((e) => e.muscleGroup == exercise.muscleGroup).length;
    final rule = rules.firstWhere((r) => r['muscleGroup'] == exercise.muscleGroup, orElse: () => {'count': 0});
    return selectedCount < (rule['count'] as int);
  }

  void _toggleExerciseSelection(String day, Exercise exercise) {
    print('Toggling exercise: ${exercise.name} for $day'); // Debug print
    setState(() {
      if (_selectedExercises[day]!.contains(exercise)) {
        print('Removing exercise'); // Debug print
        _selectedExercises[day]!.remove(exercise);
      } else if (_canSelectExercise(day, exercise)) {
        print('Adding exercise'); // Debug print
        _selectedExercises[day]!.add(exercise);
      } else {
        print('Cannot select exercise'); // Debug print
      }
    });
    print('Selected exercises for $day: ${_selectedExercises[day]!.map((e) => e.name).join(', ')}'); // Debug print
  }

  bool _isScheduleComplete() {
    return dayRules.entries.every((entry) {
      String day = entry.key;
      List<Map<String, dynamic>> rules = entry.value;
      return rules.every((rule) {
        int requiredCount = rule['count'] as int;
        int selectedCount = _selectedExercises[day]!
            .where((e) => e.muscleGroup == rule['muscleGroup'])
            .length;
        return selectedCount == requiredCount;
      });
    });
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Rules for $day:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...dayRules[day]!.map((rule) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: Text('${rule['count']} ${rule['muscleGroup']}'),
                  )),
                  Expanded(
                    child: ListView(
                      children: groupedExercises.entries.map((entry) {
                        return ExpansionTile(
                          title: Text(entry.key),
                          children: entry.value.map((exercise) {
                            final isSelected = _selectedExercises[day]!.contains(exercise);
                            final canSelect = _canSelectExercise(day, exercise);
                            return GestureDetector(
                              onTap: () {
                                print('Tapped on ${exercise.name}'); // Debug print
                                if (canSelect) {
                                  _toggleExerciseSelection(day, exercise);
                                } else {
                                  print('Cannot select ${exercise.name}'); // Debug print
                                }
                              },
                              child: ListTile(
                                title: Text(exercise.name),
                                subtitle: Text(exercise.muscleGroup),
                                trailing: Icon(
                                  isSelected ? Icons.check_box : (canSelect ? Icons.check_box_outline_blank : Icons.block),
                                  color: isSelected ? Colors.green : (canSelect ? Colors.grey : Colors.red),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
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
