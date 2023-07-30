import 'package:clubtwice/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/core/services/articles_service.dart';

class UserPage extends StatefulWidget {
  UserPage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<ArticleWithId> articlesWithID = [];
  String searchTerm = '';
  final ArticleService articleService = ArticleService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<ArticleWithId> articleList =
        await articleService.fetchUserArticles(searchTerm, widget.user!.uid);

    if (articleList.isNotEmpty) {
      setState(() {
        articlesWithID = articleList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture - Username - Name
          // const MyProfileWidget(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 46,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Anzeigen von',
                  style: TextStyle(
                      color: AppColor.border,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          )
        ],
      ),
    );
  }
}
