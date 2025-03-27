import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/Core/Meal%20Plan/meal_plan.dart';
import 'package:recipe_app/Backend/Core/Recipe/difficulty.dart';
import 'package:recipe_app/Backend/Core/Recipe/image_info.dart';
import 'package:recipe_app/Backend/Core/Recipe/rating.dart';
import 'dart:math';
import '../../Backend/Core/Meal Plan/Calendar/calendar.dart';
import '../../Backend/Core/Meal Plan/Calendar/day.dart';
import '../../Backend/Core/Recipe/time.dart';
import 'search_page.dart';
import 'shopping_list.dart';
import '../../Backend/Core/Recipe/recipe.dart';
import 'recipe_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRandomRecipes();

    //TESTING
    createMealPlan();
  }

  void createMealPlan(){
    Calendar calendar = Calendar();
    Day? today = calendar.today();
    today?.mealPlan.setSlotRecipe(MealSlot.Breakfast, Recipe("3", "Pancakes", RecipeImageInfo("", ""), [], [], Time("2", "2"), Rating(2,2), Difficulty(level: 'Easy')));
    today?.display();
  }

  Future<void> fetchRandomRecipes() async {
    List<Recipe> allRecipes = await retrieveAllRecipes();
    if (allRecipes.isNotEmpty) {
      allRecipes.shuffle(Random());
      setState(() {
        recipes = allRecipes.take(5).toList();
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    }
  }

  void _navigateToRecipePage(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E5),
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Color(0xFF6B4226))),
        backgroundColor: Color(0xFFFFA559),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingListPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ),
      body: recipes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _navigateToRecipePage(recipes[index]),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        recipes[index].getImageUrl(),
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 15,
                      child: Text(
                        recipes[index].getTitle(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFFFA559),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}







