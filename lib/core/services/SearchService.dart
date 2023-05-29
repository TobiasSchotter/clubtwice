import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/core/model/Search.dart';

class SearchService {
  static List<SearchHistory> listSearchHistory = [];

  static Future<void> fetchSearchHistory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('searchHistory').get();

    listSearchHistory =
        snapshot.docs.map((doc) => SearchHistory.fromJson(doc.data())).toList();
  }
}
