import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/drawer/drawer.dart';
import 'package:flutter_application_1/modules/profiles/models/profiles_model.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({ Key? key }) : super(key: key);

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _retypeNewPasswordController = TextEditingController();

  @override 
  void initState() {
    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _retypeNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'PASSWORD'),
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
                    controller: _currentPasswordController,
                    decoration: const InputDecoration(
                      label: Text('Current Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty!';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(
                      label: Text('New Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty!';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    controller: _retypeNewPasswordController,
                    decoration: const InputDecoration(
                      label: Text('Re-type New Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty!';
                      }
                      if(value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Processing ..', style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.blueGrey,
                          ),
                        );
                        Map _res = await ProfilesModel.updatePassword(newPassword: _newPasswordController.text, oldPassword: _currentPasswordController.text);
                        if(_res.containsKey('success') && _res['success'] == true) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Password updated!', style: TextStyle(color: Colors.white)),
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