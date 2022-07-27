import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Preferences {
  // @param String key
  // @param value Any type of value is acceptable
  // @param timeout Number of hours (default: 1)
  // @param forceSet Whether to force set pref irrespective of its timeout has passed or not. (default: true)
  static Future<bool> set(String key, value, {
    bool forceSet = false, 
    bool setTimeout = true, 
    double timeout = 1
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // set only if its timeout hasn't been passed yet
    bool _canSet = true;
    if (prefs.containsKey(key) && !forceSet) {
      var _item = json.decode(prefs.get(key) as String);
      if (_item is Map && _item.containsKey('_timeout') && _item['_timeout'] > DateTime.now().millisecondsSinceEpoch) {
        _canSet = false;
      }
    }

    if (forceSet == true) {
      _canSet = true;
    }

    if (_canSet) {
      Map obj = {"value": value};
      if (setTimeout) {
        obj["_timeout"] = DateTime.now().millisecondsSinceEpoch + (timeout * 3600000);
      }
      return await prefs.setString(key, json.encode(obj));
    }

    return false;
  }

  static get(String key, [bool inTime = false]) async {
    final _prefs = await SharedPreferences.getInstance();
    var res = _prefs.get(key);
    try {
      if (res is String) {
        res = json.decode(res);
      }
    } on FormatException catch (_) {}

    if (inTime && res is Map) {
      var resTimeout = res['_timeout'];
      var currentTimeout = DateTime.now().millisecondsSinceEpoch;
      if (resTimeout != null && resTimeout > currentTimeout) {
        return res['value'];
      }

      if (resTimeout != null && resTimeout < currentTimeout) {
        Preferences.remove(key);
        return null;
      }
    }

    return (res is Map ? res['value'] : null);
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  static getAllPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var keys = prefs.getKeys().toList();
    return keys;
  }

  static has(String key, [bool checkInTime = false]) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.containsKey(key);
    var _res = await Preferences.get(key, checkInTime);
    return _res != null;
  }

  // alias function for has
  static contains(String key) async {
    return Preferences.has(key);
  }
}
