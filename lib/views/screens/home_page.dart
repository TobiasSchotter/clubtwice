import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/views/screens/otp_verification_page.dart';
import 'package:clubtwice/views/screens/profile_page_club.dart';
import 'package:clubtwice/views/screens/search_result_page.dart';
import 'package:clubtwice/views/widgets/filter_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';

import '../../core/model/Search.dart';
import '../../core/model/article.dart';
import '../../core/services/SearchService.dart';
import '../widgets/search_field_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List<Product> productData = ProductService.productData;
  String verein = '';
  String sportart = '';
  List<Article> articleData = [];

  List<SearchHistory> listSearchHistory = SearchService.listSearchHistory;
  List<String> search = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    //checkUserVerification();
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
        verein = userData['club'] ?? '';
        sportart = userData['sport'] ?? '';
        search = List<String>.from(userData['search'] ?? []);
      });

      fetchArticles();
    }
  }

  Future<void> fetchArticles() async {
    if (verein != '' && verein.isNotEmpty) {
      // Alle Artikel mit dem entsprechenden Sportverein des aktuellen Nutzers abrufen
      QuerySnapshot articleSnapshot = await FirebaseFirestore.instance
          .collection('articles')
          .where('club', isEqualTo: verein)
          .get();

      List<Article> articles = [];

      // Die abgerufenen Artikel in Artikelobjekte umwandeln
      //for (QueryDocumentSnapshot doc in articleSnapshot.docs) {
      for (QueryDocumentSnapshot doc in articleSnapshot.docs) {
        articles.add(Article.fromFirestore(doc));
      }

      setState(() {
        articleData = articles;
      });
    } else {
      print("fetchArticles: Verein ist leer");
      //TODO error handling
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
      'search': search,
    });
  }

  void updateSearchList(String searchTerm) {
    setState(() {
      if (search.length >= 7) {
        // Remove the oldest search term
        search.removeAt(0);
      }
      search.add(searchTerm);
    });
    saveChanges();
  }

  Future<void> clearSearchHistory() async {
    setState(() {
      search = [];
    });
    saveChanges();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (verein.isNotEmpty && verein != "Keine Auswahl") {
      if (articleData.isNotEmpty) {
        content = Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: List.generate(
              articleData.length,
              (index) => ItemCard(
                article: articleData[index],
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
        title: Container(
          height: 40,
          child: SearchField(
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
          // Section 1
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
              // FilterWidget2(),
            ],
          ),
          // Section 5 - product list
          content,
        ],
      ),
    );
  }
}
