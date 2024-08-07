import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/views/screens/selection_page/selection_brand_page.dart';
import 'package:clubtwice/views/screens/selection_page/selection_club_page.dart';
import 'package:clubtwice/views/screens/selection_page/selection_size_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_color.dart';
import '../../core/services/option_service.dart';
import '../screens/selection_page/selection_sport_page.dart';

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
  String selectedClubFilter = '';
  String selectedSportFilter = '';
  String selectedTypFilter = '';
  String selectedGroesseFilter = '';
  String selectedMarkeFilter = '';

  String clubHintText = 'Verein';
  String sportHintText = 'Sportart';
  String typHintText = 'Typ';
  String groesseHintText = 'Größe';
  String markeHintText = 'Marke';

  @override
  bool get wantKeepAlive => true;

  String truncateText(String text) {
    if (text.length <= 8) {
      return text;
    } else {
      return '${text.substring(0, 8)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Container();
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        final userData = snapshot.data?.data();
        if (userData == null) {
          return Container();
        }

        final currentClub = userData['club'] as String? ?? '';
        final secondClub = userData['club2'] as String? ?? '';

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
                    child: Center(
                      child: widget.isHomePage == true
                          ? (secondClub.isNotEmpty && secondClub != 'Keine Auswahl'
                              ? DropdownButton<String>(
  dropdownColor: Colors.blueAccent,
  alignment: Alignment.center,
  value: selectedClubFilter.isEmpty ? currentClub : selectedClubFilter,
  onChanged: (String? newValue) {
    setState(() {
      selectedClubFilter = newValue!;
      clubHintText = newValue;
      print('Selected Club: $selectedClubFilter'); // Debugging
    });
    print('newValue: $newValue'); // Debugging
  },
  items: <String>[currentClub, secondClub]
      .where((value) => value.isNotEmpty && value != 'Keine Auswahl')
      .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }).toList(),
)

                              : GestureDetector(
                                  onTap: () {
                                    const snackBar = SnackBar(
                                      content:
                                      Text('Dein Verein ist fest hinterlegt'),
                                    );
                                    ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                  },
                                  child: Text(
                                    currentClub,
                                    style: const TextStyle(
                                      color: AppColor.primarySoft,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ))
                          : GestureDetector(
                              onTap: () async {
                                final selectedClub =
                                 await Navigator.push<String>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClubSelectionPage(
                                      selectedClub: selectedClubFilter,
                                    ),
                                  ),
                                );

                                if (selectedClub != null) {
                                  setState(() {
                                    selectedClubFilter = selectedClub;
                                    clubHintText = selectedClub;
                                    print('Selected Club: $selectedClubFilter'); // Debugging
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
                                    if (selectedClubFilter == 'Keine Auswahl' || selectedClubFilter.isEmpty)
                                      const Text(
                                        'Verein',
                                        style: TextStyle(fontSize: 15, color: Colors.white),
                                      ),
                                    if (selectedClubFilter != 'Keine Auswahl' && selectedClubFilter.isNotEmpty)
                                      Text(
                                        clubHintText,
                                        style: const TextStyle(fontSize: 15, color: Colors.white),
                                      ),
                                    const SizedBox(width: 8),
                                    if (selectedClubFilter != 'Keine Auswahl' && selectedClubFilter.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedClubFilter = '';
                                          });
                                        },
                                        child: const Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),

                  // Filter für Sportart
                  GestureDetector(
                    onTap: () async {
                      final selectedSport = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SportSelectionPage(
                            selectedSport: selectedSportFilter,
                          ),
                        ),
                      );

                      if (selectedSport != null) {
                        setState(() {
                          selectedSportFilter = selectedSport;
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
                          if (selectedSportFilter == 'Keine Auswahl' || selectedSportFilter.isEmpty)
                            const Text(
                              'Sportart',
                              style: TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          if (selectedSportFilter != 'Keine Auswahl' && selectedSportFilter.isNotEmpty)
                            Text(
                              sportHintText,
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          const SizedBox(width: 8),
                          if (selectedSportFilter != 'Keine Auswahl' && selectedSportFilter.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSportFilter = '';
                                });
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
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
                              child: Text(
                                truncateText(typesItem),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTypFilter = value!;
                              typHintText = value;

                              if (selectedTypFilter == 'One Size') {
                                selectedGroesseFilter = 'One Size';
                                groesseHintText = 'One Size';
                              } else {
                                selectedGroesseFilter = '';
                                groesseHintText = 'Größe';
                              }
                            });
                          },
                          hint: Text(
                            truncateText(typHintText),
                            style: const TextStyle(color: AppColor.primarySoft),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                      if (selectedTypFilter != '')
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          iconSize: 16,
                          onPressed: () {
                            setState(() {
                              selectedTypFilter = '';
                              typHintText = "Typ";
                              selectedGroesseFilter = '';
                              groesseHintText = 'Größe';
                            });
                          },
                        ),
                    ],
                  ),
                  if (selectedTypFilter != 'One Size')
                    GestureDetector(
                      onTap: () async {
                        if (selectedTypFilter != '') {
                          final selectedSize = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SizeSelectionPage(
                                selectedSize: selectedGroesseFilter,
                                selectedType: selectedTypFilter,
                              ),
                            ),
                          );

                          if (selectedSize != null) {
                            setState(() {
                              selectedGroesseFilter = selectedSize;
                              groesseHintText = selectedSize;
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                  "Bitte wählen Sie zuerst einen Typ aus."),
                                duration: Duration(seconds: 2)),
                          );
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
                            if (selectedGroesseFilter == '' || selectedGroesseFilter.isEmpty)
                              const Text(
                                'Größe',
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              ),
                            if (selectedGroesseFilter != '' && selectedGroesseFilter.isNotEmpty)
                              Text(
                                truncateText(groesseHintText),
                                style: const TextStyle(fontSize: 15, color: Colors.white),
                              ),
                            const SizedBox(width: 8),
                            if (selectedGroesseFilter != '' && selectedGroesseFilter.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedGroesseFilter = '';
                                  });
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () async {
                      final selectedBrand = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BrandSelectionPage(
                            selectedBrand: selectedMarkeFilter,
                          ),
                        ),
                      );

                      if (selectedBrand != null) {
                        setState(() {
                          selectedMarkeFilter = selectedBrand;
                          markeHintText = selectedBrand;
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
                          if (selectedMarkeFilter == 'Keine Auswahl' || selectedMarkeFilter.isEmpty)
                            const Text(
                              'Marke',
                              style: TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          if (selectedMarkeFilter != 'Keine Auswahl' && selectedMarkeFilter.isNotEmpty)
                            Text(
                              truncateText(markeHintText),
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(width: 8),
                          if (selectedMarkeFilter != 'Keine Auswahl' && selectedMarkeFilter.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedMarkeFilter = '';
                                });
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('Applying filters: $selectedClubFilter, $selectedSportFilter, $selectedTypFilter, $selectedGroesseFilter, $selectedMarkeFilter'); // Debugging
                widget.applyFilters(
                  selectedClubFilter,
                  selectedSportFilter,
                  selectedTypFilter,
                  selectedGroesseFilter,
                  selectedMarkeFilter,
                );

                widget.setExpansionTileState(false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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

