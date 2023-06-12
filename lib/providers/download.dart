import 'package:flutter/material.dart';
import 'package:office_rental/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadContract with ChangeNotifier {
  Future<void> downloadContract(
    BuildContext context,
    String bookingId,
  ) async {
    final url =
        Uri.parse("$baseUrl/api/download_contract/?booking_id=$bookingId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        downloadsDirectory = await getDownloadsDirectory();
      } else {
        // Unsupported platform
        return;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final random = DateTime.now().microsecondsSinceEpoch;
      final fileName = 'contract_$timestamp$random.pdf';
      final filePath = '${downloadsDirectory?.path}/$fileName';
      final File file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);
      print('PDF saved to: $filePath');

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Contract Downloaded'),
            content: const Text(
                'The contract PDF has been downloaded. Please view it in your device storage'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
