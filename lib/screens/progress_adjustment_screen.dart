import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/user_progress.dart';

class ProgressAdjustmentScreen extends StatefulWidget {
  @override
  _ProgressAdjustmentScreenState createState() => _ProgressAdjustmentScreenState();
}

class _ProgressAdjustmentScreenState extends State<ProgressAdjustmentScreen> {
  final StorageService _storageService = StorageService();
  List<UserProgress> _progressList = [];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  void _loadProgress() async {
    var box = await _storageService.getProgressBox();
    setState(() {
      _progressList = box.values.toList();
    });
  }

  void _updateProgress(UserProgress progress) {
    // Implement UI to update progress fields
    // After updating, save to storage
    _storageService.saveProgress(progress);
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Adjust Progress'),
        ),
        body: ListView.builder(
          itemCount: _progressList.length,
          itemBuilder: (context, index) {
            final progress = _progressList[index];
            return ListTile(
              title: Text('Exercise ID: ${progress.exerciseId}'),
              subtitle: Text('Sets: ${progress.sets}, Reps: ${progress.reps}, Weight: ${progress.weight} kg'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Navigate to a detailed edit screen or show a dialog
                  // For simplicity, show a dialog to edit sets, reps, and weight
                  showDialog(
                    context: context,
                    builder: (context) {
                      int sets = progress.sets;
                      int reps = progress.reps;
                      double weight = progress.weight;

                      return AlertDialog(
                        title: Text('Edit Progress'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'Sets'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                sets = int.tryParse(value) ?? sets;
                              },
                              controller: TextEditingController(text: sets.toString()),
                            ),
                            TextField(
                              decoration: InputDecoration(labelText: 'Reps'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                reps = int.tryParse(value) ?? reps;
                              },
                              controller: TextEditingController(text: reps.toString()),
                            ),
                            TextField(
                              decoration: InputDecoration(labelText: 'Weight'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                weight = double.tryParse(value) ?? weight;
                              },
                              controller: TextEditingController(text: weight.toString()),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text('Save'),
                            onPressed: () {
                              setState(() {
                                progress.sets = sets;
                                progress.reps = reps;
                                progress.weight = weight;
                              });
                              _storageService.saveProgress(progress);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        ));
  }
}
