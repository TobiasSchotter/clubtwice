import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/core/services/articles_service.dart';
import 'package:clubtwice/core/services/user_service.dart';
import 'package:clubtwice/views/screens/profile_page/profile_page_club.dart';
import 'package:clubtwice/views/widgets/filter_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';
import '../../widgets/search_field_tile.dart';
import 'package:clubtwice/core/model/UserModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String club = '';
  String searchTerm = '';
  List<ArticleWithId> articlesWithID = [];
  bool hasSearchResults = true;
  final UserService userService = UserService();
  final ArticleService articleService = ArticleService();
  UserModel? userModel;
  bool isExpansionTileOpen = false; // Track the state of the ExpansionTile

  String sportart = '';
  String typ = '';
  String groesse = '';
  String marke = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    String? userId = userService.getCurrentUserId();
    userModel = await userService.fetchUserData(userId);

    setState(() {
      club = userModel!.club;
    });

    List<ArticleWithId> articleList = await articleService.fetchArticles(
        searchTerm, club, sportart, typ, groesse, marke);

    setState(() {
      articlesWithID = articleList;
      hasSearchResults = articleList.isNotEmpty;
      isLoading = false;
    });
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

  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      // Zeige einen Ladebalken während der Datenabfrage
      content = const CircularProgressIndicator();
    } else if (club.isNotEmpty && club != "Keine Auswahl") {
      if (!hasSearchResults) {
        content = buildNoSearchResults();
      } else if (articlesWithID.isNotEmpty) {
        content = buildArticleList();
      } else {
        content = buildNoArticlesMessage();
      }
    } else {
      content = buildNoClubMessage();
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          buildHeader(),
          buildFilterExpansionTile(),
          content,
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: AppColor.primary,
      elevation: 0,
      title: SizedBox(
        height: 40,
        child: SearchField(
          hintText: 'Suche Vereinskleidung deines Vereins',
          onSubmitted: (searchTerm) async {
            List<ArticleWithId> articleList = await articleService
                .fetchArticles(searchTerm, club, sportart, typ, groesse, marke);
            setState(() {
              articlesWithID = articleList;
              hasSearchResults = articleList.isNotEmpty;
            });
          },
        ),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  Widget buildHeader() {
    return Container(
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
                    'Artikel aus deinem Verein 💪',
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
    );
  }

  ExpansionTile buildFilterExpansionTile() {
    return ExpansionTile(
      iconColor: Colors.white,
      textColor: Colors.white,
      title: const Text(
        'Filter',
        style: TextStyle(fontSize: 16),
      ),
      initiallyExpanded: isExpansionTileOpen,
      onExpansionChanged: (expanded) {
        setState(() {
          isExpansionTileOpen = expanded;
        });
      },
      backgroundColor: AppColor.primary,
      children: <Widget>[
        FilterWidget(
          selectedIndex: 0,
          applyFilters: applyFilters,
          isHomePage: true,
          setExpansionTileState: (bool value) {
            setState(() {
              isExpansionTileOpen = value;
            });
          },
        ),
      ],
    );
  }

  // Callback function to update filter values and reload data
  void applyFilters(String selectedClub, String selectedSportart,
      String selectedTyp, String selectedGroesse, String selectedMarke) {
    setState(() {
      //club = selectedClub;
      sportart = selectedSportart;
      typ = selectedTyp;
      groesse = selectedGroesse;
      marke = selectedMarke;
    });

    loadData(); // Reload data with the applied filters
  }

  Widget buildNoSearchResults() {
    return Container(
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
                'Keine passenden Artikel zu deiner Suche.',
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

  Widget buildArticleList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: articlesWithID.map((article) {
          return ItemCard(article: article.article, articleId: article.id);
        }).toList(),
      ),
    );
  }

  Widget buildNoArticlesMessage() {
    return Container(
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

  Widget buildNoClubMessage() {
    return Container(
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
                'Du hast noch keinen Verein hinterlegt.\n Hier auf deiner Home-Page werden alle Produkte deines Vereins angezeigt.',
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
}
