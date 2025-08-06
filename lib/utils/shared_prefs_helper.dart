
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static Future<String?> getPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone_number');
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phone_number');
    await prefs.remove('isLoggedIn');
  }
}