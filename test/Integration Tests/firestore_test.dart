import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/Backend/Core/Recipes/recipe.dart';

Future<void> main() async {
  test('Recipe object is created correctly with the given data', () async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('users').add({
      'username': 'Bob',
    });
    final snapshot = await instance.collection('users').get();

    expect(snapshot.docs.length, equals(1));
    expect(snapshot.docs.first.get('username'), equals('Bob'));
  });
  print("Passed All Firestore Tests");
}