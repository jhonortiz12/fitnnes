import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExerciseForm extends StatefulWidget {
  final Function(String, int, List<DateTime>, bool) onAddExercise;

  ExerciseForm({required this.onAddExercise});

  @override
  _ExerciseFormState createState() => _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final _exerciseController = TextEditingController();
  final _durationController = TextEditingController();
  List<DateTime> _selectedDates = [];
  bool _isVolume = false;

  Future<void> _selectDates() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDates.add(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: _exerciseController,
          decoration: InputDecoration(labelText: 'Exercise'),
        ),
        TextField(
          controller: _durationController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Duration (minutes)'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _selectDates,
          child: Text('Select Days'),
        ),
        Wrap(
          children: _selectedDates
              .map((date) => Chip(
                    label: Text(DateFormat('yyyy-MM-dd').format(date)),
                    deleteIcon: Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        _selectedDates.remove(date);
                      });
                    },
                  ))
              .toList(),
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text('Volume'),
            Checkbox(
              value: _isVolume,
              onChanged: (bool? value) {
                setState(() {
                  _isVolume = value ?? false;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final exercise = _exerciseController.text;
            final duration = int.tryParse(_durationController.text) ?? 0;
            if (exercise.isNotEmpty && duration > 0 && _selectedDates.isNotEmpty) {
              widget.onAddExercise(exercise, duration, _selectedDates, _isVolume);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter all fields correctly.'),
                ),
              );
            }
          },
          child: Text('Add Exercise'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
