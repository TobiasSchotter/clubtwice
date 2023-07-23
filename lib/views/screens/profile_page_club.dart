import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';
import '../../constant/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/core/services/user_service.dart';
import 'package:clubtwice/core/model/UserModel.dart';

class ProfilePageClub extends StatefulWidget {
  const ProfilePageClub({Key? key}) : super(key: key);

  @override
  State<ProfilePageClub> createState() => _ProfilePageClubState();
}

class _ProfilePageClubState extends State<ProfilePageClub> {
  String club = '';
  String sport = '';
  final UserService userService = UserService();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    userModel = await userService.fetchUserData();

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
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const PageSwitcher(
                      selectedIndex: 4,
                    )));
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
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Verein auswählen',
              border: OutlineInputBorder(),
            ),
            value: club.isNotEmpty ? club : null, // Set the initial value
            items: <String>['Keine Auswahl', 'SG Quelle', 'SGV Nürnberg Fürth']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                club = newValue!;
              });
            },
          ),
          Container(
            height: 16,
          ),
          DropdownButtonFormField<String>(
            focusColor: AppColor.primarySoft,
            decoration: const InputDecoration(
              labelText: 'Sportart auswählen',
              border: OutlineInputBorder(),
            ),
            value: sport.isNotEmpty ? sport : null, // Set the initial value
            items: <String>['Keine Auswahl', 'Fußball', 'Basketball']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                sport = newValue!;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomButton(
            buttonText: 'Speichern',
            onPressed: () {
              saveChanges();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erfolgreich gespeichert'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
