import 'package:flutter/material.dart';

class MyProfileWidget extends StatelessWidget {
  const MyProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey,
              image: const DecorationImage(
                image: AssetImage('assets/images/pp.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Fullname
          Container(
            margin: const EdgeInsets.only(bottom: 4, top: 14),
            child: const Text(
              'Riccardo Bald',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
          ),
          // Username
          Text(
            '@RicBal',
            style:
                TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
          ),
          Text(
            'SG Quelle Fürth',
            style:
                TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
          ),
          Text(
            'Fußball',
            style:
                TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
