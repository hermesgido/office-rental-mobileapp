import 'package:flutter/material.dart';
import 'package:office_rental/providers/booking_provider.dart';
import 'package:office_rental/providers/download.dart';
import 'package:office_rental/providers/office_provider.dart';
import 'package:office_rental/providers/user_provider.dart';
import 'package:office_rental/screens/home_page.dart';
import 'package:office_rental/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'screens/boooked_offfieces.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<OfficeProvider>(create: (_) => OfficeProvider()),
        ChangeNotifierProvider<BookingProvider>(
            create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => DownloadContract())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.yellow,
              appBarTheme:
                  const AppBarTheme(backgroundColor: null, color: null)),
          home: const SplashScreen()),
    );
  }
}
