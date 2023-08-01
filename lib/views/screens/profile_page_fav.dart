import 'package:clubtwice/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/core/services/articles_service.dart';
import '../widgets/profile_tile_widget.dart';
import 'package:clubtwice/core/model/UserModel.dart';
import 'package:clubtwice/core/services/user_service.dart';

class ProfilePageFav extends StatefulWidget {
  ProfilePageFav({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  State<ProfilePageFav> createState() => _ProfilePageFavState();
}

class _ProfilePageFavState extends State<ProfilePageFav> {
  List<ArticleWithId> articlesWithID = [];
  final UserService userService = UserService();
  final ArticleService articleService = ArticleService();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    userModel = await userService.fetchUserData();

    List<String> favoriteArticleIds = userModel?.favorites ?? [];

    List<ArticleWithId> articleList =
        await articleService.fetchArticlesByIds(favoriteArticleIds);

    if (articleList.isNotEmpty) {
      setState(() {
        articlesWithID = articleList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(192),
        child: AppBar(
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
            flexibleSpace: const MyProfileWidget(showCameraIcon: false)),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 46,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Deine Favoriten',
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
