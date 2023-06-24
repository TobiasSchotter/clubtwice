import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () {
              // Hier wird Code ausgeführt, wenn der rechte Button gedrückt wird
            },
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
            Expanded(
              child: Container(
                //width: 400,
                height: 40,
                margin: const EdgeInsets.only(right: 14),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chat_bubble_sharp,
                    //child: Icon(Icons.chat_bubble_sharp),
                  ),
                  label: const Text('Bei Verkäufer anfragen'),
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
                  enlargeCenterPage: true, // Aktives Bild vergrößern
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
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    "${article.price} €",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'poppins',
                        color: AppColor.primary),
                  ),
                ),
                Text(
                  (article.description),
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      height: 150 / 100),
                ),
                Text(
                  (article.condition),
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      height: 150 / 100),
                ),
                Text(
                  (article.size),
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      height: 150 / 100),
                ),
                Text(
                  (article.brand),
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      height: 150 / 100),
                ),
                Text(
                  (article.type),
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      height: 150 / 100),
                ),
                Text(
                  "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                    height: 150 / 100,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
