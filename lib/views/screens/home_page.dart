import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:clubtwice/views/screens/profile_page_club.dart';
import 'package:clubtwice/views/widgets/filter_tile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Product.dart';
import 'package:clubtwice/core/services/ProductService.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';

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
      });
    }
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
              height: 112,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Center(
                child: Text(
                  'Du hast noch keinen Verein und Sportart hinterlegt.\n Hier auf deiner Home-Page werden alle Produkte deines Vereins angezeigt',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            SizedBox(height: 16),
            CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePageClub()),
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
          child: TextField(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageSwitcher(selectedIndex: 1)),
              );
            },
            autofocus: false,
            style:
                TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
            decoration: InputDecoration(
              hintStyle:
                  TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
              hintText: 'Suche nach Vereinskleidung aller Vereine ...',
              prefixIcon: Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.search_outlined,
                    color: Colors.white.withOpacity(0.5)),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 1),
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
                    children: [
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
          ExpansionTile(
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
