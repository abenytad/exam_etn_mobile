import 'dart:convert'; // Import this for jsonEncode and jsonDecode
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userData['_id']);
    await prefs.setString('user_name', userData['name']);
    await prefs.setInt('user_phoneNumber', userData['phoneNumber']);
    await prefs.setString('user_enrolledPrograms', jsonEncode(userData['enrolledPrograms']));
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('user_id');
    final name = prefs.getString('user_name');
    final phoneNumber = prefs.getInt('user_phoneNumber');
    final enrolledPrograms = jsonDecode(prefs.getString('user_enrolledPrograms') ?? '[]');

    return {
      '_id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'enrolledPrograms': enrolledPrograms,
    };
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> clearData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user_id');
  await prefs.remove('user_name');
  await prefs.remove('user_phoneNumber');
  await prefs.remove('user_enrolledPrograms');
  await prefs.remove('jwt_token');
}

}
