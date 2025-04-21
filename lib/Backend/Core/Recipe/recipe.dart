import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'rating.dart';
import 'time.dart';
import 'difficulty.dart';
import 'image_info.dart';
import 'ingredient.dart';
import 'instruction.dart';

class Recipe {
  late final String _id;
  final String _title;
  final RecipeImageInfo _image;
  final List<Ingredient> _ingredients;
  final List<Instruction> _instructions;
  final Time _duration;
  final Rating _rating;
  final Difficulty _difficulty;
  late final List<TAGS> tags;

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

    for(Ingredient i in filter.ingredients){
      if(!hasIngredient(i)){
        return false;
      }
    }

    return true;
  }
}


///Returns a newly created recipe with the provided inputs. Recipe ingredients needs to be in format [Ingredient] , [Amount]. Recipe ingredient units is a List of Strings corresponding to each ingredient. Instructions is a Map of [StepNumber] , [Instruction]
Recipe? createRecipe({required String recipeTitle, required String recipeThumbnailLink, required Map<String, int> recipeIngredients, required List<String> recipeIngredientUnits, required Map<int, String> recipeInstructions, required String recipePrepTime, required String recipeCookTime, required String recipeDifficulty}){
  try {
    RecipeImageInfo imageInfo = RecipeImageInfo(
        recipeThumbnailLink, "Image of a : ${recipeTitle}");
    List<Ingredient> ingredients = [];

    int ingredientIndex = 0;
    for(var kv in recipeIngredients.entries){
      ingredients.add(Ingredient(kv.key, kv.value, recipeIngredientUnits[ingredientIndex]));
      ingredientIndex++;
    }
    List<Instruction> instructions = [];
    for(var kv in recipeInstructions.entries){
      instructions.add(Instruction(kv.key, kv.value));
    }
    Time duration = Time(recipePrepTime, recipeCookTime);
    Rating rating = Rating(0, 0);
    Difficulty difficulty = Difficulty(level: recipeDifficulty);
    Recipe newRecipe = Recipe(
        "temporary ID",
        recipeTitle,
        imageInfo,
        ingredients,
        instructions,
        duration,
        rating,
        difficulty);

    print("Recipe Creation Successful");
    return newRecipe;
  } catch(e){
    print("Error creating recipe");
    return null;
  }
}

/// Function to upload a recipe to Firestore, user must be signed in for this to work.
Future<void> uploadRecipe(Recipe recipe) async {
  try {
    CollectionReference recipesRef = FirebaseFirestore.instance.collection('recipes');

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

    await recipesRef.add(recipeData);
    print('Recipe uploaded successfully!');
  } catch (e) {
    print('Error uploading recipe: $e');
  }
}

/// Function to retrieve a recipe from Firestore by its ID
Future<Recipe?> retrieveRecipe(String recipeId) async {
  try {
    CollectionReference recipesRef = FirebaseFirestore.instance.collection('recipes');

    DocumentSnapshot recipeDoc = await recipesRef.doc(recipeId).get();

    if (recipeDoc.exists) {
      Map<String, dynamic> data = recipeDoc.data() as Map<String, dynamic>;

      List<Ingredient> ingredients = (data['ingredients'] as List).map((ingredientData) {
        return Ingredient(ingredientData['name'],
          ingredientData['quantity'],
          ingredientData['unit'],);
      }).toList();

      List<Instruction> instructions = (data['instructions'] as List).map((instructionData) {
        return Instruction(
          instructionData['stepNumber'],
          instructionData['instruction'],
        );
      }).toList();

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
      return null;
    }
  } catch (e) {
    print('Error retrieving recipe: $e');
    return null;
  }
}

