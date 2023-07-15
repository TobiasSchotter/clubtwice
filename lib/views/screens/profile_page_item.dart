import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';

import '../../core/model/article.dart';
import '../widgets/profile_tile_widget.dart';

class ProfilePageItem extends StatefulWidget {
  ProfilePageItem({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  State<ProfilePageItem> createState() => _ProfilePageItemState();
}

class _ProfilePageItemState extends State<ProfilePageItem> {
  //List<Product> productData = ProductService.productData;

  List<Article> articleData = [];
  String verein = '';
  String sportart = '';
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    //checkUserVerification();
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
          .where('club', isEqualTo: verein)
          .where('userId',
              isEqualTo: FirebaseAuth.instance.currentUser!
                  .uid); // Nur Artikel des aktuellen Benutzers abrufen

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
          const MyProfileWidget(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 46,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meine Anzeigen',
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
                articleData.length,
                (index) => ItemCard(
                  article: articleData[index],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
