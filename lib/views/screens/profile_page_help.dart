import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePageHelp extends StatefulWidget {
  const ProfilePageHelp({super.key});

  @override
  State<ProfilePageHelp> createState() => _ProfilePageHelpState();
}

class _ProfilePageHelpState extends State<ProfilePageHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Hilfe ',
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

      // Full Name
    );
  }
}
