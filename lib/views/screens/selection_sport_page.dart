import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:flutter/material.dart';

class SportSelectionPage extends StatefulWidget {
  @override
  _SportSelectionPageState createState() => _SportSelectionPageState();
}

class _SportSelectionPageState extends State<SportSelectionPage> {
  List<String> sportOptions = DropdownOptions.sportOptions;

  int selectedSportIndex = -1;
  List<String> filteredSports = [];

  @override
  void initState() {
    super.initState();
    filteredSports = sportOptions;
  }

  void filterSports(String query) {
    setState(() {
      filteredSports = sportOptions
          .where((sport) => sport.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSportSelected(String sport) {
    Navigator.pop(context, sport); // Pop with the selected sport as a result
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
                  trailing: selectedSportIndex == index
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
                    _onSportSelected(
                        filteredSports[index]); // Pass the selected sport
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
