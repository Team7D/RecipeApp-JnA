import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:recipe_app/Backend/Core/Meal%20Plan/Calendar/calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

// Mock FirebaseAuth
class MockAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  final String uid;
  MockUser({required this.uid});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Meal Planning', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockAuth mockAuth;
    const String userID = 'user123';

    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      mockAuth = MockAuth();

      // Create user doc
      await fakeFirestore.collection('userCalendars').doc(userID).set({'events': []});
    });

    test('Adds a new meal plan event to user calendar', () async {
      final mockUser = MockUser(uid: userID);
      when(mockAuth.currentUser).thenReturn(mockUser);

      await addOrOverwriteEventToUserCalendar(
        userID,
        '5 5 2025',
        'recipe123',
        firestore: fakeFirestore,
      );

      final snapshot = await fakeFirestore.collection('userCalendars').doc(userID).get();
      final userData = snapshot.data() as Map<String, dynamic>;
      final events = userData['events'] as List;

      expect(events.length, 1);
      expect(events.first, {
        'date': '5 5 2025',
        'recipeID': 'recipe123',
      });
    });

    test('Overwrites existing event on same date', () async {
      final userDoc = fakeFirestore.collection('userCalendars').doc(userID);
      await userDoc.set({
        'events': [
          {'date': '5 5 2025', 'recipeID': 'oldRecipe'}
        ]
      });

      await addOrOverwriteEventToUserCalendar(
        userID,
        '5 5 2025',
        'newRecipe',
        firestore: fakeFirestore,
      );

      final snapshot = await userDoc.get();
      final events = (snapshot.data() as Map)['events'] as List;

      expect(events.length, 1);
      expect(events.first, {
        'date': '5 5 2025',
        'recipeID': 'newRecipe',
      });
    });

    test('Adds another event on different date', () async {
      final userDoc = fakeFirestore.collection('userCalendars').doc(userID);
      await userDoc.set({
        'events': [
          {'date': '4 5 2025', 'recipeID': 'existingRecipe'}
        ]
      });

      await addOrOverwriteEventToUserCalendar(
        userID,
        '6 5 2025',
        'newRecipe',
        firestore: fakeFirestore,
      );

      final snapshot = await userDoc.get();
      final events = (snapshot.data() as Map)['events'] as List;

      expect(events.length, 2);
      expect(
        events,
        anyElement(predicate<Map>((e) =>
        e['date'] == '4 5 2025' && e['recipeID'] == 'existingRecipe')),
      );
      expect(
        events,
        anyElement(predicate<Map>((e) =>
        e['date'] == '6 5 2025' && e['recipeID'] == 'newRecipe')),
      );
    });

    test('Returns meal events using getUserCalendarData', () async {
      final userDoc = fakeFirestore.collection('userCalendars').doc(userID);
      await userDoc.set({
        'events': [
          {'date': '1 1 2025', 'recipeID': 'recipeA'},
          {'date': '2 1 2025', 'recipeID': 'recipeB'}
        ]
      });

      final data = await getUserCalendarData(userID, firestore: fakeFirestore);

      expect(data.length, 2);
      expect(
        data,
        anyElement(predicate<Map>((e) =>
        e['date'] == '1 1 2025' && e['recipeID'] == 'recipeA')),
      );
      expect(
        data,
        anyElement(predicate<Map>((e) =>
        e['date'] == '2 1 2025' && e['recipeID'] == 'recipeB')),
      );
    });
  });
}
