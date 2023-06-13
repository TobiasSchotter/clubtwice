import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyProfileWidget extends StatefulWidget {
  const MyProfileWidget({Key? key}) : super(key: key);

  @override
  _MyProfileWidgetState createState() => _MyProfileWidgetState();
}

class _MyProfileWidgetState extends State<MyProfileWidget> {
  Future<void> _uploadImage(File pickedFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Get the file name
    String fileName = path.basename(pickedFile.path);

    // Reference the Firebase storage location where the file will be uploaded
    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(user.uid)
        .child(fileName);

    // Upload the file to Firebase storage
    final uploadTask = firebaseStorageRef.putFile(File(pickedFile.path));

    // Optional: Monitor the upload progress
    uploadTask.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        print(
            'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      },
    );

    // Get the download URL of the uploaded file
    final imageUrl = await (await uploadTask).ref.getDownloadURL();

    // Save the imageUrl to the user data in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'profileImageUrl': imageUrl});

    print('Image uploaded. Download URL: $imageUrl');

    // Refresh the UI
    setState(() {});
  }

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
        final username = userData['username'] ?? '';
        var club = userData['club'] ?? '';
        var sport = userData['sport'] ?? '';

        if (sport.isEmpty || sport == "Keine Auswahl") {
          sport = '[keine Sportart hinterlegt]';
        }

        if (club.isEmpty || club == "Keine Auswahl") {
          club = '[kein Verein hinterlegt]';
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
                  image: DecorationImage(
                    image: userData['profileImageUrl'] != null
                        ? NetworkImage(userData['profileImageUrl'])
                        : AssetImage('assets/images/pp.png') as ImageProvider,
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
                        await _uploadImage(File(pickedFile.path));
                      }
                    },
                  ),
                ),
              ),
              // Fullname
              Container(
                margin: const EdgeInsets.only(bottom: 2, top: 7),
                child: Text(
                  '$firstname',
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
