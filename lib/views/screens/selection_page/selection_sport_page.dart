import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:flutter/material.dart';

class SportSelectionPage extends StatefulWidget {
  late String selectedSport;

  SportSelectionPage({required this.selectedSport});

  @override
  _SportSelectionPageState createState() => _SportSelectionPageState();
}

class _SportSelectionPageState extends State<SportSelectionPage> {
  List<String> sportOptions = DropdownOptions.sportOptions;
  List<String> filteredSports = [];

  @override
  void initState() {
    super.initState();
    // Erstelle eine Kopie der ursprünglichen Liste
    filteredSports = List<String>.from(sportOptions);

// Wenn der ausgewählte Club ein leerer String ist, setze ihn auf "Keine Auswahl"
    if (widget.selectedSport.isEmpty) {
      widget.selectedSport = "Keine Auswahl";
    }

    // Verschiebe den ausgewählten Sport an Position 1
    filteredSports.remove(widget.selectedSport);
    filteredSports.insert(0, widget.selectedSport);
  }

  void filterSports(String query) {
    setState(() {
      filteredSports = sportOptions
          .where((sport) => sport.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSportSelected(String sport) {
    String selectedSport = sport;
    // Überprüfen, ob "Keine Auswahl" ausgewählt wurde und einen leeren String in Firebase speichern
    if (selectedSport == "Keine Auswahl") {
      selectedSport = "";
    }
    Navigator.pop(context,
        selectedSport); // Pop mit dem ausgewählten Sport (oder leerem String) als Ergebnis
  }

  @override
  void dispose() {
    // Setze die Liste zurück, wenn die Seite verlassen wird
    filteredSports = sportOptions;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Text(
          'Sportarten',
          style: TextStyle(fontSize: 15),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterSports,
              decoration: const InputDecoration(
                labelText: 'Suche nach Sportarten',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredSports.length,
              separatorBuilder: (context, index) => Container(
                height: 1,
                color: AppColor.primarySoft,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredSports[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: index == 0
                      ? const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.check,
                            color: AppColor.primary,
                          ),
                        )
                      : null,
                  onTap: () {
                    _onSportSelected(filteredSports[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
