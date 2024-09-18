import 'package:flutter/material.dart';

class FoodEntryForm extends StatefulWidget {
  final Function(String, double, double, double, double, double) onAddFood;

  FoodEntryForm({required this.onAddFood});

  @override
  _FoodEntryFormState createState() => _FoodEntryFormState();
}

class _FoodEntryFormState extends State<FoodEntryForm> {
  final _foodController = TextEditingController();
  final _quantityController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  void _submitData() {
    final food = _foodController.text;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final calories = double.tryParse(_caloriesController.text) ?? 0;
    final protein = double.tryParse(_proteinController.text) ?? 0;
    final carbs = double.tryParse(_carbsController.text) ?? 0;
    final fat = double.tryParse(_fatController.text) ?? 0;

    if (food.isEmpty || quantity <= 0 || calories <= 0) {
      return; // Handle empty or invalid input
    }

    widget.onAddFood(food, quantity, calories, protein, carbs, fat);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: _foodController,
          decoration: InputDecoration(labelText: 'Food'),
        ),
        TextField(
          controller: _quantityController,
          decoration: InputDecoration(labelText: 'Quantity (grams)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _caloriesController,
          decoration: InputDecoration(labelText: 'Calories'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _proteinController,
          decoration: InputDecoration(labelText: 'Protein (g)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _carbsController,
          decoration: InputDecoration(labelText: 'Carbs (g)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _fatController,
          decoration: InputDecoration(labelText: 'Fat (g)'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Text('Add Food'),
          onPressed: _submitData,
        ),
      ],
    );
  }
}
