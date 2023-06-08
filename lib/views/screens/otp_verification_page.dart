import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/views/screens/otp_verification_page_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
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
              'E-Mail Verifizierung',
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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Der Verifizierungs-Code wurde an deine E-Mail Adresse geschickt',
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
            height: 16,
          ),
          PinCodeTextField(
            appContext: (context),
            length: 4,
            onChanged: (value) {},
            obscureText: false,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderWidth: 1.5,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 70,
              fieldWidth: 70,
              activeColor: AppColor.primary,
              inactiveColor: AppColor.border,
              inactiveFillColor: AppColor.primarySoft,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 32, bottom: 16),
            child: CustomButton(
              buttonText: 'Verifiziere deine Mail',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PageSwitcher(
                          selectedIndex: 0,
                        )));
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const OTPVerificationPageChange()), // Hier "ChangePage" mit dem Namen deiner Seite "Change" ersetzen
              );
            },
            child: const Center(
              child: Text(
                'Keine E-Mail von uns erhalten?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
