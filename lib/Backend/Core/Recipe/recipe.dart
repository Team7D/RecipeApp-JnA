﻿import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'rating.dart';
import 'time.dart';
import 'difficulty.dart';
import 'image_info.dart';
import 'ingredient.dart';
import 'instruction.dart';

class Recipe {
  final String _authorID;
  late final String _id;
  final String _title;
  final RecipeImageInfo _image;
  final List<Ingredient> _ingredients;
  final List<Instruction> _instructions;
  final Time _duration;
  final Rating _rating;
  final Difficulty _difficulty;
  final List<TAGS> _tags;

  Recipe(this._id, this._title, this._image, this._ingredients, this._instructions, this._duration, this._rating, this._difficulty, this._tags, this._authorID){
    // Ensure instructions are not empty
    if (_instructions.isEmpty) {
      throw ArgumentError('Instructions cannot be empty.');
    }}

  String getID() => _id;
  String getTitle() => _title;
  String getImageUrl() => _image.getUrl();
  String getImageDesc() => _image.getDesc();
  List<Ingredient> getIngredients() => _ingredients;
  List<Instruction> getInstructions() => _instructions;
  int getPrepTime() => _duration.getPrepTime();
  int getCookTime() => _duration.getCookingTime();
  int getTotalTime() => _duration.getTotalTime();
  Time getDuration() => _duration;
  double getAverageRating() => _rating.getAverageRating();
  int getReviewCount() => _rating.getReviewCount();
  String getAuthorID() => _authorID;
  Level getDifficultyLevel() => _difficulty.getLevel(); // helper
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
  List<TAGS> getTags() => _tags;

  bool hasTag(TAGS tag){
    if(this._tags.contains(tag)){
      return true;
    }
    return false;
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
      return false; // If the title doesn't match
    }
    if(filter.difficulty?.getLevel() != Level.None) {
      if (filter.difficulty != null &&
          _difficulty.getLevel() != filter.difficulty!.getLevel()) {
        return false; // If the difficulty doesn't match
      }
    }
    if (filter.duration != null &&
        _duration.getTotalTime() >
        filter.duration!.getTotalTime()) {
      return false; // If the duration doesn't match
    }
    if (filter.rating != null &&
        _rating.getAverageRating() < filter.rating!.getAverageRating()) {
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
Recipe? createRecipe({required String recipeTitle, required String recipeThumbnailLink, required Map<String, int> recipeIngredients, required List<String> recipeIngredientUnits, required Map<int, String> recipeInstructions, required String recipePrepTime, required String recipeCookTime, required String recipeDifficulty, required String authorID}){
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
    Time duration = Time(int.parse(recipePrepTime), int.parse(recipeCookTime));
    Rating rating = Rating(0, 0);
    Difficulty difficulty = Difficulty(level: recipeDifficulty);
    List<TAGS> tags = [];
    Recipe newRecipe = Recipe(
        "temporary ID",
        recipeTitle,
        imageInfo,
        ingredients,
        instructions,
        duration,
        rating,
        difficulty,
        tags,
        authorID
    );

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
      'authorID': recipe.getAuthorID(),
      'title': recipe.getTitle(),
      'imageUrl': recipe.getImageUrl(),
      'ingredients': recipe.getIngredients().map((ingredient) {
        return {
          'name': ingredient.getName(),
          'quantity': ingredient.getQuantity(),
          'unit': ingredient.getUnit()
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
      'tags': recipe.getTags(),
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

      List<dynamic> tagStrings = data['tags'];
      List<TAGS> tags = [];

      for(var s in tagStrings){
        tags.add(tagFromString(s.toString()));
      }

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
        tags,
        data['authorID']
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

      List<dynamic> tagStrings = data['tags'];
      List<TAGS> tags = [];

      for(var s in tagStrings){
        tags.add(tagFromString(s.toString()));
      }

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
        tags,
        data['authorID']
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

Future<bool> bookmarkRecipe({
  required String recipeID,
  required FirebaseFirestore firestore,
  required FirebaseAuth auth,
}) async {
  try {
    final String? userID = auth.currentUser?.uid;
    if (userID == null) return false;

    final userDoc = firestore.collection('userBookmarks').doc(userID);
    final userSnapshot = await userDoc.get();

    List<dynamic> bookmarks = [];

    if (userSnapshot.exists) {
      bookmarks = userSnapshot.data()?['bookmarks'] ?? [];

      final index = bookmarks.indexWhere((b) => b['recipeID'] == recipeID);
      if (index != -1) {
        bookmarks.removeAt(index);
        print('Unbookmarked recipe.');
      } else {
        bookmarks.add({'recipeID': recipeID});
        print('Bookmarked recipe.');
      }

      await userDoc.update({'bookmarks': bookmarks});
    } else {
      await userDoc.set({
        'bookmarks': [
          {'recipeID': recipeID}
        ],
      });
      print('Bookmarked recipe (new user doc).');
    }

    return true;
  } catch (e) {
    print('Error in bookmarkRecipe: $e');
    return false;
  }
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
  Thai,

  // Special Tags
  Quick,
  Easy,
  FamilyFriendly,
  BudgetFriendly,
}

TAGS tagFromString(String tag) {
  switch (tag) {
    case 'Breakfast':
      return TAGS.Breakfast;
    case 'Lunch':
      return TAGS.Lunch;
    case 'Dinner':
      return TAGS.Dinner;
    case 'Dessert':
      return TAGS.Dessert;
    case 'Snack':
      return TAGS.Snack;
    case 'Vegan':
      return TAGS.Vegan;
    case 'Vegetarian':
      return TAGS.Vegetarian;
    case 'High Protein':
      return TAGS.HighProtein;
    case 'Healthy':
      return TAGS.Healthy;
    case 'Low Carb':
      return TAGS.LowCarb;
    case 'Appetizer':
      return TAGS.Appetizer;
    case 'Main Course':
      return TAGS.MainCourse;
    case 'Side Dish':
      return TAGS.SideDish;
    case 'Salad':
      return TAGS.Salad;

  // Cuisine Types
    case 'Italian':
      return TAGS.Italian;
    case 'Chinese':
      return TAGS.Chinese;
    case 'Indian':
      return TAGS.Indian;
    case 'Mexican':
      return TAGS.Mexican;
    case 'American':
      return TAGS.American;
    case 'Thai':
      return TAGS.Thai;

  // Special Tags
    case 'Quick':
      return TAGS.Quick;
    case 'Easy':
      return TAGS.Easy;
    case 'Family Friendly':
      return TAGS.FamilyFriendly;
    case 'Budget Friendly':
      return TAGS.BudgetFriendly;
    default:
      throw ArgumentError('Invalid tag: $tag');
  }
}

String tagToString(TAGS tag) {
  return tag.toString().split('.').last.toLowerCase();
}


