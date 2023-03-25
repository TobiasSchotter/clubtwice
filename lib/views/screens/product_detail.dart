import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Product.dart';
import 'package:clubtwice/views/screens/image_viewer.dart';
import 'package:clubtwice/views/widgets/custom_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:money2/money2.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  PageController productImageSlider = PageController();
  Currency euro = Currency.create('EUR', 2, symbol: '€');
  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColor.border, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.only(right: 14),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {},
                child: SvgPicture.asset('assets/icons/Chat.svg',
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 64,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - appbar & product image
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // product image
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageViewer(imageUrl: product.image),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 310,
                  color: Colors.white,
                  child: PageView(
                    physics: const BouncingScrollPhysics(),
                    controller: productImageSlider,
                    children: List.generate(
                      product.image.length,
                      (index) => Image.asset(
                        product.image[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // appbar
              CustomAppBar(
                title: product.storeName,
                leftIcon: SvgPicture.asset('assets/icons/Bookmark.svg'),
                rightIcon: SvgPicture.asset(
                  'assets/icons/Bookmark.svg',
                  color: Colors.black.withOpacity(0.5),
                ),
                leftOnTap: () {
                  Navigator.of(context).pop();
                },
                rightOnTap: () {},
              ),
              // indicator
              Positioned(
                bottom: 16,
                child: SmoothPageIndicator(
                  controller: productImageSlider,
                  count: product.image.length,
                  effect: ExpandingDotsEffect(
                    dotColor: AppColor.primary.withOpacity(0.2),
                    activeDotColor: AppColor.primary.withOpacity(0.2),
                    dotHeight: 8,
                  ),
                ),
              ),
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
                          product.name,
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
                    Money.fromIntWithCurrency(product.price, euro).toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'poppins',
                        color: AppColor.primary),
                  ),
                ),
                Text(
                  'Bringing a new look to the Waffle sneaker family, the Nike Waffle One balances everything you love about heritage Nike running with fresh innovations.',
                  style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      height: 150 / 100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
