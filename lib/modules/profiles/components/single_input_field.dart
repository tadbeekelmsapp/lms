import 'package:flutter/material.dart';

class SingleInputField extends StatefulWidget {
  const SingleInputField({ required this.key, required this.labelText }) : super(key: key);

  final String labelText;
  final Key key;

  @override
  State<SingleInputField> createState() => _SingleInputFieldState();
}

class _SingleInputFieldState extends State<SingleInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        key: widget.key,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: widget.labelText,
        ),
        onFieldSubmitted: (_str) {
          print('onFieldSubmitted');
          print(_str);
        },
        onSaved: (_str) {
          print('onSaved');
          print(_str);
        },
      )
    );
  }
}