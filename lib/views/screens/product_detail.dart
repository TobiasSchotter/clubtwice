import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/views/screens/profile_page/profile_page_item.dart';
import 'package:clubtwice/views/screens/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clubtwice/core/services/user_service.dart';
import 'package:share/share.dart';
import '../../constant/app_button.dart';
import '../../core/model/Article.dart';
import 'package:clubtwice/core/model/UserModel.dart';

class ProductDetail extends StatefulWidget {
  final Article article;
  final String id;

  const ProductDetail({
    Key? key,
    required this.article,
    required this.id,
  }) : super(key: key);

  @override
  // Warning: Invalid use of a private type in a public API.
  // Theoreitsch müssten _ProductDetailState und ProductDetail in zwei verschiedene Dateien, da (Unterstrich) Aussagt, dass die State private ist. Heißt Es ist nur in dieser File erlaubt aber die
  // folgende Zeile erstellt einen State des Widgets ProductDetails was quasi eine Reference außerhalb dieser File macht.
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PageController productImageSlider = PageController();
  String profileImageUrl = '';
  String? userName = '';
  bool isArticleFavorite = false; // Track whether the article is in favorites

  // Services
  final UserService userService = UserService();
  UserModel? userModel;

  // params for additional articles
  int articleCount = 0;
  bool isFetching = true;
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    loadData();
    fetchArticleCount();
    checkAndSetIsArticleFavorite(widget.id);
  }

  Future<void> loadData() async {
    // user Daten des Erstellers des Artikels
    userModel = await userService.fetchUserData(widget.article.userId);

    setState(() {
      profileImageUrl = userModel?.profileImageUrl ?? '';
      userName = userModel!.username;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.article.updatedAt.toDate();
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.article.title),
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
          Builder(
            builder: (BuildContext context) {
              return PopupMenuButton<String>(
                onSelected: (value) => handlePopupMenuSelection(value),
                itemBuilder: (BuildContext context) => buildPopupMenuItems(),
                icon: const Icon(Icons.more_horiz),
              );
            },
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Builder(
                  builder: (BuildContext context) {
                    bool enableInfiniteScroll =
                        widget.article.images.length > 1;

                    return CarouselSlider(
                      options: CarouselOptions(
                          //aspectRatio: 3 / 4,
                          autoPlay: true,
                          //  enlargeCenterPage: true,
                          height: 650,
                          enableInfiniteScroll: enableInfiniteScroll,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentImageIndex = index;
                            });
                          },
                          viewportFraction: 1.0),
                      items: widget.article.images.isNotEmpty
                          ? widget.article.images.map((imageUrl) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              );
                            }).toList()
                          : [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Image.asset(
                                  'assets/images/placeholder.jpg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                    );
                  },
                ),
                Positioned(
                  top: 620.0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.article.images.isNotEmpty
                        ? widget.article.images.asMap().entries.map((entry) {
                            int index = entry.key;
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentImageIndex == index
                                    ? AppColor.primary
                                    : AppColor.primarySoft,
                              ),
                            );
                          }).toList()
                        : [],
                  ),
                ),
              ],
            ),
            buildBodyContent(dateTime),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  // Functions for handling popup menu item selection

  void handlePopupMenuSelection(String value) {
    final actions = {
      'sold': () => widget.article.isSold ? articleNotSold() : articleSold(),
      'reserved': () =>
          widget.article.isReserved ? articleNotReserved() : articleReserved(),
      'delete': articleDelete,
      'edit': articleEdit,
      'report': articleReport,
    };

    if (actions.containsKey(value)) {
      actions[value]!();
    }
  }

  // Helper methods to build UI elements

  List<PopupMenuEntry<String>> buildPopupMenuItems() {
    bool isCurrentUserArticle =
        FirebaseAuth.instance.currentUser?.uid == widget.article.userId;

    List<PopupMenuEntry<String>> menuItems = [];

    if (!widget.article.isDeleted && isCurrentUserArticle) {
      menuItems.add(
        PopupMenuItem<String>(
          value: 'sold',
          child: ListTile(
            title: Text(widget.article.isSold ? 'Nicht Verkauft' : 'Verkauft'),
          ),
        ),
      );

      if (!widget.article.isSold) {
        menuItems.add(
          PopupMenuItem<String>(
            value: 'reserved',
            child: ListTile(
              title: Text(
                widget.article.isReserved ? 'Aktivieren' : 'Reservieren',
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

      if (!widget.article.isSold) {
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

    menuItems.add(
      const PopupMenuItem<String>(
        value: 'report',
        child: ListTile(
          title: Text('Melden'),
        ),
      ),
    );

    return menuItems;
  }

  ListView buildBodyContent(DateTime dateTime) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          color: Colors.red, // Hinzugefügte Zeile für die rote Linie
          height: 2, // Hinzugefügte Zeile für die rote Linie
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        widget.article.title,
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
                  widget.article.price == 0
                      ? "Zu verschenken"
                      : "${widget.article.price} €",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: widget.article.price == 0
                        ? Colors.green
                        : AppColor.primary,
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              buildUserProfileSection(),
              Container(
                height: 1,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              Visibility(
                visible: widget.article.description.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.description,
                      style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        fontSize: 18,
                        height: 150 / 100,
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ],
                ),
              ),
              buildRichTextInfo(widget.article),
              if (widget.article.club.isNotEmpty &&
                  widget.article.sport.isNotEmpty)
                buildRichTextInfo2(widget.article),
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
    );
  }

  Widget buildBottomNavigationBar(context) {
    return Container(
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
                  // Implement the logic for the requests function here
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
                  toggleFavoriteArticle(
                      context); // Pass the current isArticleFavorite value
                },
                icon: Icon(
                  isArticleFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isArticleFavorite ? Colors.red : null,
                ),
              )),
        ],
      ),
    );
  }

  Column buildRichTextInfo(Article article) {
    final style = TextStyle(
      color: AppColor.secondary.withOpacity(0.7),
      height: 1.5,
    );

    List<InlineSpan> children = [
      if (article.condition.isNotEmpty)
        TextSpan(text: '${article.condition} • ', style: style),
      if (article.size.isNotEmpty)
        TextSpan(text: '${article.size} • ', style: style),
      if (article.type.isNotEmpty) TextSpan(text: article.type, style: style),
      if (article.brand.isNotEmpty)
        TextSpan(text: ' • ${article.brand}', style: style),
    ];

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: children,
            ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey,
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
      ],
    );
  }

  Column buildRichTextInfo2(Article article) {
    final style = TextStyle(
      color: AppColor.secondary.withOpacity(0.7),
      height: 1.5,
    );

    List<InlineSpan> children = [];

    if (article.club.isNotEmpty && article.sport.isNotEmpty) {
      children.add(
        TextSpan(text: '${article.club} • ${article.sport}', style: style),
      );
    } else if (article.club.isNotEmpty) {
      children.add(TextSpan(text: article.club, style: style));
    } else if (article.sport.isNotEmpty) {
      children.add(TextSpan(text: article.sport, style: style));
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: children,
            ),
          ),
        ),
        if (article.club.isNotEmpty && article.sport.isNotEmpty)
          Container(
            height: 1,
            color: Colors.grey,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
      ],
    );
  }

  GestureDetector buildUserProfileSection() {
    return GestureDetector(
      onTap: articleCount > 0
          ? () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => UserPage(
                  userId: widget.article.userId,
                  userName: userName!,
                  articleCount: articleCount,
                ),
              ));
            }
          : null, // Disable onTap if articleCount is 0
      child: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: getImageProvider(profileImageUrl),
            ),
            const SizedBox(width: 8),
            Text(
              userName!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            articleCount > 0
                ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Weitere ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isFetching
                                ? const CircularProgressIndicator()
                                : Text(
                                    '$articleCount',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.primary,
                                    ),
                                  ),
                          ],
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
                  )
                : const SizedBox(), // Hide the part with "Weitere [articleCount] Artikel" if articleCount is 0
          ],
        ),
      ),
    );
  }

  ImageProvider getImageProvider(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage("assets/images/pp.png");
    }
  }

  void fetchArticleCount() async {
    int count = await userService.getArticleCountForUser(widget.article.userId);
    setState(() {
      articleCount = count - 1;
      isFetching = false;
    });
  }

  void toggleFavoriteArticle(BuildContext context) async {
    // Check if the user is authenticated
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add to favorites')),
      );
      return;
    }

    // Get the user's ID
    String userId = user.uid;

    try {
      // Get a reference to the Firestore collection for users
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      // Get the user document from Firestore
      DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null &&
            userData.containsKey('favorites') &&
            userData['favorites'] is List) {
          List<String> favoritesList = List<String>.from(userData['favorites']);

          // Check if the article ID is in the favorites list
          bool isFavorite = favoritesList.contains(widget.id);

          if (isFavorite) {
            // If the article is already in favorites, remove it
            favoritesList.remove(widget.id);
          } else {
            // If the article is not in favorites, add it
            if (!isFavorite) {
              favoritesList.add(widget.id);
            }
          }

          // Update the user document with the updated favorites list
          await usersRef.doc(userId).set(
            {'favorites': favoritesList},
            SetOptions(
                merge: true), // Using merge: true to merge with existing data
          );

          setState(() {
            isArticleFavorite = !isFavorite; // Toggle the state value
          });
        } else {
          // If the "favorites" field is missing or not a List, add the "favorites" field to the user document
          List<String> favoritesList = [widget.id];
          await usersRef.doc(userId).set(
            {'favorites': favoritesList},
            SetOptions(
                merge: true), // Using merge: true to merge with existing data
          );

          setState(() {
            isArticleFavorite = true; // Update the state
          });
        }
      } else {
        // If the user document doesn't exist or data is null, handle the error accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to toggle article favorite')),
        );
      }
    } catch (error) {
      // Handle any errors that occurred during the process
      print('Error toggling article favorite: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to toggle article favorite')),
      );
    }
  }

  Future<void> checkAndSetIsArticleFavorite(String articleId) async {
    // Check if the user is authenticated
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isArticleFavorite =
            false; // If the user is not logged in, the article cannot be in favorites
      });
      return;
    }

    // Get the user's ID
    String userId = user.uid;

    try {
      // Get a reference to the Firestore collection for users
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      // Get the user document from Firestore
      DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null &&
            userData.containsKey('favorites') &&
            userData['favorites'] is List) {
          List<String> favoritesList = List<String>.from(userData['favorites']);

          // Check if the article ID is in the favorites list
          bool isFavorite = favoritesList.contains(articleId);

          setState(() {
            isArticleFavorite = isFavorite;
          });
        } else {
          // If the "favorites" field is missing or not a List, check if it's an empty list
          // If it's empty, the article is not in favorites; otherwise, it's assumed to be not in favorites
          bool isEmptyFavorites = (userData != null &&
              userData['favorites'] is List &&
              userData['favorites'].isEmpty);
          setState(() {
            isArticleFavorite = !isEmptyFavorites;
          });
        }
      } else {
        setState(() {
          isArticleFavorite =
              false; // If the user document doesn't exist or data is null, the article cannot be in favorites
        });
      }
    } catch (error) {
      print('Error checking if article is in favorites: $error');
      setState(() {
        isArticleFavorite =
            false; // Handle any errors and assume the article is not in favorites
      });
    }
  }

  void shareArticle() {
    if (widget.article.images.isNotEmpty) {
      // String imageUrl =
      //  widget.article.images[0]; // Share the first image in the list

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
    CollectionReference articlesRef =
        FirebaseFirestore.instance.collection('articles');

    try {
      await articlesRef.doc(widget.id).update({field: value});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfilePageItem()),
      );
    } catch (error) {
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
      'Artikel wiedereingestellt',
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
