import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  Future<List> fetchUserData(String searchTerm) async {
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

      List returnList = [verein, sportart];

      return returnList;
    }
    return [];
  }
}
