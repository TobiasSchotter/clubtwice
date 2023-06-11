import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant/app_color.dart';

class ImageGrid extends StatefulWidget {
  const ImageGrid({super.key});

  @override
  _ImageGridState createState() => _ImageGridState();

  List<File> getImageList() {
    return _ImageGridState().getImageList();
  }
}

class _ImageGridState extends State<ImageGrid> {
  final List<File> _imageList = [];
  final ImagePicker _picker = ImagePicker();

  List<File> getImageList() {
    return _imageList;
  }

  void _pickImage(ImageSource source) async {
    if (_imageList.length >= 5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Limit erreicht'),
            content:
                const Text('Es können maximal 5 Bilder hochgeladen werden.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      print("Jetzt wird ein Bild hinzugefügt");
      setState(() {
        _imageList.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    if (_imageList.isNotEmpty) {
      setState(() {
        _imageList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text('Kamera'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text('Galerie'),
              ),
            ),
          ],
        ),
        Container(height: 16.0),
        Container(
          decoration: _imageList.isEmpty
              ? const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: _imageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  Image.file(
                    _imageList[index],
                    fit: BoxFit.cover,
                    width: 100, // Setzen Sie die gewünschte Breite des Bilds
                    height: 100, // Setzen Sie die gewünschte Höhe des Bilds
                  ),
                  if (_imageList.isNotEmpty)
                    Positioned(
                      top: 4.0,
                      right: 4.0,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.all(4.0),
                          child: const Icon(
                            Icons.close,
                            size: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
