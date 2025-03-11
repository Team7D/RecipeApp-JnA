import 'package:flutter/material.dart';

import '../../Backend/Core/Recipes/recipe.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> allRecipes = [];
  List<String> searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    print('Page opened: Loading recipes...');
    allRecipes = await retrieveAllRecipes();
    for(Recipe r in allRecipes){
      searchResults.add(r.getTitle());
    }
    setState(() {});
  }

  void _updateSearchResults(String filter) async {
    allRecipes = await getAllRecipesWithTitleFilter(filter);
    searchResults.clear();
    for(Recipe r in allRecipes){
      searchResults.add(r.getTitle());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E5),
      appBar: AppBar(
        title: const Text("Search Recipes", style: TextStyle(color: Color(0xFF6B4226))),
        backgroundColor: Color(0xFFFFA559),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(searchResults[index], style: TextStyle(color: Color(0xFF6B4226))),
                      trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFFFFA559)),
                      onTap: () {
                        // Navigate to recipe details
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

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (text){
        setState(() {
          _updateSearchResults(text);
        });
      },
      decoration: InputDecoration(
        hintText: "Search for a recipe...",
        prefixIcon: Icon(Icons.search, color: Color(0xFFFFA559)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFFA559), width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}


