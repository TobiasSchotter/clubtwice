import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constant/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePageClub extends StatefulWidget {
  const ProfilePageClub({super.key});

  @override
  State<ProfilePageClub> createState() => _ProfilePageClubState();
}

class _ProfilePageClubState extends State<ProfilePageClub> {
  String verein = '';
  String sportart = '';

  Future<void> saveChanges() async {
    // Beispielaufruf der Funktion
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      updateUserData(userId, verein, sportart);
    }
  }

  Future<void> updateUserData(
      String userId, String verein, String sportart) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'club': verein,
      'sport': sportart,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Verein und Sportart anpassen',
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
            margin: const EdgeInsets.only(bottom: 0),
            child: Text(
              'Deine Startseite wird dir dementsprechend angezeigt. Bei Verkäufen wird dies bereits vorausgefüllt sein.\nDu kannst diese jederzeit ändern.',
              style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 12,
                  height: 150 / 100),
            ),
          ),
          // Section 2  - Form

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
                setState(() {
                  verein = newValue!;
                });
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
                setState(() {
                  sportart = newValue!;
                });
              }),

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
