import 'dart:io';

import 'package:clubtwice/constant/app_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(List<XFile>) onImagesSelected;
  final List<XFile> initialImages;

  ImagePickerWidget({
    required this.onImagesSelected,
    required this.initialImages,
  });

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<XFile> selectedImages = [];

  @override
  void initState() {
    super.initState();
    selectedImages = widget.initialImages;
  }

  Future<void> pickImages(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);

      if (image != null) {
        if (selectedImages.length < 5) {
          setState(() {
            selectedImages.add(image);
          });
          widget.onImagesSelected(selectedImages);
        } else {
          _showMaxImageLimitDialog();
        }
      }
    } catch (e) {
      // Handle image picking errors
      print("Error picking image: $e");
    }
  }

  void _removeImage(int index) {
    if (selectedImages.isNotEmpty) {
      setState(() {
        selectedImages.removeAt(index);
      });
    }
  }

  void _showMaxImageLimitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limit erreicht'),
          content: const Text('Es können maximal 5 Bilder hochgeladen werden.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showImagePickerMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Center(child: Text('Kamera')),
              onTap: () {
                Navigator.pop(context);
                pickImages(ImageSource.camera);
              },
            ),
            ListTile(
              title: const Center(child: Text('Galerie')),
              onTap: () {
                Navigator.pop(context);
                pickImages(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: selectedImages.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Image.file(
                            File(selectedImages[index].path),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 150,
                          ),
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
                      ),
                    );
                  },
                )
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
        Container(
          height: 6,
        ),
        CustomButton(
          onPressed: _showImagePickerMenu,
          buttonText: ('Bild auswählen'),
        ),
      ],
    );
  }
}
