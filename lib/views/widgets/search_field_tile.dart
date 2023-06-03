import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final Function(String) onSubmitted;

  const SearchField({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      autofocus: false,
      style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
      decoration: InputDecoration(
        hintStyle:
            TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
        hintText: 'Suche nach Vereinskleidung aller Vereine',
        prefixIcon: Container(
          padding: const EdgeInsets.all(10),
          child:
              Icon(Icons.search_outlined, color: Colors.white.withOpacity(0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        fillColor: Colors.white.withOpacity(0.1),
        filled: true,
      ),
    );
  }
}
