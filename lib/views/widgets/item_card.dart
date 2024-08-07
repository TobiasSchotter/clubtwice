import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/product_detail.dart';
import '../../core/model/Article.dart';

class ItemCard extends StatelessWidget {
  final Article article;
  final String articleId;
  final Color titleColor;
  final Color priceColor;

  const ItemCard({
    Key? key,
    required this.article,
    required this.articleId,
    this.titleColor = Colors.black,
    this.priceColor = AppColor.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String textToDisplay = '';

    if (article.club != "" && article.sport != "") {
      textToDisplay = '${article.club} • ${article.sport}';
    } else if (article.club != "") {
      textToDisplay = article.club;
    } else if (article.sport != "") {
      textToDisplay = article.sport;
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductDetail(article: article, id: articleId),
        ));
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 16 - 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // item image
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 16 - 8,
                  height: MediaQuery.of(context).size.width / 2 - 16 - 8,
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: article.images.isNotEmpty
                          ? NetworkImage(article.images[0])
                          : const AssetImage('assets/images/placeholder.jpg')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (article.isReserved == true)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        color: Colors.grey,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Reserviert',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (article.isSold == true)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        color: Colors.green,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Verkauft',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (article.isDeleted == true)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 - 16 - 8,
                      height: MediaQuery.of(context).size.width / 2 - 16 - 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(height: 8), // Gap between icon and text
                          Text(
                            'Gelöscht',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // item details
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0, bottom: 0),
                    child: Text(
                      article.price == 0
                          ? "Zu verschenken"
                          : "${article.price} €",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: article.price == 0 ? Colors.green : priceColor,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: textToDisplay.isNotEmpty,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          height: 1.5,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(text: textToDisplay),
                        ],
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColor.secondary.withOpacity(0.7),
                        height: 1.5,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(text: '${article.condition} • '),
                        TextSpan(text: '${article.size} '),
                        if (article.brand != "")
                          TextSpan(text: '• ${article.brand}'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
