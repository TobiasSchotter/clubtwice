import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/views/screens/message_detail_page.dart';
import 'package:clubtwice/views/screens/profile_page/profile_page_item.dart';
import 'package:clubtwice/views/screens/user_page.dart';
import 'package:clubtwice/views/widgets/affiliation_widget.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/attribute_widget.dart';
import '../widgets/date_widget.dart';
import '../widgets/fullscreen_widget.dart';
import '../widgets/user_section.dart';
import 'page_switcher/sell_page.dart';

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
  final FirebaseAuth auth = FirebaseAuth.instance;
  // get current userId
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

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

  // get senderId, receiverId, articleId and receiverUsername

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.article.updatedAt.toDate();

    return Scaffold(
      // extendBodyBehindAppBar: true,
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
              if (widget.article.isDeleted) {
                // Artikel ist gelöscht, also keine Popup-Menüschaltfläche anzeigen
                return const SizedBox
                    .shrink(); // oder eine andere leere Widget-Instanz zurückgeben
              } else {
                return PopupMenuButton<String>(
                  onSelected: (value) => handlePopupMenuSelection(value),
                  itemBuilder: (BuildContext context) => buildPopupMenuItems(),
                  icon: const Icon(Icons.more_horiz),
                );
              }
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
                        autoPlay: true,
                        height: 500,
                        enableInfiniteScroll: enableInfiniteScroll,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentImageIndex = index;
                          });
                        },
                        viewportFraction: 1.0,
                      ),
                      items: widget.article.images.isNotEmpty
                          ? widget.article.images.map((imageUrl) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // Hier wird das FullScreenImageDialog-Widget verwendet, um das Bild anzuzeigen
                                      return FullScreenImageDialog(
                                          imageUrl: imageUrl);
                                    },
                                  );
                                },
                                child: Container(
                                  constraints: BoxConstraints.expand(),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }).toList()
                          : [
                              GestureDetector(
                                onTap: () {
                                  // Hier wird das FullScreenImageDialog-Widget verwendet, um das Platzhalterbild anzuzeigen
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FullScreenImageDialog(
                                        imageUrl:
                                            'assets/images/placeholder.jpg',
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  constraints: BoxConstraints.expand(),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Image.asset(
                                    'assets/images/placeholder.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                    );
                  },
                ),
                Positioned(
                  top: 480.0,
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
      bottomNavigationBar: widget.article.userId != currentUserId
          ? buildBottomNavigationBar(context)
          : null,
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

  List<PopupMenuEntry<String>> buildPopupMenuItems() => FirebaseAuth
                  .instance.currentUser?.uid ==
              widget.article.userId &&
          !widget.article.isDeleted
      ? [
          PopupMenuItem<String>(
            value: 'sold',
            child: ListTile(
              title:
                  Text(widget.article.isSold ? 'Nicht Verkauft' : 'Verkauft'),
            ),
          ),
          if (!widget.article.isSold)
            PopupMenuItem<String>(
              value: 'reserved',
              child: ListTile(
                title: Text(
                    widget.article.isReserved ? 'Aktivieren' : 'Reservieren'),
              ),
            ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
              title: Text('Löschen'),
            ),
          ),
          if (!widget.article.isSold)
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                title: Text('Bearbeiten'),
              ),
            ),
        ]
      : [
          const PopupMenuItem<String>(
            value: 'report',
            child: ListTile(
              title: Text('Melden'),
            ),
          ),
        ];

  ListView buildBodyContent(DateTime dateTime) {
    Widget buildSeparator() {
      return Container(
        height: 2,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
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
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: widget.article.price == 0
                        ? Colors.green
                        : AppColor.primary,
                  ),
                ),
              ),
              buildSeparator(),
              buildUserProfileSection(),
              buildSeparator(),
              RichTextBuilderAttribute.buildRichTextInfo(widget.article),
              buildSeparator(),
              RichTextBuilderAffiliation.buildRichTextInfo2(widget.article),
              buildSeparator(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: widget.article.description.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: Container(
                        color: const Color.fromARGB(255, 238, 238,
                            238), // Set the background color to light gray
                        child: Text(
                          widget.article.description,
                          style: TextStyle(
                            color: AppColor.secondary.withOpacity(0.7),
                            fontSize: 18,
                            height: 150 / 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: widget.article.description.isNotEmpty,
                child: Container(
                  height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              DateWidget(dateTime: dateTime),
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
              child: AppButton(
                onPressed: () {
                  List<dynamic> images = widget.article.images;
                  String imageUrl = (images.isNotEmpty && images[0] != null)
                      ? images[0]
                      : 'assets/images/placeholder.jpg'; // Placeholder URL
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageDetailPage(
                        articleId: widget.id,
                        senderId: currentUserId,
                        receiverUsername: userName!,
                        receiverId: widget.article.userId,
                        articleTitle: widget.article.title,
                        articleImageUrl: imageUrl,
                        isSold: widget.article.isSold,
                        isDeleted: widget.article.isDeleted,
                      ),
                    ),
                  );
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

  Widget buildUserProfileSection() {
    return UserProfileSection(
      profileImageUrl: profileImageUrl,
      userName: userName!,
      articleCount: articleCount,
      isFetching: isFetching,
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UserPage(
              userId: widget.article.userId,
              userName: userName!,
              articleCount: articleCount,
            ),
          ),
        );
      },
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

  void shareArticle() async {
    if (widget.article.images.isNotEmpty) {
      String imageUrl = widget.article.images[0]; // Erste Bild-URL des Artikels

      try {
        // Bild lokal speichern
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/article_image.png').create();
        HttpClient()
            .getUrl(Uri.parse(imageUrl))
            .then((HttpClientRequest request) {
          return request.close();
        }).then((HttpClientResponse response) {
          response.pipe(file.openWrite());
        });

        // Pfad zur lokal gespeicherten Bild-Datei
        String imagePath = file.path;

        // Beispiel-Link zur App
        String articleLink = 'https://example.com/article/${widget.id}';

        // Artikel teilen mit Bild-Datei und Link
        Share.shareFiles([imagePath],
            text: 'Check diesen Artikel auf ClubTwice ab!\n'
                '${widget.article.title}\n'
                '${widget.article.price} €\n'
                'Link: $articleLink');
      } catch (e) {
        print('Error sharing article: $e');
      }
    } else {
      // Wenn es keine Bilder gibt, teile den Artikel ohne Bild
      String articleLink =
          'https://example.com/article/${widget.id}'; // Beispiel-Link zur App

      Share.share(
        'Check diesen Artikel auf ClubTwice ab!\n'
        '${widget.article.title}\n'
        '${widget.article.price} €\n'
        'Link: $articleLink', // Füge den Link zur Nachricht hinzu
      );
    }
  }

  void updateArticleStatus(String field, bool value, String successMessage,
      String errorMessage) async {
    CollectionReference articlesRef =
        FirebaseFirestore.instance.collection('articles');

    try {
      if (field == 'isSold' && value == true) {
        // Wenn der Artikel als verkauft markiert wird, setze isReserved auf false
        await articlesRef.doc(widget.id).update({
          'isSold': true,
          'isReserved': false,
        });
      } else {
        await articlesRef.doc(widget.id).update({field: value});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfilePageItem()),
      );
    } catch (error) {
      print('Error marking article: $error');
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

  void articleEdit() {
    // Check if the current user is the owner of the article
    bool isCurrentUserOwner = widget.article.userId == currentUserId;

    if (isCurrentUserOwner && !widget.article.isDeleted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellPage(
            articleId: widget.id,
            title: widget.article.title,
            description: widget.article.description,
            price: widget.article.price,
            isIndividuallyWearable: widget.article.isIndividuallyWearable,
            selectedType: widget.article.type,
            selectedSize: widget.article.size,
            selectedBrand: widget.article.brand,
            selectedCondition: widget.article.condition,
            images: widget.article.images,
          ),
        ),
      );
    }
  }

  void articleReport() async {
    String emailAddress = 'abc@clubtwice.de';
    String subject = 'Artikel melden: ${widget.id}';
    String body = '''
    Sehr geehrtes ClubTwice-Team,

    ich möchte einen Artikel melden, der meiner Meinung nach gegen die Nutzungsbedingungen oder Richtlinien von ClubTwice verstößt. Nachfolgend findest du die Details des Artikels:

    Artikel ID: ${widget.id}

    Bitte überprüfen Sie diesen Artikel und ergreifen Sie entsprechende Maßnahmen gemäß den ClubTwice-Richtlinien.

    Vielen Dank für Ihre Unterstützung.

    Mit freundlichen Grüßen,
    [Ihr Name]
    ''';

    String url =
        'mailto:$emailAddress?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    try {
      await launch(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-Mail-Fenster geöffnet')),
      );
    } catch (error) {
      print('Could not launch $url: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Öffnen des E-Mail-Fensters')),
      );
    }
  }
}
