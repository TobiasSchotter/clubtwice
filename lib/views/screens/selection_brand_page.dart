import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/services/option_service.dart';
import 'package:flutter/material.dart';

class BrandSelectionPage extends StatefulWidget {
  @override
  _BrandSelectionPageState createState() => _BrandSelectionPageState();
}

class _BrandSelectionPageState extends State<BrandSelectionPage> {
  List<String> popularBrandOptions = DropdownOptions.popularBrandOptions;
  List<String> lessPopularBrandOptions =
      DropdownOptions.lessPopularBrandOptions;

  int selectedBrandIndex = -1;
  List<String> filteredPopularBrands = [];
  List<String> filteredLessPopularBrands = [];

  @override
  void initState() {
    super.initState();
    filteredPopularBrands = popularBrandOptions;
    filteredLessPopularBrands = lessPopularBrandOptions;
  }

  void filterPopularBrands(String query) {
    setState(() {
      filteredPopularBrands = popularBrandOptions
          .where((brand) => brand.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void filterLessPopularBrands(String query) {
    setState(() {
      filteredLessPopularBrands = lessPopularBrandOptions
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) {
                  filterPopularBrands(query);
                  filterLessPopularBrands(query);
                },
                decoration: const InputDecoration(
                  labelText: 'Suche nach Marken',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            _buildBrandList("Beliebte Marken", filteredPopularBrands),
            const Divider(
              thickness: 1,
              color: AppColor.primarySoft,
            ),
            _buildBrandList("Andere Marken", filteredLessPopularBrands),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandList(String title, List<String> brands) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 12, color: AppColor.primary),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: brands.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: AppColor.primarySoft,
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                brands[index],
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
                _onBrandSelected(brands[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
