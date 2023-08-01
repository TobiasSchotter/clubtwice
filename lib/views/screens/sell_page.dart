import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/views/widgets/image_picker_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/model/UserModel.dart';
import '../../core/services/user_service.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  // final database = FirebaseDatabase.instance.reference();

  List<XFile> selectedImages = [];
  bool _isIndividuallyWearable = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _selectedSport = "Keine Auswahl";
  String _selectedClub = "Keine Auswahl";
  String _selectedType = "Kids";
  String _selectedSize = '152';
  String _selectedBrand = "Adidas";
  String _selectedCondition = "Sehr gut";

  User? user = FirebaseAuth.instance.currentUser;

  final UserService userService = UserService();
  UserModel? userModel;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    userModel = await userService.fetchUserData();
    setState(() {
      _selectedClub = userModel!.club;
      _selectedSport = userModel!.sport;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.primary,
        title: const Text(
          'Vereinskleidung verkaufen',
          style: TextStyle(fontSize: 15), // Schriftgröße anpassen
        ),
        centerTitle: true, // Titel mittig ausrichten
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ImagePickerWidget(onImagesSelected: handleImagesSelected),
              const SizedBox(height: 20),
              Text(
                'Titel *',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                ),
              ),
              TextFormField(
                controller: _titleController,
                cursorColor: AppColor.primarySoft,
                decoration: const InputDecoration(
                  hintText: 'z.B. Aufwärmshirt Kurzarm',
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Beschreibe deinen Artikel *',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                cursorColor: AppColor.primarySoft,
                decoration: const InputDecoration(
                  hintText: 'z.B. nur einmal getragen',
                  fillColor: Colors.black,
                ),
                maxLines: 3,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(200),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Typ',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0,
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                    _selectedSize =
                        DropdownOptions.sizeOptions[_selectedType]![0];
                  });
                },
                items: DropdownOptions.typeOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSize,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Größe',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0,
                  ),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSize = newValue!;
                  });
                },
                items:
                    DropdownOptions.sizeOptions[_selectedType]!.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
              const Divider(
                color: AppColor.border,
                height: 30,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  labelText: 'Zustand auswählen',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0,
                  ),
                ),
                items: DropdownOptions.conditionOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCondition = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedBrand,
                decoration: const InputDecoration(
                  labelText: 'Marke auswählen',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0,
                  ),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    enabled: false,
                    child: Text(
                      'Beliebtesten Marken',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ...DropdownOptions.popularBrandOptions.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }),
                  const DropdownMenuItem<String>(
                    value: null,
                    enabled: false,
                    child: Text(
                      'Weitere',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ...DropdownOptions.lessPopularBrandOptions.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _selectedBrand = newValue!;
                  });
                },
              ),
              const Divider(
                color: AppColor.border,
                height: 30,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              DropdownButtonFormField<String>(
                value: _selectedClub,
                decoration: const InputDecoration(
                  labelText: 'Verein auswählen',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0,
                  ),
                ),
                items: DropdownOptions.clubOptions
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedClub = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                focusColor: AppColor.primarySoft,
                value: _selectedSport,
                decoration: const InputDecoration(
                  labelText: 'Sportart auswählen',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0,
                  ),
                ),
                items: DropdownOptions.sportOptions
                    .map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSport = newValue!;
                  });
                },
              ),
              ListTile(
                title: const Text(
                  "Artikel unabhängig des Vereins / Sportart nutzbar",
                  style: TextStyle(fontSize: 15),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isIndividuallyWearable,
                        onChanged: (value) {
                          setState(() {
                            _isIndividuallyWearable = value;
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Individuell tragbar"),
                            content: const Text(
                                "Artikel die unabhängig des Vereins und der Sportart getragen werden können, werden allen Benutzer angezeigt."),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Schließen"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.info_outline,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Preis *',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                ),
              ),
              TextFormField(
                controller: _priceController,
                cursorColor: AppColor.primarySoft,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // Nur ganze Zahlen erlauben
                  LengthLimitingTextInputFormatter(3)
                ],
                decoration: const InputDecoration(
                  suffixText: '€',
                  hintText: 'z.B. 5',
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: () {
                  String title = _titleController.text.trim();
                  String price = _priceController.text.trim();
                  if (title.length >= 3 && price.isNotEmpty) {
                    saveArticleToFirebase(
                      title: title,
                      description: _descriptionController.text,
                      brand: _selectedBrand,
                      club: _selectedClub,
                      sport: _selectedSport,
                      price: int.parse(price),
                      isIndividuallyWearable: _isIndividuallyWearable,
                      images: selectedImages,
                      context: context,
                      condition: _selectedCondition,
                      size: _selectedSize,
                      type: _selectedType,
                      userId: user?.uid,
                    );
                  } else {
                    if (title.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Titel darf nicht leer sein'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (title.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Titel muss mindestens 3 Zeichen enthalten'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    if (price.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preis darf nicht leer sein'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                buttonText: 'Artikel einstellen',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveArticleToFirebase({
    required String title,
    required String description,
    required int price,
    required String brand,
    required String club,
    required String sport,
    required bool isIndividuallyWearable,
    required String condition,
    required String size,
    required String type,
    required List<XFile> images,
    required String? userId,
    required BuildContext context,
  }) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: CircularProgressIndicator(),
        ),
      );

      List<String> imageUrls = [];

      // Upload images to Firebase Storage
      if (images.isNotEmpty) {
        imageUrls = await uploadFiles(images);
      }

      // TODO - create Article object in /models/article.dart
      // Create a map with article data
      Map<String, dynamic> articleData = {
        'title': title,
        'description': description,
        'price': price,
        'brand': brand,
        'club': club,
        'sport': sport,
        'isIndividuallyWearable': isIndividuallyWearable,
        'condition': condition,
        'size': size,
        'type': type,
        'images': imageUrls,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'userId': userId,
        'isSold': false,
        'isReserved': false,
        'isDeleted': false,
      };

// Add the articleData to Firestore
      await FirebaseFirestore.instance.collection('articles').add(articleData);

      // Hide loading indicator
      Navigator.of(context).pop();

      // Show snackbar and navigate to home screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erfolgreich eingestellt.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const PageSwitcher(
          selectedIndex: 0,
        ),
      ));
    } catch (error) {
      // Hide loading indicator
      Navigator.of(context).pop();

      // Show snackbar for error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Etwas ist schief gelaufen.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<String>> uploadFiles(List<XFile> images) async {
    var imageUrls =
        await Future.wait(images.map((image) => uploadFile(File(image.path))));

    List<String> stringList = imageUrls.map((item) => item.toString()).toList();
    return stringList;
  }

  Future<String> uploadFile(File image) async {
    // Generate a unique filename for the image
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    String userID = user!.uid;

    // Upload the image file to Firebase Storage
    Reference storageReference =
        FirebaseStorage.instance.ref().child('users/$userID/images/$fileName');
    TaskSnapshot snapshot = await storageReference.putFile(image);

    // Get the download URL of the uploaded image
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void handleImagesSelected(List<XFile> images) {
    setState(() {
      selectedImages = images;
    });
  }
}
