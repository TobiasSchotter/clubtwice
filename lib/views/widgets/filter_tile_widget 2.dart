import 'package:flutter/material.dart';
import '../../constant/app_color.dart';

class FilterWidget2 extends StatelessWidget {
  const FilterWidget2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          color: AppColor.secondary,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 40, // set the height of the first row
                child: DropdownButton<String>(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dein Verein ist fest hinterlegt!'),
                      ),
                    );
                  },
                  // icon: Icon(Icons.group),
                  iconSize: 15.0,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0.5,
                    color: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'verein1', child: Text('Verein 1')),
                    // DropdownMenuItem(child: Text('Verein 2'), value: 'verein2'),
                    // DropdownMenuItem(child: Text('Verein 3'), value: 'verein3'),
                  ],
                  onChanged: (value) {},
                  hint: const Text('Verein',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),
              ),
              const SizedBox(height: 10), // add some spacing between the rows
              SizedBox(
                height: 40, // set the height of the second row
                child: DropdownButton<String>(
                  // icon: Icon(Icons.directions_run),
                  iconSize: 15.0,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0.5,
                    color: Colors.white,
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'sportart1', child: Text('Sportart 1')),
                    DropdownMenuItem(
                        value: 'sportart2', child: Text('Sportart 2')),
                    DropdownMenuItem(
                        value: 'sportart3', child: Text('Sportart 3')),
                  ],
                  onChanged: (value) {},
                  hint: const Text('Sportart',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),
              ),
              const SizedBox(height: 10), // add some spacing between the rows
              SizedBox(
                height: 40,
                child: DropdownButton<String>(
                  // Optionen für den Typ
                  // icon: Icon(Icons.type_specimen),
                  iconSize: 15.0,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.black,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'typ1', child: Text('Kids')),
                    DropdownMenuItem(value: 'typ2', child: Text('Erwachs.')),
                    DropdownMenuItem(value: 'typ3', child: Text('Universal')),
                  ],
                  onChanged: (value) {},
                  hint: const Text('Typ',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),
              ),
              const SizedBox(height: 10), // add some spacing between the rows
              SizedBox(
                height: 40,
                child: DropdownButton<String>(
                  // icon: Icon(Icons.height_outlined),
                  iconSize: 15.0,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.black,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'größe1', child: Text('Größe 1')),
                    DropdownMenuItem(value: 'größe2', child: Text('Größe 2')),
                    DropdownMenuItem(value: 'größe3', child: Text('Größe 3')),
                  ],
                  onChanged: (value) {},
                  hint: const Text('Größe',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),
              ),
              const SizedBox(height: 10), // add some spacing between the rows
              SizedBox(
                height: 40,
                child: DropdownButton<String>(
                  // icon: Icon(Icons.label),
                  iconSize: 15.0,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.black,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'marke1', child: Text('Marke 1')),
                    DropdownMenuItem(value: 'marke2', child: Text('Marke 2')),
                    DropdownMenuItem(value: 'marke3', child: Text('Marke 3')),
                  ],
                  onChanged: (value) {},
                  hint: const Text('Marke',
                      style: TextStyle(color: AppColor.primarySoft)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
