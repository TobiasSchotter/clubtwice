import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';

class ProfilePageClub extends StatefulWidget {
  const ProfilePageClub({super.key});

  @override
  State<ProfilePageClub> createState() => _ProfilePageClubState();
}

class _ProfilePageClubState extends State<ProfilePageClub> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profil anpassen',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
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
          // Section 1 - Header
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 12),
            child: const Text(
              'Willkommen bei ClubTwice  👋',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 0),
            child: Text(
              'Passe hier deine Vereinszugehörigkeit und deine Sportart an.',
              style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 12,
                  height: 150 / 100),
            ),
          ),
          // Section 2  - Form

          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 0),
            child: Text(
              'Account',
              style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.5),
                  letterSpacing: 6 / 100,
                  fontWeight: FontWeight.w600),
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
              items: <String>['SG Quelle', 'SGV Nürnberg Fürth']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {});
              }),
          Container(
            height: 16,
          ),
          DropdownButtonFormField<String>(
              focusColor: AppColor.primarySoft,
              decoration: const InputDecoration(
                labelText: 'Sportart auswählen',
                border: OutlineInputBorder(),
              ),
              items: <String>['Fußball', 'Basketball']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {});
              }),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erfolgreich gespeichert'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              backgroundColor: AppColor.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: const Text(
              'Speichern',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: 'poppins'),
            ),
          ),
        ],
      ),
    );
  }
}
