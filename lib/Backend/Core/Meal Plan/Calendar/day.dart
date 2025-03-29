import 'package:recipe_app/Backend/Core/Recipe/ingredient.dart';

import '../meal_plan.dart';

class Day {
  int dayNumber;
  int dayOfWeek; // Day of the week (0 = Saturday, 1 = Sunday, ..., 6 = Friday)
  late MealPlan mealPlan;

  Day(this.dayNumber, this.dayOfWeek){
    mealPlan = MealPlan();
  }

  void display() {
    print("${_getDayOfWeek(dayOfWeek)} $dayNumber${_getOrdinalSuffix(dayNumber)}");
    mealPlan.display();
    print("");
  }

  List<Ingredient> getMealPlanIngredients(){
    return mealPlan.getAllIngredients();
  }


  String _getOrdinalSuffix(int day) {
    // Special cases for 11, 12, 13
    if (day >= 10 && day <= 20) {
      return 'th';
    }

    int lastDigit = day % 10;

    switch (lastDigit) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

enum MonthOfYear {
  January, February, March, April, May, June,
  July, August, September, October, November, December
}

// Convert day number to a day of the week
String _getDayOfWeek(int dayCode) {
  switch (dayCode) {
    case 0: return "Saturday";
    case 1: return "Sunday";
    case 2: return "Monday";
    case 3: return "Tuesday";
    case 4: return "Wednesday";
    case 5: return "Thursday";
    case 6: return "Friday";
    default: return "Invalid day";
  }
}