import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../constant/app_button.dart';
import '../../core/model/article.dart';

class ProductDetail extends StatefulWidget {
  //final Product product;
  final Article article;
  const ProductDetail(
      //{super.key, required this.product});
      {super.key,
      required this.article});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PageController productImageSlider = PageController();
  String profileImageUrl = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      String userId = widget.article.userId; // UserID aus dem Artikel
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        if (userData != null) {
          setState(() {
            profileImageUrl = userData.containsKey('profileImageUrl')
                ? userData['profileImageUrl']
                : '';
            userName =
                userData.containsKey('username') ? userData['username'] : '';
          });
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    //Product product = widget.product;
    Article article = widget.article;
    Timestamp firebaseTimestamp = article.updatedAt;
    DateTime dateTime = firebaseTimestamp.toDate();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(article.title),
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.black,
          alignment: Alignment.center,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle different options based on the selected value
              if (value == 'sold') {
                articleSold();
              } else if (value == 'reserved') {
                articleReserved();
                // Perform delete operation
              } else if (value == 'delete') {
                articleDelet();
                // Perform delete operation
              } else if (value == 'edit') {
                articleEdit();
                // Perform edit operation
              } else if (value == 'report') {
                // Perform report operation
                articleReport();
              }
            },
            itemBuilder: (BuildContext context) {
              // Check if the article belongs to the current user
              bool isCurrentUserArticle =
                  FirebaseAuth.instance.currentUser?.uid == article.userId;

              // Create a list of PopupMenuEntry based on the conditions
              List<PopupMenuEntry<String>> menuItems = [];

              if (isCurrentUserArticle) {
                menuItems.add(
                  const PopupMenuItem<String>(
                    value: 'sold',
                    child: ListTile(
                      title: Text('Verkauft markieren'),
                    ),
                  ),
                );
                menuItems.add(
                  const PopupMenuItem<String>(
                    value: 'reserved',
                    child: ListTile(
                      title: Text('Reserviert markieren'),
                    ),
                  ),
                );

                menuItems.add(
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      title: Text('Artikel löschen'),
                    ),
                  ),
                );
                menuItems.add(
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(
                      title: Text('Artikel bearbeiten'),
                    ),
                  ),
                );
              }
              menuItems.add(
                const PopupMenuItem<String>(
                  value: 'report',
                  child: ListTile(
                    title: Text('Artikel melden'),
                  ),
                ),
              );

              return menuItems;
            },
            icon: Icon(Icons.more_horiz),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              margin: const EdgeInsets.only(right: 14),
              child: IconButton(
                onPressed: () {
                  // Implementiere die Logik für die Favorisieren-Funktion hier
                },
                icon: Icon(
                  Icons.share_outlined,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(right: 14),
                child: CustomButton(
                  onPressed: () {
                    // Implementiere die Logik für die Anfragen-Funktion hier
                  },
                  buttonText: 'Anfragen',
                ),
              ),
            ),
            Container(
              width: 40,
              margin: const EdgeInsets.only(right: 14),
              child: IconButton(
                onPressed: () {
                  // Implementiere die Logik für die Teilen-Funktion hier
                },
                icon: Icon(
                  Icons.favorite_border,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // product image
              CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 16 / 9, // Seitenverhältnis der Bilder
                    autoPlay: true, // Automatische Wiedergabe aktivieren
                    enlargeCenterPage: true,
                    height: 300 // Aktives Bild vergrößern
                    ),
                items: article.images.isNotEmpty
                    ? article.images.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList()
                    : [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.asset(
                            'assets/images/placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
              )
            ],
          ),
          // Section 2 - product info

          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          article.title,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'poppins',
                              color: AppColor.secondary),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    "${article.price} €",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'poppins',
                        color: AppColor.primary),
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                if (profileImageUrl.isNotEmpty)
                  Container(
                    // padding: const EdgeInsets.all(16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(profileImageUrl),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                Text(
                  (article.description),
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      fontSize: 18,
                      height: 150 / 100),
                ),
                // Separator line
                Container(
                  height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: article.condition,
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: ' • ',
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: article.size,
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: ' • ',
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                          text: article.type,
                          style: TextStyle(
                            color: AppColor.secondary.withOpacity(0.7),
                            height: 1.5,
                          )),
                      TextSpan(
                        text: ' • ',
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: article.brand,
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: article.club,
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: ' • ',
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: article.sport,
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "Artikel individuell tragabar: ${article.isIndividuallyWearable ? 'Ja' : 'Nein'}",
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void articleSold() {}

  void articleReserved() {}

  void articleDelet() {}

  void articleEdit() {}

  void articleReport() {}
}
