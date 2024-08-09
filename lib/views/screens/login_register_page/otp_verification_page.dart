import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:clubtwice/views/screens/login_register_page/register_page.dart';
import 'package:clubtwice/constant/app_button.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;
  const OTPVerificationPage({super.key, required this.email});

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
          _navigateToNextPage();
          break;
        }
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  void _navigateToNextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const PageSwitcher(selectedIndex: 0),
      ),
    );
  }

  Future<void> _sendVerificationEmail() async {
    try {
      if (_user != null) {
        await _user!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bestätigungsmail wurde erneut gesendet.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fehler beim Senden der Bestätigungsmail.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Verifizierung abbrechen'),
          content: const Text(
            'Sicher, dass du die Verifizierung abbrechen möchtest? Die Registrierung wird vollständig zurückgesetzt!',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Bestätigen'),
              onPressed: () {
                _deleteUser();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Delete user from Firebase Authentication
        await currentUser.delete();

        // Delete user from Firestore or any other database if necessary
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Die Verifizierung wurde abgebrochen und der Benutzer wurde gelöscht.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fehler beim Löschen des Benutzers.'),
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
        title: const Text(
          'Verifizierung',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: _showConfirmationDialog,
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.black,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Bitte bestätige deine E-Mail-Adresse',
                  style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Der Verifizierungs-Code wurde an deine E-Mail Adresse geschickt:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.secondary, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Kontrolliere deinen Spam-Ordner',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.secondary, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bitte fordere eine neue Bestätigungsmail an, wenn du die E-Mail weiterhin nicht finden kannst',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.secondary, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Nach Bestätigung der Mailadresse kann es noch bis zu 15 Sekunden dauern, bis du automatisch weitergeleitet wirst',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.secondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Keine E-Mail von uns erhalten?',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                AppButton(
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
      ),
    );
  }
}
