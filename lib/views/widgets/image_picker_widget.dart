import 'dart:io';

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

  Future<void> pickImages() async {
    if (selectedImages.length < 5) {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          selectedImages.add(image);
        });
        widget.onImagesSelected(selectedImages);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: selectedImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.file(
                  File(selectedImages[index].path),
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: pickImages,
          child: Text('Bilder auswählen'),
        ),
      ],
    );
  }
}
