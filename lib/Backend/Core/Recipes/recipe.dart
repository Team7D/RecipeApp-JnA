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
  final ImageInfo _image;
  final List<Ingredient> _ingredients;
  final List<Instruction> _instructions;
  final Time _duration;
  final Rating _rating;
  final Difficulty _difficulty;

  Recipe(this._id, this._title, this._image, this._ingredients, this._instructions, this._duration, this._rating, this._difficulty);

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
    }
  }
  bool hasIngredient(Ingredient ingredient){
    for(Ingredient i in _ingredients){
      if(i.getName() == ingredient.getName()){
        return true;
      }
    }
    return false;
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
          'unit': ingredient.getUnit(),
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
        ImageInfo(data['imageUrl'], ''),
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
        ImageInfo(data['imageUrl'], ''),
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



  // // Creating some example ingredients
  // var ingredient1 = Ingredient(name: 'Spaghetti', quantity: 200, unit: 'g');
  // var ingredient2 = Ingredient(name: 'Bacon', quantity: 100, unit: 'g');
  // var ingredient3 = Ingredient(name: 'Eggs', quantity: 2, unit: '');
  //
  // // Creating instructions
  // var instruction1 = Instruction(stepNumber: 1, instruction: 'Boil the spaghetti.');
  // var instruction2 = Instruction(stepNumber: 2, instruction: 'Fry the bacon until crispy.');
  // var instruction3 = Instruction(stepNumber: 3, instruction: 'Mix the eggs with Parmesan cheese.');
  //
  // // Time for cooking
  // var time = Time(preparationTime: '10', cookingTime: '15');
  //
  // // Difficulty level
  // var difficulty = Difficulty(level: Levels.Medium);
  //
  // // Image information
  // var image = ImageInfo(url: 'https://example.com/spaghetti.jpg', description: 'Spaghetti with bacon');
  //
  // // Rating
  // var rating = Rating(averageRating: 4.5, reviewCount: 120);
  //
  // // Creating the recipe
  // var recipe = Recipe(
  //   id: '1',
  //   title: 'Spaghetti Carbonara',
  //   image: image,
  //   ingredients: [ingredient1, ingredient2, ingredient3],
  //   instructions: [instruction1, instruction2, instruction3],
  //   duration: time,
  //   rating: rating,
  //   difficulty: difficulty,
  // );
  //
  // // Displaying recipe details
  // print(recipe.title);
  // print('Ingredients:');
  // for (var ingredient in recipe.ingredients) {
  //   print('${ingredient.quantity} ${ingredient.unit} ${ingredient.name}');
  // }
  // print('Instructions:');
  // for (var instruction in recipe.instructions) {
  //   print('Step ${instruction.stepNumber}: ${instruction.instruction}');
  // }
  // print('Total Time: ${recipe.duration.totalTime}');
  // print('Rating: ${recipe.rating.averageRating} stars (${recipe.rating.reviewCount} reviews)');

