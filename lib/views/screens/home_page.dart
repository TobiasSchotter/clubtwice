import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/core/services/articles_service.dart';
import 'package:clubtwice/core/services/user_service.dart';
import 'package:clubtwice/views/screens/profile_page_club.dart';
import 'package:clubtwice/views/widgets/filter_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';
import '../widgets/search_field_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String verein = '';
  String sportart = '';
  List<ArticleWithId> articlesWithID = [];
  String searchTerm = '';
  final UserService userService = UserService();
  final ArticleService articleService = ArticleService();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List vereinSportartList = await userService.fetchUserClubInformation();

    if (vereinSportartList.isNotEmpty) {
      setState(() {
        verein = vereinSportartList[0];
        sportart = vereinSportartList[1];
      });
    }

    List<ArticleWithId> articleList =
        await articleService.fetchArticles(searchTerm, verein);

    if (articleList.isNotEmpty) {
      setState(() {
        articlesWithID = articleList;
      });
      //example needs to be removed
      print(articlesWithID[0].id);
    }
  }

  // void checkUserVerification() async {
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser != null && !currentUser.emailVerified) {
  //     await Future.delayed(const Duration(
  //         milliseconds: 500)); // Verzögerung von 500 Millisekunden
  //     // Benutzer ist eingeloggt, aber nicht verifiziert
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const OTPVerificationPage()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (verein.isNotEmpty && verein != "Keine Auswahl") {
      if (articlesWithID.isNotEmpty) {
        content = Container(
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
        );
      } else {
        content = Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 160,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: const Center(
                  child: Text(
                    'Aktuell gibt es noch keine Artikel von deinem Verein.\n Sobald es welche gibt, werden sie hier angezeigt.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }
    } else {
      content = Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 160,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Center(
                child: Text(
                  'Du hast noch keinen Verein hinterlegt.\n Hier auf deiner Home-Page werden alle Produkte deines Vereins angezeigt',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilePageClub()),
                );
              },
              buttonText: 'Verein hinterlegen',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        title: SizedBox(
          height: 40,
          child: SearchField(
            hintText: 'Suche Vereinskleidung deines Vereins',
            onSubmitted: (searchTerm) async {
              List<ArticleWithId> articleList =
                  await articleService.fetchArticles(searchTerm, verein);
              if (articleList.isNotEmpty) {
                setState(() {
                  articlesWithID = articleList;
                });
              }
            },
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColor.primary,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Expanded(
                        child: Text(
                          'Artikel aus deinem Verein 💪 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            height: 150 / 100,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const ExpansionTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            title: Text(
              'Filter',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: AppColor.primary,
            children: <Widget>[
              FilterWidget(
                selectedIndex: 0,
              ),
            ],
          ),
          content,
        ],
      ),
    );
  }
}
