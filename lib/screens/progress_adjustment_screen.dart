import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/user_progress.dart';

class ProgressAdjustmentScreen extends StatefulWidget {
  const ProgressAdjustmentScreen({super.key});

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
    try {
      var progressList = _storageService.getProgressList();
      setState(() {
        _progressList = progressList;
      });
    } catch (e) {
      print('Error loading progress: $e');
      // You might want to show an error message to the user here
    }
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
          title: const Text('Adjust Progress'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadProgress,
              tooltip: 'Refresh Progress',
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _progressList.length,
          itemBuilder: (context, index) {
            final progress = _progressList[index];
            return ListTile(
              title: Text('Exercise ID: ${progress.exerciseId}'),
              subtitle: Text('Sets: ${progress.sets}, Reps: ${progress.reps}, Weight: ${progress.weight.toStringAsFixed(1)} kg'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController setsController = TextEditingController(text: progress.sets.toString());
                      TextEditingController repsController = TextEditingController(text: progress.reps.toString());
                      TextEditingController weightController = TextEditingController(text: progress.weight.toString());

                      return AlertDialog(
                        title: const Text('Edit Progress'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: const InputDecoration(labelText: 'Sets'),
                              keyboardType: TextInputType.number,
                              controller: setsController,
                            ),
                            TextField(
                              decoration: const InputDecoration(labelText: 'Reps'),
                              keyboardType: TextInputType.number,
                              controller: repsController,
                            ),
                            TextField(
                              decoration: const InputDecoration(labelText: 'Weight'),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              controller: weightController,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text('Save'),
                            onPressed: () {
                              setState(() {
                                progress.sets = int.tryParse(setsController.text) ?? progress.sets;
                                progress.reps = int.tryParse(repsController.text) ?? progress.reps;
                                progress.weight = double.tryParse(weightController.text) ?? progress.weight;
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
