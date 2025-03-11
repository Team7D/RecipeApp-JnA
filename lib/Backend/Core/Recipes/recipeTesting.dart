import 'package:recipe_app/Backend/Core/Recipes/rating.dart';
import 'package:recipe_app/Backend/Core/Recipes/recipe.dart';
import 'package:recipe_app/Backend/Core/Recipes/time.dart';
import 'recipe.dart';
import 'difficulty.dart';
import 'image_info.dart';
import 'ingredient.dart';
import 'instruction.dart';

class RecipeTesting{
  List<Recipe> currentRecipes = [Recipe("002", "Chicken Alfredo", ImageInfo('https://example.com/chicken-alfredo.jpg', 'Creamy Chicken Alfredo with fettuccine.'),
    [
      Ingredient('Fettuccine', 250, 'g'),
      Ingredient('Chicken Breast', 200, 'g'),
      Ingredient('Heavy Cream', 200, 'ml'),
      Ingredient('Parmesan Cheese', 50, 'g'),
      Ingredient('Garlic', 2, 'cloves'),
      Ingredient('Butter', 2, 'tbsp'),
    ],
    [
      Instruction(1, 'Cook fettuccine in boiling water for 8-10 minutes.'),
      Instruction(2, 'Sauté garlic and chicken in butter until golden.'),
      Instruction(3, 'Add heavy cream and Parmesan cheese, and stir until creamy.'),
      Instruction(4, 'Mix pasta with the sauce and serve hot.'),
    ],
    Time('10', '20'),
    Rating(4.8, 150),
    Difficulty(level: "Medium"),
  ),

    Recipe("003", "Beef Tacos", ImageInfo('https://example.com/beef-tacos.jpg', 'Juicy Beef Tacos with fresh toppings.'),
      [
        Ingredient('Ground Beef', 300, 'g'),
        Ingredient('Taco Shells', 6, 'pcs'),
        Ingredient('Tomatoes', 2, 'pcs'),
        Ingredient('Lettuce', 50, 'g'),
        Ingredient('Cheddar Cheese', 50, 'g'),
        Ingredient('Taco Seasoning', 1, 'tbsp'),
      ],
      [
        Instruction(1, 'Cook ground beef with taco seasoning until fully cooked.'),
        Instruction(2, 'Prepare toppings by chopping tomatoes and lettuce.'),
        Instruction(3, 'Fill taco shells with beef and add toppings.'),
        Instruction(4, 'Serve with salsa and sour cream.'),
      ],
      Time('15', '10'),
      Rating(4.6, 120),
      Difficulty(level: "Easy"),
    ),

    Recipe("004", "Margherita Pizza", ImageInfo('https://example.com/margherita-pizza.jpg', 'Classic Margherita Pizza with fresh basil.'),
      [
        Ingredient('Pizza Dough', 1, 'pcs'),
        Ingredient('Tomato Sauce', 100, 'ml'),
        Ingredient('Mozzarella Cheese', 150, 'g'),
        Ingredient('Fresh Basil', 5, 'leaves'),
        Ingredient('Olive Oil', 1, 'tbsp'),
      ],
      [
        Instruction(1, 'Preheat oven to 220°C (430°F).'),
        Instruction(2, 'Spread tomato sauce over pizza dough.'),
        Instruction(3, 'Add mozzarella and drizzle with olive oil.'),
        Instruction(4, 'Bake for 10-12 minutes until golden.'),
        Instruction(5, 'Garnish with fresh basil and serve.'),
      ],
      Time('15', '15'),
      Rating(4.7, 180),
      Difficulty(level: "Medium"),
    ),

    Recipe("005", "Caesar Salad", ImageInfo('https://example.com/caesar-salad.jpg', 'Fresh Caesar Salad with homemade croutons.'),
      [
        Ingredient('Romaine Lettuce', 100, 'g'),
        Ingredient('Croutons', 50, 'g'),
        Ingredient('Parmesan Cheese', 30, 'g'),
        Ingredient('Caesar Dressing', 50, 'ml'),
        Ingredient('Chicken Breast', 150, 'g'),
      ],
      [
        Instruction(1, 'Grill chicken until cooked and slice thinly.'),
        Instruction(2, 'Toss lettuce with Caesar dressing.'),
        Instruction(3, 'Add chicken, croutons, and Parmesan cheese.'),
        Instruction(4, 'Serve chilled.'),
      ],
      Time('10', '10'),
      Rating(4.4, 90),
      Difficulty(level: "Easy"),
    ),

    Recipe("006", "Pad Thai", ImageInfo('https://example.com/pad-thai.jpg', 'Authentic Pad Thai with shrimp and peanuts.'),
      [
        Ingredient('Rice Noodles', 200, 'g'),
        Ingredient('Shrimp', 150, 'g'),
        Ingredient('Eggs', 2, 'pcs'),
        Ingredient('Bean Sprouts', 50, 'g'),
        Ingredient('Peanuts', 30, 'g'),
        Ingredient('Pad Thai Sauce', 50, 'ml'),
      ],
      [
        Instruction(1, 'Soak rice noodles in warm water until soft.'),
        Instruction(2, 'Stir-fry shrimp and beaten eggs.'),
        Instruction(3, 'Add noodles and Pad Thai sauce and toss well.'),
        Instruction(4, 'Top with bean sprouts and crushed peanuts.'),
      ],
      Time('15', '15'),
      Rating(4.9, 200),
      Difficulty(level: "Hard"),
    ),

    Recipe("007", "Grilled Cheese Sandwich", ImageInfo('https://example.com/grilled-cheese.jpg', 'Crispy Grilled Cheese Sandwich with melty cheddar.'),
      [
        Ingredient('Bread Slices', 2, 'pcs'),
        Ingredient('Cheddar Cheese', 50, 'g'),
        Ingredient('Butter', 1, 'tbsp'),
      ],
      [
        Instruction(1, 'Butter one side of each bread slice.'),
        Instruction(2, 'Place cheese between the slices.'),
        Instruction(3, 'Grill in a skillet until golden on both sides.'),
        Instruction(4, 'Serve hot with tomato soup.'),
      ],
      Time('5', '5'),
      Rating(4.2, 80),
      Difficulty(level: "Easy"),
    ),

    Recipe("008", "Pancakes", ImageInfo('https://example.com/pancakes.jpg', 'Fluffy Pancakes with maple syrup.'),
      [
        Ingredient('Flour', 100, 'g'),
        Ingredient('Milk', 200, 'ml'),
        Ingredient('Eggs', 2, 'pcs'),
        Ingredient('Sugar', 2, 'tbsp'),
        Ingredient('Baking Powder', 1, 'tsp'),
      ],
      [
        Instruction(1, 'Mix all ingredients to form a smooth batter.'),
        Instruction(2, 'Pour batter into a hot pan and cook until bubbles form.'),
        Instruction(3, 'Flip and cook until golden brown.'),
        Instruction(4, 'Serve with syrup and fruits.'),
      ],
      Time('10', '10'),
      Rating(4.5, 110),
      Difficulty(level: "Easy"),
    ),

    Recipe("009", "Tom Yum Soup", ImageInfo('https://example.com/tom-yum-soup.jpg', 'Spicy and sour Tom Yum Soup with shrimp.'),
      [
        Ingredient('Shrimp', 200, 'g'),
        Ingredient('Mushrooms', 100, 'g'),
        Ingredient('Lemongrass', 1, 'stalk'),
        Ingredient('Chili Paste', 1, 'tbsp'),
        Ingredient('Coconut Milk', 200, 'ml'),
      ],
      [
        Instruction(1, 'Boil water with lemongrass and chili paste.'),
        Instruction(2, 'Add mushrooms and shrimp, and cook until done.'),
        Instruction(3, 'Pour in coconut milk and simmer briefly.'),
        Instruction(4, 'Serve hot with fresh herbs.'),
      ],
      Time('15', '15'),
      Rating(4.6, 95),
      Difficulty(level: "Medium"),
    ),

    Recipe("010", "Chocolate Cake", ImageInfo('https://example.com/chocolate-cake.jpg', 'Rich Chocolate Cake with chocolate frosting.'),
      [
        Ingredient('Flour', 200, 'g'),
        Ingredient('Cocoa Powder', 50, 'g'),
        Ingredient('Sugar', 150, 'g'),
        Ingredient('Eggs', 3, 'pcs'),
        Ingredient('Butter', 100, 'g'),
      ],
      [
        Instruction(1, 'Mix dry ingredients in a bowl.'),
        Instruction(2, 'Add eggs and melted butter, mix until smooth.'),
        Instruction(3, 'Pour batter into a greased cake tin.'),
        Instruction(4, 'Bake at 180°C (350°F) for 25-30 minutes.'),
      ],
      Time('20', '30'),
      Rating(4.7, 130),
      Difficulty(level: "Medium"),
    ),
  ];

  void getAllRecipes() async{
    List<Recipe> recipes = await retrieveAllRecipes();

    for(Recipe r in recipes){
      print(r.getTitle());
    }
  }

  void upload(){
    for(Recipe currentRecipe in currentRecipes) {
      uploadRecipe(currentRecipe);
    }
  }
}