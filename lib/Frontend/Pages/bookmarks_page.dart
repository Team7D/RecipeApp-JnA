import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/Backend/Core/Recipe/recipe.dart';

class BookmarkedRecipesPage extends StatefulWidget {
  @override
  _BookmarkedRecipesPageState createState() => _BookmarkedRecipesPageState();
}

class _BookmarkedRecipesPageState extends State<BookmarkedRecipesPage> {
  List<Recipe> _bookmarked = [];

  @override
  void initState() {
    super.initState();

    populateBookmarks();
  }


  Future<void> populateBookmarks() async{
    _bookmarked = await getUserBookmarkedRecipes();

    setState(() {});
  }

  Future<void> unbookmark(int index) async{
    bookmarkRecipe(recipeID: _bookmarked[index].getID(), firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance);
    _bookmarked.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Recipes'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _bookmarked.isEmpty
            ? Center(
          child: Text(
            'No bookmarks yet.',
            style: TextStyle(fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: _bookmarked.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 6,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  _bookmarked[index].getTitle(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.bookmark, color: Colors.red),
                onTap: () {
                  unbookmark(index);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
