import 'package:cloud_firestore/cloud_firestore.dart';
import 'rating.dart';
import 'time.dart';
import 'difficulty.dart';
import 'image_info.dart';
import 'ingredient.dart';
import 'instruction.dart';

class Recipe {
  final String _id;
  final String _title;
  final RecipeImageInfo _image;
  final List<Ingredient> _ingredients;
  final List<Instruction> _instructions;
  final Time _duration;
  final Rating _rating;
  final Difficulty _difficulty;
  bool isBookmarked;

  Recipe(this._id, this._title, this._image, this._ingredients, this._instructions, this._duration, this._rating, this._difficulty, {this.isBookmarked = false,});

  String getID() => _id;
  String getTitle() => _title;
  String getImageUrl() => _image.getUrl();
  String getImageDesc() => _image.getDesc();
  List<Ingredient> getIngredients() => _ingredients;
  List<Instruction> getInstructions() => _instructions;
  String getPrepTime() => _duration.getPrepTime();
  String getCookTime() => _duration.getCookingTime();
  String getTotalTime() => _duration.getTotalTime();
  double getAverageRating() => _rating.getAverageRating();
  int getReviewCount() => _rating.getReviewCount();
  String getDifficulty(){
    Level l =  _difficulty.getLevel();
    switch(l){
      case Level.Easy:
        return "Easy";
      case Level.Medium:
        return "Medium";
      case Level.Hard:
        return "Hard";
      case Level.None:
        return "Any";
    }
  }

  String displayMacros(){
    String returnValue = "";

    double totalCals = 0;
    double totalCarbs = 0;
    double totalProteins = 0;
    double totalFats = 0;
    double totalFiber = 0;

    for(Ingredient i in _ingredients){
      Macros? macros = i.getMacros();
      if(macros == null) continue;

      totalCals += macros.calories;
      totalCarbs += macros.carbohydrates;
      totalProteins += macros.proteins;
      totalFats += macros.fats;
      totalFiber += macros.fiber;
    }

    print("Total Macros");
    print('Carbohydrates: $totalCarbs g');
    returnValue += "Carbohydrates: ${totalCarbs.toStringAsFixed(1)}\n";
    print('Proteins: $totalProteins g');
    returnValue += "Proteins: ${totalProteins.toStringAsFixed(1)}\n";
    print('Fats: $totalFats g');
    returnValue += "Fats: ${totalFats.toStringAsFixed(1)}\n";
    print('Calories: $totalCals kcal');
    returnValue += "Calories: ${totalCals.toStringAsFixed(1)}\n";
    print('Fiber: $totalFiber g');
    returnValue += "Fiber: ${totalFiber.toStringAsFixed(1)}\n";

    return returnValue;
  }
  bool hasIngredient(Ingredient ingredient){
    for(Ingredient i in _ingredients){
      if(i.getName() == ingredient.getName()){
        return true;
      }
    }
    return false;
  }
  bool MatchesFilter(Filter filter) {
    if ((filter.title != null && filter.title != "") && !_title.contains(filter.title.toString())) {
      print("Doesn't match title");
      return false; // If the title doesn't match
    }
    if(filter.difficulty?.getLevel() != Level.None) {
      if (filter.difficulty != null &&
          _difficulty.getLevel() != filter.difficulty!.getLevel()) {
        print("Doesn't match difficulty");
        return false; // If the difficulty doesn't match
      }
    }
    if (filter.duration != null &&
        int.parse(_duration.getTotalTime()) >
        int.parse(filter.duration!.getTotalTime())) {
      print("Doesn't match duration");
      return false; // If the duration doesn't match
    }
    if (filter.rating != null &&
        _rating.getAverageRating() < filter.rating!.getAverageRating()) {
      print("Doesn't match rating");
      return false; // If the rating is less than
    }

    //TODO: Ingredient check
    for(Ingredient i in filter.ingredients){
      if(!hasIngredient(i)){
        return false; // If there is an ingredient mismatch
      }
    }

    return true; // Otherwise return true as we meet all criteria
  }
}

/// Function to upload a recipe to Firestore, user must be signed in for this to work.
Future<void> uploadRecipe(Recipe recipe) async {
  try {
    // Create a reference to the 'recipes' collection in Firestore
    CollectionReference recipesRef = FirebaseFirestore.instance.collection('recipes');

    // Prepare the recipe data to be uploaded
    Map<String, dynamic> recipeData = {
      'title': recipe.getTitle(),
      'imageUrl': recipe.getImageUrl(),
      'ingredients': recipe.getIngredients().map((ingredient) {
        return {
          'name': ingredient.getName(),
          'quantity': ingredient.getQuantity(),
          'unit': ingredient.getMeasurement().toString(),
        };
      }).toList(),
      'instructions': recipe.getInstructions().map((instruction) {
        return {'stepNumber': instruction.getStepNumber(), 'instruction': instruction.getInstruction()};
      }).toList(),
      'preparationTime': recipe.getPrepTime(),
      'cookingTime': recipe.getCookTime(),
      'difficulty': recipe.getDifficulty(),
      'rating': {
        'averageRating': recipe.getAverageRating(),
        'reviewCount': recipe.getReviewCount(),
      },
    };

    // Add the recipe to the Firestore collection
    await recipesRef.add(recipeData);
    print('Recipe uploaded successfully!');
  } catch (e) {
    print('Error uploading recipe: $e');
  }
}

