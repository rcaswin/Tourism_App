import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_to_kumari/pages/explorepage.dart';
import 'package:trip_to_kumari/pages/homepage.dart';
import 'package:trip_to_kumari/pages/maps.dart';
import 'package:trip_to_kumari/pages/menuspage.dart';
import 'package:trip_to_kumari/pages/samplechatapp.dart';
import 'package:trip_to_kumari/pages/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Trip to Kumari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 239, 245, 253),
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routes: {
        // Bottom Navigation Bar Routes
        '/homepage': (context) => const HomePage(),
        '/expore': (context) => const ExplorePage(),
        '/mappage': (context) => const MapScreen(),
        '/chatbot': (context) => TourismScreen(),
        '/menu': (context) => MenusPage(),
      },
      home: SplashScreenPage(),
    );
  }
}
