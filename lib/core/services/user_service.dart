import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/core/model/UserModel.dart';

class UserService {
  Future<UserModel?> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
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
}
