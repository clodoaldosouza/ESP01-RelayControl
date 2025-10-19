import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DeviceService {
  static Future<bool> toggleDevice(String ip, bool isOn) async {
    final hasProtocol = ip.startsWith('http://') || ip.startsWith('https://');
    final fullUrl = hasProtocol ? '$ip/update' : 'http://$ip/update';
    final url = Uri.parse(fullUrl);
    
    final body = jsonEncode({'relay': !isOn ? 'true' : 'false'});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        if (kDebugMode) {
          debugPrint('Error: ${response.statusCode}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Connection error: $e');
      }
      return false;
    }
  }

  static Future<bool?> getRelayStatus(String ip) async {
    final hasProtocol = ip.startsWith('http://') || ip.startsWith('https://');
    final fullUrl = hasProtocol ? '$ip/status' : 'http://$ip/status';
    final url = Uri.parse(fullUrl);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['relay'] as bool?;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to access server: $e');
      }
    }
    return null;
  }
}
