import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/drawer/drawer.dart';
import 'package:flutter_application_1/modules/profiles/models/profiles_model.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class ProfileInfo {
  const ProfileInfo({
    this.fullName,
    this.about,
    this.address
  });

  final String? fullName;
  final String? address;
  final String? about;
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({ Key? key }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  @override 
  void initState() {
    super.initState();
    ProfilesModel.getProfileInfo().then((_info) {
      setState(() {
        _fullNameController.text = _info.fullName == null ? '' : _info.fullName!;
        _addressController.text = _info.address == null ? '' : _info.address!;
        _aboutController.text = _info.about == null ? '' : _info.about!;
      });
    });
  }

  @override 
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _aboutController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'PROFILE'),
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
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      label: Text('Full Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 100.0,
                    ),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        label: Text('Address'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 300.0,
                    ),
                    child: TextFormField(
                      controller: _aboutController,
                      decoration: const InputDecoration(
                        label: Text('About'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                      minLines: 2,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please tell us something about yourself';
                        }
                        return null;
                      },
                    ),
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
                        Map _res = await ProfilesModel.updateProfileInfo(fullName: _fullNameController.text, address: _addressController.text, about: _aboutController.text);
                        if(_res.containsKey('success') && _res['success'] == true) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Profile updated!', style: TextStyle(color: Colors.white)),
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