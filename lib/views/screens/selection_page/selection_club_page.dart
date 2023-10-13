import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:flutter/material.dart';

class ClubSelectionPage extends StatefulWidget {
  late String selectedClub;

  ClubSelectionPage({required this.selectedClub});

  @override
  _ClubSelectionPageState createState() => _ClubSelectionPageState();
}

class _ClubSelectionPageState extends State<ClubSelectionPage> {
  List<String> clubOptions = DropdownOptions.clubOptions;

  int selectedClubIndex = -1;
  List<String> filteredClubs = [];

  @override
  void initState() {
    super.initState();
    // Erstelle eine Kopie der ursprünglichen Liste
    filteredClubs = List<String>.from(clubOptions);

    // Wenn der ausgewählte Club ein leerer String ist, setze ihn auf "Keine Auswahl"
    if (widget.selectedClub.isEmpty) {
      widget.selectedClub = "Keine Auswahl";
    }

    // Verschiebe den ausgewählten Sport an Position 1
    filteredClubs.remove(widget.selectedClub);
    filteredClubs.insert(0, widget.selectedClub);
  }

  void filterClubs(String query) {
    setState(() {
      filteredClubs = clubOptions
          .where((club) => club.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onClubSelected(String club) {
    String selectedClub = club;

    // Überprüfen, ob "Keine Auswahl" ausgewählt wurde und einen leeren String in Firebase speichern
    if (selectedClub == "Keine Auswahl") {
      selectedClub = "";
    }

    Navigator.pop(context,
        selectedClub); // Pop mit dem ausgewählten Club (oder leerem String) als Ergebnis
  }

  @override
  void dispose() {
    // Setze die Liste zurück, wenn die Seite verlassen wird
    filteredClubs = clubOptions;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Text(
          'Sportvereine',
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
              onChanged: filterClubs,
              decoration: const InputDecoration(
                labelText: 'Suche nach Vereinen',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredClubs.length,
              separatorBuilder: (context, index) => Container(
                height: 1,
                color: AppColor.primarySoft,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredClubs[index],
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
                    _onClubSelected(
                        filteredClubs[index]); // Pass the selected sport
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
