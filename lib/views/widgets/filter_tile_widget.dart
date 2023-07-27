import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_color.dart';
import '../../core/services/option_service.dart';

class FilterWidget extends StatelessWidget {
  final int selectedIndex;

  const FilterWidget({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> allBrands = List.from(popularBrands)
      ..addAll(lesspopularBrands);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Container(); // Handle when the user is not logged in
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Handle while data is being fetched
        }

        final userData = snapshot.data?.data();
        if (userData == null) {
          return Container(); // Handle when user data is not available
        }

        final club = userData['club'] as String? ??
            ''; // Use 'as String?' to handle nullable value

        return Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.secondary,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 110,
                    child: DropdownButton<String>(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dein Verein ist fest hinterlegt!'),
                          ),
                        );
                      },
                      iconDisabledColor: Colors.white,
                      iconEnabledColor: Colors.white,
                      iconSize: 15.0,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 0.5,
                        color: Colors.white,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: club,
                          child: Text(selectedIndex == 0 ? club : 'Verein 1'),
                        ),
                      ],
                      onChanged: (value) {
                        // No need to do anything here since the value is not changed
                      },
                      hint: const Text('Verein',
                          style: TextStyle(color: AppColor.primarySoft)),
                      alignment: Alignment.center,
                    ),
                  ),
                  // Filteroptionen für die Sportart
                  DropdownButton<String>(
                    iconSize: 15.0,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0.5,
                      color: Colors.white,
                    ),
                    items: sport.map((sportItem) {
                      return DropdownMenuItem(
                        value: sportItem,
                        child: Text(sportItem),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle the value when the user selects an item
                      // You can put your logic here
                    },
                    hint: const Text('Sportart',
                        style: TextStyle(color: AppColor.primarySoft)),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.secondary,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 77,
                    child: DropdownButton<String>(
                      iconSize: 15.0,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      items: types.map((typesItem) {
                        return DropdownMenuItem(
                          value: typesItem,
                          child: Text(typesItem),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Handle the value when the user selects an item
                        // You can put your logic here
                      },
                      hint: const Text('Typ',
                          style: TextStyle(color: AppColor.primarySoft)),
                      alignment: Alignment.center,
                    ),
                  ),
                  // Filteroptionen für die Größe
                  DropdownButton<String>(
                    iconSize: 15.0,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.black,
                    ),
                    items: sizes[types[1]]!.map((sizeItem) {
                      return DropdownMenuItem(
                        value: sizeItem,
                        child: Text(sizeItem),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle the value when the user selects an item
                      // You can put your logic here
                    },
                    hint: const Text('Größe',
                        style: TextStyle(color: AppColor.primarySoft)),
                    alignment: Alignment.center,
                  ),

                  // Filteroptionen für die Marke
                  DropdownButton<String>(
                    iconSize: 15.0,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.black,
                    ),
                    items: allBrands.map((brandItem) {
                      return DropdownMenuItem(
                        value: brandItem,
                        child: Text(brandItem),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Handle the value when the user selects an item
                      // You can put your logic here
                    },
                    hint: const Text('Marke',
                        style: TextStyle(color: AppColor.primarySoft)),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
