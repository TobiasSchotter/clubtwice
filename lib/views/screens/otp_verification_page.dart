import 'package:clubtwice/views/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      // Bestätigungsmail gesendet
      // ...
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bitte bestätige deine E-Mail-Adresse.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: !_isEmailVerified ? _sendVerificationEmail : null,
                  child: const Text('Bestätigungsmail erneut senden')),
              const SizedBox(height: 16.0),
              Text(
                _isEmailVerified
                    ? 'E-Mail wurde bestätigt.'
                    : 'E-Mail wurde noch nicht bestätigt.',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
