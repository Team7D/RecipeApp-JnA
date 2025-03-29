import 'package:flutter/material.dart';

import '../../Backend/Core/Meal Plan/Calendar/calendar.dart';
import '../../Backend/Core/Meal Plan/meal_plan.dart';
import '../../Backend/Core/Recipe/ingredient.dart';
import '../../Backend/Core/Recipe/recipe.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  List<String> shoppingList = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> _addItem() async {
    //This is testing the import ingredients from mealplan - should be moved to an 'import' button
    await test();

    if (_controller.text.isNotEmpty) {
      setState(() {
        shoppingList.add(_controller.text);
        _controller.clear();
      });
    }
  }

  Future<void> test() async {
    Calendar c = Calendar();

    List<Recipe> recipes = await retrieveAllRecipes();

    c.today()?.mealPlan.setSlotRecipe(MealSlot.Dinner, recipes[0]);

    List<Ingredient>? ingredients = c.thisYear()?.getYearMealPlanIngredients();

    if(ingredients == null) return;

    for(Ingredient i in ingredients){
      shoppingList.add(i.toString());
      print(i);
    }

    setState(() {});
  }

  void _removeItem(int index) {
    setState(() {
      shoppingList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E5),
      appBar: AppBar(
        title: Text("Shopping List", style: TextStyle(color: Color(0xFF6B4226))),
        backgroundColor: Color(0xFFFFA559),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Add an item...",
                prefixIcon: Icon(Icons.add_shopping_cart, color: Color(0xFFFFA559)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFA559)),
              child: Text("Add to List", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: shoppingList.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(shoppingList[index], style: TextStyle(color: Color(0xFF6B4226))),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _removeItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
