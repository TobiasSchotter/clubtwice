import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/constant/app_button.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:clubtwice/views/screens/selection_page/selection_brand_page.dart';
import 'package:clubtwice/views/screens/selection_page/selection_club_page.dart';
import 'package:clubtwice/views/screens/selection_page/selection_size_page.dart';
import 'package:clubtwice/views/screens/selection_page/selection_sport_page.dart';
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
import 'package:flutter_image_compress/flutter_image_compress.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  // final database = FirebaseDatabase.instance.reference();

  List<XFile> selectedImages = [];
  bool _isIndividuallyWearable = false;
  bool isVerschenkenChecked = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _selectedSport = "";
  String _selectedClub = "";
  String _selectedType = "Kids";
  String _selectedSize = '152';
  String _selectedBrand = "";
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
    String? userId = userService.getCurrentUserId();
    userModel = await userService.fetchUserData(userId);
    setState(() {
      _selectedClub = userModel!.club;
      _selectedSport = userModel!.sport;
    });
  }

  Widget _buildSportSelection(BuildContext context) {
    String? displaySport =
        _selectedSport.isEmpty ? 'Keine Auswahl' : _selectedSport;
    return GestureDetector(
      onTap: () async {
        final selectedSport = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => SportSelectionPage(
              selectedSport: _selectedSport, // Pass the selected sport
            ),
          ),
        );

        if (selectedSport != null) {
          setState(() {
            _selectedSport = selectedSport;
          });
          displaySport = (_selectedSport.isEmpty ? 'Keine Auswahl' : sport)
              as String?; // Aktualisiere die Anzeige des Sports
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        height: 54,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '  Sport wählen',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  displaySport,
                  style: const TextStyle(fontSize: 16, color: AppColor.primary),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_right, color: AppColor.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubSelection(BuildContext context) {
    String? displayClub =
        _selectedClub.isEmpty ? 'Keine Auswahl' : _selectedClub;
    return GestureDetector(
      onTap: () async {
        final selectedClub = await Navigator.push<String>(
          context,
          MaterialPageRoute(
              builder: (context) => ClubSelectionPage(
                    selectedClub: _selectedClub,
                  )),
        );

        if (selectedClub != null) {
          setState(() {
            _selectedClub = selectedClub;
          });

          displayClub = (_selectedClub.isEmpty ? 'Keine Auswahl' : club)
              as String?; // Aktualisiere die Anzeige des Clubs
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        height: 54,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '  Verein wählen',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  displayClub,
                  style: const TextStyle(fontSize: 16, color: AppColor.primary),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_right, color: AppColor.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeSelection(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedSize = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SizeSelectionPage(selectedSize: _selectedType),
          ),
        );

        print('Selected Size: $selectedSize');
        print('Selected Size: $_selectedType');
        print('Selected Size: $_selectedSize');

        if (selectedSize != null) {
          setState(() {
            _selectedSize = selectedSize;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        height: 54,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '  Größe wählen',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  _selectedSize,
                  style: const TextStyle(fontSize: 16, color: AppColor.primary),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_right, color: AppColor.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandSelection(BuildContext context) {
    String displayBrand =
        _selectedBrand.isEmpty ? 'Keine Auswahl' : _selectedBrand;

    return GestureDetector(
      onTap: () async {
        final selectedBrand = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => BrandSelectionPage(
              selectedBrand: _selectedBrand.isEmpty ? '' : _selectedBrand,
            ),
          ),
        );

        if (selectedBrand != null) {
          // Nur aktualisieren, wenn eine Auswahl getroffen wurde
          if (selectedBrand.isNotEmpty) {
            setState(() {
              _selectedBrand = selectedBrand;
              displayBrand = _selectedBrand;
            });
          } else {
            setState(() {
              _selectedBrand = ''; // Leerstring setzen
              displayBrand = 'Keine Auswahl';
            });
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        height: 54,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '  Marke wählen',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  displayBrand,
                  style: const TextStyle(fontSize: 16, color: AppColor.primary),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_right, color: AppColor.primary),
              ],
            ),
          ],
        ),
      ),
    );
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
              const SizedBox(height: 16),
              Text(
                'Beschreibe deinen Artikel',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey), // Add a border to the TextFormField
                  borderRadius: BorderRadius.circular(
                      8), // Add rounded corners to the TextFormField
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  cursorColor: AppColor.primarySoft,
                  decoration: const InputDecoration(
                    hintText: 'z.B. nur einmal getragen',
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10), // Adjust padding for the TextFormField
                    border: InputBorder
                        .none, // Hide the default border of the TextFormField
                  ),
                  maxLines: 3,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(300),
                  ],
                ),
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
                        DropdownOptions.sizeOptionsCloth[_selectedType]![0];
                  });
                },
                items: DropdownOptions.typeOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _buildSizeSelection(context),
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
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCondition = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildBrandSelection(context),
              const Divider(
                color: AppColor.border,
                height: 30,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              _buildClubSelection(context),
              const SizedBox(height: 12),
              _buildSportSelection(context),
              ListTile(
                title: const Text(
                  "Artikel unabhängig nutzbar",
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
                'Preis*',
                style: TextStyle(
                  color: AppColor.secondary.withOpacity(0.7),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3)
                      ],
                      decoration: const InputDecoration(
                        suffixText: '€',
                        hintText: 'z.B. 5',
                      ),
                      enabled: !isVerschenkenChecked,
                    ),
                  ),
                  Checkbox(
                    value: isVerschenkenChecked,
                    onChanged: (newValue) {
                      assert(newValue != null);
                      setState(() {
                        isVerschenkenChecked = newValue!;
                        if (isVerschenkenChecked) {
                          _priceController.text = '0';
                        } else {
                          _priceController.text =
                              ''; // Setze den Preiswert auf einen leeren String.
                        }
                      });
                    },
                  ),
                  const Text('Zu verschenken'),
                ],
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

  // Future<String> uploadFileWithCompression(File image) async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   String userID = user!.uid;

  //   // Compress the image
  //   final result = await FlutterImageCompress.compressAndGetFile(
  //     image.path, // Use the File object
  //     image.path,
  //     quality: 75, // Adjust the quality as needed
  //   );

  //   // Upload the compressed image to Firebase Storage
  //   Reference storageReference =
  //       FirebaseStorage.instance.ref().child('users/$userID/images/$fileName');
  //   TaskSnapshot snapshot = await storageReference.putFile(result as File);

  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  void handleImagesSelected(List<XFile> images) {
    setState(() {
      selectedImages = images;
    });
  }
}
