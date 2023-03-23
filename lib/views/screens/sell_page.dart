import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clubtwice/constant/app_color.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final ImagePicker _picker = ImagePicker();
  List<File> _imageList = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String selectedSport = "Fußball";
  String selectedClub = "SG Quelle";
  String selectedSize = "Einheitsgröße";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _pickImage();
                      },
                      child: Text('Foto hinzufügen'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 18),
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _removeImage();
                      },
                      child: Text('Foto entfernen'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 18),
                        backgroundColor: AppColor.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
              Container(height: 16.0),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _imageList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Image.file(
                    _imageList[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 0),
                child: Text(
                  'Titel',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                  ),
                ),
              ),
              TextFormField(
                  controller: _titleController,
                  cursorColor: AppColor.primarySoft,
                  decoration: const InputDecoration(
                    //icon: Icon(Icons.sell),
                    hintText: 'z.B. Aufwärmshirt Kurzarm',
                  )),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 0),
                child: Text(
                  'Beschreibung',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                  ),
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                cursorColor: AppColor.primarySoft,
                decoration: InputDecoration(
                    //labelText: 'Description',
                    ),
                maxLines: 5,
              ),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                  value: selectedSize,
                  decoration: InputDecoration(
                    labelText: 'Größe auswählen',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>[
                    'Einheitsgröße',
                    '116',
                    '128',
                    '116',
                    '128',
                    '146',
                    '164',
                    '170',
                    'S',
                    'M',
                    'L',
                    'XL',
                    'XXL',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedSize = newValue!;
                    });
                  }),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                  value: selectedClub,
                  decoration: InputDecoration(
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
                      selectedClub = newValue!;
                    });
                  }),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                  focusColor: AppColor.primarySoft,
                  value: selectedSport,
                  decoration: InputDecoration(
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
                      selectedSport = newValue!;
                    });
                  }),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 0),
                child: Text(
                  'Preis',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                  ),
                ),
              ),
              TextFormField(
                controller: _priceController,
                cursorColor: AppColor.primarySoft,
                decoration: InputDecoration(
                  hintText: 'z.B. 5 Euro',
                ),
                keyboardType: TextInputType.number,
              ),
              Container(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Implement logic to submit the item for sale
                },
                child: Text('Einstellen'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
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
}
