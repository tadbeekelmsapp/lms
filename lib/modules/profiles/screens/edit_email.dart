import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/drawer/drawer.dart';
import 'package:flutter_application_1/modules/profiles/models/profiles_model.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({ Key? key }) : super(key: key);

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override 
  void initState() {
    super.initState();
    Auth.user().then((Map? user) {
      if(user is Map) {
        setState(() {
          _emailController.text = user['email'];
        });
      }
    });
  }

  @override 
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'EMAIL'),
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
                    controller: _emailController,
                    decoration: const InputDecoration(
                      label: Text('Email'),
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
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),
                    obscureText: true,
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
                        Map _res = await ProfilesModel.updateEmail(email: _emailController.text, password: _passwordController.text);
                        if(_res.containsKey('success') && _res['success'] == true) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Email updated!', style: TextStyle(color: Colors.white)),
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