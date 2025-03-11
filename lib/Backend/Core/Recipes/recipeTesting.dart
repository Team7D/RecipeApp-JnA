import 'package:recipe_app/Backend/Core/Recipes/rating.dart';
import 'package:recipe_app/Backend/Core/Recipes/recipe.dart';
import 'package:recipe_app/Backend/Core/Recipes/time.dart';
import 'recipe.dart';
import 'difficulty.dart';
import 'image_info.dart';
import 'ingredient.dart';
import 'instruction.dart';

class RecipeTesting{
  List<Recipe> currentRecipes = [];

  Future<void> getAllRecipes() async{
    Filter filter = Filter(title: "", ingredients: [], duration: null, rating: null, difficulty: Difficulty(level: "Easy"));

    List<Recipe> recipes = await getAllRecipesWithFilter(filter);

    print(recipes.length);

    for(Recipe r in recipes){
      print(r.getTitle());
    }
  }

  void upload(){
    for(Recipe currentRecipe in currentRecipes) {
      uploadRecipe(currentRecipe);
    }
  }
}