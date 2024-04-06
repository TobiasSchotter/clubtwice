import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/core/services/articles_service.dart';
import '../../widgets/profile_tile_widget.dart';
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
  bool isLoading = true; // Flag zur Anzeige des Ladebildschirms

  @override
  void initState() {
    super.initState();
    // Setzen Sie isLoading auf true, um den Ladebildschirm zu aktivieren.
    loadData();
  }

  Future<void> loadData() async {
    String? userId = userService.getCurrentUserId();
    userModel = await userService.fetchUserData(userId);

    List<String> favoriteArticleIds = userModel?.favorites ?? [];

    List<ArticleWithId> articleList =
        await articleService.fetchArticlesByIds(favoriteArticleIds);

    setState(() {
      articlesWithID = articleList;
      isLoading =
          false; // Daten wurden geladen oder es gab einen Fehler, den Ladebildschirm ausblenden
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(220),
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
              flexibleSpace: const MyProfileWidget()),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              height: 44,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Deine Anzeigen',
                    style: TextStyle(
                      color: AppColor.border,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(), // Ladebildschirm anzeigen
                          )
                        : articlesWithID.isNotEmpty
                            ? Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: List.generate(
                                  articlesWithID.length,
                                  (index) => ItemCard(
                                    article: articlesWithID[index].article,
                                    articleId: articlesWithID[index].id,
                                  ),
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(height: 160),
                                    const Text(
                                      "Du hast noch keine Artikel favorisiert. \n Markiere deine Favoriten und finde Sie hier wieder.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(height: 16),
                                    AppButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SearchResultPage(
                                                      searchKeyword: '',
                                                    )));
                                      },
                                      buttonText: 'Jetzt suchen',
                                    ),
                                  ],
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
