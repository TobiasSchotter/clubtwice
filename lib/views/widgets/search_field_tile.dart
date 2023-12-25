import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchField extends StatelessWidget {
  final Function(String) onSubmitted;
  final String hintText;

  const SearchField(
      {Key? key, required this.onSubmitted, required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(2.5),
        child: TextField(
          onSubmitted: onSubmitted,
          autofocus: false,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
          decoration: InputDecoration(
            hintStyle:
                TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
            hintText: hintText,
            prefixIcon: Icon(Icons.search_outlined,
                color: Colors.white.withOpacity(0.5)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
          inputFormatters: [
            LengthLimitingTextInputFormatter(40),
          ],
        ),
      ),
    );
  }
}
