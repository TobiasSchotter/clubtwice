import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/core/services/articles_service.dart';
import 'package:clubtwice/core/services/user_service.dart';
import '../../../constant/app_button.dart';
import '../../widgets/profile_tile_widget.dart';
import 'package:clubtwice/core/model/UserModel.dart';

class ProfilePageItem extends StatefulWidget {
  ProfilePageItem({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  State<ProfilePageItem> createState() => _ProfilePageItemState();
}

class _ProfilePageItemState extends State<ProfilePageItem> {
  // List<Product> productData = ProductService.productData;

  List<ArticleWithId> articlesWithID = [];
  String club = '';
  String sport = '';
  String searchTerm = '';
  final UserService userService = UserService();
  final ArticleService articleService = ArticleService();
  UserModel? userModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String? userId = userService.getCurrentUserId();
    userModel = await userService.fetchUserData(userId);

    setState(() {
      club = userModel!.club;
      sport = userModel!.sport;
    });

    List<ArticleWithId> articleList =
        await articleService.fetchUserArticles(searchTerm, widget.user!.uid);

    setState(() {
      articlesWithID = articleList;
      isLoading = false;
    });
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const PageSwitcher(
                    selectedIndex: 4,
                  ),
                ));
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            height: 46,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deine Anzeigen',
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
                              "Du hast noch keine Artikel eingestellt. \n Verkaufe jetzt deine Artikel hier.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const PageSwitcher(
                                          selectedIndex: 2,
                                        )));
                              },
                              buttonText: 'Jetzt verkaufen',
                            ),
                          ],
                        ),
                      ),
          )
        ],
      ),
    );
  }
}
