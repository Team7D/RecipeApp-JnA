import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/Core/Meal%20Plan/meal_plan.dart';
import 'package:recipe_app/Backend/Core/Recipe/recipe.dart';
import '../../Backend/Core/Meal Plan/Calendar/day.dart';
import '../../Backend/Core/Meal Plan/Calendar/month.dart';
import '../../Backend/Core/Meal%20Plan/Calendar/calendar.dart';


class MealPlanPage extends StatefulWidget {
  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  List<Recipe> recipes = [];
  Calendar calendar = Calendar();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    fetchUserCalendarData();
  }


  Future<void> fetchRecipes() async {
    List<Recipe> bookmarkedRecipes = await getUserBookmarkedRecipes();
    setState(() {
      recipes = bookmarkedRecipes;
    });
  }

  Future<void> fetchUserCalendarData() async {
    try {
      List<Map<String, dynamic>> returnData = await getUserCalendarData(FirebaseAuth.instance.currentUser!.uid);

      List<Future<void>> updateFutures = [];

      for (var item in returnData) {
        updateFutures.add(calendar.updateCalendar(item));
      }

      await Future.wait(updateFutures);

      setState(() {});
    } catch (e) {
      print("Error fetching user calendar data: $e");
    }
  }

  Future<void> updateUserCalendarData(Day selectedDay, String recipeID) async {
    String date = selectedDay.dayNumber.toString() + " " +
    selectedDay.monthBelongsTo.monthNumber.toString() + " " +
    selectedDay.monthBelongsTo.yearBelongsTo.year.toString();

    addOrOverwriteEventToUserCalendar(FirebaseAuth.instance.currentUser!.uid, date, recipeID);
  }


  void _selectRecipeForDay(Day day) async {
    Recipe? selectedRecipe = await _pickRecipe();
    if (selectedRecipe == null) return;

    updateUserCalendarData(day, selectedRecipe.getID());
    setState(() {
      day.mealPlan.setSlotRecipe(MealSlot.Breakfast, selectedRecipe);
    });
  }


  Future<Recipe?> _pickRecipe() async {
    return await showDialog<Recipe>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a Recipe from your Bookmarks"),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: recipes.length + 1, // +1 for "None"
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: const Text("None"),
                    onTap: () {
                      Navigator.of(context).pop(null); // Return null for "None"
                    },
                  );
                }

                final recipe = recipes[index - 1]; // Adjust index for list
                return ListTile(
                  title: Text(recipe.getTitle()),
                  onTap: () {
                    Navigator.of(context).pop(recipe);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }



  Widget _buildCalendar() {

    // Get today
    DateTime today = DateTime.now();

    // Start from current month
    Month? currentMonth = calendar.thisMonth();
    int dayIndex = today.day - 1;

    // Gather 30 days across months
    List<Day> upcomingDays = [];

    while (upcomingDays.length < 30) {
      List<Day>? daysInMonth = currentMonth?.days;

      while (dayIndex < daysInMonth!.length && upcomingDays.length < 30) {
        upcomingDays.add(daysInMonth[dayIndex]);
        dayIndex++;
      }

      // Move to next month if needed
      if (upcomingDays.length < 30) {
        currentMonth = calendar.nextMonth();
        dayIndex = 0;
      }
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: upcomingDays.length,
      itemBuilder: (context, index) {
        final thisDay = upcomingDays[index];
        final isToday = thisDay == today.day &&
            thisDay.monthBelongsTo == today.month &&
            thisDay.monthBelongsTo.yearBelongsTo == today.year;

        final recipe = thisDay.mealPlan.getRecipeAtSlot(slot: MealSlot.Breakfast);

        return GestureDetector(
          onTap: () => _selectRecipeForDay(thisDay),
          child: Card(
            color: isToday ? Colors.red : Colors.white,
            margin: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  thisDay.dayNumber.toString(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  getDayOfWeek(thisDay.dayOfWeek),
                  style: const TextStyle(fontSize: 14),
                ),
                if (recipe != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      recipe.getTitle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Plan"),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Color(0xFFFFF6E5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select a Day and Add a Recipe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(child: _buildCalendar()),
          ],
        ),
      ),
    );
  }
}




