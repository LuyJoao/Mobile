import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/splash_screen.dart'; 
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const Color primaryPurple = Color(0xFF673AB7);
  static const Color accentGreen = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PC Builder Pro',
      theme: ThemeData(
        primaryColor: primaryPurple,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(primaryPurple.value, {
            50: primaryPurple.withOpacity(0.1),
            100: primaryPurple.withOpacity(0.2),
            200: primaryPurple.withOpacity(0.3),
            300: primaryPurple.withOpacity(0.4),
            400: primaryPurple.withOpacity(0.5),
            500: primaryPurple,
            600: primaryPurple.withOpacity(0.8),
            700: primaryPurple.withOpacity(0.9),
            800: primaryPurple,
            900: primaryPurple,
          }),
          accentColor: accentGreen,
          backgroundColor: Colors.grey.shade50,
        ),
        scaffoldBackgroundColor: Colors.grey.shade50,

        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}