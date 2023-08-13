import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:flutter/material.dart';

class BrandSelectionPage extends StatefulWidget {
  @override
  _BrandSelectionPageState createState() => _BrandSelectionPageState();
}

class _BrandSelectionPageState extends State<BrandSelectionPage> {
  List<String> brandOptions = DropdownOptions.popularBrandOptions +
      DropdownOptions.lessPopularBrandOptions;

  int selectedBrandIndex = -1;
  List<String> filteredBrands = [];

  @override
  void initState() {
    super.initState();
    filteredBrands = brandOptions;
  }

  void filterBrands(String query) {
    setState(() {
      filteredBrands = brandOptions
          .where((brand) => brand.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onBrandSelected(String brand) {
    Navigator.pop(context, brand);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: const Text(
          'Marken',
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
              onChanged: filterBrands,
              decoration: const InputDecoration(
                labelText: 'Suche nach Marken',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredBrands.length,
              separatorBuilder: (context, index) => Container(
                height: 1,
                color: AppColor.primarySoft,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredBrands[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: selectedBrandIndex == index
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
                    _onBrandSelected(filteredBrands[index]);
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
