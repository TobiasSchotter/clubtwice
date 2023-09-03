import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:flutter/material.dart';

class SizeSelectionPage extends StatefulWidget {
  final String selectedSize;

  SizeSelectionPage({required this.selectedSize});

  @override
  _SizeSelectionPageState createState() => _SizeSelectionPageState();
}

class _SizeSelectionPageState extends State<SizeSelectionPage> {
  Map<String, List<String>> sizeOptionsCloth = DropdownOptions.sizeOptionsCloth;
  Map<String, List<String>> sizeOptionsShoe = DropdownOptions.sizeOptionsShoe;

  int selectedSizeIndex = -1;
  List<String> filteredSizesCloth = [];
  List<String> filteredSizesShoe = [];

  @override
  void initState() {
    super.initState();
    filteredSizesCloth = sizeOptionsCloth[widget.selectedSize] ?? [];
    filteredSizesShoe = sizeOptionsShoe[widget.selectedSize] ?? [];
  }

  void filterSizesCloth(String query) {
    setState(() {
      filteredSizesCloth = sizeOptionsCloth[widget.selectedSize]!
          .where((size) => size.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void filterSizesShoe(String query) {
    setState(() {
      filteredSizesShoe = sizeOptionsShoe[widget.selectedSize]!
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
          'Größen',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) {
                  filterSizesCloth(query);

                  filterSizesShoe(query);
                },
                decoration: const InputDecoration(
                  labelText: 'Suche nach Größen',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            _buildSizeList("Kleidergrößen", filteredSizesCloth),
            const Divider(
              thickness: 1,
              color: AppColor.primarySoft,
            ),
            _buildSizeList("Schuhgrößen", filteredSizesShoe),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeList(String title, List<String> sizes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColor.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sizes.length,
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            color: AppColor.primarySoft,
          ),
          itemBuilder: (context, index) {
            final selectedSize = sizes[index];

            return ListTile(
              title: Text(
                selectedSize,
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
                _onSizeSelected(selectedSize);
              },
            );
          },
        ),
      ],
    );
  }
}
