import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/views/screens/profile_page_club.dart';
import 'package:clubtwice/views/widgets/filter_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';
import '../../core/model/article.dart';
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
  List<Article> articleData = [];
  String searchTerm = '';

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
      });

      fetchArticles(searchTerm);
    }
  }

  Future<void> fetchArticles(String searchTerm) async {
    if (verein != '' && verein.isNotEmpty) {
      Query articlesQuery = FirebaseFirestore.instance
          .collection('articles')
          .where('club', isEqualTo: verein);

      QuerySnapshot articleSnapshot = await articlesQuery.get();

      List<Article> articles = [];

      for (QueryDocumentSnapshot doc in articleSnapshot.docs) {
        Article article = Article.fromFirestore(doc);
        if (article.title.toLowerCase().contains(searchTerm.toLowerCase())) {
          articles.add(article);
        }
      }

      articles.sort((b, a) => a.createdAt.compareTo(b.createdAt));

      setState(() {
        articleData = articles;
      });
    } else {
      print("fetchArticles: Verein ist leer");
      // TODO: error handling
    }
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
            hintText: 'Suche Vereinskleidung deines Vereins',
            onSubmitted: (searchTerm) {
              fetchArticles(searchTerm);
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
