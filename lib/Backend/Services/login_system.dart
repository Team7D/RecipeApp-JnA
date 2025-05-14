import 'package:firebase_auth/firebase_auth.dart';

///Displays a popup to the user allowing them to sign in with google.
Future<void> loginWithGoogle() async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  try {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();

    await auth.signInWithPopup(googleProvider);

    print("Getting all recipes with filter:");

  } catch (error) {
    print("Error logging in");
  }
}

///DONT USE THIS, FOR TEST PURPOSES ONLY
Future<void> loginWithCustom() async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.signInWithEmailAndPassword(email: "test@gmail.com", password: "testing");
  } catch (error) {
    print(error);
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
