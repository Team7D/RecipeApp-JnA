import 'package:flutter/material.dart';
import '../../Backend/Core/Recipes/recipe.dart';
import '../../Backend/Core/Recipes/ingredient.dart';
import '../../Backend/Core/Recipes/time.dart';
import '../../Backend/Core/Recipes/rating.dart';
import '../../Backend/Core/Recipes/difficulty.dart';
import 'recipe_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();
  List<Recipe> _searchResults = [];
  String _selectedFilter = 'Difficulty';
  String _selectedFilterValue = '';
  List<String> _selectedIngredients = [];

  final Map<String, List<String>> filterOptions = {
    'Difficulty': ['Easy', 'Medium', 'Hard'],
    'Rating': ['1', '2', '3', '4', '5'],
    'Total Time': ['< 30 min', '30-60 min', '> 60 min'],
    'Ingredients': []
  };

  void _performSearch() async {
    Filter filter = Filter(
      title: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
      ingredients: _selectedIngredients.isNotEmpty ? _selectedIngredients.map((name) => Ingredient(name, 1, '')).toList() : [],
      duration: _selectedFilter == 'Total Time' ? _parseTime(_selectedFilterValue) : null,
      rating: _selectedFilter == 'Rating' ? Rating(double.tryParse(_selectedFilterValue) ?? 0, 0) : null,
      difficulty: _selectedFilter == 'Difficulty' ? Difficulty(level: _selectedFilterValue) : null,
    );

    List<Recipe> results = await getAllRecipesWithFilter(filter);
    setState(() => _searchResults = results);
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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a recipe',
                suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: _performSearch),
              ),
              onChanged: (_) => _performSearch(),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedFilter,
              onChanged: (newValue) => setState(() {
                _selectedFilter = newValue!;
                _selectedFilterValue = '';
                _selectedIngredients.clear();
                _performSearch();
              }),
              items: filterOptions.keys.map((filter) => DropdownMenuItem(value: filter, child: Text(filter))).toList(),
            ),
            SizedBox(height: 10),
            if (_selectedFilter == 'Ingredients') ...[
              TextField(
                controller: _ingredientController,
                decoration: InputDecoration(
                  labelText: 'Enter ingredient',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_ingredientController.text.trim().isNotEmpty) {
                        setState(() {
                          _selectedIngredients.add(_ingredientController.text.trim());
                          _ingredientController.clear();
                          _performSearch();
                        });
                      }
                    },
                  ),
                ),
                onSubmitted: (_) {
                  if (_ingredientController.text.trim().isNotEmpty) {
                    setState(() {
                      _selectedIngredients.add(_ingredientController.text.trim());
                      _ingredientController.clear();
                      _performSearch();
                    });
                  }
                },
              ),
              Wrap(
                children: _selectedIngredients.map((ingredient) => Chip(
                  label: Text(ingredient),
                  onDeleted: () {
                    setState(() {
                      _selectedIngredients.remove(ingredient);
                      _performSearch();
                    });
                  },
                )).toList(),
              ),
            ] else
              DropdownButton<String>(
                value: _selectedFilterValue.isEmpty ? null : _selectedFilterValue,
                hint: Text('Select $_selectedFilter'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedFilterValue = newValue!;
                    _performSearch();
                  });
                },
                items: (filterOptions[_selectedFilter] ?? []).map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
              ),
            SizedBox(height: 10),
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















