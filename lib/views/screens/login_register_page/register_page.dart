import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/login_register_page/login_page.dart';
import 'package:clubtwice/views/screens/login_register_page/otp_verification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constant/app_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool isObscured = true;
  bool isObscured2 = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _confirmemailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      if (_firstNameController.text.trim().isEmpty) {
        setState(() {
          errorMessage = 'Der Vorname darf nicht leer sein.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_userNameController.text.trim().isEmpty) {
        setState(() {
          errorMessage = 'Der Nutzername darf nicht leer sein.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (emailConfirmation(
              _emailController.text, _confirmemailController.text) &&
          passwordConfirm(
              _passwordController.text, _confirmPasswordController.text) &&
          passwordRequirement(_passwordController.text)) {
        emailConfirm(_emailController.text);

        // Create user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Get the user's UID
        String uid = userCredential.user!.uid;

        // add userdetails
        addUserDetails(uid, _firstNameController.text.trim(),
            _userNameController.text.trim(), _emailController.text.trim());

        // Benutzer erfolgreich erstellt, leite zur E-Mail-Verifizierung weiter
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(
                email: _emailController.text,
              ),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      print(errorMessage);
      // Show error message as snack bar
    }
  }

  Future<void> addUserDetails(
      String uid, String firstName, String userName, String email) async {
    // Speichern der Benutzerdetails in Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'first Name': firstName,
      'username': userName,
      'email': email,
      'club': "Keine Auswahl",
      'sport': "Keine Auswahl",
      'favorites': <String>[], // Empty list for favorites
    });
  }

  Future emailConfirm(email) async {
    if (email.isEmpty) {
      setState(() {
        errorMessage = 'Die E-Mail-Adresse darf nicht leer sein.';
      });
      // Show error message as snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if email contains '@' and at least one dot
    final dotCount = email.split('.').length - 1;
    final isValidEmail = email.contains('@') && dotCount >= 1;
    if (!isValidEmail) {
      setState(() {
        errorMessage = 'Die eingegebene E-Mail-Adresse ist ungültig.';
      });
      // Show error message as snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Check if email already exists in Firebase
    final user = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    // ignore: unnecessary_null_comparison
    if (user != null && user.isNotEmpty) {
      setState(() {
        errorMessage = 'Die eingegebene E-Mail-Adresse existiert bereits.';
      });
      // Show error message as snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  bool passwordConfirm(String pw, String pwToConfirm) {
    if (pw == pwToConfirm) {
      return true;
    } else {
      setState(() {
        errorMessage = 'Die Passwörter stimmen nicht überein.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  bool emailConfirmation(email, confirmEmail) {
    if (email == confirmEmail) {
      return true;
    } else {
      setState(() {
        errorMessage =
            'Die eingegebenen E-Mail-Adressen stimmen nicht überein.';
      });
      // Show error message as snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  bool passwordRequirement(password) {
    // Check password requirements
    final hasNumber = password.contains(RegExp(r'\d'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (password.length < 8 || !hasNumber || !hasSpecialChar) {
      setState(() {
        errorMessage =
            'Das Passwort muss mindestens 8 Zeichen lang sein und mindestens eine Zahl und ein Sonderzeichen enthalten.';
      });
      // Show error message as snack bar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } else {
      return true;
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
        title: const Text('Registrieren',
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
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 48,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColor.secondary.withOpacity(0.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Du hast schon einen Account?',
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
              'Willkommen bei ClubTwice  👋',
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
          // Section 2  - Form
          // Full Name
          TextField(
            autofocus: false,
            controller: _firstNameController,
            decoration: InputDecoration(
              hintText: 'Vorname',
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Profile.svg',
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
          ),
          const SizedBox(height: 16),
          // Username
          TextField(
            autofocus: false,
            controller: _userNameController,
            decoration: InputDecoration(
              hintText: 'Nutzername',
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Profile.svg',
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
          ),
          const SizedBox(height: 16),
          // Email
          TextField(
            autofocus: false,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'E-Mail',
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(70),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            autofocus: false,
            controller: _confirmemailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'E-Mail wiederholen',
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(70),
            ],
          ),
          const SizedBox(height: 16),
          // Password
          TextField(
            autofocus: false,
            controller: _passwordController,
            obscureText: isObscured,
            decoration: InputDecoration(
              hintText: 'Passwort',
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Lock.svg',
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
          ),
          const SizedBox(height: 16),
          // Repeat Password
          TextField(
            autofocus: false,
            controller: _confirmPasswordController,
            obscureText: isObscured2,
            decoration: InputDecoration(
              hintText: 'Passwort wiederholen',
              prefixIcon: Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Lock.svg',
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
              //
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscured2 = !isObscured2;
                  });
                },
                icon: isObscured2
                    ? Icon(Icons.visibility_off,
                        color: AppColor.primary.withOpacity(0.5), size: 20)
                    : Icon(Icons.visibility,
                        color: AppColor.primary.withOpacity(0.5), size: 20),
              ),
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
          ),
          const SizedBox(height: 24),
          // Sign Up Button
          CustomButton(
            buttonText: 'Registrieren',
            onPressed: () {
              //Nav needs to be removed after firebase integration
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => const OTPVerificationPage()));
              createUserWithEmailAndPassword();
            },
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'oder',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          // SIgn in With Google
          ElevatedButton(
            onPressed: () {
              const snackBar = SnackBar(
                content: Text('Funktion akutell nicht verfügbar'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
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
                SvgPicture.asset(
                  'assets/icons/Google.svg',
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: const Text(
                    'Registiere dich mit Google',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 5),
          ),

          // SIgn in With Facebook
          ElevatedButton(
            onPressed: () {
              const snackBar = SnackBar(
                content: Text('Funktion akutell nicht verfügbar'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
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
                SvgPicture.asset(
                  'assets/icons/Google.svg',
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: const Text(
                    'Registiere dich mit Facebook',
                    style: TextStyle(
                      color: AppColor.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
