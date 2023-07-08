import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/widgets/item_card.dart';

import '../../core/model/article.dart';
import '../widgets/filter_tile_widget.dart';
import '../widgets/search_field_tile.dart';

class SearchResultPage extends StatefulWidget {
  final String searchKeyword;
  SearchResultPage({required this.searchKeyword});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  TextEditingController searchInputController = TextEditingController();

  List<Article> searchedArticleData = [];

  List<String> search = [];

  @override
  void initState() {
    super.initState();
    searchInputController.text = widget.searchKeyword;
    tabController = TabController(length: 1, vsync: this);
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
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    QuerySnapshot<Map<String, dynamic>> articleSnapshot =
        await FirebaseFirestore.instance.collection('articles').get();

    List<Article> articles = [];

    for (QueryDocumentSnapshot doc in articleSnapshot.docs) {
      Article article = Article.fromFirestore(doc);
      if (article.title
          .toLowerCase()
          .contains(widget.searchKeyword.toLowerCase())) {
        articles.add(article);
      }
    }

    setState(() {
      searchedArticleData = articles;
    });
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
                  // FilterWidget2(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  'Suchergebnisse zu ${widget.searchKeyword}',
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
                    searchedArticleData.length,
                    (index) => ItemCard(
                      article: searchedArticleData[index],
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
