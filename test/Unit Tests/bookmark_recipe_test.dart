import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_app/Backend/Core/Recipe/recipe.dart';

class MockAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  final String uid;
  MockUser({required this.uid});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('bookmarkRecipe', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockAuth mockAuth;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockAuth = MockAuth();
    });

    test('adds a recipe to bookmarks if not already bookmarked', () async {
      final userID = 'user123';
      final userDoc = fakeFirestore.collection('userBookmarks').doc(userID);

      await userDoc.set({'bookmarks': []}); // Ensure bookmarks field exists

      // Mock currentUser to return the MockUser
      final mockUser = MockUser(uid: userID);
      when(mockAuth.currentUser).thenReturn(mockUser);

      // Call the bookmarkRecipe function
      final result = await bookmarkRecipe(
        recipeID: 'recipe456',
        firestore: fakeFirestore,
        auth: mockAuth,
      );

      // Check if the recipe was bookmarked
      expect(result, isTrue);

      final userData = await userDoc.get();
      expect(userData.data()?['bookmarks'], [
        {'recipeID': 'recipe456'}
      ]);
    });

    test('removes a recipe if it is already bookmarked', () async {
      final userID = 'user123';
      final userDoc = fakeFirestore.collection('userBookmarks').doc(userID);

      // Add an already bookmarked recipe
      await userDoc.set({
        'bookmarks': [
          {'recipeID': 'recipe456'}
        ]
      });

      // Mock currentUser to return the MockUser
      final mockUser = MockUser(uid: userID);
      when(mockAuth.currentUser).thenReturn(mockUser);

      // Call the bookmarkRecipe function
      final result = await bookmarkRecipe(
        recipeID: 'recipe456',
        firestore: fakeFirestore,
        auth: mockAuth,
      );

      // Check if the recipe was removed
      expect(result, isTrue);

      final userData = await userDoc.get();
      expect(userData.data()?['bookmarks'], isEmpty);
    });

    test('creates a new document if one does not exist', () async {
      final userID = 'user123';
      final userDoc = fakeFirestore.collection('userBookmarks').doc(userID);

      // Mock currentUser to return the MockUser
      final mockUser = MockUser(uid: userID);
      when(mockAuth.currentUser).thenReturn(mockUser);

      // Call the bookmarkRecipe function
      final result = await bookmarkRecipe(
        recipeID: 'recipe456',
        firestore: fakeFirestore,
        auth: mockAuth,
      );

      // Check if the document is created and recipe is added
      expect(result, isTrue);

      final userData = await userDoc.get();
      expect(userData.exists, isTrue);
      expect(userData.data()?['bookmarks'], [
        {'recipeID': 'recipe456'}
      ]);
    });

    test('returns false if user is not logged in', () async {
      // Mock currentUser to return null (no user logged in)
      when(mockAuth.currentUser).thenReturn(null);

      // Call the bookmarkRecipe function
      final result = await bookmarkRecipe(
        recipeID: 'recipe456',
        firestore: fakeFirestore,
        auth: mockAuth,
      );

      // Expect the result to be false when no user is logged in
      expect(result, isFalse);
    });
  });
}

