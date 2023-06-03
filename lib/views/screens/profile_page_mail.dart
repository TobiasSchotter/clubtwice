import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clubtwice/constant/app_color.dart';

import '../../constant/app_button.dart';

class ProfilePageMail extends StatefulWidget {
  const ProfilePageMail({Key? key}) : super(key: key);

  @override
  State<ProfilePageMail> createState() => _ProfilePageMailState();
}

class _ProfilePageMailState extends State<ProfilePageMail> {
  final TextEditingController _emailController = TextEditingController();
  String _originalEmail = '';

  @override
  void initState() {
    super.initState();
    // Set the initial value of the email controller and original email

    _originalEmail = _emailController.text;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    String newEmail = _emailController.text;

    // Überprüfen, ob das E-Mail-Feld leer ist und das "@"-Zeichen nicht darin vorhanden ist
    if (newEmail.isEmpty ||
        !newEmail.contains('@') ||
        !newEmail.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte geben Sie eine gültige E-Mail-Adresse ein'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Überprüfen, ob die neue E-Mail-Adresse gleich der alten E-Mail-Adresse ist
    if (newEmail == _originalEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Die neue E-Mail-Adresse darf nicht identisch mit der alten E-Mail-Adresse sein'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Send confirmation email only if email has been changed
    try {
      // Aktuellen Benutzer abrufen
      User? user = FirebaseAuth.instance.currentUser;

      // E-Mail-Adresse aktualisieren
      await user?.updateEmail(newEmail);

      // Bestätigungs-E-Mail an die alte Adresse senden
      await user?.sendEmailVerification();

      // Confirmation email sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bestätigungs-E-Mail an die alte Adresse gesendet'),
        ),
      );
    } catch (e) {
      // Fehler beim Aktualisieren der E-Mail-Adresse
      print('Fehler beim Aktualisieren der E-Mail-Adresse: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fehler beim Aktualisieren der E-Mail-Adresse',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update the original email with the new value
    _originalEmail = newEmail;

    // Show a snackbar to indicate that changes have been saved
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Änderungen wurden gespeichert'),
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
          'E-Mail ändern',
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
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          // Section 1 - Header
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 12),
            child: const Text(
              'So änderst du deine E-Mail-Adresse',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Text(
              ' - Gebe hier deine neue E-Mail-Adresse ein\n - Aus Sicherheitsgründen wird eine E-Mail an die ursprüngliche Adresse gesendet\n - Prüfe und bestätige anschließend die Änderung',
              style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 12,
                  height: 150 / 100),
            ),
          ),

          // Full Name
          TextField(
            autofocus: false,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'deine.neue.email@email.com',
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/icons/Message.svg',
                  color: AppColor.primary,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.border, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.primary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
          ),
          const SizedBox(height: 16),

          CustomButton(
            buttonText: 'E-Mail-Adresse ändern',
            onPressed: _saveChanges,
          ),
        ],
      ),
    );
  }
}
