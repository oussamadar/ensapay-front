import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    SharedPreferences  prefs = await SharedPreferences.getInstance().catchError((e){print("shared prefs: $e");});
    return json.decode(prefs.getString(key));
  }

  save(String key, value) async {
    SharedPreferences  prefs = await SharedPreferences.getInstance().catchError((e){print("shared prefs: $e");});
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    SharedPreferences  prefs = await SharedPreferences.getInstance().catchError((e){print("shared prefs: $e");});
    prefs.remove(key);
  }
  clear()async{
    SharedPreferences  prefs = await SharedPreferences.getInstance().catchError((e){print("shared prefs: $e");});
    prefs.clear();
    // ignore: deprecated_member_use
    prefs.commit();
  }
}