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

  void setSlotRecipe(MealSlot slot, Recipe recipe){
    _mealPlan[slot] = recipe;
  }
}

enum MealSlot{Breakfast, Lunch, Dinner}
