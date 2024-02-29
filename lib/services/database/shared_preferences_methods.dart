import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMethods {
  Future<bool> setUrl(String key, String value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString(key, value);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getUrl(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? result = prefs.getString(key);

      if (result == null || result.isEmpty) return null;

      return result;
    } catch (_) {
      return null;
    }
  }
}
