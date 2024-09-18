import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/exercise_form.dart';
import '../widgets/user_info_form.dart';
import '../widgets/food_entry_form.dart'; // Asegúrate de importar el formulario de alimentos aquí

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final List<Map<String, dynamic>> _exercises = [];
  final List<Map<String, dynamic>> _foods = [];
  String? _name;
  String? _weight;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _initializeExercises();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedWeight = prefs.getString('weight');
    
    if (storedName == null || storedWeight == null) {
      _showUserInfoDialog();
    } else {
      setState(() {
        _name = storedName;
        _weight = storedWeight;
      });
    }
  }

  void _initializeExercises() {
    setState(() {
      _exercises.addAll([
        {
          'exercise': 'Push-ups', 
          'duration': 15, 
          'days': [DateTime.now()],
          'isVolume': false,
        },
        {
          'exercise': 'Squats', 
          'duration': 20, 
          'days': [DateTime.now().add(Duration(days: 1))],
          'isVolume': false,
        },
      ]);
    });
  }

  void _addExercise(String exercise, int duration, List<DateTime> days, bool isVolume) {
    setState(() {
      _exercises.add({
        'exercise': exercise,
        'duration': duration,
        'days': days,
        'isVolume': isVolume,
      });
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _addFood(String food, double quantity, double calories, double protein, double carbs, double fat) {
    setState(() {
      _foods.add({
        'food': food,
        'quantity': quantity,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      });
    });
  }

  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add Exercise'),
          content: ExerciseForm(onAddExercise: _addExercise),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddFoodDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add Food'),
          content: FoodEntryForm(onAddFood: _addFood),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showUserInfoDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Enter Your Info'),
          content: UserInfoForm(onSaveUserInfo: _saveUserInfo),
        );
      },
    );
  }

  Future<void> _saveUserInfo(String name, String weight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('weight', weight);
    setState(() {
      _name = name;
      _weight = weight;
    });
  }

  String _formatDates(List<DateTime> dates) {
    return dates.map((date) {
      return '${date.day}/${date.month}/${date.year}';
    }).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise and Food List'),
        actions: [
          if (_name != null)
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('User Info'),
                      content: Text('Name: $_name\nWeight: $_weight kg'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_name != null && _weight != null)
              Text(
                'Welcome, $_name!\nYour current weight: $_weight kg',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Text(
                    'Exercises:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ..._exercises.map((exercise) {
                    final days = exercise['days'] as List<DateTime>;
                    final isVolume = exercise['isVolume'] as bool;
                    return ListTile(
                      title: Text(exercise['exercise']),
                      subtitle: Text(
                        '${exercise['duration']} minutes on ${_formatDates(days)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (isVolume)
                            IconButton(
                              icon: Icon(Icons.info_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text('Diet Recommendation'),
                                      content: Text('Recommended diet for volume: High-protein diet.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          child: Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => _removeExercise(_exercises.indexOf(exercise)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  Text(
                    'Food Intake:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ..._foods.map((food) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          food['food'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Quantity: ${food['quantity']} grams\nCalories: ${food['calories']} kcal\nProtein: ${food['protein']} g\nCarbs: ${food['carbs']} g\nFat: ${food['fat']} g',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _foods.remove(food);
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAddExerciseDialog,
              child: Text('Add Exercise'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showAddFoodDialog,
              child: Text('Add Food'),
            ),
          ],
        ),
      ),
    );
  }
}
