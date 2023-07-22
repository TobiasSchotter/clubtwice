import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/views/screens/profile_page_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clubtwice/core/services/user_service.dart';
import 'package:share/share.dart';
import '../../constant/app_button.dart';
import '../../core/model/article.dart';

class ProductDetail extends StatefulWidget {
  final Article article;
  final String id;

  const ProductDetail({
    super.key,
    required this.article,
    required this.id,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PageController productImageSlider = PageController();
  String profileImageUrl = '';
  String userName = '';
  final UserService userService = UserService();
  int articleCount = 10;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List<String> dataList =
        await userService.fetchUserProfileImageUrl(widget.article.userId);

    if (dataList.isNotEmpty) {
      setState(() {
        profileImageUrl = dataList[0];
        userName = dataList[1];
      });
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
                if (article.isSold == true) {
                  articleNotSold();
                } else {
                  articleSold();
                }
              } else if (value == 'reserved') {
                if (article.isReserved == true) {
                  articleNotReserved();
                } else {
                  articleReserved();
                }
              } else if (value == 'delete') {
                articleDelete();
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

              if (!article.isDeleted) {
                // Check if the article is not deleted
                if (isCurrentUserArticle) {
                  menuItems.add(
                    PopupMenuItem<String>(
                      value: 'sold',
                      child: ListTile(
                        title: Text(
                            article.isSold ? 'Nicht Verkauft' : 'Verkauft'),
                      ),
                    ),
                  );

                  if (!article.isSold) {
                    menuItems.add(
                      PopupMenuItem<String>(
                        value: 'reserved',
                        child: ListTile(
                          title: Text(
                            article.isReserved ? 'Aktivieren' : 'Reservieren',
                          ),
                        ),
                      ),
                    );
                  }

                  menuItems.add(
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        title: Text('Löschen'),
                      ),
                    ),
                  );

                  if (!article.isSold) {
                    menuItems.add(
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          title: Text('Bearbeiten'),
                        ),
                      ),
                    );
                  }
                }
              }

              menuItems.add(
                const PopupMenuItem<String>(
                  value: 'report',
                  child: ListTile(
                    title: Text('Melden'),
                  ),
                ),
              );

              return menuItems;
            },
            icon: const Icon(Icons.more_horiz),
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
                  shareArticle();
                },
                icon: const Icon(
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
                  favoriteArticle();
                },
                icon: const Icon(
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
                  GestureDetector(
                    onTap: () {},
                    child: Container(
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
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .end, // Align children to the right
                              children: [
                                const Text(
                                  'Weitere ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '$articleCount',
                                  // '${widget.articleCount}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const Text(
                                  ' Artikel',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                // RichText(
                //  text: TextSpan(
                //    children: [
                //     TextSpan(
                //     text:
                //       "Artikel individuell tragabar: ${article.isIndividuallyWearable ? 'Ja' : 'Nein'}",
                //   style: TextStyle(
                //     color: AppColor.secondary.withOpacity(0.7),
                //    height: 1.5,
                //    ),
                //   ),
                //   ],
                //   ),
                //   ),
                // Container(
                //  height: 1,
                //   color: Colors.grey,
                //   margin: const EdgeInsets.symmetric(vertical: 8),
                // ),
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

  void favoriteArticle() {}

  void shareArticle() {
    if (widget.article.images.isNotEmpty) {
      String imageUrl =
          widget.article.images[0]; // Share the first image in the list

      Share.share('Check out this article!\n'
          'Title: ${widget.article.title}\n'
          'Description: ${widget.article.description}\n'
          'Price: ${widget.article.price} €\n'
          // 'Image: $imageUrl', // You can add more details as needed
          );
    } else {
      // If there are no images, share the article without an image
      Share.share(
        'Check out this article!\n'
        'Title: ${widget.article.title}\n'
        'Description: ${widget.article.description}\n'
        'Price: ${widget.article.price} €\n',
      );
    }
  }

  void updateArticleStatus(String field, bool value, String successMessage,
      String errorMessage) async {
    // Get a reference to the Firestore collection
    CollectionReference articlesRef =
        FirebaseFirestore.instance.collection('articles');

    try {
      // Update the document in Firestore with the new data
      await articlesRef.doc(widget.id).update({field: value});

      // Show a success message to the user, if desired
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfilePageItem()));
    } catch (error) {
      // Handle any errors that occurred during the update process
      print('Error marking article as sold: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  void articleSold() {
    updateArticleStatus(
      'isSold',
      true,
      'Artikel verkauft',
      'Artikel konnte nicht verkauft werden',
    );
  }

  void articleNotSold() {
    updateArticleStatus(
      'isSold',
      false,
      'Artikel wiedereinstellen',
      'Artikel konnte nicht wiedereingestellt werden',
    );
  }

  void articleReserved() {
    updateArticleStatus(
      'isReserved',
      true,
      'Artikel reserviert',
      'Artikel konnte nicht reserviert werden',
    );
  }

  void articleNotReserved() {
    updateArticleStatus(
      'isReserved',
      false,
      'Artikel aktiviert',
      'Artikel konnte nicht aktviert werden',
    );
  }

  void articleDelete() {
    updateArticleStatus(
      'isDeleted',
      true,
      'Artikel wurde gelöscht',
      'Artikel konnte nicht gelöscht werden',
    );
  }

  void articleEdit() {}

  void articleReport() {}
}
