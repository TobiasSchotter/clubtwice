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
  bool _isUploading = false;
  bool _isDeleting = false;

  Future<void> _uploadImage(File pickedFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String fileName = path.basename(pickedFile.path);

    final firebaseStorageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(user.uid)
        .child(fileName);

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final currentImageUrl = userData.data()!['profileImageUrl'];

    if (currentImageUrl != null) {
      await firebase_storage.FirebaseStorage.instance
          .refFromURL(currentImageUrl)
          .delete();
    }

    setState(() {
      _isUploading = true;
    });

    final uploadTask = firebaseStorageRef.putFile(File(pickedFile.path));

    uploadTask.snapshotEvents.listen(
      (firebase_storage.TaskSnapshot snapshot) {
        print(
            'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      },
    );

    await Future.delayed(const Duration(milliseconds: 500));

    final imageUrl = await (await uploadTask).ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'profileImageUrl': imageUrl});

    setState(() {
      _isUploading = false;
    });

    print('Image uploaded. Download URL: $imageUrl');
  }

  Future<void> _deleteImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final imageUrl = userData.data()!['profileImageUrl'];

    if (imageUrl == null) return;

    setState(() {
      _isDeleting = true;
    });

    final imageRef =
        firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
    await imageRef.delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'profileImageUrl': null});

    setState(() {
      _isDeleting = false;
    });

    print('Image deleted.');
  }

  Widget _buildUserInfoText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Container();
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final userData = snapshot.data?.data();
        if (userData == null) {
          return Container();
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
              GestureDetector(
                onTap: () async {
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
                                _deleteImage();
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
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: userData['profileImageUrl'] != null
                          ? NetworkImage(userData['profileImageUrl'])
                          : const AssetImage('assets/images/pp.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    Text(
                      '$firstname',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    _buildUserInfoText('$username'),
                    _buildUserInfoText('$club'),
                    _buildUserInfoText('$sport'),
                    if (_isUploading) const CircularProgressIndicator(),
                    if (_isDeleting) const CircularProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
