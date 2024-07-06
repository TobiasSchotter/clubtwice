import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/views/screens/message_detail_page.dart';
import 'package:clubtwice/views/screens/profile_page/profile_page_item.dart';
import 'package:clubtwice/views/screens/user_page.dart';
import 'package:clubtwice/views/widgets/affiliation_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:flutter/services.dart';
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
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PageController productImageSlider = PageController();
  String profileImageUrl = '';
  String? userName = '';
  bool isArticleFavorite = false;

  final UserService userService = UserService();
  UserModel? userModel;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

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
    appBar: AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
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
              return const SizedBox.shrink();
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
    body: ListView(
      padding: EdgeInsets.zero, // Setze padding auf EdgeInsets.zero
      shrinkWrap: true,
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
                  items: buildCarouselItems(),
                );
              },
            ),
            Positioned(
              top: 470.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildCarouselIndicators(),
              ),
            ),
          ],
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
                          color: AppColor.secondary,
                        ),
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
              Visibility(
                visible: widget.article.description.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
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
    ),
    bottomNavigationBar: widget.article.userId != currentUserId
        ? buildBottomNavigationBar(context)
        : null,
  );
}




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

  List<Widget> buildCarouselItems() {
    return widget.article.images.isNotEmpty
        ? widget.article.images.map((imageUrl) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FullScreenImageDialog(imageUrl: imageUrl);
                  },
                );
              },
              child: Container(
                constraints: const BoxConstraints.expand(),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const FullScreenImageDialog(
                      imageUrl: 'assets/images/placeholder.jpg',
                    );
                  },
                );
              },
              child: Container(
                constraints: const BoxConstraints.expand(),
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Image.asset(
                  'assets/images/placeholder.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
  }

List<Widget> buildCarouselIndicators() {
  return widget.article.images.length > 1 // Bedingung auf mehr als 1 Bild geändert
      ? widget.article.images.asMap().entries.map((entry) {
          int index = entry.key;
          return Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentImageIndex == index
                  ? AppColor.primary
                  : AppColor.primarySoft,
            ),
          );
        }).toList()
      : [];
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
                      : 'assets/images/placeholder.jpg';
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
                toggleFavoriteArticle(context);
              },
              icon: Icon(
                isArticleFavorite ? Icons.favorite : Icons.favorite_border,
                color: isArticleFavorite ? Colors.red : null,
              ),
            ),
          ),
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add to favorites')),
      );
      return;
    }

    String userId = user.uid;

    try {
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null &&
            userData.containsKey('favorites') &&
            userData['favorites'] is List) {
          List<String> favoritesList = List<String>.from(userData['favorites']);

          bool isFavorite = favoritesList.contains(widget.id);

          if (isFavorite) {
            favoritesList.remove(widget.id);
          } else {
            favoritesList.add(widget.id);
          }

          await usersRef.doc(userId).set(
            {'favorites': favoritesList},
            SetOptions(merge: true),
          );

          setState(() {
            isArticleFavorite = !isFavorite;
          });
        } else {
          List<String> favoritesList = [widget.id];
          await usersRef.doc(userId).set(
            {'favorites': favoritesList},
            SetOptions(merge: true),
          );

          setState(() {
            isArticleFavorite = true;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to toggle article favorite')),
        );
      }
    } catch (error) {
      print('Error toggling article favorite: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to toggle article favorite')),
      );
    }
  }

  Future<void> checkAndSetIsArticleFavorite(String articleId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isArticleFavorite = false;
      });
      return;
    }

    String userId = user.uid;

    try {
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');

      DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null &&
            userData.containsKey('favorites') &&
            userData['favorites'] is List) {
          List<String> favoritesList = List<String>.from(userData['favorites']);

          bool isFavorite = favoritesList.contains(articleId);

          setState(() {
            isArticleFavorite = isFavorite;
          });
        } else {
          bool isEmptyFavorites = (userData != null &&
              userData['favorites'] is List &&
              userData['favorites'].isEmpty);
          setState(() {
            isArticleFavorite = !isEmptyFavorites;
          });
        }
      } else {
        setState(() {
          isArticleFavorite = false;
        });
      }
    } catch (error) {
      print('Error checking if article is in favorites: $error');
      setState(() {
        isArticleFavorite = false;
      });
    }
  }

  void shareArticle() async {
    if (widget.article.images.isNotEmpty) {
      String imageUrl = widget.article.images[0];

      try {
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/article_image.png').create();
        HttpClient()
            .getUrl(Uri.parse(imageUrl))
            .then((HttpClientRequest request) {
          return request.close();
        }).then((HttpClientResponse response) {
          response.pipe(file.openWrite());
        });

        String imagePath = file.path;

        String articleLink = 'https://example.com/article/${widget.id}';

        Share.shareFiles([imagePath],
            text: 'Check diesen Artikel auf ClubTwice ab!\n'
                '${widget.article.title}\n'
                '${widget.article.price} €\n'
                'Link: $articleLink');
      } catch (e) {
        print('Error sharing article: $e');
      }
    } else {
      String articleLink = 'https://example.com/article/${widget.id}';

      Share.share(
        'Check diesen Artikel auf ClubTwice ab!\n'
        '${widget.article.title}\n'
        '${widget.article.price} €\n'
        'Link: $articleLink',
      );
    }
  }

  void updateArticleStatus(String field, bool value, String successMessage,
      String errorMessage) async {
    CollectionReference articlesRef =
        FirebaseFirestore.instance.collection('articles');

    try {
      if (field == 'isSold' && value == true) {
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

    ich möchte einen Artikel melden, der meiner Meinung nach gegen die Nutzungsbedingungen oder Richtlinien von ClubTwice verstößt. Nachfolgend findest Sie die Details des Artikels:

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
  
  buildSeparator() {
      return Container(
        height: 2,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      );
    }
}
