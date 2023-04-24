import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:clubtwice/views/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Product.dart';
import 'package:clubtwice/core/services/ProductService.dart';
import 'package:clubtwice/views/widgets/item_card.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> productData = ProductService.productData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: AppColor.primary,
        elevation: 0,
        title: Container(
          height: 40,
          child: TextField(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PageSwitcher()),
              );
            },
            autofocus: false,
            style:
                TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
            decoration: InputDecoration(
              hintStyle:
                  TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
              hintText: 'Suche nach Vereinskleidung aller Vereine ...',
              prefixIcon: Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.search_outlined,
                    color: Colors.white.withOpacity(0.5)),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              fillColor: Colors.white.withOpacity(0.1),
              filled: true,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1
          Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColor.primary,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Artikel aus deinem Verein 💪 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            height: 150 / 100,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            color: AppColor.secondary,
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 75,
                  // Filteroptionen für den Verein
                  child: DropdownButton<String>(
                    icon: Icon(Icons.group),
                    iconDisabledColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    iconSize: 20.0,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0.5,
                      color: Colors.white,
                    ),
                    items: [
                      DropdownMenuItem(
                          child: Text('Verein 1'), value: 'verein1'),
                      DropdownMenuItem(
                          child: Text('Verein 2'), value: 'verein2'),
                      DropdownMenuItem(
                          child: Text('Verein 3'), value: 'verein3'),
                    ],
                    onChanged: (value) {
                      // TODO: Implementieren Sie die Filterlogik für den Verein
                    },
                    hint: Text('Verein',
                        style: TextStyle(color: AppColor.primarySoft)),
                  ),
                ),
                // Filteroptionen für die Sportart

                DropdownButton<String>(
                  icon: Icon(Icons.directions_run),
                  iconSize: 20.0,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(
                        child: Text('Sportart 1'), value: 'sportart1'),
                    DropdownMenuItem(
                        child: Text('Sportart 2'), value: 'sportart2'),
                    DropdownMenuItem(
                        child: Text('Sportart 3'), value: 'sportart3'),
                  ],
                  onChanged: (value) {
                    // TODO: Implementieren Sie die Filterlogik für die Sportart
                  },
                  hint: Text('Sportart',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),

                DropdownButton<String>(
                  icon: Icon(Icons.type_specimen),
                  iconSize: 20.0,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(child: Text('Kids'), value: 'typ1'),
                    DropdownMenuItem(child: Text('Erwachs.'), value: 'typ2'),
                    DropdownMenuItem(child: Text('Universal'), value: 'typ3'),
                  ],
                  onChanged: (value) {
                    // TODO: Implementieren Sie die Filterlogik für die Sportart
                  },
                  hint: Text('Typ',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),
                // Filteroptionen für die Größe
                DropdownButton<String>(
                  icon: Icon(Icons.height_outlined),
                  iconSize: 20.0,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(child: Text('Größe 1'), value: 'größe1'),
                    DropdownMenuItem(child: Text('Größe 2'), value: 'größe2'),
                    DropdownMenuItem(child: Text('Größe 3'), value: 'größe3'),
                  ],
                  onChanged: (value) {
                    // TODO: Implementieren Sie die Filterlogik für die Größe
                  },
                  hint: Text('Größe',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),

                // Filteroptionen für die Marke
                DropdownButton<String>(
                  icon: Icon(Icons.label),
                  iconSize: 20.0,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(child: Text('Marke 1'), value: 'marke1'),
                    DropdownMenuItem(child: Text('Marke 2'), value: 'marke2'),
                    DropdownMenuItem(child: Text('Marke 3'), value: 'marke3'),
                  ],
                  onChanged: (value) {
                    // TODO: Implementieren Sie die Filterlogik für die Marke
                  },
                  hint: Text('Marke',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),
              ],
            ),
          ),

          // Section 5 - product list
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
