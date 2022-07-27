import 'dart:convert';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/profiles/screens/edit_profile.dart';
import 'package:flutter_application_1/utils/services/oc_shared_pref.dart';
import 'package:http/http.dart' as http; 

class ProfilesModel {
  static Future<Map> login({ required String email, required String password }) async {
    Uri _uri = Uri.http(
      'www.tadbeeke.com',
      '/app/login',
      { "type": "login" }
    );

    Map _payload = {
      "email": email,
      "password": password
    };

    http.Response _response = await http.post(_uri, body: _payload);
    var isHtml = _response.headers['content-type'].toString().contains("text/html");
    
    if(isHtml) {
      return {
        "error": true
      };
    }

    var _body = jsonDecode(_response.body);
    if(_body is Map && _body.containsKey('error') && _body['error'] == false) {
      bool _isLoggedIn = await Auth.saveUser(user: _body['user']);
      return {
        'isLoggedIn': _isLoggedIn,
        "user": _body['user']
      };
    }
    return { "error": true };
  }

  static Future<Map> register({ 
    required String email, 
    required String fullName, 
    required String phone, 
    required String password }) async {
      Uri _uri = Uri.http(
      'www.tadbeeke.com',
      '/app/login',
      { "type": "register" }
    );

    Map _payload = {
      "email": email,
      "password": password,
      "full_name": fullName,
      "phone": phone
    };

    http.Response _response = await http.post(_uri, body: _payload);
    bool isHtml = _response.headers['content-type'].toString().contains("text/html");
    
    if(isHtml) {
      print('is html');
      return {
        "error": true
      };
    }

    var _body = jsonDecode(_response.body);
    print(_body);
    if(_body is Map && _body.containsKey('error') && _body['error'] == false) {
      Map _res = await ProfilesModel.login(email: email, password: password);
      return {
        'isRegistered': true,
        'isLoggedIn': _res.containsKey('isLoggedIn') && _res['isLoggedIn'] == true,
        'user': _res.containsKey('user') ? _res['user'] : null
      };
    }
    return {"error": true};
  }

  static Future<ProfileInfo> getProfileInfo() async {
    // String? _fullName = await Preferences.get('profiles.user.full_name');
    // String? _about = await Preferences.get('profiles.user.about');
    // String? _address = await Preferences.get('profiles.user.address');

    String? _fullName;
    String? _about;
    String? _address;

    Map? _user = await Auth.user();
    if(_user is Map) {
      _fullName = _user['full_name'];
      _about = _user['about'];
      _address = _user['address'];
    }

    return ProfileInfo(
      fullName: _fullName,
      about: _about,
      address: _address
    );
  }

  static Future<Map> updateProfileInfo({ required String fullName, required String address, required String about }) async {

    int? _userId = await Auth.getUserId();

    if(_userId == null) {
      return {
        'status': 400,
        'error': 'You are not logged in'
      };
    }

    Map _payload = {
      'full_name': fullName,
      'about': about,
      'address': address,
      'user_id': _userId.toString()
    };

    Uri _uri = Uri.http(
      '157.241.12.13',
      '/app/account/profile',
      {
        'auth': 'true',
        'user_id': _userId.toString()
      }
    );

    http.Response _response = await http.post(_uri, body: _payload);
    try {
      if(_response.statusCode == 200) {
        var _body = jsonDecode(_response.body);
        if(_body is Map) {
          bool _isPrefUpdated = await Auth.updateUser(fullName: fullName, about: about, address: address);
          return {
            'success': true,
            'isPrefUpdated': _isPrefUpdated
          };
        }
      }
    } catch(e) {
      return {
        'error': true,
        'errorMessage': e.toString(),
      };
    }

    return {
      'error': true
    };
  }

  static Future<Map> updatePassword({ required String newPassword, required String oldPassword }) async {
    Preferences.set('profiles.user.password', newPassword, forceSet: true);
    int? _userId = await Auth.getUserId();

    if(_userId == null) {
      return {
        'status': 400,
        'error': 'You are not logged in'
      };
    }

    Map _payload = {
      'currentpassword': oldPassword,
      'confirmpassword': newPassword,
      'password': newPassword,
      'user_id': _userId.toString()
    };

    Uri _uri = Uri.http(
      '157.241.12.13',
      '/app/account/password',
      {
        'auth': 'true',
        'user_id': _userId.toString()
      }
    );

    http.Response _response = await http.post(_uri, body: _payload);
    try {
      if(_response.statusCode == 200) {
        var _body = jsonDecode(_response.body);
        if(_body is Map) {
          bool _isPrefUpdated = await Auth.updateUser(password: newPassword);
          print('_isPrefUpdated');
          print(_isPrefUpdated);
          return {
            'success': true
          };
        }
      }
    } catch(e) {
      return {
        'error': true,
        'errorMessage': e.toString(),
      };
    }

    return {
      'error': true
    };
  }

  static Future<String?> getEmail() async {
    String? _email = await Preferences.get('profiles.user.email');
    return _email;
  }
  
  static Future<Map> updateEmail({ required String email, required String password }) async {
    int? _userId = await Auth.getUserId();

    if(_userId == null) {
      return {
        'status': 400,
        'error': 'You are not logged in'
      };
    }

    Map? _user = await Auth.user();

    if(_user == null) {
      return {
        'status': 400,
        'error': 'You are not logged in'
      };
    }

    Map _payload = {
      'email': email,
      'mobile': _user['mobile'] ?? "",
      'password': password,
      'user_id': _userId.toString()
    };

    Uri _uri = Uri.http(
      '157.241.12.13',
      '/app/account/email',
      {
        'auth': 'true',
        'user_id': _userId.toString()
      }
    );

    http.Response _response = await http.post(_uri, body: _payload);
    try {
      if(_response.statusCode == 200) {
        var _body = jsonDecode(_response.body);
        if(_body is Map) {
          bool _isPrefUpdated = await Auth.updateUser(email: email);
          print('_isPrefUpdated');
          print(_isPrefUpdated);
          return {
            'success': true
          };
        }
      }
    } catch(e) {
      return {
        'error': true,
        'errorMessage': e.toString(),
      };
    }

    return {
      'error': true
    };
  }

  static Future<String?> getPhone() async {
    String? _phone = await Preferences.get('profiles.user.phone');
    return _phone;
  }

  static Future<Map> updatePhone({ required String phone }) async {
    int? _userId = await Auth.getUserId();

    if(_userId == null) {
      return {
        'status': 400,
        'error': 'You are not logged in'
      };
    }

    Map _payload = {
      'mobile': phone,
      'user_id': _userId.toString()
    };

    Uri _uri = Uri.http(
      '157.241.12.13',
      '/app/account/phone',
      {
        'auth': 'true',
        'user_id': _userId.toString()
      }
    );

    http.Response _response = await http.post(_uri, body: _payload);
    try {
      if(_response.statusCode == 200) {
        var _body = jsonDecode(_response.body);
        if(_body is Map) {
          bool _isPrefUpdated = await Auth.updateUser(phone: phone);
          return {
            'success': true,
            '_isPrefUpdated': _isPrefUpdated
          };
        }
      }
    } catch(e) {
      return {
        'error': true,
        'errorMessage': e.toString(),
      };
    }

    return {
      'error': true
    };
  }
}