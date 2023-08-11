import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:flutter/material.dart';

class ClubSelectionPage extends StatefulWidget {
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
    filteredClubs = clubOptions;
  }

  void filterClubs(String query) {
    setState(() {
      filteredClubs = clubOptions
          .where((club) => club.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onClubSelected(String club) {
    Navigator.pop(context, club); // Pop with the selected sport as a result
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
                labelText: 'Suche nach Sportarten',
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
                  trailing: selectedClubIndex == index
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
