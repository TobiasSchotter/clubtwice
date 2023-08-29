import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:flutter/material.dart';

class SizeSelectionPage extends StatefulWidget {
  final String selectedType; // Add this line

  SizeSelectionPage({required this.selectedType}); // Add this constructor

  @override
  _SizeSelectionPageState createState() => _SizeSelectionPageState();
}

class _SizeSelectionPageState extends State<SizeSelectionPage> {
  Map<String, List<String>> sizeOptions = DropdownOptions.sizeOptions;

  int selectedSizeIndex = -1;
  List<String> filteredSizes = [];

  @override
  void initState() {
    super.initState();
    filteredSizes = sizeOptions[widget.selectedType] ?? [];
  }

  void filterSizes(String query) {
    setState(() {
      // Filter based on the selected type (sizeOptions[widget.selectedType])
      filteredSizes = sizeOptions[widget.selectedType]!
          .where((size) => size.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSizeSelected(String size) {
    Navigator.pop(context, size);
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
              onChanged: filterSizes,
              decoration: const InputDecoration(
                labelText: 'Suche nach Vereinen',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredSizes.length,
              separatorBuilder: (context, index) => Container(
                height: 1,
                color: AppColor.primarySoft,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredSizes[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: selectedSizeIndex == index
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
                    _onSizeSelected(
                        filteredSizes[index]); // Pass the selected sport
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
