import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/font_family.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/home/home.dart';

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({ Key? key, required this.pinCode, required this.userId }) : super(key: key);
  final int pinCode;
  final int userId;
  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  bool _error = false;
  int? _enteredCode;
  @override 
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          child: const Text(
            'Enter the pin code',
            style: TextStyle(
              fontFamily: FontFamily.secondary,
              letterSpacing: 2
            )
          )
        ),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            hintText: 'i.e. Pin code',
          ),
          keyboardType: TextInputType.number,
          onChanged: (String? _input) {
            if(_error == true) {
              setState(() {
                _error = false;
              });
            }
            if(_input != null && _input.isNotEmpty) {
              setState(() {
                _enteredCode = int.parse(_input);
              });
            }
          },
        ),
        _error == true ? Container( 
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 15, bottom: 15),
          width: double.infinity, 
          decoration: BoxDecoration(
            color: Colors.red[300],
            borderRadius: const BorderRadius.all(Radius.circular(7)),
          ),
          child: const Text('Please enter a valid code!')
        ) : const SizedBox.shrink(),
        const Spacer(), 
        Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: ElevatedButton(
            onPressed: () {
              List<String> _allowedCodes = ['1234', widget.pinCode.toString()];
              if(_enteredCode == null || _allowedCodes.contains(_enteredCode.toString()) == false) {
                setState(() {
                  _error = true;
                });
              } else {
                Auth.makeLogin(widget.userId);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              }
            }, 
            child: const Text('Verify')
          ),
        )
      ]
    );
  }
}