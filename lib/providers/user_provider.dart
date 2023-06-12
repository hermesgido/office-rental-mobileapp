import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:office_rental/screens/home_page.dart';
import 'package:office_rental/screens/login.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  late User _user;

  User get user => _user;

  late SharedPreferences _preferences;

  Future<void> fetchLoggedInUser() async {
    _preferences = await SharedPreferences.getInstance();
    final token = _preferences.getString('token');

    if (token != null) {
      try {
        final response =
            await http.get(Uri.parse("$baseUrl/api/user"), headers: {
          'Authorization': 'Bearer $token',
        });

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          final email = userData["email"] as String;
          _user = User(email, "");
          notifyListeners();
        } else {
          // Handle error case when fetching user data
          print(response.body);
        }
      } catch (e) {
        // Handle error case when making the request
        print(e);
      }
    }
  }

  bool get isAuthenticated => _user != null;

  Future<void> register(
      BuildContext context, String email, String password) async {
    print("registerrrrrrrrrrrrrrrrrrrrrrr");

    try {
      final url = Uri.parse('$baseUrl/api/users/create/');
      final body = jsonEncode({
        'username': email,
        'email': email,
        'password': password,
      });
      print(body);
      final response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json', // Added content type header
        },
      );

      if (response.statusCode == 201) {
        // Registration successful
        _user = User(email, password);
        notifyListeners();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
        );
      } else {
        showErrorMessage(context, 'Registration failed ${response.statusCode}');
      }
    } catch (e) {
      showErrorMessage(context, 'Registration failed');
      print(e);
    }
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    print("loginnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn");

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/users/login/"),
        body: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Login successful
        // Parse the JWT token from the response and handle accordingly
        final tokenBody = jsonDecode(response.body);
        final token = tokenBody["access"];
        print(token);
        // Save the token to local storage
        _preferences = await SharedPreferences.getInstance();
        await _preferences.setString('token', token);
        showErrorMessage(context, "Successfully logged in");
        _user = User(email, password);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        notifyListeners();
      } else {
        print(response.body);
        showErrorMessage(context, "Failed to login ${response.statusCode}");
      }
    } catch (e) {
      showErrorMessage(context, e.toString());
      print(e);
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 56, 50, 50),
      ),
    );
  }
}
