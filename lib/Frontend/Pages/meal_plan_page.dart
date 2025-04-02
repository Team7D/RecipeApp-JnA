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
    List<Recipe> allRecipes = await retrieveAllRecipes();
    setState(() {
      recipes = allRecipes;
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
          title: Text("Select a Recipe"),
          content: Container(
            height: 200,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                Recipe recipe = recipes[index];
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
    //Get this current month
    Month? thisMonth = calendar.thisMonth();
    if(thisMonth != null){
      //Then build the calendar with the days of this month
      //thisMonth.display();
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: thisMonth?.days.length,
      itemBuilder: (context, index) {
        //Get the first day of this month
        Day? thisDay = thisMonth?.days[index];
        return GestureDetector(
          onTap: () => _selectRecipeForDay(thisDay!),
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.all(4),
            child: Column(
              children: [
                Text(
                  thisMonth!.days[index].dayNumber.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  getDayOfWeek(thisMonth.days[index].dayOfWeek),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (thisDay!.mealPlan.getRecipeAtSlot(slot: MealSlot.Breakfast) != null)
                  Text(thisDay.mealPlan.getRecipeAtSlot(slot: MealSlot.Breakfast)!.getTitle(), style: TextStyle(fontSize: 16)),
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
        backgroundColor: Color(0xFFFFA559),
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




