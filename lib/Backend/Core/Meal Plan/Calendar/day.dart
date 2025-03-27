import '../meal_plan.dart';

class Day {
  int dayNumber;
  int dayOfWeek; // Day of the week (0 = Saturday, 1 = Sunday, ..., 6 = Friday)
  late MealPlan mealPlan;

  Day(this.dayNumber, this.dayOfWeek){
    mealPlan = MealPlan();
  }

  void display() {
    print("${getDayOfWeek(dayOfWeek)} $dayNumber${getOrdinalSuffix(dayNumber)}");
    mealPlan.display();
    print("");
  }


  String getOrdinalSuffix(int day) {
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

// Helper function to get the number of days in a month
int getDaysInMonth(int monthNumber, bool isLeapYear) {
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

int calculateFirstDayOfYear(int year) {
  int day = 1;
  int month = 1;

  // Zeller's Congruence algorithm
  if (month == 1 || month == 2) {
    month += 12;
    year -= 1;
  }

  int k = year % 100; // The year within the century
  int j = year ~/ 100; // The century

  int f = (day + (13 * (month + 1)) ~/ 5 + k + k ~/ 4 + j ~/ 4 - 2 * j) % 7;

  return f;
}

// Convert day number to a day of the week
String getDayOfWeek(int dayCode) {
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