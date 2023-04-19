import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatefulWidget {
  final VoidCallback onConfirm;

  const DeleteAccountDialog({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  _DeleteAccountDialogState createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Konto löschen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Möchtest du dein Konto wirklich löschen?'),
          CheckboxListTile(
            title: Text('Ja, ich bestätige die Löschung meines Kontos.'),
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            if (_isChecked) {
              Navigator.of(context).pop();
              widget.onConfirm();
            }
          },
          child: Text('Löschen'),
        ),
      ],
    );
  }
}
