import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageKey {
  static String token = "token";
}

class LocalStorageServices {
  static late SharedPreferences _prefs;
  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static setData(String key, String data) async {
    await _prefs.setString(key, data);
    await _prefs.reload();
  }

  static String getData(String key) {
    final data = _prefs.getString(key);
    return data ?? "";
  }

  static setBoolData(String key, bool data) async {
    await _prefs.setBool(key, data);
  }

  static bool getBoolData(String key) {
    final data = _prefs.getBool(key);
    return data ?? false;
  }

  static setIntData(String key, int data) async {
    await _prefs.setInt(key, data);
  }

  static int getIntData(String key) {
    final data = _prefs.getInt(key);
    return data ?? 0;
  }

  static bool iskeyexists(String key) {
    final isExist = _prefs.containsKey(key);
    return isExist;
  }

  static deleteData(String key) async {
    await _prefs.remove(key);
    await _prefs.reload();
  }
}
