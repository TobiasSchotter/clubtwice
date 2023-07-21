import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clubtwice/constant/app_color.dart';
import '../../constant/app_button.dart';

class ProfilePageSet extends StatefulWidget {
  const ProfilePageSet({super.key});

  @override
  _ProfilePageSetState createState() => _ProfilePageSetState();
}

class _ProfilePageSetState extends State<ProfilePageSet> {
  final TextEditingController _firstNameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    // _lastNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

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

        final firstName = userData['first Name'] ?? '';
        //final lastName = userData['last Name'] ?? '';
        final userName = userData['username'] ?? '';

        // Set the initial value of the TextField
        _firstNameController.text = firstName;
        // _lastNameController.text = lastName;
        _userNameController.text = userName;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Profil anpassen',
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

                // if (shouldRefresh == true) {
                // Führe die Aktualisierungslogik aus
                // ...
                //   }
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
              Text(
                'Vorname',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.5),
                  letterSpacing: 6 / 100,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Full Name
              TextField(
                autofocus: false,
                controller:
                    _firstNameController, // Bind the controller to the TextField
                decoration: InputDecoration(
                  hintText: 'Vorname',
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/Profile.svg',
                      color: AppColor.primary,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
              ),

              const SizedBox(height: 8),

              const SizedBox(height: 8),
              Text(
                'Benutzername',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.5),
                  letterSpacing: 6 / 100,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Email
              TextField(
                autofocus: false,
                controller:
                    _userNameController, // Bind the controller to the TextField
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Benutzername',
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'assets/icons/Profile.svg',
                      color: AppColor.primary,
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.border, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColor.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fillColor: AppColor.primarySoft,
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),

              CustomButton(
                buttonText: 'Speichern',
                onPressed: () {
                  final newFirstName = _firstNameController.text.trim();
                  // final newLastName = _lastNameController.text.trim();
                  final newUserName = _userNameController.text.trim();

                  if (newFirstName.isNotEmpty &&
                      //  newLastName.isNotEmpty &&
                      newUserName.isNotEmpty) {
                    if (newFirstName != firstName ||
                        //  newLastName != lastName ||
                        newUserName != userName) {
                      // Update user data in Firebase
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({
                        'first Name': newFirstName,
                        // 'last Name': newLastName,
                        'username': newUserName,
                      }).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erfolgreich gespeichert'),
                          ),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Fehler beim Speichern der Daten: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Es wurden keine Änderungen vorgenommen'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Vorname und Nachname dürfen nicht leer sein'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
