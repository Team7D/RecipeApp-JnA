import 'package:recipe_app/Backend/Core/Recipe/difficulty.dart';
import 'package:recipe_app/Backend/Core/Recipe/image_info.dart';
import 'package:recipe_app/Backend/Core/Recipe/ingredient.dart';
import 'package:recipe_app/Backend/Core/Recipe/instruction.dart';
import 'package:recipe_app/Backend/Core/Recipe/rating.dart';
import 'package:recipe_app/Backend/Core/Recipe/recipe.dart';
import 'package:recipe_app/Backend/Core/Recipe/time.dart';
import 'package:test/test.dart';

void main() {
  test('Recipe object is created correctly with the given data', () {
    final recipe = Recipe(
      '1',
      'Chocolate Cake',
      RecipeImageInfo('image_url', 'image_description'),
      [Ingredient('Flour', 2,  "cups"), Ingredient('Sugar', 1, "cup")],
      [Instruction(1, 'Mix ingredients'), Instruction(2, 'Bake at 350°F')],
      Time('30', '60'),
      Rating(4.5, 100),
      Difficulty(level: 'Easy'),
      [],
      ''
    );

    // Test the values initialized in the constructor
    expect(recipe.getID(), equals('1'));
    expect(recipe.getTitle(), equals('Chocolate Cake'));
    expect(recipe.getImageUrl(), equals('image_url'));
    expect(recipe.getImageDesc(), equals('image_description'));
    expect(recipe.getIngredients().length, equals(2));
    expect(recipe.getIngredients()[0].getName(), equals('Flour'));
    expect(recipe.getInstructions().length, equals(2));
    expect(recipe.getInstructions()[0].getInstruction(), equals('Mix ingredients'));
    expect(recipe.getPrepTime(), equals('30'));
    expect(recipe.getCookTime(), equals('60'));
    expect(recipe.getTotalTime(), equals('90 m'));
    expect(recipe.getAverageRating(), equals(4.5));
    expect(recipe.getReviewCount(), equals(100));
  });

  test('Recipe should handle empty inputs', () {
    final recipe = Recipe(
      '',
      '',
      RecipeImageInfo('', ''),
      [],
      [],
      Time('', ''),
      Rating(0, 0),
      Difficulty(level: 'Any'),
      [],
      ''
    );

    expect(recipe.getIngredients().isEmpty, equals(true));
    expect(recipe.getInstructions().isEmpty, equals(true));
  });

  print("Passed All Recipe Creation Tests");
}


