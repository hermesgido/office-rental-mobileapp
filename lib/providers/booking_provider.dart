import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking.dart';
import '../screens/login.dart';
import '../utils/constants.dart';

class BookingProvider with ChangeNotifier {
  Future<List<OfficeReservation>> getUserBookings(String userId,
      {required BuildContext context}) async {
    final List<OfficeReservation> bookingList = [];

    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    if (token == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignInPage(),
        ),
      );
      return [];
      // Handle the case where the token is null
      // For example, you can show an error message or redirect the user to the login page.
    } else {
      final url = Uri.parse("$baseUrl/api/officebookings/?user_id=$userId/");
      final headers = {
        "Authorization": "Bearer $token",
      };
      final response = await http.get(url, headers: headers);
      final data = jsonDecode(response.body);
      print(data);
      print("data goes hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      if (response.statusCode == 200) {
        bookingList.clear();
        for (var i in data) {
          bookingList.add(OfficeReservation.fromJson(i));
        }
        return bookingList;
      } else {
        final errorMessage = "Unable to get Office: ${response.statusCode}";
        showErrorMessage(context, errorMessage);
        throw Exception(errorMessage);
      }
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
