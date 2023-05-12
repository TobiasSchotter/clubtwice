import 'package:flutter/material.dart';

import '../../constant/app_color.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          color: AppColor.secondary,
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 70,
                // Filteroptionen für den Verein
                child: DropdownButton<String>(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Dein Verein ist fest hinterlegt!'),
                      ),
                    );
                  },
                  icon: Icon(Icons.group),
                  iconDisabledColor: Colors.white,
                  iconEnabledColor: Colors.white,
                  iconSize: 15.0,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0.5,
                    color: Colors.white,
                  ),
                  items: [
                    DropdownMenuItem(child: Text('Verein 1'), value: 'verein1'),
                    // DropdownMenuItem(child: Text('Verein 2'), value: 'verein2'),
                    // DropdownMenuItem(child: Text('Verein 3'), value: 'verein3'),
                  ],
                  onChanged: (value) {
                    // TODO: Implementieren Sie die Filterlogik für den Verein
                  },
                  hint: Text('Verein',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),
              ),
              // Filteroptionen für die Sportart
              DropdownButton<String>(
                icon: Icon(Icons.directions_run),
                iconSize: 15.0,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 0.5,
                  color: Colors.white,
                ),
                items: [
                  DropdownMenuItem(
                      child: Text('Sportart 1'), value: 'sportart1'),
                  DropdownMenuItem(
                      child: Text('Sportart 2'), value: 'sportart2'),
                  DropdownMenuItem(
                      child: Text('Sportart 3'), value: 'sportart3'),
                ],
                onChanged: (value) {
                  // TODO: Implementieren Sie die Filterlogik für die Sportart
                },
                hint: Text('Sportart',
                    style: TextStyle(color: AppColor.primarySoft)),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: AppColor.secondary,
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 77,
                child: DropdownButton<String>(
                  icon: Icon(Icons.type_specimen),
                  iconSize: 15.0,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(child: Text('Kids'), value: 'typ1'),
                    DropdownMenuItem(child: Text('Erwachs.'), value: 'typ2'),
                    DropdownMenuItem(child: Text('Universal'), value: 'typ3'),
                  ],
                  onChanged: (value) {
                    // TODO: Implementieren Sie die Filterlogik für die Sportart
                  },
                  hint: Text('Typ',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),
              ),
              // Filteroptionen für die Größe
              DropdownButton<String>(
                icon: Icon(Icons.height_outlined),
                iconSize: 15.0,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 0,
                  color: Colors.black,
                ),
                items: [
                  DropdownMenuItem(child: Text('Größe 1'), value: 'größe1'),
                  DropdownMenuItem(child: Text('Größe 2'), value: 'größe2'),
                  DropdownMenuItem(child: Text('Größe 3'), value: 'größe3'),
                ],
                onChanged: (value) {
                  // TODO: Implementieren Sie die Filterlogik für die Größe
                },
                hint: Text('Größe',
                    style: TextStyle(color: AppColor.primarySoft)),
              ),
              // Filteroptionen für die Marke
              DropdownButton<String>(
                icon: Icon(Icons.label),
                iconSize: 15.0,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 0,
                  color: Colors.black,
                ),
                items: [
                  DropdownMenuItem(child: Text('Marke 1'), value: 'marke1'),
                  DropdownMenuItem(child: Text('Marke 2'), value: 'marke2'),
                  DropdownMenuItem(child: Text('Marke 3'), value: 'marke3'),
                ],
                onChanged: (value) {
                  // TODO: Implementieren Sie die Filterlogik für die Marke
                },
                hint: Text('Marke',
                    style: TextStyle(color: AppColor.primarySoft)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}