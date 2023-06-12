import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:office_rental/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/office.dart';
import '../utils/constants.dart';

class OfficeProvider with ChangeNotifier {
  final List<Office> _officeList = [];

  Future<List<Office>> getOffices(
      {required bool forceRefresh, required BuildContext context}) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/offices/"),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _officeList.clear();
        for (var i in data) {
          _officeList.add(Office.fromJson(i));
        }
        return _officeList;
      } else {
        final errorMessage = "Unable to get Office: ${response.statusCode}";
        showErrorMessage(context, errorMessage);
        throw Exception(errorMessage);
      }
    } catch (e) {
      final errorMessage = "Error occurred: $e";
      showErrorMessage(context, errorMessage);
      print(errorMessage);
      return []; // Return an empty list to handle the error case
    }
  }

  List<Office> get officeList {
    return _officeList;
  }

  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<Office?> getSingleOffice(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/offices/$id"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final data2 = Office.fromJson(data);
        return data2;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> bookOffice(BuildContext context, id) async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    if (token == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignInPage(),
        ),
      );
      // Handle the case where the token is null
      // For example, you can show an error message or redirect the user to the login page.
      return;
    } else {
      print(token);
      final response = await http.post(
        Uri.parse("$baseUrl/api/offices/$id/book/"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Added content type header
        },
        body: jsonEncode(
          {"office_id": id},
        ),
      );
      // Handle the response from the server
      if (response.statusCode == 200) {
        showErrorMessage(context, "Office booked has been successfully");
        print(response.body);
      } else {
        showErrorMessage(context, "Office booking has not been successfully");

        print("failedddddddddddd  ");
        print(response);
      }
    }
  }

  
}
