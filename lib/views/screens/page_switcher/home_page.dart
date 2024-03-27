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
  String _searchTerm = '';
  List<ArticleWithId> articlesWithID = [];
  bool hasSearchResults = true;
  final UserService userService = UserService();
  final ArticleService articleService = ArticleService();
  UserModel? userModel;
  bool isExpansionTileOpen = false; // Track the state of the ExpansionTile

  final ScrollController _scrollController = ScrollController();
  int _limit = 8;

  String sportart = '';
  String typ = '';
  String groesse = '';
  String marke = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Move the call to loadData to after initState is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(null);
    });
  }

  @override
  void dispose() {
    // Dispose the scroll controller
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Check if the user has reached the end of the list
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more articles
      double currentPosition = _scrollController.position.pixels;
      loadData(currentPosition);
    }
  }

  Future<void> loadData(double? currentPosition) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      try {
        String? userId = userService.getCurrentUserId();
        userModel = await userService.fetchUserData(userId);
        club = userModel!.club;

        List<ArticleWithId> additionalArticles =
            await articleService.fetchArticles(
          _searchTerm,
          club,
          sportart,
          typ,
          groesse,
          marke,
          limit: _limit,
          startArticle: articlesWithID.isNotEmpty ? articlesWithID.last : null,
        );

        // Filter out duplicates before adding to the list
        // Ansbach fix
        List<ArticleWithId> uniqueArticles = additionalArticles
            .where((article) => !articlesWithID
                .any((existingArticle) => existingArticle.id == article.id))
            .toList();

        setState(() {
          articlesWithID.addAll(uniqueArticles);
          _limit += additionalArticles.length;
          isLoading = false;
          hasSearchResults = articlesWithID.isNotEmpty;
        });

        // Scroll back to the previous position
        if (_scrollController.hasClients && currentPosition != null) {
          _scrollController.jumpTo(currentPosition);
        }
      } catch (error) {
        // Handle error
        print("Error: $error");
        setState(() {
          isLoading = false;
        });
      }
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
    return Scaffold(
      appBar: buildAppBar(),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: [
              buildHeader(),
              buildFilterExpansionTile(),
              Expanded(
                child: buildArticleList(),
              ),
            ],
          );
        },
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
                .fetchArticles(searchTerm, club, sportart, typ, groesse, marke,
                    limit: _limit);
            setState(() {
              articlesWithID = articleList;
              hasSearchResults = articlesWithID.isNotEmpty;
              _searchTerm = searchTerm;
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
            child: const Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
      String selectedTyp, String selectedGroesse, String selectedMarke) async {
    setState(() {
      //club = selectedClub;
      _searchTerm = '';
      sportart = selectedSportart;
      typ = selectedTyp;
      groesse = selectedGroesse;
      marke = selectedMarke;
      articlesWithID.clear(); // Clear the list when applying filters
      _limit = 8; // Reset the limit when applying filters
    });

    await loadData(null); // Reload data with the applied filters
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
                'Keine passenden Artikel zu deiner Suche. \n Entweder gibt es noch keinen Artikel aus deinem Verein oder du musst deine Filter anpassen.',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      controller: _scrollController,
      child: Column(
        children: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            ),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: articlesWithID.map((article) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 16 - 8,
                child:
                    ItemCard(article: article.article, articleId: article.id),
              );
            }).toList(),
          ), // To be improved

          if (!isLoading && !hasSearchResults) buildNoSearchResults(),
          if (!isLoading && club.isEmpty) buildNoClubMessage(),
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
