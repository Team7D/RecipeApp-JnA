import 'package:flutter/material.dart';

class AddRecipePage extends StatefulWidget {
  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  List<String> _ingredients = [];
  String _selectedDifficulty = 'Easy';
  String _selectedTime = '< 30 min';

  final Map<String, List<String>> filterOptions = {
    'Difficulty': ['Easy', 'Medium', 'Hard'],
    'Total Time': ['< 30 min', '30-60 min', '> 60 min'],
  };

  void _addIngredient() {
    if (_ingredientController.text.trim().isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text.trim());
        _ingredientController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Recipe Title'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                decoration: InputDecoration(labelText: 'Difficulty'),
                onChanged: (newValue) => setState(() => _selectedDifficulty = newValue!),
                items: filterOptions['Difficulty']!
                    .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                    .toList(),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedTime,
                decoration: InputDecoration(labelText: 'Total Time'),
                onChanged: (newValue) => setState(() => _selectedTime = newValue!),
                items: filterOptions['Total Time']!
                    .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                    .toList(),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _ingredientController,
                decoration: InputDecoration(
                  labelText: 'Enter Ingredient',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ),
              ),
              Wrap(
                children: _ingredients.map((ingredient) => Chip(
                  label: Text(ingredient),
                  onDeleted: () => setState(() => _ingredients.remove(ingredient)),
                )).toList(),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _stepsController,
                decoration: InputDecoration(labelText: 'Cooking Steps'),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Future backend integration for saving the recipe
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Save Recipe', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
