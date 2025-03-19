import 'package:flutter/material.dart';
import '../../Backend/Core/Recipes/recipe.dart';
import 'recipe_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _ingredientController = TextEditingController();
  List<Recipe> _searchResults = [];
  String _selectedFilter = 'Difficulty';
  String _selectedFilterValue = '';
  String _ingredientQuery = '';

  final Map<String, List<String>> filterOptions = {
    'Difficulty': ['Easy', 'Medium', 'Hard'],
    'Rating': ['1', '2', '3', '4', '5'],
    'Total Time': ['< 30 min', '30-60 min', '> 60 min'],
  };

  void _performSearch() async {
    String query = _searchController.text.trim();
    List<Recipe> results = await getAllRecipesWithTitleFilter(query);

    if (_selectedFilter == 'Difficulty' && _selectedFilterValue.isNotEmpty) {
      results = results.where((recipe) => recipe.getDifficulty() == _selectedFilterValue).toList();
    } else if (_selectedFilter == 'Rating' && _selectedFilterValue.isNotEmpty) {
      double rating = double.tryParse(_selectedFilterValue) ?? 0;
      results = results.where((recipe) => recipe.getAverageRating() >= rating).toList();
    } else if (_selectedFilter == 'Total Time' && _selectedFilterValue.isNotEmpty) {
      results = results.where((recipe) {
        int totalTime = int.tryParse(recipe.getTotalTime().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        if (_selectedFilterValue == '< 30 min') return totalTime < 30;
        if (_selectedFilterValue == '30-60 min') return totalTime >= 30 && totalTime <= 60;
        if (_selectedFilterValue == '> 60 min') return totalTime > 60;
        return true;
      }).toList();
    } else if (_selectedFilter == 'Ingredients' && _ingredientQuery.isNotEmpty) {
      results = results.where((recipe) {
        return recipe.getIngredients().any((ingredient) =>
            ingredient.getName().toLowerCase().contains(_ingredientQuery.toLowerCase()));
      }).toList();
    }

    setState(() {
      _searchResults = results;
    });
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
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
              onSubmitted: (value) => _performSearch(),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedFilter,
              onChanged: (newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                  _selectedFilterValue = '';
                  _ingredientQuery = '';
                });
              },
              items: ['Difficulty', 'Ingredients', 'Rating', 'Total Time']
                  .map<DropdownMenuItem<String>>((String filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(filter),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            if (_selectedFilter == 'Ingredients')
              TextField(
                controller: _ingredientController,
                decoration: InputDecoration(
                  labelText: 'Enter ingredient',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _ingredientQuery = _ingredientController.text.trim();
                      });
                      _performSearch();
                    },
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    _ingredientQuery = value.trim();
                  });
                  _performSearch();
                },
              )
            else
              DropdownButton<String>(
                value: _selectedFilterValue.isEmpty ? null : _selectedFilterValue,
                hint: Text('Select $_selectedFilter'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedFilterValue = newValue!;
                  });
                  _performSearch();
                },
                items: (filterOptions[_selectedFilter] ?? []).map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
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
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.image),
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








