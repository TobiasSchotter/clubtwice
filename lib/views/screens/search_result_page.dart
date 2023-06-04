import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Product.dart';
import 'package:clubtwice/core/services/ProductService.dart';
import 'package:clubtwice/views/widgets/item_card.dart';

import '../widgets/filter_tile_widget.dart';

class SearchResultPage extends StatefulWidget {
  final String searchKeyword;
  SearchResultPage({required this.searchKeyword});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  TextEditingController searchInputController = TextEditingController();
  List<Product> searchedProductData = ProductService.searchedProductData;

  List<String> search = [];

  @override
  void initState() {
    super.initState();
    searchInputController.text = widget.searchKeyword;
    tabController = TabController(length: 4, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
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
            autofocus: false,
            controller: searchInputController,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              hintStyle:
                  TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
              hintText: 'Finde Vereinskleidung aller Vereine',
              prefixIcon: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.search, color: Colors.white)
                  //color: Colors.white),
                  ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              fillColor: Colors.white.withOpacity(0.1),
              filled: true,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // 1 - Related
          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
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
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  'Suchergebnisse zu ${widget.searchKeyword}',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(
                    searchedProductData.length,
                    (index) => ItemCard(
                      product: searchedProductData[index],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(),
          const SizedBox(),
          const SizedBox(),
        ],
      ),
    );
  }
}
