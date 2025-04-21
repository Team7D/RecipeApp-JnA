import 'package:firebase_auth/firebase_auth.dart';
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

  final List<String>? fullName = FirebaseAuth.instance.currentUser?.displayName?.split(' ');
  late final String? userName = fullName?[0];

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
        recipes = allRecipes;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => SearchPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddRecipePage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => ShoppingListPage()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (_) => MealPlanPage()));
        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (_) => BookmarkedRecipesPage()));
        break;
    }
  }

  void _navigateToRecipePage(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipePage(recipe: recipe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6E5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hey, $userName 👋",
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Ready to whip up something tasty?", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecipeRow("🍽️ Today's Picks", recipes), //.where((r) => r.category == 'Todays Picks').toList()),
                  const SizedBox(height: 24),
                  _buildRecipeRow("🍳 Breakfast", recipes.where((r) => r.hasTag(TAGS.Breakfast)).toList()),
                  const SizedBox(height: 24),
                  _buildRecipeRow("🥗 Lunch", recipes.where((r) => r.hasTag(TAGS.Lunch)).toList()),
                  const SizedBox(height: 24),
                  _buildRecipeRow("🍽️ Dinner", recipes.where((r) => r.hasTag(TAGS.Dinner)).toList()),
                  const SizedBox(height: 24),
                  _buildRecipeRow("🍰 Desserts", recipes.where((r) => r.hasTag(TAGS.Dessert)).toList()),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.red),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Recipe'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Shopping List'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Meal Plan'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookmarks'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeRow(String title, List<Recipe> recipeList) {
    if (recipeList.isEmpty) return const SizedBox(); // Don’t show empty categories

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recipeList.length > 5 ? 5 : recipeList.length,  // Limit the items to 5
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final recipe = recipeList[index];
              return GestureDetector(
                onTap: () => _navigateToRecipePage(recipe),
                child: Container(
                  width: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          recipe.getImageUrl(),
                          height: 90,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          recipe.getTitle(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _quickActionTile(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
