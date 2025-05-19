import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  Future<Map<String, String?>> getUserInfoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('user_id'),
      'name': prefs.getString('user_name'),
      'email': prefs.getString('user_email'),
      'phone': prefs.getString('user_phone'),
    };
  }
}
