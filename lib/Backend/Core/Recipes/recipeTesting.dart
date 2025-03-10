import 'package:recipe_app/Backend/Core/Recipes/rating.dart';
import 'package:recipe_app/Backend/Core/Recipes/recipe.dart';
import 'package:recipe_app/Backend/Core/Recipes/time.dart';
import 'recipe.dart';
import 'difficulty.dart';
import 'image_info.dart';
import 'ingredient.dart';
import 'instruction.dart';

class RecipeTesting{
  late Recipe currentRecipe;
  void createRecipe(){
    currentRecipe = Recipe("001", "Spaghetti Carbonara", ImageInfo('https://example.com/spaghetti-carbonara.jpg', 'Delicious Spaghetti Carbonara with bacon and eggs.'),
        [
          Ingredient('Spaghetti', 200, 'g'),
          Ingredient('Bacon', 100, 'g'),
          Ingredient('Eggs', 2, 'pcs'),
          Ingredient('Parmesan Cheese', 50, 'g'),
          Ingredient('Garlic', 1, 'clove'),
          Ingredient('Olive Oil', 1, 'tbsp'),
        ],
        [
          Instruction(1, 'Boil water in a large pot and cook spaghetti for 10-12 minutes.'),
          Instruction(2, 'Fry bacon and garlic in olive oil until crispy.'),
          Instruction(3, 'Whisk eggs and parmesan cheese together in a bowl.'),
          Instruction(4, 'Mix the spaghetti, bacon, and egg mixture in the pan.'),
          Instruction(5, 'Serve with extra Parmesan cheese on top.'),
        ],
        Time('10', '15'),
        Rating(4.5, 100),
        Difficulty(level: Level.Easy),
    );
  }

  void upload(){
    uploadRecipe(currentRecipe);
  }
}