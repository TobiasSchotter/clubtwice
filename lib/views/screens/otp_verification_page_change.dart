import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/views/screens/otp_verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';

class OTPVerificationPageChange extends StatefulWidget {
  const OTPVerificationPageChange({Key? key});

  @override
  State<OTPVerificationPageChange> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPageChange> {
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getEmailFromFirebase().then((email) {
      setState(() {
        _emailController.text = email;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<bool> _saveChanges() async {
    String newEmail = _emailController.text;

    // Check if the email field is empty or does not contain the "@" symbol
    if (newEmail.isEmpty ||
        !newEmail.contains('@') ||
        !newEmail.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte geben Sie eine gültige E-Mail-Adresse ein'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    try {
      // Get the current user
      //User? user = FirebaseAuth.instance.currentUser;

      // Update the email address
      //await user?.updateEmail(newEmail);

      // Send a verification email to the old address
      //await user?.sendEmailVerification();

      // Confirmation email sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Der Verifizierungs-Code wurde an deine E-Mail Adresse geschickt'),
        ),
      );
    } catch (e) {
      // Error updating the email address

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fehler beim Versenden des Verifizierungs-Codes',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Update the original email with the new value
    // setState(() {});

    return true;
  }

  Future<String> getEmailFromFirebase() async {
    // Insert code here to retrieve the email address from Firebase
    // Example:
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    return email ?? '';
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
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 8),
            child: const Text(
              'Keine E-Mail von uns erhalten?',
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
                    '- Stelle sicher, dass du dein E-Mail richtig angegeben hast',
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
                    '- Bitte fordere einen neuen Verifizierungscode an, wenn du die E-Mail weiterhin nicht finden kannst',
                    style: TextStyle(
                      color: AppColor.secondary.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      // Additional desired settings for the text field decoration
                      ),
                ),
                Text(
                  'Bitte prüfe, ob deine E-Mail Adresse richtig ist',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            buttonText: 'Verifizierungscode erneut senden',
            onPressed: () async {
              bool changesSaved = await _saveChanges();
              if (changesSaved) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OTPVerificationPage(),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
