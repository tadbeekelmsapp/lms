import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/font_family.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/home/home.dart';
import 'package:flutter_application_1/modules/profiles/models/profiles_model.dart';
import 'package:flutter_application_1/modules/profiles/pin_code_screen.dart';
import 'package:flutter_application_1/widgets/text.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formkey = GlobalKey<FormState>();

  String? _phoneNumber;
  String? _dialCode = "+973";
  bool? _error;
  String _errorMessage = "Something went wrong!";
  bool _showOtpScreen = false;
  bool _isLoading = false;
  int? _pinCode;
  int? _userId;

  double _sigmaX = 2.0; // from 0-10
  double _sigmaY = 2.0; // from 0-10
  double _opacity = 0.5; // from 0-1.0

  bool _isRegister = false;
  bool _passwordVisible = false;
  bool _retypePasswordVisible = false;

  bool _hasSubmitted = false;
  bool _isProcessing = false;

  TextEditingController _fullNameEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _phoneEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  TextEditingController _retypePasswordEditingController = TextEditingController();

  @override 
  void initState() {
    super.initState();
    Auth.isLoggedIn().then((bool isLoggedIn) {
      if(isLoggedIn) {
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }

  Widget _singleFormField({ required String labelText, bool isPassword = false, required TextEditingController controller, bool isPhone = false }) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: (controller != _phoneEditingController) ? TextFormField(
        controller: controller,
        obscureText: isPassword && !_passwordVisible,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.only(left:15, right: 15, top: 8, bottom: 8),
          labelText: labelText,
          suffixIcon: !isPassword ? null : IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xff8E7AE1),
            ),
            onPressed: () {
              setState(() {
                if(isPassword) {
                  _passwordVisible = !_passwordVisible;
                }
               });
             },
            ),
        ),
        
        validator: (val) {
          if(val == null || val.isEmpty) {
            return "Please provide your " + labelText.toLowerCase();
          }
          if(controller == _emailEditingController && (!val.contains('@') || !val.contains('.'))) {
            return "Invalid email";
          }
          if(_isRegister && (isPassword || controller == _retypePasswordEditingController) && _passwordEditingController.text != _retypePasswordEditingController.text) {
            return "Passwords do not match";
          }
          return null;
        },
      ) : InternationalPhoneNumberInput(
            countries: const ['KW', 'SA', 'QA', 'AE', 'BH', 'OM', 'IR'],
            inputBorder: const OutlineInputBorder(),
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            inputDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left:15, right: 15, top: 8, bottom: 8),
            ),
            formatInput: false,
            validator: (val) {
              if(val == null || val.isEmpty) {
                return "Please enter your phone number";
              }
              return null;
            },
            onInputChanged: (PhoneNumber phone) {
              setState(() {
                _dialCode = phone.dialCode;
                _phoneEditingController.text = phone.parseNumber();
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formkey,
              autovalidateMode: _hasSubmitted ? AutovalidateMode.onUserInteraction : null,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          // color: _isRegister ? Color(0xff8E7AE1) : null,
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          border: _isRegister ? Border.all(color: const Color(0xff8E7AE1), width: 2) : null,
                        ),
                        child: InkWell(
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              fontFamily: FontFamily.secondary,
                              letterSpacing: 2,
                              color: !_isRegister ? Colors.grey : Colors.white,
                              fontSize: _isRegister ? 16 : 14,
                            )
                          ),
                          onTap: () {
                            setState(() {
                              _isRegister = true;
                              _error = false;
                            });
                          },
                        )
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                          border: !_isRegister ? Border.all(color: const Color(0xff8E7AE1), width: 2) : null,
                        ),
                        child: InkWell(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontFamily: FontFamily.secondary,
                              letterSpacing: 2,
                              color: _isRegister ? Colors.grey[600] : Colors.white,
                              fontSize: !_isRegister ? 16 : 14,
                            )
                          ),
                          onTap: () {
                            setState(() {
                              _isRegister = false;
                              _error = false;
                            });
                          },
                        )
                      ),
                    ]
                  ),
                  
                  if(_error == true) Text(_errorMessage, style: const TextStyle(color: Colors.red)), 
                  
                  if(_isRegister) _singleFormField(labelText: "Full Name", controller: _fullNameEditingController),
                  _singleFormField(labelText: "Email", controller: _emailEditingController),
                  if(_isRegister) _singleFormField(labelText: "Phone", controller: _phoneEditingController),
                  _singleFormField(labelText: "Password", isPassword: true, controller: _passwordEditingController),
                  if(_isRegister) _singleFormField(labelText: "Re-type Password", isPassword: true, controller: _retypePasswordEditingController),
                  
                  // const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: _isProcessing ? ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)) : null,
                      child: _isProcessing ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1, )) : Text(_isRegister ? "REGISTER" : "LOGIN", style: const TextStyle(fontSize: 15)), 
                      onPressed: _isProcessing ? null : () async {
                        setState(() {
                          _hasSubmitted = true;
                          _error = false;
                        });
                        if (_formkey.currentState!.validate()) {
                          String _email = _emailEditingController.text;
                          String _fullName = _fullNameEditingController.text;
                          String _phone = (_dialCode == null ? '+973' : _dialCode!) + _phoneEditingController.text;
                          String _password = _passwordEditingController.text;
                  
                          setState(() => _isProcessing = true);
                          Map _apiResponse = {};
                          if(_isRegister) {
                            print('user want to register');
                            _apiResponse = await ProfilesModel.register(email: _email, fullName: _fullName, phone: _phone, password: _password);
                          } else {
                            print('user want to login');
                            _apiResponse = await ProfilesModel.login(email: _email, password: _password);
                          }
                          print(_apiResponse);
                          setState(() => _isProcessing = false);
                          
                          if(_apiResponse.containsKey('error')) {
                            setState(() => _error = true);
                            
                            if(!_isRegister) {
                              setState(() => _errorMessage = 'You need to register first!');
                            }
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                          }
                        }
                      }, 
                    )
                  ),
                ],
              ),  
          ),
        ),
      )
    );
  }
}