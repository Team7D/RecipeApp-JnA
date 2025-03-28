import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/Backend/Core/Recipes/ingredient.dart';
import '../Core/Recipes/recipe.dart';
import '../Core/Recipes/recipeTesting.dart';

///Displays a popup to the user allowing them to sign in with google.
Future<void> loginWithGoogle() async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  try {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();

    await auth.signInWithPopup(googleProvider);

    //TODO : Ignore this section just for testing stuff...
    RecipeTesting rt = RecipeTesting();
    print("Getting all recipes with filter:");

  } catch (error) {
    print("Error logging in");
  }
}

///Signs the user out
Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}

///Use this function to get the currently signed in user, this then allows you to access the user's data such as email, name, UID. If there is no currently signed in user then it will return null.
Future<User?> getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
}
