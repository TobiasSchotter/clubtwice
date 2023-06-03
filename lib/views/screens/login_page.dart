import 'package:clubtwice/views/screens/pw_reset_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:clubtwice/views/screens/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constant/app_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool isObscured = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const PageSwitcher(
          selectedIndex: 0,
        ),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        print('Fehlercode: ${e.code}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Die E-Mail-Adresse oder das Passwort ist falsch.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print('Unbekannter Fehler: ${e.code}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ein Fehler ist aufgetreten. .'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Unbekannter Fehler: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Ein Fehler ist aufgetreten. Bitte versuchen Sie es erneut.'),
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
        // ignore: prefer_const_constructors
        title: Text('Einloggen',
            style: const TextStyle(
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
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColor.secondary.withOpacity(0.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Du hast noch keinen Account?',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                ' Anmelden',
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
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
              'Willkommen zurück',
              style: TextStyle(
                color: AppColor.secondary,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
                fontSize: 20,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 32),
            child: Text(
              'Bei ClubTwice schenkst du Vereinskleidung neues Leben und verhilfst Vereinen zu mehr Nachhaltigkeit',
              style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 12,
                  height: 150 / 100),
            ),
          ),
          // Section 2 - Form
          // Email
          TextField(
            autofocus: false,
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'deine.email@email.com',
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Message.svg',
                    color: AppColor.primary),
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
          // Password
          TextField(
            autofocus: false,
            controller: _passwordController,
            obscureText: isObscured,
            decoration: InputDecoration(
              hintText: '**********',
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/icons/Lock.svg',
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
              //
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
                icon: isObscured
                    ? Icon(Icons.visibility_off,
                        color: AppColor.primary.withOpacity(0.5), size: 20)
                    : Icon(Icons.visibility,
                        color: AppColor.primary.withOpacity(0.5), size: 20),
              ),
            ),
          ),
          // Forgot Passowrd
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ResetPage()));
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary.withOpacity(0.1),
              ),
              child: Text(
                'Passwort vergessen?',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColor.secondary.withOpacity(0.5),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          // Sign In button
          CustomButton(
            buttonText: 'Einloggen',
            onPressed: () {
              if (_emailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Bitte geben Sie Ihre Anmeldedaten ein'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                signInWithEmailAndPassword();
              }
            },
          ),
        ],
      ),
    );
  }
}
