import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/schedule.dart';
import '../models/user_progress.dart';
import '../models/exercise.dart';
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

  Future<void> _updateExerciseWeight(Schedule schedule) async {
    List<UserProgress> progressList = await _storageService.getProgressList();
    List<UserProgress> scheduleProgress = progressList.where((progress) => progress.scheduleId == schedule.id).toList();

    // Get all exercises for this schedule
    List<Exercise> allExercises = schedule.weeklySchedule.values.expand((e) => e).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Exercise Weights'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: scheduleProgress.length,
              itemBuilder: (context, index) {
                UserProgress progress = scheduleProgress[index];
                Exercise exercise = allExercises.firstWhere((e) => e.id == progress.exerciseId, orElse: () => Exercise(id: '', name: 'Unknown', isBodyWeight: false));
                TextEditingController weightController = TextEditingController(text: progress.weight.toString());
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercise.name, style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  labelText: 'Weight (kg)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('kg'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                List<Widget> textFields = (context.findRenderObject() as RenderBox).findAllChildrenOfType<TextField>();
                for (int i = 0; i < scheduleProgress.length; i++) {
                  UserProgress progress = scheduleProgress[i];
                  TextEditingController weightController = textFields[i].controller as TextEditingController;
                  double newWeight = double.tryParse(weightController.text) ?? progress.weight;
                  progress.weight = newWeight;
                  await _storageService.saveProgress(progress);
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Weights updated successfully')),
                );
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.fitness_center),
                        onPressed: () => _updateExerciseWeight(schedule),
                        tooltip: 'Update weights',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteSchedule(schedule.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
