import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfileWidget extends StatelessWidget {
  const MyProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Container(); // Handle when user is not logged in
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Handle while data is being fetched
        }

        final userData = snapshot.data?.data();
        if (userData == null) {
          return Container(); // Handle when user data is not available
        }

        final firstname = userData['first Name'] ?? '';
        final lastname = userData['last Name'] ?? '';
        final username = userData['username'] ?? '';
        //   final club = userData['club'] ?? '[kein Verein hinterlegt]';
        //    final sport = userData['sport'] ?? '[keine Sportart hinterlegt]';

        var club = userData['club'] ?? '';
        var sport = userData['sport'] ?? '';

        if (club.isEmpty && sport.isEmpty) {
          club = '[kein Verein hinterlegt]';
          sport = '[keine Sportart hinterlegt]';
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/pp.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    iconSize: 14,
                    icon: const Icon(Icons.camera_alt_rounded),
                    color: Colors.white,
                    onPressed: () async {
                      // Image picking logic
                      final pickedFile = await showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Galerie'),
                                  onTap: () async {
                                    final picker = ImagePicker();
                                    final pickedImage = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      maxWidth: 400,
                                    );
                                    Navigator.of(context).pop(pickedImage);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Kamera'),
                                  onTap: () async {
                                    final picker = ImagePicker();
                                    final pickedImage = await picker.pickImage(
                                      source: ImageSource.camera,
                                      maxWidth: 400,
                                    );
                                    Navigator.of(context).pop(pickedImage);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Bild löschen'),
                                  onTap: () {
                                    Navigator.of(context).pop(null);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      if (pickedFile != null) {
                        // Hier kannst du den Code zum Hochladen des Bildes einfügen
                        // Beispiel für die Verwendung des Bildes:
                      }
                    },
                  ),
                ),
              ),
              // Fullname
              Container(
                margin: const EdgeInsets.only(bottom: 2, top: 7),
                child: Text(
                  '$firstname' + ' $lastname',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              // Username
              Text(
                '$username',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
              Text(
                '$club',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
              Text(
                '$sport',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
