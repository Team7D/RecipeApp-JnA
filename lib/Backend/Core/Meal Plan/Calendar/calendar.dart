import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Recipe/recipe.dart';
import '../meal_plan.dart';
import 'year.dart';
import 'day.dart';
import 'month.dart';

class Calendar {
  List<Year> _years = [];

  Calendar(){
    DateTime today = DateTime.now();

    for(Year year in _years){
      if(year.year == today.year){
        return;
      }
    }
    _years.add(Year(today.year));
  }

  ///Returns the calendar day corresponding to today (real time)
  Day? today(){
    DateTime today = DateTime.now();

    return getDayInMonthInYear(today.year, today.month, today.day);
  }

  ///Returns the calendar month corresponding to today (real time)
  Month? thisMonth(){
    DateTime today = DateTime.now();

    return getMonthInYear(today.year, today.month);
  }

  ///Returns the calendar year corresponding to today (real time)
  Year? thisYear(){
    DateTime today = DateTime.now();

    return getYear(today.year);
  }

  void addYear(int yearNumber) {
    _years.add(Year(yearNumber));
  }

  ///Returns the Year object with the given year (E.g 2025 returns the year associated with 2025)
  Year? getYear(int yearNumber) {
    for (var year in _years) {
      if (year.year == yearNumber) {
        return year;
      }
    }
    return null;
  }

  ///Returns the Month object with the given month from within a Year object (E.g [Year], 9 returns September, [Year])
  Month? getMonthFromYear(Year year, int monthNumber){
    for(var month in year.months){
      if(month.monthNumber == monthNumber){
        return month;
      }
    }
    return null;
  }

  ///Returns the Month object with the given month from within a year number (E.g (2025, 9) returns September, 2025)
  Month? getMonthInYear(int yearNumber, int monthNumber) {
    for (var year in _years) {
      if (year.year == yearNumber) {
        for(var month in year.months){
          if(month.monthNumber == monthNumber){
            return month;
          }
        }
      }
    }
    return null;
  }

  ///Returns the Day object with the given Month object (E.g [Month], 9 returns [Month] 9th)
  Day? getDayFromMonth(Month month, int dayNumber){
    for(var day in month.days){
      if(day.dayNumber == dayNumber ){
        return day;
      }
    }
    return null;
  }

  ///Returns the Day object with the given month number from within a year number (E.g (2025, 9, 1) returns 1st September, 2025)
  Day? getDayInMonthInYear(int yearNumber, int monthNumber, int dayNumber){
    for (var year in _years) {
      if (year.year == yearNumber) {
        for(var month in year.months){
          if(month.monthNumber == monthNumber){
            for(var day in month.days){
              if(day.dayNumber == dayNumber){
                return day;
              }
            }
          }
        }
      }
    }
    return null;
  }

  ///Displays the whole year meal plans
  void displayYear(int yearNumber) {
    var year = getYear(yearNumber);
    if (year != null) {
      year.display();
    } else {
      print("YEAR NOT FOUND");
    }
  }

  ///Displays the whole given month's meal plan from within the year
  void displayMonthInYear(int yearNumber, int monthNumber) {
    var year = getYear(yearNumber);
    if (year != null) {
      year.displayMonthInYear(monthNumber);
    } else {
      print("YEAR NOT FOUND");
    }
  }

  ///Displays the whole month's meal plan if you HAVE the Year object
  void displayMonthFromYear({required Year year, required int monthNumber}){
    year.displayMonthInYear(monthNumber);
  }

  ///Displays the given day's meal plan from within the year provided, and the month provided
  void displayDayInMonthInYear(int yearNumber, int monthNumber, int dayNumber) {
    var year = getYear(yearNumber);
    if (year != null) {
      year.displayDayInMonthInYear(monthNumber, dayNumber);
    } else {
      print("YEAR NOT FOUND");
    }
  }

  ///Displays the day's meal plan if you HAVE the Month object
  void displayDayFromMonth({required Month month, required int dayNumber}){
    month.displayDay(dayNumber);
  }

  Future<void> updateCalendar(Map<String, dynamic> map) async{
    String date = map['date'];
    String recipeID = map['recipeID'];

    List<String> dateData = date.split(" ");
    int day = int.parse(dateData[0]);
    int month = int.parse(dateData[1]);
    int year = int.parse(dateData[2]);

    Recipe? recipe = await retrieveRecipe(recipeID);

    Day? selectedDay = this.getDayInMonthInYear(year, month, day);

    selectedDay?.mealPlan.setSlotRecipe(MealSlot.Breakfast, recipe!);

  }
}

Future<List<Map<String, dynamic>>> getUserCalendarData(String userID) async {
  List<Map<String, dynamic>> returnData = [];

  try {
    CollectionReference userCalendar = FirebaseFirestore.instance.collection('userCalendars');

    DocumentSnapshot userData = await userCalendar.doc(userID).get();

    if (userData.exists) {
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

      List<dynamic> events = data['events'];

      for (var event in events) {
        returnData.add({
          'date': event['date'],
          'recipeID': event['recipeID'],
        });
      }
    }

  } catch (e) {
    print("Error getting calendar data: $e");
  }

  return returnData;
}

Future<void> addOrOverwriteEventToUserCalendar(String userID, String date, String recipeID) async {
  try {
    CollectionReference userCalendar = FirebaseFirestore.instance.collection('userCalendars');

    DocumentReference userDoc = userCalendar.doc(userID);

    DocumentSnapshot userData = await userDoc.get();

    if (userData.exists) {
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
      List<dynamic> events = data['events'] ?? [];

      // Check if an event with the same date already exists
      bool eventUpdated = false;
      for (var event in events) {
        if (event['date'] == date) {
          // Overwrite the event with the new recipeID for the existing date
          event['recipeID'] = recipeID;
          eventUpdated = true;
          break;
        }
      }

      // If no event with the same date was found, add the new event
      if (!eventUpdated) {
        events.add({
          'date': date,
          'recipeID': recipeID,
        });
      }

      // Update the 'events' field with the updated list
      await userDoc.update({
        'events': events,
      });
      print("Event added/overwritten successfully!");
    } else {
      // If the document doesn't exist, create it with the new event
      await userDoc.set({
        'events': [
          {
            'date': date,
            'recipeID': recipeID,
          },
        ],
      });
      print("Event added successfully!");
    }
  } catch (e) {
    print("Error adding/overwriting event: $e");
  }
}





