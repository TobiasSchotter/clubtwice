import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/core/services/user_service.dart';
import 'package:clubtwice/core/model/UserModel.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/constant/app_button.dart';

import '../selection_page/selection_club_page.dart';
import '../selection_page/selection_sport_page.dart';

class ProfilePageClub extends StatefulWidget {
  const ProfilePageClub({Key? key}) : super(key: key);

  @override
  State<ProfilePageClub> createState() => _ProfilePageClubState();
}

class _ProfilePageClubState extends State<ProfilePageClub> {
  late Future<UserModel?> _userDataFuture;
  String club = '';
  String club2 = ''; // New second club
  String sport = '';
  final UserService userService = UserService();
  bool changesMade = false;

  @override
  void initState() {
    super.initState();
    _userDataFuture = loadData();
  }

  Future<UserModel?> loadData() async {
    String? userId = userService.getCurrentUserId();
    UserModel? user = await userService.fetchUserData(userId);
    setState(() {
      club = user?.club ?? '';
     club2 = user?.club2 ?? ''; // New second club
      sport = user?.sport ?? '';
    });
    return user;
  }

Future<void> saveChanges() async {
  if (club == club2) {
    // Zeige eine Snackbar mit der Fehlermeldung an
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Der erste und der zweite Verein dürfen nicht identisch sein.'),
        backgroundColor: Colors.red,
      ),
    );
    return; // Verhindere das weitere Ausführen der Methode
  }

  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      await userService.updateUserClubInformation(userId, club, club2, sport);
      // Erfolgreiche Speicherung
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Änderungen erfolgreich gespeichert.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (error) {
    // Zeige eine Snackbar für allgemeine Fehler an
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fehler beim Speichern: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  String truncateText(String text) {
    if (text.length <= 12) {
      return text;
    } else {
      return '${text.substring(0, 12)}...';
    }
  }

  Widget _buildSportSelection(BuildContext context) {
    String displaySport = sport.isEmpty ? 'Keine Auswahl' : sport;
    return GestureDetector(
      onTap: () async {
        final selectedSport = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => SportSelectionPage(selectedSport: sport),
          ),
        );
        if (selectedSport != null) {
          setState(() {
            sport = selectedSport;
          });
          displaySport = sport.isEmpty ? 'Keine Auswahl' : sport;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '  Sport wählen',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  truncateText(displaySport),
                  style: const TextStyle(fontSize: 16, color: AppColor.primary),
                ),
                 const SizedBox(width: 8),
                  if (sport.isNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    sport = '';
                  });
                  displaySport = 'Keine Auswahl';
                },
                child: const Icon(Icons.delete, color: Colors.grey),
              ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_right, color: AppColor.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }
Widget _buildClubSelection(BuildContext context) {
  String displayClub = club.isEmpty ? 'Keine Auswahl' : club;

  return GestureDetector(
    onTap: () async {
      final selectedClub = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => ClubSelectionPage(selectedClub: club),
        ),
      );
      if (selectedClub != null) {
        setState(() {
          club = selectedClub;
        });
        displayClub = club.isEmpty ? 'Keine Auswahl' : club;
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '  Verein wählen',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Text(
                truncateText(displayClub),
                style: const TextStyle(fontSize: 16, color: AppColor.primary),
              ),
              const SizedBox(width: 8),
               if (club.isNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    club = '';
                  });
                  displayClub = 'Keine Auswahl';
                },
                child: const Icon(Icons.delete, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_right, color: AppColor.primary),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildSecondClubSelection(BuildContext context) { // New second club selection
    String displayClub2 = club2.isEmpty ? 'Keine Auswahl' : club2;

    return GestureDetector(
      onTap: () async {
        final selectedClub2 = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => ClubSelectionPage(selectedClub: club2),
          ),
        );
        if (selectedClub2 != null) {
          setState(() {
            club2 = selectedClub2;
          });
          displayClub2 = club2.isEmpty ? 'Keine Auswahl' : club2;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '  Zweiten Verein wählen',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  truncateText(displayClub2),
                  style: const TextStyle(fontSize: 16, color: AppColor.primary),
                  
                ),
                 const SizedBox(width: 8),
                  if (club2.isNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    club2 = '';
                  });
                  displayClub2 = 'Keine Auswahl';
                },
                child: const Icon(Icons.delete, color: Colors.grey),
              ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_right, color: AppColor.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Verein und Sportart anpassen',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () async {
            if (changesMade) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const PageSwitcher(
                  selectedIndex: 4,
                ),
              ));
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.black,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: FutureBuilder<UserModel?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Fehler beim Laden der Daten: ${snapshot.error}'));
          } else {
            return ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Text(
                    'Deine Startseite wird dir dementsprechend angezeigt. Bei Verkäufen wird dies bereits vorausgefüllt seinn. Du kannst diese jederzeit ändern.',
                    style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      fontSize: 15,
                      height: 150 / 100,
                    ),
                  ),
                ),
                Container(
                  height: 16,
                ),
                _buildClubSelection(context),
                Container(
                  height: 16,
                ),
                _buildSportSelection(context),
                 Container(
                  height: 16,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Optional:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSecondClubSelection(context), //  New second club selection
                const SizedBox(height: 16),
                AppButton(
  buttonText: 'Speichern',
  onPressed: () async {
    await saveChanges();
  },
)
              ],
            );
          }
        },
      ),
    );
  }
}
