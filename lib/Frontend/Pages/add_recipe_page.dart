import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/Core/Recipe/ingredient.dart';

import '../../Backend/Core/Recipe/recipe.dart';

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

  late TextEditingController _ingredientNameController = TextEditingController();
  final TextEditingController _ingredientQuantityController = TextEditingController();
  late TextEditingController _ingredientUnitController = TextEditingController();

  String selectedDifficulty = 'Easy';
  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];

  final List<String> availableTags = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Dessert',
    'Snack',
    'Vegan',
    'Vegetarian',
    'High Protein',
    'Healthy',
    'Low Carb',
    'Appetizer',
    'Main Course',
    'Side Dish',
    'Salad',
    'Italian',
    'Chinese',
    'Indian',
    'Mexican',
    'American',
    'Thai',
    'Quick',
    'Easy',
    'Family Friendly',
    'Budget Friendly'
  ];
  List<String> selectedTags = [];

  late List<String> allPossibleIngredients = [];
  List<Map<String, String>> ingredients = [];
  List<String> instructions = [];

  final List<String> allUnits = [
    // Volume
    'tsp',
    'tbsp',
    'fl oz',
    'cup',
    'pt',
    'qt',
    'gal',
    'ml',
    'L',
    'cc',

    // Weight
    'oz',
    'lb',
    'g',
    'kg',

    // Other
    'pinch',
    'dash',
    'sprig',
    'slice',
    'piece',
    'block',
    'stick',
  ];

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    allPossibleIngredients = await getAllIngredientNames();
  }

  void _addInstruction() {
    if (_instructionController.text.trim().isNotEmpty) {
      setState(() {
        instructions.add(_instructionController.text.trim());
        _instructionController.clear();
      });
    }
  }

  void _submitRecipe() {
    if (!_formKey.currentState!.validate()) return;

    // Build initial recipe map
    final Map<String, dynamic> recipe = {
      'name': _recipeNameController.text.trim(),
      'prepTime': int.tryParse(_prepTimeController.text.trim()) ?? 0,
      'cookTime': int.tryParse(_cookTimeController.text.trim()) ?? 0,
      'difficulty': selectedDifficulty,
      'tags': selectedTags,
      'imageUrl': _imageUrlController.text.trim(),
      'ingredients': ingredients,
      'instructions': instructions,
    };

    print("✅ Raw Recipe Data: $recipe");

    // Convert ingredients list to quantity + unit mappings
    final Map<String, int> ingredientMap = {};
    final List<String> units = [];

    for (final map in recipe['ingredients']) {
      final name = map['name']?.toString().trim() ?? '';
      final quantityStr = map['quantity']?.toString() ?? '';
      final unit = map['unit']?.toString() ?? '';

      final quantity = int.tryParse(quantityStr);

      if (name.isNotEmpty && quantity != null) {
        ingredientMap[name] = quantity;
        units.add(unit);
      } else {
        // Skip or log invalid ingredient
        debugPrint("⚠️ Skipping invalid ingredient: $map");
      }
    }

    // Convert instructions list to step-by-step map
    final Map<int, String> instructs = {};
    for (int i = 0; i < instructions.length; i++) {
      final stepText = instructions[i].trim();
      if (stepText.isNotEmpty) {
        instructs[i + 1] = stepText;
      }
    }

    // Create Recipe object using your custom function
    final Recipe? upload = createRecipe(
      recipeTitle: recipe['name'],
      recipeThumbnailLink: recipe['imageUrl'],
      recipeIngredients: ingredientMap,
      recipeIngredientUnits: units,
      recipeInstructions: instructs,
      recipePrepTime: recipe['prepTime'].toString(),
      recipeCookTime: recipe['cookTime'].toString(),
      recipeDifficulty: recipe['difficulty'],
      authorID: FirebaseAuth.instance.currentUser!.uid
    );

    if (upload != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Recipe submitted successfully!')),
      );

      uploadRecipe(upload);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to create recipe.')),
      );
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
          child: Column(
            children: [

              // Recipe Name
              TextFormField(
                controller: _recipeNameController,
                decoration: InputDecoration(labelText: 'Recipe Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),

              // Prep Time & Cook Time
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

              // Difficulty Dropdown
              DropdownButtonFormField<String>(
                value: selectedDifficulty,
                decoration: InputDecoration(labelText: 'Difficulty'),
                items: difficulties
                    .map((diff) =>
                    DropdownMenuItem(value: diff, child: Text(diff)))
                    .toList(),
                onChanged: (val) => setState(() => selectedDifficulty = val!),
              ),

              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),

              SizedBox(height: 20),

              // Ingredient Inputs
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') return const Iterable<String>.empty();
                  return allPossibleIngredients.where((ingredient) =>
                      ingredient.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (String selection) {
                  _ingredientNameController.text = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  _ingredientNameController = controller;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(labelText: 'Ingredient Name'),
                    onSubmitted: (_) => onEditingComplete(),
                  );
                },
              ),
              TextField(
                controller: _ingredientQuantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') return const Iterable<String>.empty();
                  return allUnits.where((unit) =>
                      unit.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (String selection) {
                  _ingredientUnitController.text = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  _ingredientUnitController = controller;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(labelText: 'Unit (e.g., grams, cups)'),
                    onSubmitted: (_) => onEditingComplete(),
                  );
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  final name = _ingredientNameController.text.trim();
                  final qty = _ingredientQuantityController.text.trim();
                  final unit = _ingredientUnitController.text.trim();

                  if (name.isNotEmpty && qty.isNotEmpty && unit.isNotEmpty) {
                    setState(() {
                      ingredients.add({
                        'name': name,
                        'quantity': qty,
                        'unit': unit,
                      });
                      _ingredientNameController.clear();
                      _ingredientQuantityController.clear();
                      _ingredientUnitController.clear();
                    });
                  }
                },
                child: Text("Add Ingredient"),
              ),

              // Display Ingredients
              Wrap(
                spacing: 6,
                children: ingredients
                    .map((ing) => Chip(
                  label: Text("${ing['name']} – ${ing['quantity']} ${ing['unit']}"),
                  onDeleted: () =>
                      setState(() => ingredients.remove(ing)),
                ))
                    .toList(),
              ),

              SizedBox(height: 20),

              // Tags
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Select Tags',
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
                    decoration:
                    InputDecoration(labelText: 'Add Instruction Step'),
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
                    onPressed: () =>
                        setState(() => instructions.removeAt(index)),
                  ),
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitRecipe,
                child: Text('Submit Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
