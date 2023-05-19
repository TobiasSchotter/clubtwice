import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constant/app_button.dart';
import '../../constant/app_color.dart';

class PWChangePage extends StatefulWidget {
  const PWChangePage({Key? key}) : super(key: key);

  @override
  State<PWChangePage> createState() => _PWChangePageState();
}

class _PWChangePageState extends State<PWChangePage> {
  final _auth = FirebaseAuth.instance;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  String? _errorMessage = '';
  bool _isLogin = true;
  bool isObscured = true;
  bool isObscured2 = true;
  bool isObscured3 = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Passwort ändern',
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
          // Section 1 - Header
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 12),
            child: const Text(
              'So erstellst du ein sicheres Passwort',
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
              ' - Verwende mindestens 8 Zeichen\n - Wähle eine Kombination aus Buchstaben, Zahlen und Sonderzeichen',
              style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                  fontSize: 12,
                  height: 150 / 100),
            ),
          ),
          // const SizedBox(height: 16),
          // Password
          TextField(
            controller: _oldPasswordController,
            autofocus: false,
            obscureText: isObscured,
            decoration: InputDecoration(
              hintText: 'Altes Passwort eingeben',
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
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _newPasswordController,
            autofocus: false,
            obscureText: isObscured2,
            decoration: InputDecoration(
              hintText: 'Neues Passwort eingeben',
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
          ),
          const SizedBox(height: 16),
          // Repeat Password
          TextField(
            controller: _repeatPasswordController,
            autofocus: false,
            obscureText: isObscured3,
            decoration: InputDecoration(
              hintText: 'Neues Passwort wiederholen',
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
                    isObscured3 = !isObscured3;
                  });
                },
                icon: isObscured3
                    ? Icon(Icons.visibility_off,
                        color: AppColor.primary.withOpacity(0.5), size: 20)
                    : Icon(Icons.visibility,
                        color: AppColor.primary.withOpacity(0.5), size: 20),
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            buttonText: 'Passwort ändern',
            onPressed: _changePassword,
          ),
          if (_errorMessage != null && _errorMessage!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _changePassword() async {
    setState(() {
      _errorMessage = '';
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final repeatPassword = _repeatPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || repeatPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Bitte alle Felder ausfüllen';
      });
      return;
    }

    final credential = EmailAuthProvider.credential(
        email: currentUser!.email!, password: oldPassword);

    try {
      await currentUser.reauthenticateWithCredential(credential);

      if (newPassword.length < 8 ||
          !newPassword.contains(RegExp(r'[0-9]')) ||
          !newPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        setState(() {
          _errorMessage =
              'Das neue Passwort muss mindestens 8 Zeichen lang sein und mindestens eine Zahl und ein Sonderzeichen enthalten.';
        });
        return;
      }

      if (newPassword != repeatPassword) {
        setState(() {
          _errorMessage =
              'Die wiederholte Eingabe des neuen Passworts stimmt nicht überein.';
        });
        return;
      }

      await currentUser.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwort erfolgreich geändert.'),
        ),
      );

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Das alte Passwort ist falsch.';
        });
      } else {
        setState(() {
          _errorMessage =
              'Ein Fehler ist aufgetreten. Bitte versuchen Sie es später erneut.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Ein Fehler ist aufgetreten. Bitte versuchen Sie es später erneut.';
      });
    }
  }
}
