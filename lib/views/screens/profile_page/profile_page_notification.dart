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

class ProfilePageNotification extends StatefulWidget {
  const ProfilePageNotification({Key? key}) : super(key: key);

  @override
  State<ProfilePageNotification> createState() =>
      _ProfilePageNotificationState();
}

class _ProfilePageNotificationState extends State<ProfilePageNotification> {
  late Future<UserModel?> _userDataFuture;
  String club = '';
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
      sport = user?.sport ?? '';
    });
    return user;
  }

  Future<void> saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      await userService.updateUserClubInformation(userId, club, sport);
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
                  displaySport,
                  style: const TextStyle(fontSize: 16, color: AppColor.primary),
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
                  displayClub,
                  style: const TextStyle(fontSize: 16, color: AppColor.primary),
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
          'Benachrichtigungen anpassen',
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
            return Center(child: CircularProgressIndicator());
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
                    'Zu welchen neu eingestellten Artikel möchtest du benachrichtigt werden? \nDu kannst diese jederzeit ändern.',
                    style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      fontSize: 12,
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
                const SizedBox(height: 16),
                CustomButton(
                  buttonText: 'Speichern',
                  onPressed: () async {
                    try {
                      await saveChanges();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erfolgreich gespeichert'),
                        ),
                      );
                      setState(() {
                        changesMade = true;
                      });
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Fehler beim Speichern: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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
