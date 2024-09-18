import 'package:flutter/material.dart';

class UserInfoForm extends StatefulWidget {
  final Function(String, String) onSaveUserInfo;

  UserInfoForm({required this.onSaveUserInfo});

  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();

  void _submit() {
    final enteredName = _nameController.text;
    final enteredWeight = _weightController.text;

    if (enteredName.isEmpty || enteredWeight.isEmpty) {
      // Mostrar un error si los campos están vacíos
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Por favor, completa todos los campos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Llamar a la función de guardado
    widget.onSaveUserInfo(enteredName, enteredWeight);
    Navigator.of(context).pop(); // Cerrar el diálogo
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Weight (kg)'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Save Info'),
        ),
      ],
    );
  }
}
