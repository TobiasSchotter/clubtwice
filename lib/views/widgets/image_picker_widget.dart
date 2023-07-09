import 'dart:io';

import 'package:clubtwice/constant/app_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(List<XFile>) onImagesSelected;

  ImagePickerWidget({required this.onImagesSelected});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<XFile> selectedImages = [];

  Future<void> pickImages(ImageSource source) async {
    if (selectedImages.length < 5) {
      final XFile? image = await ImagePicker().pickImage(source: source);

      if (image != null) {
        setState(() {
          selectedImages.add(image);
        });
        widget.onImagesSelected(selectedImages);
      }
    } else {
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
    }
  }

  void _removeImage(int index) {
    if (selectedImages.isNotEmpty) {
      setState(() {
        selectedImages.removeAt(index);
      });
    }
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () => pickImages(ImageSource.gallery),
                buttonText: 'Galerie',
              ),
            ),
            const SizedBox(
                width:
                    16), // Fügt einen horizontalen Abstand zwischen den Buttons hinzu
            Expanded(
              child: CustomButton(
                onPressed: () => pickImages(ImageSource.camera),
                buttonText: 'Kamera',
              ),
            ),
          ],
        )
      ],
    );
  }
}
