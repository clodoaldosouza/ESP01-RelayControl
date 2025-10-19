import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_ip', ip);
  }

  static Future<String?> loadIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('device_ip');
  }
}
