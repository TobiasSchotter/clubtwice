import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  Future<List> fetchUserClubInformation() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      Map<String, dynamic> userData = snapshot.data() ?? {};

      String verein = userData['club'] ?? '';
      String sportart = userData['sport'] ?? '';

      return [verein, sportart];
    }
    return [];
  }

  Future<List<String>> fetchUserSearchHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      Map<String, dynamic> userData = snapshot.data() ?? {};
      List<String> search = List<String>.from(userData['search'] ?? []);

      return search;
    }
    return [];
  }

  Future<List<String>> fetchUserProfileImageUrl(String uID) async {
    try {
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uID).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data();

        if (userData != null) {
          final profileImageUrl = userData['profileImageUrl'] ?? '';
          final userName = userData['username'] ?? '';

          return [profileImageUrl, userName];
        }
      }

      return [];
    } catch (error) {
      print('Error fetching user data: $error');
      return [];
    }
  }

  Future<void> updateUserClubInformation(
      String userId, String verein, String sportart) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'club': verein,
      'sport': sportart,
    });
  }

  Future<void> updateUserSearchHistory(
      String userId, List<String> search) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'search': search,
    });
  }
}