/// Function to retrieve a recipe from Firestore by its ID
Future<Recipe?> retrieveRecipe(String recipeId) async {
  try {
    // Get a reference to the 'recipes' collection
    CollectionReference recipesRef = FirebaseFirestore.instance.collection('recipes');

    // Get the recipe document by its ID
    DocumentSnapshot recipeDoc = await recipesRef.doc(recipeId).get();

    if (recipeDoc.exists) {
      // Convert Firestore document data to Recipe model using getter methods
      Map<String, dynamic> data = recipeDoc.data() as Map<String, dynamic>;

      // Convert the ingredients from Firestore data to a list of Ingredient objects
      List<Ingredient> ingredients = (data['ingredients'] as List).map((ingredientData) {
        return Ingredient(ingredientData['name'],
          ingredientData['quantity'],
          ingredientData['unit'],);
      }).toList();

      // Convert the instructions from Firestore data to a list of Instruction objects
      List<Instruction> instructions = (data['instructions'] as List).map((instructionData) {
        return Instruction(
          instructionData['stepNumber'],
          instructionData['instruction'],
        );
      }).toList();

      // Create and return the Recipe object using getter methods
      return Recipe(
        recipeDoc.id,
        data['title'],
        RecipeImageInfo(data['imageUrl'], ''),
        ingredients,
        instructions,
        Time(
          data['preparationTime'],
          data['cookingTime'],
        ),
        Rating(
          data['rating']['averageRating'],
          data['rating']['reviewCount'],
        ),
        Difficulty(level: data['difficulty']),
      );
    } else {
      print('Recipe not found');
      return null; // Return null if the recipe doesn't exist
    }
  } catch (e) {
    print('Error retrieving recipe: $e');
    return null; // Return null in case of any errors
  }
}

/// Function to retrieve ALL recipes from the Firestore, this will become bad if there is a lot of recipes.
Future<List<Recipe>> retrieveAllRecipes() async {
  try {
    // Get a reference to the 'recipes' collection
    CollectionReference recipesRef = FirebaseFirestore.instance.collection('recipes');

    // Get all recipe documents in the 'recipes' collection
    QuerySnapshot querySnapshot = await recipesRef.get();

    // Map each document to a Recipe object
    List<Recipe> recipes = querySnapshot.docs.map((recipeDoc) {
      Map<String, dynamic> data = recipeDoc.data() as Map<String, dynamic>;

      // Convert the ingredients from Firestore data to a list of Ingredient objects
      List<Ingredient> ingredients = (data['ingredients'] as List).map((ingredientData) {
        return Ingredient(
          ingredientData['name'],
          ingredientData['quantity'],
          ingredientData['unit'],
        );
      }).toList();

      // Convert the instructions from Firestore data to a list of Instruction objects
      List<Instruction> instructions = (data['instructions'] as List).map((instructionData) {
        return Instruction(
          instructionData['stepNumber'],
          instructionData['instruction'],
        );
      }).toList();

      // Create and return the Recipe object using getter methods
      return Recipe(
        recipeDoc.id,
        data['title'],
        RecipeImageInfo(data['imageUrl'], ''),
        ingredients,
        instructions,
        Time(
          data['preparationTime'],
          data['cookingTime'],
        ),
        Rating(
          data['rating']['averageRating'],
          data['rating']['reviewCount'],
        ),
        Difficulty(level: data['difficulty']),
      );
    }).toList();

    // Return the list of all recipes
    return recipes;
  } catch (e) {
    print('Error retrieving recipes: $e');
    return []; // Return an empty list in case of any errors
  }
}

Future<List<Recipe>> getAllRecipesWithTitleFilter(String filter) async{
  List<Recipe> allRecipes = await retrieveAllRecipes();
  List<Recipe> filteredRecipes = [];

  for(Recipe r in allRecipes){
    if(r.getTitle().contains(filter)){
      filteredRecipes.add(r);
    }
  }

  return filteredRecipes;
}

Future<List<Recipe>> getAllRecipesWithIngredientFilter(List<Ingredient> ingredients) async {
  List<Recipe> allRecipes = await retrieveAllRecipes();
  List<Recipe> filteredRecipes = [];

  for (Recipe r in allRecipes) {
    // Check if all required ingredients are present in the recipe
    if (ingredients.every((i) => r.hasIngredient(i))) {
      filteredRecipes.add(r);
    }
  }

  return filteredRecipes;
}

Future<List<Recipe>> getAllRecipesWithFilter(Filter filter) async {
  List<Recipe> allRecipes = await retrieveAllRecipes();
  List<Recipe> filteredRecipes = [];

  for (Recipe r in allRecipes) {
    if(r.MatchesFilter(filter)) {
      filteredRecipes.add(r);
    }
  }

  return filteredRecipes;
}

class Filter{
  late String? title;
  late List<Ingredient> ingredients;
  late Time? duration;
  late Rating? rating;
  late Difficulty? difficulty;

  Filter({required this.title, required this.ingredients, required this.duration, required this.rating, required this.difficulty});

  bool isEmpty(){
    if(title != null){
      print("TITLE IS NOT NULL");
      return false;
    }

    if(ingredients.isNotEmpty){
      print("INGREDIENTS ARE NOT EMPTY");
      return false;
    }

    if(duration != null){
      print("DURATION IS NOT NULL");
      return false;
    }

    if(rating != null) {
      print("RATING IS NOT NULL");
      return false;
    }

    if(difficulty != null || difficulty?.getLevel() == Level.None){
      print("DIFFICULTY IS NOT NULL OR IT IS SET TO ANY");
      return false;
    }

    return true;
  }
}

