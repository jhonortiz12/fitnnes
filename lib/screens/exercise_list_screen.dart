import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/exercise_form.dart';
import '../widgets/user_info_form.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  // Lista para almacenar los ejercicios
  final List<Map<String, dynamic>> _exercises = [];
  String? _name;  // Nombre del usuario
  String? _weight;  // Peso del usuario

  @override
  void initState() {
    super.initState();
    _loadUserInfo();  // Cargar la información del usuario
    _initializeExercises();  // Inicializar la lista de ejercicios
  }

  // Cargar información del usuario desde SharedPreferences
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedWeight = prefs.getString('weight');
    
    // Si no hay información, mostrar el formulario de ingreso de usuario
    if (storedName == null || storedWeight == null) {
      _showUserInfoDialog();
    } else {
      setState(() {
        _name = storedName;
        _weight = storedWeight;
      });
    }
  }

  // Inicializar la lista de ejercicios con algunos valores predeterminados
  void _initializeExercises() {
    setState(() {
      _exercises.addAll([
        {
          'exercise': 'Push-ups',
          'duration': 15,
          'days': [DateTime.now()],
          'isVolume': false
        },
        {
          'exercise': 'Squats',
          'duration': 20,
          'days': [DateTime.now().add(Duration(days: 1))],
          'isVolume': false
        },
      ]);
    });
  }

  // Agregar un nuevo ejercicio a la lista
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

  // Eliminar un ejercicio de la lista por índice
  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  // Mostrar el diálogo para agregar un nuevo ejercicio
  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add Exercise'),
          content: ExerciseForm(onAddExercise: _addExercise), // Asegúrate de que la firma sea correcta
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

  // Mostrar el diálogo para ingresar información del usuario
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

  // Guardar la información del usuario en SharedPreferences
  Future<void> _saveUserInfo(String name, String weight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('weight', weight);
    setState(() {
      _name = name;
      _weight = weight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise List'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Mostrar el saludo al usuario si está disponible
            if (_name != null && _weight != null)
              Text(
                'Welcome, $_name!\nYour current weight: $_weight kg',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            Expanded(
              // Mostrar la lista de ejercicios
              child: ListView.builder(
                itemCount: _exercises.length,
                itemBuilder: (ctx, index) {
                  final exercise = _exercises[index];
                  final days = exercise['days'] as List<DateTime>;
                  final isVolume = exercise['isVolume'] as bool;
                  return ListTile(
                    title: Text(exercise['exercise']),
                    subtitle: Text(
                      '${exercise['duration']} minutes on ${days.map((d) => DateFormat('yyyy-MM-dd').format(d)).join(', ')}'
                      '${isVolume ? ' (Volume)' : ''}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón para eliminar el ejercicio
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => _removeExercise(index),
                        ),
                        // Botón para mostrar información de dieta si es un ejercicio de volumen
                        if (isVolume)
                          IconButton(
                            icon: Icon(Icons.info),
                            color: Colors.blue,
                            onPressed: () {
                              // Aquí puedes mostrar la información de la dieta recomendada
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Dieta recomendada: Alta en proteínas y calorías.'),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Botón para agregar un nuevo ejercicio
            ElevatedButton(
              onPressed: _showAddExerciseDialog,
              child: Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
