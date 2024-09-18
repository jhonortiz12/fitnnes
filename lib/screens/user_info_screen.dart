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
  String? _weightError;

  void _submit() {
    final enteredName = _nameController.text;
    final enteredWeight = _weightController.text;
    final weight = int.tryParse(enteredWeight);

    if (enteredName.isEmpty || enteredWeight.isEmpty || weight == null) {
      setState(() {
        _weightError = weight == null ? 'Enter a valid number' : null;
      });
      return;
    }

    setState(() {
      _weightError = null;
    });

    widget.onSaveUserInfo(enteredName, enteredWeight);
    Navigator.of(context).pop(); // Close the dialog
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
          decoration: InputDecoration(
            labelText: 'Weight (kg)',
            errorText: _weightError,
          ),
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
