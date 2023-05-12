import 'dart:io';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:flutter/material.dart';
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
  List<File> _imageList = [];
  bool _isIndividuallyWearable = false;
  bool _isPriceValid = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String selectedSport = "Fußball";
  String selectedClub = "SG Quelle";
  String _selectedType = "Kids";
  String _selectedSize = '140';
  String SelectedBrand = "Adidas";
  String selectedCondition = "Neu";

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
        title: Text('Vereinskleidung verkaufen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ImageGrid(),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 0),
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
                  items: _conditionOptions
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
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      'Beliebtesten Marken',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                    enabled: false,
                  ),
                  ..._popularBrandOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }),
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      'Weitere',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                    enabled: false,
                  ),
                  ..._lessPopularBrandOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }),
                ],
                onChanged: (newValue) {
                  setState(() {
                    SelectedBrand = newValue!;
                  });
                },
              ),
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
                            title: Text("Individuell tragbar"),
                            content: Text(
                                "Artikel die unabhängig des Vereins und der Sportart getragen werden können, werden allen Benutzer angezeigt."),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Schließen"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Icon(
                        Icons.info_outline,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //margin: EdgeInsets.only(top: 20, bottom: 0),
                child: Text(
                  'Preis *',
                  style: TextStyle(
                    color: AppColor.secondary.withOpacity(0.7),
                  ),
                ),
              ),
              TextFormField(
                controller: _priceController,
                cursorColor: AppColor.primarySoft,
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                decoration: InputDecoration(
                  suffixText: '€',
                  hintText: 'z.B. 5,50',
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _isPriceValid = false;
                    } else if (double.tryParse(value.replaceAll(',', '.')) ==
                        null) {
                      _isPriceValid = false;
                    } else {
                      _isPriceValid = true;
                    }
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Bitte geben Sie einen Preis ein';
                  } else if (double.tryParse(value.replaceAll(',', '.')) ==
                      null) {
                    return 'Bitte geben Sie eine gültige Zahl ein';
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
                          }
                        : null,
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
