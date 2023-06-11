import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_color.dart';

class FilterWidget extends StatelessWidget {
  final int selectedIndex;

  const FilterWidget({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Container(); // Handle when user is not logged in
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

        final club = userData['club'] ?? '';

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
                      icon: const Icon(Icons.group),
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
                          value: 'verein1',
                          child: Text(selectedIndex == 0 ? club : 'Verein 1'),
                        ),
                      ],
                      onChanged: (value) {},
                      hint: const Text('Verein',
                          style: TextStyle(color: AppColor.primarySoft)),
                      alignment: Alignment.center,
                    ),
                  ),
                  // Filteroptionen für die Sportart
                  DropdownButton<String>(
                    icon: const Icon(Icons.directions_run),
                    iconSize: 15.0,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0.5,
                      color: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'sportart1', child: Text('Sportart 1')),
                      DropdownMenuItem(
                          value: 'sportart2', child: Text('Sportart 2')),
                      DropdownMenuItem(
                          value: 'sportart3', child: Text('Sportart 3')),
                    ],
                    onChanged: (value) {},
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
                      icon: const Icon(Icons.type_specimen),
                      iconSize: 15.0,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'typ1', child: Text('Kids')),
                        DropdownMenuItem(
                            value: 'typ2', child: Text('Erwachs.')),
                        DropdownMenuItem(
                            value: 'typ3', child: Text('Universal')),
                      ],
                      onChanged: (value) {},
                      hint: const Text('Typ',
                          style: TextStyle(color: AppColor.primarySoft)),
                      alignment: Alignment.center,
                    ),
                  ),
                  // Filteroptionen für die Größe
                  DropdownButton<String>(
                    icon: const Icon(Icons.height_outlined),
                    iconSize: 15.0,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.black,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'größe1', child: Text('Größe 1')),
                      DropdownMenuItem(value: 'größe2', child: Text('Größe 2')),
                      DropdownMenuItem(value: 'größe3', child: Text('Größe 3')),
                    ],
                    onChanged: (value) {},
                    hint: const Text('Größe',
                        style: TextStyle(color: AppColor.primarySoft)),
                    alignment: Alignment.center,
                  ),
                  // Filteroptionen für die Marke
                  DropdownButton<String>(
                    icon: const Icon(Icons.label),
                    iconSize: 15.0,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.black,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'marke1', child: Text('Marke 1')),
                      DropdownMenuItem(value: 'marke2', child: Text('Marke 2')),
                      DropdownMenuItem(value: 'marke3', child: Text('Marke 3')),
                    ],
                    onChanged: (value) {},
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
