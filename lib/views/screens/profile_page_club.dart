import 'package:clubtwice/views/screens/selection_club_page.dart';
import 'package:clubtwice/views/screens/selection_sport_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/core/services/user_service.dart';
import 'package:clubtwice/core/model/UserModel.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/constant/app_button.dart';

class ProfilePageClub extends StatefulWidget {
  const ProfilePageClub({Key? key}) : super(key: key);

  @override
  State<ProfilePageClub> createState() => _ProfilePageClubState();
}

class _ProfilePageClubState extends State<ProfilePageClub> {
  String club = '';
  String sport = '';
  String originalClub = '';
  String originalSport = '';
  final UserService userService = UserService();
  UserModel? userModel;
  bool changesMade = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String? userId = userService.getCurrentUserId();
    userModel = await userService.fetchUserData(userId);

    setState(() {
      club = userModel!.club;
      sport = userModel!.sport;
    });
  }

  Future<void> saveChanges() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      userService.updateUserClubInformation(userId, club, sport);
    }
  }

  Widget _buildSportSelection(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedSport = await Navigator.push<String>(
          context,
          MaterialPageRoute(
              builder: (context) => SportSelectionPage(
                    selectedSport: sport,
                  )),
        );

        if (selectedSport != null) {
          setState(() {
            sport = (selectedSport == "Keine Auswahl") ? "" : selectedSport;
          });
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
                  sport.isEmpty ? "Keine Auswahl" : sport,
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
    return GestureDetector(
      onTap: () async {
        final selectedClub = await Navigator.push<String>(
          context,
          MaterialPageRoute(
              builder: (context) => ClubSelectionPage(
                    selectedClub: club,
                  )),
        );

        if (selectedClub != null) {
          setState(() {
            club = (selectedClub == "Keine Auswahl") ? "" : selectedClub;
          });
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
                  club.isEmpty ? "Keine Auswahl" : club,
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
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 0),
            child: Text(
              'Deine Startseite wird dir dementsprechend angezeigt. Bei Verkäufen wird dies bereits vorausgefüllt sein.\nDu kannst diese jederzeit ändern.',
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
              if (club != originalClub || sport != originalSport) {
                await saveChanges();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erfolgreich gespeichert'),
                  ),
                );
                setState(() {
                  changesMade = true;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Keine Änderungen vorgenommen'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
