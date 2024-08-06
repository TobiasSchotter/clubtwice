import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/login_register_page/login_page.dart';
import 'package:clubtwice/views/screens/login_register_page/otp_verification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../constant/app_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _errorMessage;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Registrieren',
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
      bottomNavigationBar: _buildLoginLink(),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildHeaderSection(),
          _buildFormSection(),
          const SizedBox(height: 24),
          AppButton(
            buttonText: 'Registrieren',
            onPressed: _createUserWithEmailAndPassword,
          ),
          const SizedBox(height: 16),
          _buildThirdPartyLoginButtons(),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
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
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              height: 150 / 100,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        _buildTextField(
          controller: _firstNameController,
          hintText: 'Vorname',
          icon: 'assets/icons/Profile.svg',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _userNameController,
          hintText: 'Nutzername',
          icon: 'assets/icons/Profile.svg',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailController,
          hintText: 'E-Mail',
          icon: 'assets/icons/Message.svg',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _confirmEmailController,
          hintText: 'E-Mail wiederholen',
          icon: 'assets/icons/Message.svg',
        ),
        const SizedBox(height: 16),
        _buildPasswordTextField(
          controller: _passwordController,
          hintText: 'Passwort',
          icon: 'assets/icons/Lock.svg',
          isObscured: true,
        ),
        const SizedBox(height: 16),
        _buildPasswordTextField(
          controller: _confirmPasswordController,
          hintText: 'Passwort wiederholen',
          icon: 'assets/icons/Lock.svg',
          isObscured: true,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
  }) {
    return TextField(
      controller: controller,
      autofocus: false,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Container(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            icon,
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
      inputFormatters: [
        LengthLimitingTextInputFormatter(55),
      ],
    );
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
    required bool isObscured,
  }) {
    return TextField(
      controller: controller,
      autofocus: false,
      obscureText: isObscured,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Container(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            icon,
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
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
      ],
    );
  }

  Widget _buildThirdPartyLoginButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _signInWithGoogle,
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColor.primary,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            backgroundColor: AppColor.primarySoft,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/Google.svg'),
              const SizedBox(width: 8),
              const Text(
                'Registriere dich mit Google',
                style: TextStyle(
                  color: AppColor.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Access the email here
        final googleEmail = googleSignInAccount.email;
        String? googleName = googleSignInAccount.displayName;

        // Check if the Google email already exists
        final UserCredential existingUser =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (existingUser.additionalUserInfo!.isNewUser) {
          // User is new, proceed with registration process
          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final User? user = userCredential.user;

          // Add user details to Firestore and Firebase Authentication
          if (user != null) {
            // if googleName is null, set it to "Nicht festgelegt"
            googleName ??= "Nicht festgelegt";

            await _addUserDetailsGoogle(user.uid, googleEmail, googleName);
          }

          // Continue with your registration flow...
          _navigateToNextPage();
        } else {
          // User is already registered
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Ein Konto mit dieser Google-E-Mail existiert bereits.'),
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

  void _navigateToNextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const PageSwitcher(selectedIndex: 0),
      ),
    );
  }

  Future<void> _createUserWithEmailAndPassword() async {
    try {
      // Validate form fields
      if (!_validateFields()) return;

      // Check if the username is already taken
      bool isUsernameTaken =
          await _isUsernameTaken(_userNameController.text.trim());
      if (isUsernameTaken) {
        setState(() {
          _errorMessage = 'Der Benutzername ist bereits vergeben.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create user
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get the user's UID
      final String uid = userCredential.user!.uid;

      // Add user details
      await _addUserDetails(uid);

      // Send email verification
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OTPVerificationPage(email: _emailController.text),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _errorMessage = 'Die E-Mail-Adresse wird bereits verwendet.';
            break;
          case 'invalid-email':
            _errorMessage = 'Ungültige E-Mail-Adresse.';
            break;
          case 'weak-password':
            _errorMessage = 'Das Passwort ist zu schwach.';
            break;
          default:
            _errorMessage = 'Ein Fehler ist aufgetreten: ${e.message}';
            break;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _isUsernameTaken(String username) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking username availability: $e');
      return true; // Assume username is taken in case of error
    }
  }

  bool _validateFields() {
    if (_firstNameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Der Vorname darf nicht leer sein.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_userNameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Der Nutzername darf nicht leer sein.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Die E-Mail-Adresse darf nicht leer sein.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_confirmEmailController.text != _emailController.text) {
      setState(() {
        _errorMessage =
            'Die eingegebenen E-Mail-Adressen stimmen nicht überein.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Das Passwort darf nicht leer sein.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() {
        _errorMessage = 'Die Passwörter stimmen nicht überein.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _addUserDetails(String uid) async {
    // Save user details in Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'first Name': _firstNameController.text.trim(),
      'username': _userNameController.text.trim(),
      'email': _emailController.text.trim(),
      'club': "",
      'club2': "",
      'sport': "",
      'favorites': <String>[], // Empty list for favorites
    });
  }

  Future<void> _addUserDetailsGoogle(
      String uid, String email, String googleName) async {
    // Check if the Google username already exists
    bool isUsernameTaken = await _isUsernameTaken(googleName);

    // If the username is already taken, append an index
    if (isUsernameTaken) {
      int index = 1;
      String newUsername = googleName;
      while (isUsernameTaken) {
        newUsername = '$googleName$index';
        isUsernameTaken = await _isUsernameTaken(newUsername);
        index++;
      }
      googleName = newUsername;
    }

    // Save user details in Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'first Name': googleName,
      'username': googleName,
      'email': email,
      'club': "",
      'club2': "",
      'sport': "",
      'favorites': <String>[], // Empty list for favorites
    });
  }
}
