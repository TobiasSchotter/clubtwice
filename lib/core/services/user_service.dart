import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/core/model/UserModel.dart';

class UserService {
  Future<UserModel?> fetchUserData(String? userId) async {
    if (userId != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      Map<String, dynamic> userData = snapshot.data() ?? {};

      return UserModel.fromMap(userData);
    } else {
      return null; // Return null instead of throwing an error
    }
  }

  Future<void> updateUserClubInformation(
      String userId, String club, String sportart) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'club': club,
      'sport': sportart,
    });
  }

  Future<void> updateUserSearchHistory(
      String userId, List<String> search) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'search': search,
    });
  }

  // Future<void> updateUserFavoriten(
  //     String userId, List<String> favoriten) async {
  //   await FirebaseFirestore.instance.collection('users').doc(userId).update({
  //     'favoriten': favoriten,
  //   });
  // }

  Future<String> getAuthenticatedUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // If there is no currently authenticated user, return null
      return '';
    }
  }

  String? getCurrentUserId() {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    // If a user is logged in, return the UID; otherwise, return null
    return user?.uid;
  }

  Future<int> getArticleCountForUser(String userId) async {
    try {
      // Access the "articles" collection in Firestore
      CollectionReference articlesRef =
          FirebaseFirestore.instance.collection('articles');

      // Query the collection to get all articles with the specified userId
      QuerySnapshot querySnapshot =
          await articlesRef.where('userId', isEqualTo: userId).get();

      // Return the count of articles for the user
      return querySnapshot.size;
    } catch (e) {
      // Handle any errors that may occur during the Firestore operation
      print('Error getting article count for user: $e');
      return 0; // Return 0 in case of an error
    }
  }
}
