import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_color.dart';
import '../../core/services/option_service.dart';
import '../screens/selection_sport_page.dart';

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
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget>
    with AutomaticKeepAliveClientMixin<FilterWidget> {
  String selectedClub = '';
  String selectedSportart = 'Keine Auswahl';
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
      return Container();
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
                                  child: Text(currentClub),
                                )
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
                        hint: Text(
                          clubHintText,
                          style: const TextStyle(color: AppColor.primarySoft),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final selectedSport = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SportSelectionPage(
                            selectedSport: selectedSportart,
                          ),
                        ),
                      );

                      if (selectedSport != null) {
                        setState(() {
                          selectedSportart = selectedSport;
                          sportHintText = selectedSport;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (selectedSportart == 'Sportart' &&
                              selectedSportart == "Keine Auswahl")
                            const Text(
                              'Sportart',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          if (selectedSportart != 'Sportart')
                            Text(
                              sportHintText,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          const SizedBox(width: 8),
                          if (selectedSportart != 'Sportart' &&
                              selectedSportart != 'Keine Auswahl' &&
                              selectedSportart.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSportart =
                                      ''; // Setzen Sie den Wert zurück
                                  sportHintText = 'Sportart';
                                });
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          // const Icon(
                          //  Icons.keyboard_arrow_right,
                          //  color: AppColor.primary,
                          //   ),
                        ],
                      ),
                    ),
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
                      hint: Text(
                        typHintText,
                        style: const TextStyle(color: AppColor.primarySoft),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
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
                              value: '',
                              child: Text('Wähle Typ'),
                            )
                          ]
                        : sizesCloth[selectedTyp]!.map((sizeItem) {
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
                    hint: Text(
                      groesseHintText,
                      style: const TextStyle(color: AppColor.primarySoft),
                    ),
                    alignment: Alignment.center,
                  ),
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
                    hint: Text(
                      markeHintText,
                      style: const TextStyle(color: AppColor.primarySoft),
                    ),
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
