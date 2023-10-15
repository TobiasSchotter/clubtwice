import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../welcome_page.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  bool isCheckboxChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Account löschen',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.black,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                  'Ich bestätige, dass all meine Transaktionen abgeschlossen sind',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              leading: Checkbox(
                value: isCheckboxChecked,
                onChanged: (value) {
                  setState(() {
                    isCheckboxChecked = value!;
                  });
                },
              ),
            ),
            const Divider(
                color: Colors.transparent), // Leerer Raum zwischen den Strichen
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Wenn du jetzt deinen Account löschst, wird er umgehend deaktiviert. Deaktivierte Accounts sind nur noch für das ClubTwice-Team sichtbar, bis sie endgültig gelöscht werden. Der Löschvorgang erfolgt innerhalb der in unserer Club-Twice-Datenschutzhinweisen beschriebenen Frist.',
                style: TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Center(
              child: Column(
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        if (isCheckboxChecked) {
                          try {
                            // Delete user from Firebase
                            UserService userService = UserService();
                            userService.deleteUser();

                            // Navigate to welcome page
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const WelcomePage(),
                              ),
                            );

                            // Sign out any remaining sessions
                            await FirebaseAuth.instance.signOut();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Account erfolgreich gelöscht'),
                              ),
                            );
                          } catch (e) {
                            print('Error deleting user: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Fehler beim Löschen des Accounts'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Bitte bestätige, dass alle Transaktionen abgeschlossen sind.'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        'Löschen',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    buttonText: 'Nicht löschen',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
