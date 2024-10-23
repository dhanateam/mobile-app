import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save token (phone number) to shared preferences
  static Future<void> setLogin(String token) async {
    await _preferences?.setString('token', token);
  }

  // Get the stored token (returns null if not found)
  static String? getLogin() {
    return _preferences?.getString('token');
  }

  // Remove the token from shared preferences (for logout)
  static Future<void> removeLogin() async {
    await _preferences?.remove('token');
  }
}
