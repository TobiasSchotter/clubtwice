import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/core/model/Search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/SearchService.dart';
import 'package:clubtwice/views/screens/search_result_page.dart';
import 'package:clubtwice/views/widgets/search_history_tile.dart';

import '../widgets/search_field_tile.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchHistory> listSearchHistory = SearchService.listSearchHistory;

  List<String> search = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      Map<String, dynamic> userData = snapshot.data() ?? {};
      setState(() {
        search = List<String>.from(userData['search'] ?? []);
      });
    }
  }

  Future<void> saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      await updateUserData(userId);
    }
  }

  Future<void> updateUserData(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'search': search,
    });
  }

  void updateSearchList(String searchTerm) {
    if (searchTerm.trim().isEmpty) {
// Ignore empty or whitespace-only search terms
      return;
    }

    setState(() {
      if (search.contains(searchTerm)) {
// Remove the duplicated search term
        search.remove(searchTerm);
      } else if (search.length >= 7) {
// Remove the oldest search term
        search.removeAt(6);
      }
      search.insert(
          0, searchTerm); // Insert the newest search term at the beginning
    });

    saveChanges();
  }

  Future<void> clearSearchHistory() async {
    setState(() {
      search = [];
    });
    saveChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        title: Container(
          height: 40,
          child: SearchField(
            hintText: 'Suche Vereinskleidung aller Vereine',
            onSubmitted: (searchTerm) {
              updateSearchList(searchTerm);
              saveChanges();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchResultPage(
                    searchKeyword: searchTerm,
                  ),
                ),
              );
            },
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Dein Suchverlauf...',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: search.length, // Use the length of the 'search' list
                itemBuilder: (context, index) {
                  String searchTerm = search[
                      index]; // Get the search term from the 'search' list
                  return SearchHistoryTile(
                    data: SearchHistory(
                        title:
                            searchTerm), // Create a SearchHistory object with the search term
                    onTap: () {
                      updateSearchList(searchTerm);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchResultPage(
                            searchKeyword: searchTerm,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: clearSearchHistory,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColor.primary.withOpacity(0.3),
                    backgroundColor: AppColor.primarySoft,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                  ),
                  child: Text(
                    'Suchverlauf löschen',
                    style:
                        TextStyle(color: AppColor.secondary.withOpacity(0.5)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
