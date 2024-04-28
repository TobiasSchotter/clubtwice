import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/login_register_page/register_page.dart';
import 'package:clubtwice/views/screens/login_register_page/pw_reset_page.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscured = true;

  Future<void> signInWithEmailAndPassword() async {
  // Überprüfen, ob E-Mail und Passwort eingegeben wurden
  if (_emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bitte E-Mail eingeben.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }
  if (_passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bitte Passwort eingeben.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const PageSwitcher(selectedIndex: 0),
    ));
  } on FirebaseAuthException catch (e) {
    String errorMessage =
        'Ein Fehler ist aufgetreten. Bitte versuchen Sie es erneut.';
    if (e.code == "wrong-password" || e.code == "invalid-email") {
      errorMessage = 'Die E-Mail-Adresse oder das Passwort ist falsch.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Ein Fehler ist aufgetreten. Bitte versuchen Sie es erneut.',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Future<bool> checkIfUserIsRegistered(String email) async {
    try {
      // Fetch the sign-in methods for the provided email
      final methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // If methods is not empty, it means a user with this email exists
      return methods.isNotEmpty;
    } catch (e) {
      // Handle any errors that occur during the check
      print('Error checking if user is registered: $e');
      return false; // Return false in case of an error
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        // Check if the user is already registered
        final isUserRegistered =
            await checkIfUserIsRegistered(googleSignInAccount.email);

        if (isUserRegistered) {
          // Proceed with Google sign-in if the user is registered
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );

          // Sign in with Google credential
          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);

          // Navigate to next page upon successful sign-in
          if (userCredential.user != null) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const PageSwitcher(selectedIndex: 0),
            ));
          }
        } else {
          // Display a message indicating that the user needs to create an account
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Du musst zu erst ein Konto erstellen.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fehler beim Anmelden mit Google.'),
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
          'Einloggen',
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
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const RegisterPage(),
            ));
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
                height: 150 / 100,
              ),
            ),
          ),
          TextField(
            autofocus: false,
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'deine.email@email.com',
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
                borderSide: const BorderSide(
                  color: AppColor.border,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColor.primary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(70),
            ],
          ),
          const SizedBox(height: 16),
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
                borderSide: const BorderSide(
                  color: AppColor.border,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColor.primary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: AppColor.primarySoft,
              filled: true,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
                icon: isObscured
                    ? Icon(
                        Icons.visibility_off,
                        color: AppColor.primary.withOpacity(0.5),
                        size: 20,
                      )
                    : Icon(
                        Icons.visibility,
                        color: AppColor.primary.withOpacity(0.5),
                        size: 20,
                      ),
              ),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ResetPage(),
                ));
              },
              child: const Text(
                'Passwort vergessen?',
                style: TextStyle(
                  color: AppColor.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColor.primary, // Set the background color here
            ),
            child: ElevatedButton(
              onPressed: signInWithEmailAndPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                elevation: 0, // Remove elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Einloggen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _signInWithGoogle,
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primary,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              backgroundColor: AppColor.primarySoft,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/icons/Google.svg'),
                const SizedBox(width: 16),
                const Text(
                  'Einloggen mit Google',
                  style: TextStyle(
                    color: AppColor.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
