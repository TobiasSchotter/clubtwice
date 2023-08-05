import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:clubtwice/core/services/articles_service.dart';
import 'package:clubtwice/core/services/user_service.dart';
import '../widgets/filter_tile_widget.dart';
import '../widgets/search_field_tile.dart';
import 'package:clubtwice/core/model/UserModel.dart';

class SearchResultPage extends StatefulWidget {
  final String searchKeyword;
  SearchResultPage({required this.searchKeyword});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  List<ArticleWithId> articlesWithID = [];
  List<String> searchHistory = [];
  UserModel? userModel;
  String currentSearchKeyword = "";

  final UserService userService = UserService();
  final ArticleService articleService = ArticleService();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
    currentSearchKeyword = widget.searchKeyword;
    loadData();
  }

  Future<void> loadData() async {
    String? userId = userService.getCurrentUserId();
    userModel = await userService.fetchUserData(userId);

    setState(() {
      searchHistory = userModel?.search ?? [];
    });

    List<ArticleWithId> articleList =
        await articleService.fetchArticlesClubWide(widget.searchKeyword);
    if (articleList.isNotEmpty) {
      setState(() {
        articlesWithID = articleList;
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
      'search': searchHistory,
    });
  }

  void updateSearchList(String searchTerm) {
    if (searchTerm.trim().isEmpty) {
      // Ignore empty or whitespace-only search terms
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
      searchHistory.insert(
          0, searchTerm); // Insert the newest search term at the beginning
    });

    saveChanges();
  }

  Future<void> performSearch(String searchTerm) async {
    if (searchTerm.trim().isEmpty) {
      // Ignore empty or whitespace-only search terms
      return;
    }

    // Update the search keyword in the UI
    setState(() {
      currentSearchKeyword = searchTerm;
    });

    // Update the search history
    setState(() {
      if (searchHistory.contains(searchTerm)) {
        // Remove the duplicated search term
        searchHistory.remove(searchTerm);
      } else if (searchHistory.length >= 7) {
        // Remove the oldest search term
        searchHistory.removeAt(6);
      }
      searchHistory.insert(
          0, searchTerm); // Insert the newest search term at the beginning
    });

    // Save changes to Firestore
    saveChanges();

    // Perform the search and update the search results
    List<ArticleWithId> articleList =
        await articleService.fetchArticlesClubWide(searchTerm);
    setState(() {
      articlesWithID = articleList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const PageSwitcher(
                selectedIndex: 1,
              ),
            ));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: SizedBox(
          height: 40,
          child: SearchField(
            hintText: 'Suche Vereinskleidung aller Vereine',
            onSubmitted: performSearch,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // 1 - Related
          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              const ExpansionTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                title: Text('Filter'),
                backgroundColor: AppColor.primary,
                children: <Widget>[
                  FilterWidget(
                    selectedIndex: 1,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  'Suchergebnisse zu $currentSearchKeyword',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(
                    articlesWithID.length,
                    (index) => ItemCard(
                      article: articlesWithID[index].article,
                      articleId: articlesWithID[index].id,
                    ),
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
