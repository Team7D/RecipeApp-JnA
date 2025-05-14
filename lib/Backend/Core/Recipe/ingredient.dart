import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String _name;
  final int _quantity;
  final String _unit;
  late final Macros? _macros;

  Ingredient(this._name, this._quantity, this._unit, {bool testing = false}) {
    if(!testing) {
      Init();
    }
  }

  @override
  String toString(){
    return _quantity.toString() + _unit + " " + _name;
  }

  String getName() => _name;

  int getQuantity() => _quantity;

  String getUnit() => _unit;


  void displayMacros(){
    if(_macros == null) return;

    _macros?.display();
  }

  bool matches(Ingredient other){
    if(_name == other._name){
      return true;
    }

    return false;
  }

  void Init(){
    _getMacrosByName();
  }

  Macros? getMacros() => _macros;

  Future<void> _getMacrosByName() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ingredients')
          .where('name', isEqualTo: this._name)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        // Extract macros
        var macros = Macros(
          carbohydrates: data['carbohydrates'],
          proteins: data['proteins'],
          fats: data['fats'],
          calories: data['calories'],
          fiber: data['fiber'],
        );

        this._macros = macros;
      } else {
        print('No data found for the given ingredient name: $_name');
        return null;
      }
    } catch (e) {
      print('Error fetching macros by name: $e');
      return null;
    }
  }

}


enum VolumeUnit {
  teaspoon, // tsp
  tablespoon, // tbsp
  fluidOunce, // fl oz
  cup, // cup
  pint, // pt
  quart, // qt
  gallon, // gal
  milliliter, // ml
  liter, // L
  cubicCentimeter, // cc
}

enum WeightUnit {
  ounce, // oz
  pound, // lb
  gram, // g
  kilogram, // kg
}

enum TemperatureUnit {
  celsius, // °C
  fahrenheit, // °F
}

enum OtherUnit {
  pinch, // a very small amount
  dash, // slightly larger than a pinch
  sprig, // a small stem or branch of an herb
  slice, // used for bread, cakes, etc.
  piece, // individual servings of a food item
  block, // commonly used for cheese or butter
  stick, // commonly used for butter (1 stick = 1/2 cup or 4 oz)
  none // Use for temporary ingredients
}

class Macros {
  //All macros are per 100g or per 1 item
  final double carbohydrates; // in grams (g)
  final double proteins; // in grams (g)
  final double fats; // in grams (g)
  final double calories; // in kcal
  final double fiber; // in grams (g)

  Macros({
    required this.carbohydrates,
    required this.proteins,
    required this.fats,
    required this.calories,
    required this.fiber,
  });

  /// Method to display nutrient values in a readable format
  String display() {
    String displayInfo = "";
    displayInfo += "Carbohydrates: $carbohydrates g\n";
    displayInfo +="Proteins: $proteins g\n";
    displayInfo +="Fats: $fats g\n";
    displayInfo +="Calories: $calories kcal\n";
    displayInfo +="Fiber: $fiber g\n";

    return displayInfo;
  }
}


///Returns a list of strings for all stored ingredients. Use this when first prompting the user to select an ingredient.
Future<List<String>> getAllIngredientNames() async {
  List<String> ingredientNames = [];

  try {
    // Get a reference to the 'ingredients' collection
    CollectionReference ingRef = FirebaseFirestore.instance.collection('ingredients');

    // Get all ingredient documents in the 'ingredients' collection
    QuerySnapshot querySnapshot = await ingRef.get();

    for (var doc in querySnapshot.docs) {
        ingredientNames.add(doc['name'] as String);
      }
  } catch (e) {
    print("Error getting ingredient names: $e");
  }

  return ingredientNames;
}

///Returns a list of all ingredients with a given prefix.
///Use this whenever the user is selecting an Ingredient, will filter down the search values by the text input.
List<String> filterIngredientNamesByPrefix(List<String> allIngredients, String prefix){
  List<String> filteredList = [];

  for(String s in allIngredients){
    if(s.startsWith(prefix)){
      filteredList.add(s);
    }
  }

  return filteredList;
}


void createIngredients() async {
  // Define common ingredients and their macros (Carbs, Proteins, Fats, Calories, Fiber), use this for manual inputting into firebase.
  List<Map<String, dynamic>> ingredients = [];


  // Loop through each ingredient and add to Firestore
  for (var ingredient in ingredients) {
    try {
      // Create a new document with the ingredient name as the ID
      await FirebaseFirestore.instance
          .collection('ingredients')
          .doc(ingredient['name'].toString())  // Using the ingredient name as the document ID
          .set({
        'name': ingredient['name'],
        'carbohydrates': ingredient['carbohydrates'],
        'proteins': ingredient['proteins'],
        'fats': ingredient['fats'],
        'calories': ingredient['calories'],
        'fiber': ingredient['fiber'],
      });
      print('Successfully added ${ingredient['name']} to Firestore.');
    } catch (e) {
      print('Error adding ${ingredient['name']}: $e');
    }
  }
}




