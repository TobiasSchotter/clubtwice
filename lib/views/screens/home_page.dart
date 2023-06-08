import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/views/screens/profile_page_club.dart';
import 'package:clubtwice/views/screens/search_result_page.dart';
import 'package:clubtwice/views/widgets/filter_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Product.dart';
import 'package:clubtwice/core/services/ProductService.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';

import '../../core/model/Search.dart';
import '../../core/services/SearchService.dart';
import '../widgets/search_field_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> productData = ProductService.productData;
  String verein = '';
  String sportart = '';

  List<SearchHistory> listSearchHistory = SearchService.listSearchHistory;
  List<String> search = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
        search = List<String>.from(userData['search'] ?? []);
      });
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
    if (verein.isNotEmpty) {
      content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(
            productData.length,
            (index) => ItemCard(
              product: productData[index],
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Center(
                child: Text(
                  'Du hast noch keinen Verein und Sportart hinterlegt.\n Hier auf deiner Home-Page werden alle Produkte deines Vereins angezeigt',
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
                            fontSize: 18,
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
            title: Text('Filter'),
            backgroundColor: AppColor.primary,
            children: <Widget>[
              FilterWidget(),
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
