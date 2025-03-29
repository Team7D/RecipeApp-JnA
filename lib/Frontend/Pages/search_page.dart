import 'package:flutter/material.dart';
import '../../Backend/Core/Recipe/recipe.dart';
import '../../Backend/Core/Recipe/ingredient.dart';
import '../../Backend/Core/Recipe/time.dart';
import '../../Backend/Core/Recipe/rating.dart';
import '../../Backend/Core/Recipe/difficulty.dart';
import 'recipe_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();

  List<Recipe> _searchResults = [];
  List<String> _selectedIngredients = [];
  String _selectedDifficulty = "Any";
  String _selectedRating = "Any";
  String _selectedTime = "Any";

  final List<String> difficultyOptions = ['Any', 'Easy', 'Medium', 'Hard'];
  final List<String> ratingOptions = ['Any', '1', '2', '3', '4', '5'];
  final List<String> timeOptions = ['Any', '< 30 min', '30-60 min', '> 60 min'];

  void _performSearch() async {
    Filter filter = Filter(
      title: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
      ingredients: _selectedIngredients.isNotEmpty
          ? _selectedIngredients.map((name) => Ingredient(name, 1, "g")).toList()
          : [],
      duration: _selectedTime != "Any" ? _parseTime(_selectedTime) : null,
      rating: _selectedRating != "Any" ? Rating(double.tryParse(_selectedRating) ?? 0, 0) : null,
      difficulty: _selectedDifficulty != "Any" ? Difficulty(level: _selectedDifficulty) : null,
    );

    _searchResults = filter.isEmpty() ? await retrieveAllRecipes() : await getAllRecipesWithFilter(filter);
    setState(() {});
  }

  Time? _parseTime(String timeFilter) {
    switch (timeFilter) {
      case '< 30 min':
        return Time("0", "30");
      case '30-60 min':
        return Time("30", "60");
      case '> 60 min':
        return Time("60", "120");
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  void _showFilterPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: [
                  Text("Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Divider(),

                  // Difficulty Filter
                  Text("Difficulty"),
                  DropdownButton<String>(
                    value: _selectedDifficulty,
                    onChanged: (newValue) {
                      setModalState(() {
                        _selectedDifficulty = newValue!;
                      });
                      _performSearch();
                    },
                    items: difficultyOptions.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
                  ),

                  // Rating Filter
                  Text("Rating"),
                  DropdownButton<String>(
                    value: _selectedRating,
                    onChanged: (newValue) {
                      setModalState(() {
                        _selectedRating = newValue!;
                      });
                      _performSearch();
                    },
                    items: ratingOptions.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
                  ),

                  // Time Filter
                  Text("Total Time"),
                  DropdownButton<String>(
                    value: _selectedTime,
                    onChanged: (newValue) {
                      setModalState(() {
                        _selectedTime = newValue!;
                      });
                      _performSearch();
                    },
                    items: timeOptions.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
                  ),

                  // Ingredients Filter
                  Text("Ingredients"),
                  TextField(
                    controller: _ingredientController,
                    decoration: InputDecoration(
                      hintText: 'Enter ingredient',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (_ingredientController.text.trim().isNotEmpty) {
                            setModalState(() {
                              _selectedIngredients.add(_ingredientController.text.trim());
                              _ingredientController.clear();
                            });
                            _performSearch();
                          }
                        },
                      ),
                    ),
                  ),

                  // Show selected ingredients as chips
                  Wrap(
                    children: _selectedIngredients.map((ingredient) => Chip(
                      label: Text(ingredient),
                      onDeleted: () {
                        setModalState(() {
                          _selectedIngredients.remove(ingredient);
                        });
                        _performSearch();
                      },
                    )).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E5),
      appBar: AppBar(
        title: Text('Search Recipes', style: TextStyle(color: Color(0xFF6B4226))),
        backgroundColor: Color(0xFFFFA559),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a recipe',
                suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: _performSearch),
              ),
              onChanged: (_) => _performSearch(),
            ),
            SizedBox(height: 10),

            // Open Filter Button
            ElevatedButton.icon(
              onPressed: _showFilterPopup,
              icon: Icon(Icons.filter_list),
              label: Text("Filters"),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFA559)),
            ),

            SizedBox(height: 10),

            // Recipe List
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  Recipe recipe = _searchResults[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          recipe.getImageUrl(),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(Icons.image),
                        ),
                      ),
                      title: Text(recipe.getTitle(), style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Difficulty: ${recipe.getDifficulty()} • ⭐ ${recipe.getAverageRating()}"),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecipePage(recipe: recipe)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


















