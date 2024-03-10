import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _prefs;

  SharedPreferencesService._();

  factory SharedPreferencesService() {
    if (_instance == null) {
      throw Exception("SharedPreferencesService must be initialized.");
    }
    return _instance!;
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _instance = SharedPreferencesService._();
  }

  SharedPreferences get prefs => _prefs;

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }
}
