import 'package:recipe_app/Backend/Core/Recipe/ingredient.dart';
import '../Recipe/recipe.dart';

class MealPlan{
  Map<MealSlot, Recipe?> _mealPlan = {
    MealSlot.Breakfast: null,
    MealSlot.Lunch: null,
    MealSlot.Dinner: null
  };

  void display(){
    print("Breakfast: " + (_mealPlan[MealSlot.Breakfast] != null ? _mealPlan[MealSlot.Breakfast]!.getTitle() : "Nothing"));
    print("Lunch: " + (_mealPlan[MealSlot.Lunch] != null ? _mealPlan[MealSlot.Lunch]!.getTitle() : "Nothing"));
    print("Dinner: " + (_mealPlan[MealSlot.Dinner] != null ? _mealPlan[MealSlot.Dinner]!.getTitle() : "Nothing"));
  }

  ///Use this to set the slot's recipe (E.g Breakfast (MealSlot.Breakfast) -> Pancakes (Should be a recipe object))
  void setSlotRecipe(MealSlot slot, Recipe recipe){
    _mealPlan[slot] = recipe;
  }

  ///Use this to retrieve the recipe at a given meal slot
  Recipe? getRecipeAtSlot({required MealSlot slot}){
    return _mealPlan[slot];
  }

  List<Ingredient> getAllIngredients(){
    List<Ingredient> ingredients = [];

    for(var kv in _mealPlan.entries){
      Recipe? recipe = kv.value;

      if(recipe == null) continue;

      for(Ingredient i in recipe.getIngredients()){
        ingredients.add(i);
      }
    }

    return ingredients;
  }
}

enum MealSlot{Breakfast, Lunch, Dinner}
