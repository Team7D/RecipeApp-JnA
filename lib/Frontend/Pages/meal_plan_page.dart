import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/Core/Meal%20Plan/meal_plan.dart';
import 'package:recipe_app/Backend/Core/Recipe/recipe.dart';
import '../../Backend/Core/Meal%20Plan/Calendar/calendar.dart';


class MealPlanPage extends StatefulWidget {
  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  List<Recipe> recipes = [];
  MealPlan mealPlan = MealPlan();
  Calendar calendar = Calendar();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }


  Future<void> fetchRecipes() async {
    List<Recipe> allRecipes = await retrieveAllRecipes();
    setState(() {
      recipes = allRecipes;
    });
  }


  void _selectRecipeForDay(DateTime date) async {
    Recipe? selectedRecipe = await _pickRecipe();
    if (selectedRecipe != null) {
      setState(() {
        mealPlan.setSlotRecipe(MealSlot.Breakfast, selectedRecipe);
      });
    }
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        DateTime day = DateTime.now().add(Duration(days: index));
        return GestureDetector(
          onTap: () => _selectRecipeForDay(day),
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.all(4),
            child: Column(
              children: [
                Text(
                  day.day.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (mealPlan.getRecipeAtSlot(slot: MealSlot.Breakfast) != null)
                  Text(mealPlan.getRecipeAtSlot(slot: MealSlot.Breakfast)!.getTitle(), style: TextStyle(fontSize: 12)),
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




