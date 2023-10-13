import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImpressumPage extends StatefulWidget {
  const ImpressumPage({super.key});

  @override
  State<ImpressumPage> createState() => _ImpressumPageState();
}

class _ImpressumPageState extends State<ImpressumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Impressum',
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
