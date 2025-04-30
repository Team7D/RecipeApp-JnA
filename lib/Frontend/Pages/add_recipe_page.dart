import 'package:flutter/material.dart';

class CreateRecipePage extends StatefulWidget {
  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _prepTimeController = TextEditingController();
  final TextEditingController _cookTimeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  String selectedDifficulty = 'Easy';
  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];

  final List<String> availableTags = ['Vegan', 'Gluten-Free', 'Dessert', 'Quick', 'Healthy'];
  List<String> selectedTags = [];

  final List<String> allPossibleIngredients = [
    'Flour', 'Sugar', 'Salt', 'Butter', 'Eggs', 'Milk', 'Baking Powder', 'Vanilla Extract',
    'Olive Oil', 'Garlic', 'Onion', 'Tomato', 'Cheese'
  ];
  List<String> ingredients = [];
  List<String> instructions = [];

  void _addInstruction() {
    if (_instructionController.text.trim().isNotEmpty) {
      setState(() {
        instructions.add(_instructionController.text.trim());
        _instructionController.clear();
      });
    }
  }

  void _submitRecipe() {
    if (_formKey.currentState!.validate()) {
      final recipe = {
        'name': _recipeNameController.text.trim(),
        'prepTime': int.tryParse(_prepTimeController.text.trim()) ?? 0,
        'cookTime': int.tryParse(_cookTimeController.text.trim()) ?? 0,
        'difficulty': selectedDifficulty,
        'tags': selectedTags,
        'imageUrl': _imageUrlController.text.trim(),
        'ingredients': ingredients,
        'instructions': instructions,
      };

      // Simulate saving or sending
      print("✅ Recipe Submitted: $recipe");

      // Optionally clear fields or navigate away
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recipe submitted!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Recipe')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [

            // Recipe name
            TextFormField(
              controller: _recipeNameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),

            // Preparation and cooking time
            TextFormField(
              controller: _prepTimeController,
              decoration: InputDecoration(labelText: 'Preparation Time (min)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _cookTimeController,
              decoration: InputDecoration(labelText: 'Cooking Time (min)'),
              keyboardType: TextInputType.number,
            ),

            // Difficulty
            DropdownButtonFormField<String>(
              value: selectedDifficulty,
              decoration: InputDecoration(labelText: 'Difficulty'),
              items: difficulties.map((diff) =>
                  DropdownMenuItem(value: diff, child: Text(diff))
              ).toList(),
              onChanged: (val) => setState(() => selectedDifficulty = val!),
            ),

            // Image URL
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),

            SizedBox(height: 20),

            // Ingredient Autocomplete
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') return const Iterable<String>.empty();
                return allPossibleIngredients.where((ingredient) =>
                    ingredient.toLowerCase().contains(textEditingValue.text.toLowerCase())
                );
              },
              onSelected: (String selection) {
                if (!ingredients.contains(selection)) {
                  setState(() => ingredients.add(selection));
                }
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(labelText: 'Search & Add Ingredient'),
                  onSubmitted: (_) => onEditingComplete(),
                );
              },
            ),

            Wrap(
              spacing: 6,
              children: ingredients
                  .map((ing) => Chip(
                label: Text(ing),
                onDeleted: () => setState(() => ingredients.remove(ing)),
              ))
                  .toList(),
            ),

            SizedBox(height: 20),

            // Tags selection
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Select Tags', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Wrap(
              spacing: 8.0,
              children: availableTags.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTags.add(tag);
                      } else {
                        selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Instructions
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _instructionController,
                  decoration: InputDecoration(labelText: 'Add Instruction Step'),
                ),
              ),
              IconButton(icon: Icon(Icons.add), onPressed: _addInstruction),
            ]),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: instructions.length,
              itemBuilder: (context, index) => ListTile(
                leading: Text('${index + 1}.'),
                title: Text(instructions[index]),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => setState(() => instructions.removeAt(index)),
                ),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRecipe,
              child: Text('Submit Recipe'),
            ),

          ]),
        ),
      ),
    );
  }
}
