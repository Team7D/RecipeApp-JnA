import 'package:flutter/material.dart';

class BookmarkedRecipesPage extends StatefulWidget {
  @override
  _BookmarkedRecipesPageState createState() => _BookmarkedRecipesPageState();
}

class _BookmarkedRecipesPageState extends State<BookmarkedRecipesPage> {
  // Placeholder recipes
  final List<String> _bookmarkedTitles = [
    'Spaghetti Bolognese',
    'Chicken Curry',
    'Stir Fry',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Recipes'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _bookmarkedTitles.isEmpty
            ? Center(
          child: Text(
            'No bookmarks yet.',
            style: TextStyle(fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: _bookmarkedTitles.length,
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
                  _bookmarkedTitles[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Icons.bookmark, color: Colors.red),
                onTap: () {

                },
              ),
            );
          },
        ),
      ),
    );
  }
}
