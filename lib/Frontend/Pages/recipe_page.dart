import 'package:flutter/material.dart';
import '../../Backend/Core/Recipe/recipe.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  RecipePage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E5),
      appBar: AppBar(
        title: Text(recipe.getTitle(), style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () {
              // Bookmark functionality placeholder
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                recipe.getImageUrl(),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // Recipe Title
            Text(
              recipe.getTitle(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),

            // Difficulty & Time Row
            Row(
              children: [
                Icon(Icons.leaderboard, color: Colors.red[300]),
                SizedBox(width: 6),
                Text(
                  recipe.getDifficulty(),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(width: 16),
                Icon(Icons.timer, color: Colors.red[300]),
                SizedBox(width: 6),
                Text(
                  "${recipe.getTotalTime()}",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Nutritional Information
            _buildSectionCard(
              title: "Nutritional Information",
              child: Text(
                recipe.displayMacros(),
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),

            // Ingredients
            _buildSectionCard(
              title: "Ingredients",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.getIngredients().map((ingredient) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "• ${ingredient.getName()} (${ingredient.getQuantity()}${ingredient.getUnit()})",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Instructions
            _buildSectionCard(
              title: "Instructions",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: recipe.getInstructions().map((instruction) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      "${instruction.getStepNumber()}. ${instruction.getInstruction()}",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

