import 'package:flutter/material.dart';
import 'pages/home_page.dart'; 
import 'pages/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PC Build Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, 
        primaryColor: const Color(0xFF263238), 
        hintColor: const Color(0xFF78909C), 
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), 
        cardColor: Colors.white,

        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF263238)),
          bodyLarge: TextStyle(fontSize: 16.0, color: Color(0xFF455A64)),
          bodyMedium: TextStyle(fontSize: 14.0, color: Color(0xFF607D8B)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF263238), 
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 4,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF00ACC1), 
          foregroundColor: Colors.white,
          elevation: 6,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFFCFD8DC), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFF00ACC1), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF455A64)),
          hintStyle: const TextStyle(color: Color(0xFF90A4AE)),
        ),
      ),
      home: const SplashScreen(), 
    );
  }
}