/// Function to retrieve ALL recipes from the Firestore, this will become bad if there is a lot of recipes.
Future<List<Recipe>> retrieveAllRecipes() async {
  try {
    CollectionReference recipesRef = FirebaseFirestore.instance.collection('recipes');

    QuerySnapshot querySnapshot = await recipesRef.get();

    List<Recipe> recipes = querySnapshot.docs.map((recipeDoc) {
      Map<String, dynamic> data = recipeDoc.data() as Map<String, dynamic>;

      List<Ingredient> ingredients = (data['ingredients'] as List).map((ingredientData) {
        return Ingredient(
          ingredientData['name'],
          ingredientData['quantity'],
          ingredientData['unit'],
        );
      }).toList();

      List<Instruction> instructions = (data['instructions'] as List).map((instructionData) {
        return Instruction(
          instructionData['stepNumber'],
          instructionData['instruction'],
        );
      }).toList();

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

    return recipes;
  } catch (e) {
    print('Error retrieving recipes: $e');
    return [];
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


Future<bool> bookmarkRecipe(String recipeID) async {
  try {
    CollectionReference userCalendar = FirebaseFirestore.instance.collection('userBookmarks');

    DocumentReference userDoc = userCalendar.doc(FirebaseAuth.instance.currentUser?.uid);

    DocumentSnapshot userData = await userDoc.get();

    if (userData.exists) {
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
      List<dynamic> bookmarks = data['bookmarks'] ?? [];

      // Check if the recipe is already bookmarked and if so unbookmark it
      bool flag = false;
      for (var bookmark in bookmarks) {
        if (bookmark['recipeID'] == recipeID) {
          bookmarks.remove(bookmark);
          print("Un-Bookmarked recipe successfully!");
          flag = true;
        }
      }

      if(!flag){
        bookmarks.add({
          'recipeID': recipeID,
        });
        print("Bookmarked recipe successfully!");
      }

      // Update the 'bookmarks' field with the updated list
      await userDoc.update({
        'bookmarks': bookmarks,
      });
    } else {
      // If the document doesn't exist, create it with the new event
      await userDoc.set({
        'bookmarks': [
          {
            'recipeID': recipeID,
          },
        ],
      });
      print("Bookmarked successfully!");
      return true;
    }
  } catch (e) {
    print("Error bookmarking recipe: $e");
  }
  return false;
}

Future<List<String>> getUserBookmarkedRecipesIDs() async {
  List<String> returnData = [];

  try {
    CollectionReference userCalendar = FirebaseFirestore.instance.collection('userBookmarks');

    String? userID = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot userData = await userCalendar.doc(userID).get();

    if (userData.exists) {
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

      List<dynamic> bookmarks = data['bookmarks'];

      for (var bookmark in bookmarks) {
        returnData.add(bookmark['recipeID']);
      }
    }

  } catch (e) {
    print("Error getting bookmark data: $e");
  }
  return returnData;
}

Future<List<Recipe>> getUserBookmarkedRecipes() async {
  List<Recipe> returnData = [];

  try {
    CollectionReference userCalendar = FirebaseFirestore.instance.collection('userBookmarks');

    String? userID = FirebaseAuth.instance.currentUser?.uid;
    DocumentSnapshot userData = await userCalendar.doc(userID).get();

    if (userData.exists) {
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

      List<dynamic> bookmarks = data['bookmarks'];

      for (var bookmark in bookmarks) {
        Recipe? r = await retrieveRecipe(bookmark['recipeID']);

        if(r != null){
          returnData.add(r);
        }
      }
    }

  } catch (e) {
    print("Error getting bookmark data: $e");
  }
  return returnData;
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

enum TAGS{
  Breakfast,
  Lunch,
  Dinner,
  Dessert,
  Snack,
  Vegan,
  Vegetarian,
  HighProtein,
  Healthy,
  LowCarb,
  Appetizer,
  MainCourse,
  SideDish,
  Salad,

  // Cuisine Types
  Italian,
  Chinese,
  Indian,
  Mexican,
  American,

  // Special Tags
  Quick,
  Easy,
  FamilyFriendly,
  BudgetFriendly,
}

