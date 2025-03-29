import 'package:recipe_app/Backend/Core/Recipe/ingredient.dart';

import 'day.dart';

class Month {
  int monthNumber;
  List<Day> days = [];
  late int daysInMonth;
  late String monthName;
  int startingDay;

  Month(this.monthNumber, this.startingDay, {required bool isLeapYear}) {
    daysInMonth = _getDaysInMonth(monthNumber, isLeapYear);
    monthName = MonthOfYear.values[monthNumber - 1].toString().split('.').last;
    _generateDays();
  }


  List<Ingredient> getMonthMealPlanIngredients(){
    List<Ingredient> ingredients = [];

    for(Day day in days){
      for(Ingredient i in day.getMealPlanIngredients()){
        ingredients.add(i);
      }
    }

    return ingredients;
  }

  List<Ingredient> getWeekMealPlanIngredients({required int startingDay}){
    List<Ingredient> ingredients = [];

    for(int i = startingDay; i < startingDay+7; i++){
      for(Ingredient i in days[i].getMealPlanIngredients()){
        ingredients.add(i);
      }
    }

    return ingredients;
  }

  void _generateDays() {
    int currentDayOfWeek = startingDay;

    for (int day = 1; day <= daysInMonth; day++) {
      days.add(Day(day, currentDayOfWeek));
      currentDayOfWeek = (currentDayOfWeek + 1) % 7;
    }
  }

  void display() {
    print(monthName.toUpperCase());
    for (var day in days) {
      day.display();
    }
    print("");
  }

  void displayDay(int dayNumber) {
    days[dayNumber - 1].display();
  }

  // Helper function to get the number of days in a month
  int _getDaysInMonth(int monthNumber, bool isLeapYear) {
    switch (monthNumber) {
      case 1: // January
      case 3: // March
      case 5: // May
      case 7: // July
      case 8: // August
      case 10: // October
      case 12: // December
        return 31;
      case 4: // April
      case 6: // June
      case 9: // September
      case 11: // November
        return 30;
      case 2: // February
        return isLeapYear ? 29 : 28;
      default:
        throw ArgumentError("Invalid month number");
    }
  }
}