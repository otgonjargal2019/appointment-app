import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';
import '../models/organization_type_model.dart';

class ApiService {
  final String baseUrl;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  ApiService({required this.baseUrl});

  Future<void> saveUserInfo(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Or remove specific keys
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('googleAuth::::   ${googleAuth}');

      // Send the idToken to your backend for verification
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': googleAuth.idToken}),
      );

      if (response.statusCode == 200) {
        // Handle successful sign-in
        final data = jsonDecode(response.body);
        await saveUserInfo(data['token']); // Save token
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to sign in with Google');
      }
    } catch (error) {
      print('Google sign-in error: $error');
    }
  }

  Future<UserModel?> signIn(String phoneNumber, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      String token = data['token'];
      await saveUserInfo(token);

      return UserModel(username: data['username'], phoneNumber: phoneNumber);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<UserModel?> signUp(
      String username, String phoneNumber, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'phoneNumber': phoneNumber,
        'password': password
      }),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? 'Failed to sign up');
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<OrganizationTypeModel>?> getOrganizationTypes() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/organization/types'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // print("getOrganizationTypes::::: ${response.body}");
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => OrganizationTypeModel.fromJson(json)).toList();
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(
          errorResponse['message'] ?? 'Failed to get organization types');
    }
  }
}
