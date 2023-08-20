import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_color.dart';
import '../../core/services/option_service.dart';

class FilterWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(String, String, String, String, String) applyFilters;
  final bool isHomePage;
  final Function(bool) setExpansionTileState;

  const FilterWidget({
    Key? key,
    required this.selectedIndex,
    required this.applyFilters,
    required this.isHomePage,
    required this.setExpansionTileState,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget>
    with AutomaticKeepAliveClientMixin<FilterWidget> {
  String selectedClub = '';
  String selectedSportart = '';
  String selectedTyp = '';
  String selectedGroesse = '';
  String selectedMarke = '';

  String clubHintText = 'Verein';
  String sportHintText = 'Sportart';
  String typHintText = 'Typ';
  String groesseHintText = 'Größe';
  String markeHintText = 'Marke';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        final userData = snapshot.data?.data();
        if (userData == null) {
          return Container();
        }

        final currentClub = userData['club'] as String? ?? '';

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
                      width: 175,
                      child: Center(
                        child: DropdownButton<String>(
                          alignment: Alignment.center,
                          iconDisabledColor: Colors.white,
                          iconEnabledColor: Colors.white,
                          iconSize: 15.0,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 0,
                            color: Colors.white,
                          ),
                          items: widget.isHomePage == true
                              ? [
                                  DropdownMenuItem(
                                      value: currentClub,
                                      child: Text(currentClub))
                                ]
                              : club.map((clubItem) {
                                  return DropdownMenuItem(
                                    value: clubItem,
                                    child: Text(clubItem),
                                  );
                                }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedClub = value!;
                              clubHintText = value;
                            });
                          },
                          hint: Text(clubHintText,
                              style:
                                  const TextStyle(color: AppColor.primarySoft)),
                        ),
                      )),
                  DropdownButton<String>(
                    iconSize: 15.0,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.white,
                    ),
                    items: sport.map((sportItem) {
                      return DropdownMenuItem(
                        value: sportItem,
                        child: Text(sportItem),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSportart = value!;
                        sportHintText = value;
                      });
                    },
                    hint: Text(sportHintText,
                        style: const TextStyle(color: AppColor.primarySoft)),
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
                    width: 79,
                    child: DropdownButton<String>(
                      iconSize: 15.0,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      items: types.map((typesItem) {
                        // Filteroptionen für den Typ
                        return DropdownMenuItem(
                          value: typesItem,
                          child: Text(typesItem),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTyp = value!;
                          typHintText = value;
                        });
                      },
                      hint: Text(typHintText,
                          style: const TextStyle(color: AppColor.primarySoft)),
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
                    items: selectedTyp == ''
                        ? [
                            const DropdownMenuItem(
                                value: '', child: Text('Wähle Typ'))
                          ]
                        : sizes[selectedTyp]!.map((sizeItem) {
                            return DropdownMenuItem(
                              value: sizeItem,
                              child: Text(sizeItem),
                            );
                          }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGroesse = value!;
                        groesseHintText = value;
                      });
                    },
                    hint: Text(groesseHintText,
                        style: const TextStyle(color: AppColor.primarySoft)),
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
                      setState(() {
                        selectedMarke = value!;
                        markeHintText = value;
                      });
                    },
                    hint: Text(markeHintText,
                        style: const TextStyle(color: AppColor.primarySoft)),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.applyFilters(
                  selectedClub,
                  selectedSportart,
                  selectedTyp,
                  selectedGroesse,
                  selectedMarke,
                );

                widget.setExpansionTileState(false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Filter anwenden'),
            )
          ],
        );
      },
    );
  }
}
