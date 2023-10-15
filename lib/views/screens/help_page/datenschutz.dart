import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DatenschutzPage extends StatefulWidget {
  const DatenschutzPage({super.key});

  @override
  State<DatenschutzPage> createState() => _DatenschutzPageState();
}

class _DatenschutzPageState extends State<DatenschutzPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Datenschutzhinweise',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.black,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}
