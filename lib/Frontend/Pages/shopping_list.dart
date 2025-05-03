import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Backend/Core/Meal Plan/Calendar/calendar.dart';
import '../../Backend/Core/Meal Plan/meal_plan.dart';
import '../../Backend/Core/Recipe/ingredient.dart';
import '../../Backend/Core/Recipe/recipe.dart';

List<String> shoppingList = [];

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _addItem() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        shoppingList.add(_controller.text);
        _controller.clear();
      });
    }
  }

  Future<void> importFromMealPlan() async {
    Calendar c = Calendar();

    List<Map<String, dynamic>> returnData = await getUserCalendarData(FirebaseAuth.instance.currentUser!.uid, firestore: FirebaseFirestore.instance);
    for(var item in returnData){
      await c.updateCalendar(item);
    }

    List<Ingredient>? ingredients = c.thisMonth()?.getMonthMealPlanIngredients();

    Map<String, List<dynamic>> ingredientValues = {};

    for (Ingredient i in ingredients!) {
      if (ingredientValues.containsKey(i.getName())) {
        ingredientValues[i.getName()]?[0] += i.getQuantity();
      } else {
        ingredientValues[i.getName()] = [i.getQuantity(), i.getUnit()];
      }
    }
    ingredientValues.forEach((key, value) {
      shoppingList.add("${value[0]}${value[1]} $key");
      print('Ingredient: $key, Quantity: ${value[0]}, Unit: ${value[1]}');
    });

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
        title: Text("Shopping List", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.red,
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
                prefixIcon: Icon(Icons.add_shopping_cart, color: Colors.red),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Add to List", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: importFromMealPlan,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Import from Meal Plan", style: TextStyle(color: Colors.white)),
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
