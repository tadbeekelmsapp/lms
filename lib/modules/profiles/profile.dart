import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/drawer/drawer.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ Key? key, this.actionType = 'profiles' }) : super(key: key);

  final String actionType;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool _isLoading = true;
  int? _userId;

  @override 
  void initState() {
    super.initState();
    Auth.getUserId().then((id) {
      setState(() {
        _isLoading = false;
      });
      if(id != null) {
        setState(() {
          _userId = id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String _url = "http://www.tadbeeke.com/app/account/";
    switch(widget.actionType) {
      case "phone":
        _url += "phone";
      break;
      case "email":
        _url += "email";
      break;
      case "password":
        _url += "password";
      break;
      case "profiles":
      default: 
        _url += "profile";
      break;
    }
    _url += "?auth=true";
    Widget _active = const Center(child: CircularProgressIndicator());
    if(_isLoading) {
      _active = const Center(child: CircularProgressIndicator());
    } else if(!_isLoading && _userId == null) {
      _active = const Center(child: Text('User not found!'));
    } else {
      print(_url + "&uuid=" + _userId.toString());
      _active = InAppWebView(
        onLoadHttpError: (controller, url, statusCode, description) {
          print('description....');
          print(description);
        },
        initialUrlRequest: URLRequest(url: Uri.parse(_url + "&uuid=" + _userId.toString())),
        initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true,
          ),
        ),
      );
    }
    return Scaffold(
      drawer: AppDrawer(),
      appBar: appBar(title: widget.actionType.toString().toUpperCase()),
      body: _active
    );
  }
}