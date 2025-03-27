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
        title: Text(recipe.getTitle(), style: TextStyle(color: Color(0xFF6B4226))),
        backgroundColor: Color(0xFFFFA559),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                recipe.getImageUrl(),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              recipe.getTitle(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF6B4226)),
            ),
            SizedBox(height: 10),
            Text(
              "Difficulty: ${recipe.getDifficulty()}",
              style: TextStyle(fontSize: 18, color: Color(0xFF6B4226)),
            ),
            SizedBox(height: 10),
            Text(
              "Prep Time: ${recipe.getPrepTime()} | Cook Time: ${recipe.getCookTime()} | Total Time: ${recipe.getTotalTime()}",
              style: TextStyle(fontSize: 16, color: Color(0xFF6B4226)),
            ),
            SizedBox(height: 20),
            Text(
              "Ingredients",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6B4226)),
            ),
            ...recipe.getIngredients().map((ingredient) => Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text("• ${ingredient.getName()} (${ingredient.getQuantity()})",
                  style: TextStyle(fontSize: 16, color: Color(0xFF6B4226))),
            )),
            SizedBox(height: 20),
            Text(
              "Instructions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6B4226)),
            ),
            ...recipe.getInstructions().map((instruction) => Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text("${instruction.getStepNumber()}. ${instruction.getInstruction()}",
                  style: TextStyle(fontSize: 16, color: Color(0xFF6B4226))),
            )),
          ],
        ),
      ),
    );
  }
}
