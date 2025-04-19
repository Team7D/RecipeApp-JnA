import 'package:flutter/material.dart';
import 'dart:math';
import 'search_page.dart';
import 'shopping_list.dart';
import '../../Backend/Core/Recipe/recipe.dart';
import 'recipe_page.dart';
import 'add_recipe_page.dart';
import 'meal_plan_page.dart';
import 'bookmarks_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchRandomRecipes();
  }

  Future<void> fetchRandomRecipes() async {
    List<Recipe> allRecipes = await retrieveAllRecipes();
    if (allRecipes.isNotEmpty) {
      allRecipes.shuffle(Random());
      setState(() {
        recipes = allRecipes.take(10).toList();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddRecipePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoppingListPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MealPlanPage()),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookmarkedRecipesPage()),
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
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        recipes[index].getImageUrl(),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 15,
                      child: Text(
                        recipes[index].getTitle(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 15,
                      child: IconButton(
                        icon: Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          //TODO Implement bookmarking functionality here
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
        bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
      canvasColor: Colors.red,
    ),
    child: BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: _selectedIndex,
    onTap: _onItemTapped,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmarks',
          ),
        ],
      ),
    ));
  }
}












