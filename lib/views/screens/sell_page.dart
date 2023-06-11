import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clubtwice/constant/app_color.dart';
import '../widgets/grid_widget.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  // final database = FirebaseDatabase.instance.reference();

  final ImagePicker _picker = ImagePicker();
  final List<File> _imageList = [];
  bool _isIndividuallyWearable = false;
  bool _isPriceValid = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _selectedSport = "Fußball";
  String _selectedClub = "SG Quelle";
  String _selectedType = "Kids";
  String _selectedSize = '140';
  String _selectedBrand = "Adidas";
  String _selectedCondition = "Neu";

  User? user = FirebaseAuth.instance.currentUser;

  final List<String> _typeOptions = ['Kids', 'Erwachsene', 'Universal'];
  final Map<String, List<String>> _sizeOptions = {
    'Erwachsene': ['S', 'M', 'L', 'XL', 'XXL'],
    'Kids': ['140', '164', '170', 'XS'],
    'Universal': ['Einheitsgröße'],
  };
  final List<String> _conditionOptions = [
    'Neu, mit Etikett',
    'Neu',
    'Sehr gut',
    'Gut',
    'Zufriedenstellend'
  ];

  final List<String> _popularBrandOptions = ['Adidas', 'Puma', 'Nike'];
  final List<String> _lessPopularBrandOptions = [
    'Asics',
    'Capelli',
    'Castore',
    'Craft',
    'Fila',
    'Hummel',
    'Jako',
    'Joma',
    'Kappa',
    'Macron',
    'Mizuno',
    'Reebok',
    'Saller',
    'Umbro',
    'Uhlsport'
  ];

  @override
  Widget build(BuildContext context) {
    // final SellRef = database.child('/Sell');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // den Zurück-Button deaktivieren
        backgroundColor: AppColor.primary,
        title: const Text('Vereinskleidung verkaufen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ImageGrid(),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 0),
                child: Text(
                  'Titel *',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                  ),
                ),
              ),
              TextFormField(
                controller: _titleController,
                cursorColor: AppColor.primarySoft,
                decoration: const InputDecoration(
                  hintText: 'z.B. Aufwärmshirt Kurzarm',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bitte geben Sie einen Titel ein';
                  } else {
                    int letterCount = 0;
                    for (int i = 0; i < value.length; i++) {
                      if (value[i].trim().isNotEmpty) {
                        letterCount++;
                      }
                    }
                    if (letterCount < 3) {
                      return 'Der Titel muss mindestens 3 Buchstaben haben';
                    }
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 0),
                child: Text(
                  'Beschreibe deinen Artikel',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                  ),
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                cursorColor: AppColor.primarySoft,
                decoration: const InputDecoration(
                    hintText: 'z.B. nur einmal getragen',
                    //labelText: 'Description',
                    fillColor: Colors.black),
                maxLines: 3,
              ),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Typ',
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                    _selectedSize = _sizeOptions[_selectedType]![0];
                  });
                },
                items: _typeOptions
                    .map((option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
              ),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                value: _selectedSize,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Größe',
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSize = newValue!;
                  });
                },
                items: _sizeOptions[_selectedType]!
                    .map((option) => DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
              ),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  decoration: const InputDecoration(
                    labelText: 'Zustand auswählen',
                    border: OutlineInputBorder(),
                  ),
                  items: _conditionOptions
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
                  }),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                value: _selectedBrand,
                decoration: const InputDecoration(
                  labelText: 'Marke auswählen',
                  border: OutlineInputBorder(),
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
                  ..._popularBrandOptions
                      .map<DropdownMenuItem<String>>((String value) {
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
                  ..._lessPopularBrandOptions
                      .map<DropdownMenuItem<String>>((String value) {
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
              Column(
                children: <Widget>[
                  Divider(
                    color: Colors.grey[400],
                    height: 30,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                  value: _selectedClub,
                  decoration: const InputDecoration(
                    labelText: 'Verein auswählen',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['SG Quelle', 'SGV Nürnberg Fürth']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedClub = newValue!;
                    });
                  }),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                  focusColor: AppColor.primarySoft,
                  value: _selectedSport,
                  decoration: const InputDecoration(
                    //contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    //border: InputBorder.none,
                    labelText: 'Sportart auswählen',

                    border: OutlineInputBorder(),
                  ),
                  items: <String>['Fußball', 'Basketball']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSport = newValue!;
                    });
                  }),
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
                  FilteringTextInputFormatter
                      .digitsOnly // Nur ganze Zahlen erlauben
                ],
                decoration: const InputDecoration(
                  suffixText: '€',
                  hintText: 'z.B. 5',
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _isPriceValid = false;
                    } else {
                      _isPriceValid = true;
                    }
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bitte geben Sie einen Preis ein';
                  }
                  return null;
                },
              ),
              Container(
                height: 16,
              ),
              ElevatedButton(
                onPressed:
                    _titleController.text.trim().length >= 3 && _isPriceValid
                        ? () {
                            // // Navigator.of(context).pop();
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => PageSwitcher(
                            //           selectedIndex: 0,
                            //         )));
                            saveArticleToFirebase(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                brand: _selectedBrand,
                                club: _selectedClub,
                                sport: _selectedSport,
                                price: double.parse(_priceController.text),
                                isIndividuallyWearable: _isIndividuallyWearable,
                                images: _imageList,
                                context: context,
                                condition: _selectedCondition,
                                size: _selectedSize,
                                type: _selectedType,
                                userId: user?.uid);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text('Erfolgreich eingestellt'),
                            //   ),
                            // );
                          }
                        : null,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: const Text('Artikel einstellen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _imageList.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage() {
    if (_imageList.isNotEmpty) {
      setState(() {
        _imageList.removeLast();
      });
    }
  }

  Future<void> saveArticleToFirebase({
    required String title,
    required String description,
    required double price,
    required String brand,
    required String club,
    required String sport,
    required bool isIndividuallyWearable,
    required String condition,
    required String size,
    required String type,
    required List<File> images,
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
        List<String> imageUrls = await uploadImagesToFirebaseStorage(images);
      }

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
        'isDeleted': false,
      };

      // Save the article data to Firestore
      await FirebaseFirestore.instance.collection('articles').add(articleData);

      // Hide loading indicator
      //Navigator.of(context).pop();

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
              )));
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
      // for debugging
      //print(error);
    }
  }

  Future<List<String>> uploadImagesToFirebaseStorage(List<File> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      try {
        // Show image upload loading indicator
        // ...

        // Generate a unique filename for the image
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // Upload the image file to Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child('images/$fileName');
        TaskSnapshot snapshot = await storageReference.putFile(image);

        // Get the download URL of the uploaded image
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);

        // Hide image upload loading indicator
      } catch (error) {
        print('Error uploading image: $error');
        // Handle image upload error
      }
    }

    return imageUrls;
  }
}
