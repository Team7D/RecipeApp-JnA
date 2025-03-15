import 'package:flutter/material.dart';
import '../../Backend/Core/Recipes/recipe.dart';
import 'recipe_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Recipe> _searchResults = [];

  void _performSearch() async {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      List<Recipe> results = await getAllRecipesWithTitleFilter(query);
      setState(() {
        _searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E5),
      appBar: AppBar(
        title: Text("Search Recipes", style: TextStyle(color: Color(0xFF6B4226))),
        backgroundColor: Color(0xFFFFA559),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Search for a recipe',
                labelStyle: TextStyle(color: Color(0xFF6B4226)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Color(0xFF6B4226)),
                  onPressed: _performSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) => _performSearch(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                Recipe recipe = _searchResults[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipePage(recipe: recipe),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            recipe.getImageUrl(),
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 15,
                          child: Text(
                            recipe.getTitle(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





