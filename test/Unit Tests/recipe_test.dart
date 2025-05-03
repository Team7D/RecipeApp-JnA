import 'package:test/test.dart';
import 'package:recipe_app/Backend/Core/Recipe/recipe.dart';
import 'package:recipe_app/Backend/Core/Recipe/image_info.dart';
import 'package:recipe_app/Backend/Core/Recipe/ingredient.dart';
import 'package:recipe_app/Backend/Core/Recipe/instruction.dart';
import 'package:recipe_app/Backend/Core/Recipe/time.dart';
import 'package:recipe_app/Backend/Core/Recipe/rating.dart';
import 'package:recipe_app/Backend/Core/Recipe/difficulty.dart';

void main() {
  group('Recipe Model Tests', () {
    late Recipe recipe;

    setUp(() {
      recipe = Recipe(
        '1',
        'Chocolate Cake',
        RecipeImageInfo('image_url', 'image_description'),
        [
          Ingredient('Flour', 2, "cups", testing: true),
          Ingredient('Sugar', 1, "cup", testing: true)
        ],
        [
          Instruction(1, 'Mix ingredients'),
          Instruction(2, 'Bake at 350°F')
        ],
        Time(30, 60),
        Rating(4.5, 100),
        Difficulty(level: 'Easy'),
        [],
        '',
      );
    });

    test('Correct ID, title, and image data', () {
      expect(recipe.getID(), '1');
      expect(recipe.getTitle(), 'Chocolate Cake');
      expect(recipe.getImageUrl(), 'image_url');
      expect(recipe.getImageDesc(), 'image_description');
    });

    test('Throws error if instructions are empty', () {
      expect(
              () => Recipe(
            '2',
            'Pancakes',
            RecipeImageInfo('image_url', 'image_description'),
            [
              Ingredient('Flour', 1, 'cup', testing: true),
              Ingredient('Milk', 1, 'cup', testing: true),
            ],
            [],  // Empty instructions
            Time(10, 5),
            Rating(4.0, 50),
            Difficulty(level: 'Easy'),
            [],
            '',
          ),
          throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'Instructions cannot be empty.'))
      );
    });

    test('Correct ingredients and their properties', () {
      final ingredients = recipe.getIngredients();
      expect(ingredients, hasLength(2));
      expect(ingredients[0].getName(), 'Flour');
      expect(ingredients[0].getQuantity(), 2);
      expect(ingredients[0].getUnit(), 'cups');
    });

    test('Correct instructions and their order', () {
      final instructions = recipe.getInstructions();
      expect(instructions, hasLength(2));
      expect(instructions[0].getInstruction(), 'Mix ingredients');
      expect(instructions[1].getInstruction(), 'Bake at 350°F');
    });

    test('Correct time handling', () {
      expect(recipe.getPrepTime(), 30);
      expect(recipe.getCookTime(), 60);
      expect(recipe.getTotalTime(), 90); // Assuming this returns a formatted total
    });

    test('Correct rating and review count', () {
      expect(recipe.getAverageRating(), 4.5);
      expect(recipe.getReviewCount(), 100);
    });
  });
}
