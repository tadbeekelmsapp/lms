import 'dart:convert';

import 'package:flutter_application_1/utils/services/oc_shared_pref.dart';

class Auth {
  static makeLogin(int userId) {
    Preferences.set('auth.user.id', userId, forceSet: true, setTimeout: false);
  }

  static Future<bool> isLoggedIn() async {
    var _id = await Preferences.get('auth.user.id');
    if(_id == null) {
      return false;
    }
    if(_id is String) {
      _id = int.parse(_id);
    }
    return _id != 0;
  }

  static Future<int?> getUserId() async {
    var _id = await Preferences.get('auth.user.id');
    if(_id is String && _id.isNotEmpty) {
      return int.parse(_id);
    }
    return (_id is int ? _id : null);
  }

  static Future<bool> saveUser({ required Map user }) async {
    bool isUserSet = await Preferences.set("auth.user", jsonEncode(user), forceSet: true, setTimeout: false);
    bool isUserIdSet = await Preferences.set("auth.user.id", user['id'].toString(), forceSet: true, setTimeout: false);
    return isUserSet && isUserIdSet;
  }

  static Future<Map?> user() async { 
    String? _user = await Preferences.get("auth.user");
    if(_user is String) {
      return jsonDecode(_user);
    }
    return null;
  }

  static Future<bool> updateUser({ fullName, email, phone, about, address, password }) async {
    Map? _user = await Auth.user();
    if(_user == null) {
      return false;
    } 

    Map _fields = {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'about': about,
      'address': address,
      'password': password
    };

    _fields.keys.forEach((key) {
      if(_fields[key] != null) {
        _user[key] = _fields[key];
      }
    });

    return await Preferences.set("auth.user", jsonEncode(_user), forceSet: true);
  }
}