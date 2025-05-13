import 'package:recipe_app/Backend/Core/Recipe/difficulty.dart';
import 'package:recipe_app/Backend/Core/Recipe/image_info.dart';
import 'package:recipe_app/Backend/Core/Recipe/ingredient.dart';
import 'package:recipe_app/Backend/Core/Recipe/instruction.dart';
import 'package:recipe_app/Backend/Core/Recipe/rating.dart';
import 'package:recipe_app/Backend/Core/Recipe/recipe.dart';
import 'package:recipe_app/Backend/Core/Recipe/time.dart';
import 'package:test/test.dart';

void main() {
  group('Recipe Filtering Tests', () {
    // Sample test data
    final recipe1 = Recipe(
      '1', 'Pasta', RecipeImageInfo('url1', 'desc1'),
      [Ingredient('Flour', 200, 'g', testing: true), Ingredient('Egg', 1, 'unit', testing: true)],
      [Instruction(1, 'Mix ingredients'), Instruction(2, 'Cook pasta')],
      Time(10, 20),
      Rating(4.5, 100),
      Difficulty(level: 'Medium'),
      [TAGS.MainCourse, TAGS.Italian],
      'author1',
    );

    final recipe2 = Recipe(
      '2', 'Salad', RecipeImageInfo('url2', 'desc2'),
      [Ingredient('Lettuce', 100, 'g', testing: true), Ingredient('Tomato', 2, 'unit', testing: true)],
      [Instruction(1, 'Chop ingredients'), Instruction(2, 'Mix salad')],
      Time(5, 10),
      Rating(4.0, 50),
      Difficulty(level: 'Easy'),
      [TAGS.SideDish, TAGS.Vegan],
      'author2',
    );

    final recipe3 = Recipe(
      '3', 'Pizza', RecipeImageInfo('url3', 'desc3'),
      [Ingredient('Flour', 300, 'g', testing: true), Ingredient('Cheese', 100, 'g', testing: true)],
      [Instruction(1, 'Knead dough'), Instruction(2, 'Bake pizza')],
      Time(20, 30),
      Rating(4.7, 200),
      Difficulty(level: 'Hard'),
      [TAGS.MainCourse, TAGS.Italian],
      'author3',
    );

    final List<Recipe> recipes = [recipe1, recipe2, recipe3];

    // Local mock versions of the filtering methods
    Future<List<Recipe>> getAllRecipesWithTitleFilter(String title) async {
      return recipes.where((r) => r.getTitle().contains(title)).toList();
    }

    Future<List<Recipe>> getAllRecipesWithIngredientFilter(List<Ingredient> ingredients) async {
      return recipes.where((r) => ingredients.every((i) => r.hasIngredient(i))).toList();
    }

    Future<List<Recipe>> getAllRecipesWithFilter(Filter filter) async {
      return recipes.where((r) => r.MatchesFilter(filter)).toList();
    }

    test('Should filter recipes by title', () async {
      final filtered = await getAllRecipesWithTitleFilter('Pasta');
      expect(filtered.length, equals(1));
      expect(filtered.first.getTitle(), equals('Pasta'));
    });

    test('Should filter recipes by ingredients', () async {
      final ingredients = [Ingredient('Flour', 200, 'g', testing: true)];
      final filtered = await getAllRecipesWithIngredientFilter(ingredients);

      expect(filtered.length, equals(2)); // Pasta & Pizza
      expect(filtered.any((r) => r.getTitle() == 'Pasta'), isTrue);
      expect(filtered.any((r) => r.getTitle() == 'Pizza'), isTrue);
    });

    test('Should filter recipes by difficulty', () async {
      final filter = Filter(
        title: null,
        ingredients: [],
        duration: null,
        rating: null,
        difficulty: Difficulty(level: 'Medium'),
      );

      final filtered = await getAllRecipesWithFilter(filter);
      expect(filtered.length, equals(1));
      expect(filtered.first.getTitle(), equals('Pasta'));
    });

    test('Should filter recipes by duration (prep + cook)', () async {
      final filter = Filter(
        title: null,
        ingredients: [],
        duration: Time(15, 30), // 45 mins
        rating: null,
        difficulty: null,
      );

      final filtered = await getAllRecipesWithFilter(filter);
      expect(filtered.length, equals(2)); // Salad (15) & Pasta (30)
      expect(filtered.any((r) => r.getTitle() == 'Pasta'), isTrue);
      expect(filtered.any((r) => r.getTitle() == 'Salad'), isTrue);
    });

    test('Should return empty list if no recipes match title', () async {
      final filter = Filter(
        title: 'Nonexistent',
        ingredients: [],
        duration: null,
        rating: null,
        difficulty: null,
      );

      final filtered = await getAllRecipesWithFilter(filter);
      expect(filtered.isEmpty, isTrue);
    });

    test('Should return all recipes when filter is empty', () async {
      final filter = Filter(
        title: null,
        ingredients: [],
        duration: null,
        rating: null,
        difficulty: null,
      );

      final filtered = await getAllRecipesWithFilter(filter);
      expect(filtered.length, equals(3));
    });

    test('Should filter by multiple criteria', () async {
      final filter = Filter(
        title: 'Pasta',
        ingredients: [Ingredient('Flour', 200, 'g', testing: true)],
        duration: Time(15, 20), // 35 mins
        rating: Rating(4.0, 0),
        difficulty: Difficulty(level: 'Medium'),
      );

      final filtered = await getAllRecipesWithFilter(filter);
      expect(filtered.length, equals(1));
      expect(filtered.first.getTitle(), equals('Pasta'));
    });

    test('Should return no recipes if ingredients do not match', () async {
      final ingredients = [Ingredient('Sugar', 50, 'g', testing: true)];
      final filtered = await getAllRecipesWithIngredientFilter(ingredients);
      expect(filtered.isEmpty, isTrue);
    });

    test('Should return recipes matching tag', () {
      final tag = TAGS.MainCourse;
      final filtered = recipes.where((r) => r.hasTag(tag)).toList();

      expect(filtered.length, equals(2));
      expect(filtered.any((r) => r.getTitle() == 'Pasta'), isTrue);
      expect(filtered.any((r) => r.getTitle() == 'Pizza'), isTrue);
    });
  });
}
