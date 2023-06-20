import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Product.dart';
import 'package:clubtwice/views/screens/product_detail.dart';
import 'package:money2/money2.dart';

import '../../core/model/article.dart';

// ignore: must_be_immutable
class ItemCard extends StatelessWidget {
  //final Product product;
  final Article article;
  final Color titleColor;
  final Color priceColor;
  Currency euro = Currency.create('EUR', 2, symbol: '€');

  ItemCard({
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
                      ? AssetImage(article.images[0])
                      : const AssetImage(
                          //'../../../assets/images/placeholder.jpg'), // Placeholder image path
                          'assets/images/placeholder.jpg'), // Placeholder image path
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // item details
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                      Money.fromIntWithCurrency(article.price, euro).toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: priceColor,
                      ),
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
