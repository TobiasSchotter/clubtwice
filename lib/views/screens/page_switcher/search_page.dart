import 'package:clubtwice/core/model/Search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/SearchService.dart';
import 'package:clubtwice/views/screens/search_result_page.dart';
import 'package:clubtwice/views/widgets/search_history_tile.dart';
import 'package:clubtwice/core/services/user_service.dart';
import '../../widgets/search_field_tile.dart';
import 'package:clubtwice/core/model/UserModel.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchHistory> listSearchHistory = SearchService.listSearchHistory;
  List<String> searchHistory = [];
  final UserService userService = UserService();
  UserModel? userModel;

  // Define a TextEditingController
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String? userId = userService.getCurrentUserId();
    userModel = await userService.fetchUserData(userId);

    setState(() {
      searchHistory = userModel?.search ?? [];
    });
  }

  Future<void> saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      await userService.updateUserSearchHistory(userId, searchHistory);
    }
  }

  // Ignore empty or whitespace-only search terms
  void updateSearchList(String searchTerm) {
    if (searchTerm.trim().isEmpty) {
      return;
    }
    setState(() {
      if (searchHistory.contains(searchTerm)) {
        // Remove the duplicated search term
        searchHistory.remove(searchTerm);
      } else if (searchHistory.length >= 7) {
        // Remove the oldest search term
        searchHistory.removeAt(6);
      }
      // Insert the newest search term at the beginning
      searchHistory.insert(0, searchTerm);
    });
    saveChanges();
  }

  Future<void> clearSearchHistory() async {
    setState(() {
      searchHistory = [];
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
        title: SizedBox(
          height: 40,
          child: SearchField(
            hintText: 'Suche Vereinskleidung aller Vereine',
            controller: _searchController,
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
                  'Dein Suchverlauf ...',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  String searchTerm = searchHistory[index];
                  return SearchHistoryTile(
                    data: SearchHistory(title: searchTerm),
                    onTap: () {
                      updateSearchList(searchTerm);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchResultPage(searchKeyword: searchTerm),
                        ),
                      );
                    },
                    onDelete: () {
                      setState(() {
                        searchHistory.removeAt(index);
                      });
                      saveChanges();
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
