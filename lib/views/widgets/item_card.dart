import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/product_detail.dart';
import '../../core/model/article.dart';

// ignore: must_be_immutable
class ItemCard extends StatelessWidget {
  //final Product product;
  final Article article;
  final Color titleColor;
  final Color priceColor;

  const ItemCard({
    super.key,
    //required this.product,
    required this.article,
    this.titleColor = Colors.black,
    this.priceColor = AppColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            //builder: (context) => ProductDetail(product: product)));
            builder: (context) => ProductDetail(article: article)));
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 16 - 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      "${article.price} €",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: priceColor,
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: article.condition,
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.7),
                              height: 150 / 100,
                              fontSize: 12),
                        ),
                        TextSpan(
                          text: ' • ',
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.7),
                              height: 150 / 100,
                              fontSize: 12),
                        ),
                        TextSpan(
                          text: article.size,
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.7),
                              height: 150 / 100,
                              fontSize: 12),
                        ),
                        TextSpan(
                          text: ' • ',
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.7),
                              height: 150 / 100,
                              fontSize: 12),
                        ),
                        TextSpan(
                          text: article.brand,
                          style: TextStyle(
                              color: AppColor.secondary.withOpacity(0.7),
                              height: 150 / 100,
                              fontSize: 12),
                        ),
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
