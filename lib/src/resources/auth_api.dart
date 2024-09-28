import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pics/src/models/user_model.dart';
import 'package:pics/src/services/shared_data.dart';

class AuthApiProvider {
  final String ipaddres = '10.154.35.15';

  Future<UserModel> login(int phoneNumber, String password) async {
    final url = Uri.parse('http://$ipaddres:5000/auth/login');
    final body = jsonEncode({
      'phoneNumber': phoneNumber,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        final cookies = response.headers['set-cookie'];
        String jwtToken = '';
        if (cookies != null) {
          final match = RegExp(r'jwt_token=([^;]+)').firstMatch(cookies);
          if (match != null) {
            jwtToken = match.group(1) ?? '';
          }
        }


        await PreferencesService.saveUserData(jsonResponse);
        await PreferencesService.saveToken(jwtToken);
        print(UserModel.fromApi(jsonResponse).name);
        return UserModel.fromApi(jsonResponse);
      } else {
       final errorMessage = jsonDecode(response.body)['error'];
      throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    final response =
        await http.get(Uri.parse('http://$ipaddres:5000/auth/logout'));

    if (response.statusCode == 200) {
      await PreferencesService
          .clearData(); // Ensure this clears all relevant data
      print('Logout successful');
    } else {
      throw Exception(
          'Failed to logout: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> signUp(int phoneNumber, String password, String name) async {
    final url = Uri.parse('http://$ipaddres:5000/users/');
    final body = jsonEncode({
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Sign Up successful: $data');
      } else {
         final errorMessage = jsonDecode(response.body)['error'];
      throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }
}
