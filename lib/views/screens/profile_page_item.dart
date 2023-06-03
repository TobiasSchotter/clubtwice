// ignore_for_file: prefer_const_constructors
import 'package:clubtwice/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/core/services/ProductService.dart';
import 'package:clubtwice/core/model/Product.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';

import '../widgets/profile_tile_widget.dart';

class ProfilePageItem extends StatefulWidget {
  ProfilePageItem({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  State<ProfilePageItem> createState() => _ProfilePageItemState();
}

class _ProfilePageItemState extends State<ProfilePageItem> {
  List<Product> productData = ProductService.productData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      // bottomNavigationBar: PageSwitcher(),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture - Username - Name
          const MyProfileWidget(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: 46,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Meine Anzeigen',
                  style: TextStyle(
                      color: AppColor.border,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                productData.length,
                (index) => ItemCard(
                  product: productData[index],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
