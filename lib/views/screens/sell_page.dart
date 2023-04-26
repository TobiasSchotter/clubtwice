import 'dart:io';
import 'package:clubtwice/views/screens/page_switcher.dart';
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
  bool _isIndividuallyWearable = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String selectedSport = "Fußball";
  String selectedClub = "SG Quelle";
  String _selectedType = "Kids";
  String _selectedSize = '170';
  String SelectedBrand = "Adidas";
  String selectedCondition = "Neu";

  final List<String> _typeOptions = ['Kids', 'Erwachsene', 'Universal'];
  final Map<String, List<String>> _sizeOptions = {
    'Erwachsene': ['S', 'M', 'L', 'XL', 'XXL'],
    'Kids': ['140', '164', '170', 'XS'],
    'Universal': ['Einheitsgröße'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // den Zurück-Button deaktivieren
        backgroundColor: AppColor.primary,
        title: Text('Vereinskleidung verkaufen'),
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
                      child: Text('Foto hochladen'),
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
              Container(
                color: AppColor.primarySoft,
                child: GridView.builder(
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
                  'Beschreibe deinen Artikel',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                  ),
                ),
              ),
              Container(
                // color: AppColor.primarySoft,
                child: TextFormField(
                  controller: _descriptionController,
                  cursorColor: AppColor.primarySoft,
                  decoration: InputDecoration(
                      hintText: 'z.B. nur einmal getragen',
                      //labelText: 'Description',
                      fillColor: Colors.black),
                  maxLines: 3,
                ),
              ),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
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
                decoration: InputDecoration(
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
                  value: selectedCondition,
                  decoration: InputDecoration(
                    labelText: 'Zustand auswählen',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['Neu', 'Sehr gut', 'Gut', 'Müll']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCondition = newValue!;
                    });
                  }),
              Container(
                height: 16,
              ),
              DropdownButtonFormField<String>(
                  value: SelectedBrand,
                  decoration: InputDecoration(
                    labelText: 'Marke auswählen',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['Adidas', 'Puma', 'Nike']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      SelectedBrand = newValue!;
                    });
                  }),
              Container(
                child: Column(
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
              ListTile(
                title: Text(
                  "Kann auch individuell getragen werden",
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Transform.scale(
                  scale:
                      0.8, // Hier können Sie den Wert anpassen, um die Größe zu ändern
                  child: Switch(
                    value: _isIndividuallyWearable,
                    onChanged: (value) {
                      setState(() {
                        _isIndividuallyWearable = value;
                      });
                    },
                  ),
                ),
              ),
              Container(
                //margin: EdgeInsets.only(top: 20, bottom: 0),
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixText: '€',
                  hintText: 'z.B. 5',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bitte geben Sie einen Preis ein';
                  } else if (double.tryParse(value) == null) {
                    return 'Bitte geben Sie eine gültige Zahl ein';
                  }
                  return null;
                },
              ),
              Container(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PageSwitcher(
                            selectedIndex: 0,
                          )));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erfolgreich eingestellt'),
                    ),
                  );
                },
                child: Text('Artikel einstellen'),
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
