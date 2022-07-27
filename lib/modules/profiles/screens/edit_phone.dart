import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/drawer/drawer.dart';
import 'package:flutter_application_1/modules/profiles/models/profiles_model.dart';
import 'package:flutter_application_1/utils/services/oc_shared_pref.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class EditPhoneScreen extends StatefulWidget {
  const EditPhoneScreen({ Key? key }) : super(key: key);

  @override
  State<EditPhoneScreen> createState() => _EditPhoneScreenState();
}

class _EditPhoneScreenState extends State<EditPhoneScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();

  @override 
  void initState() {
    super.initState();
    Auth.user().then((Map? user) {
      if(user is Map && user['mobile'].toString().isNotEmpty) {
        _phoneController.text = user['mobile'];
      }
    });
  }

  @override 
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'PHONE'),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      label: Text('Phone Number')
                    ),
                    validator: (phone) {
                      if(phone == null || phone.toString().length < 7) {
                        return 'Please enter a valid phone number';
                      }
                      print('valid phone');
                      return null;
                    },
                  ),
                ),
                
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('UPDATE'),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        print(_phoneController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Processing ..', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.blueGrey,
                          ),
                        );
                        Map _res = await ProfilesModel.updatePhone(phone: _phoneController.text);
                        print(_res);
                        if(_res.containsKey('success') && _res['success'] == true) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Phone updated!', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.green.shade700,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error updating! Please try later', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red.shade200,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }

                      }
                    },
                  )
                )
              ]
            ),
          )
        ),
      )
    );
  }
}