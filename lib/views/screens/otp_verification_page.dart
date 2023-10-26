import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/views/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constant/app_color.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  User? _user;
  bool _isEmailVerified = false;
  bool _isListening = true;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  @override
  void dispose() {
    _isListening = false;
    super.dispose();
  }

  Future<void> _checkEmailVerification() async {
    while (_isListening) {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.reload();
        setState(() {
          _user = currentUser;
          _isEmailVerified = currentUser.emailVerified;
        });

        if (_isEmailVerified) {
          // E-Mail wurde bereits bestätigt, Seite wechseln
          _navigateToNextPage();
          break;
        }
      }

      await Future.delayed(const Duration(
          seconds: 5)); // Warte 3 Sekunden vor dem erneuten Prüfen
    }
  }

  void _navigateToNextPage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const PageSwitcher(
              selectedIndex: 0,
            )));
  }

  Future<void> _sendVerificationEmail() async {
    if (_user != null) {
      await _user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bestätigungsmail wurde erneut gesendet.'),
        ),
      );
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog muss manuell geschlossen werden
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verifizierung abbrechen'),
          content: const Text(
              'Sicher, dass du die Verifizierung abbrechen möchtest? Die Registrierung wird vollständig zurückgesetzt!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
              },
            ),
            TextButton(
              child: const Text('Bestätigen'),
              onPressed: () {
                // Benutzer löschen oder andere Aktionen ausführen
                _deleteUser(); // Beispiel: Benutzer löschen
                Navigator.of(context).pop(); // Dialog schließen

                // Zurück zur Registrierungsseite
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const RegisterPage()));
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.delete();
      // Zeige eine Meldung an den Benutzer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Die Verifizierung wurde abgebrochen und der Benutzer wurde gelöscht.'),
          backgroundColor: Colors.red,
        ),
      );
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
        title: const Text('Verifizierung',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            _showConfirmationDialog();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.black,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 8),
                child: const Text(
                  'Bitte bestätige deine E-Mail-Adresse',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'poppins',
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '- Der Verifizierungs-Code wurde an deine E-Mail Adresse geschickt',
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '- Kontrolliere deinen Spam-Ordner',
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '- Bitte fordere einen neue Bestätigungsmail an, wenn du die E-Mail weiterhin nicht finden kannst',
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '- Nach Bestätigung der Mailadresse kann es noch ein paar Sekunden dauern, bis du automatisch weitergeleitest wirst',
                        style: TextStyle(
                          color: AppColor.secondary.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    //   Container(
                    // margin: const EdgeInsets.only(top: 0, bottom: 20),
                    //  child: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //    TextField(
                    //      controller: _emailController,
                    //     decoration: InputDecoration(
                    // Additional desired settings for the text field decoration
                    //          ),
                    //                               ),
                    // Text(
                    //   'Bitte prüfe, ob deine E-Mail Adresse richtig ist',
                    //   style: TextStyle(
                    //    fontSize: 12,
                    //    color: Colors.grey,
                    //   ),
                    //   ),
                    //  ],
                    //  ),
                    //  ),
                  ],
                ),
              ),
              const Text(
                'Keine E-Mail von uns erhalten?',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                onPressed: () {
                  if (!_isEmailVerified) {
                    _sendVerificationEmail();
                  }
                },
                buttonText: 'Bestätigungsmail erneut senden',
              ),
              const SizedBox(height: 16.0),
              Text(
                _isEmailVerified
                    ? 'E-Mail wurde bestätigt.'
                    : 'E-Mail wurde noch nicht bestätigt.',
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
