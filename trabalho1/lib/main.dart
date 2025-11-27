import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart';

const Color primaryDarkBlue = Color(0xFF053F5E);
const Color accentGreenLime = Color(0xFF4BC073);
const Color primaryRed = Color(0xFF8B0000);
const Color backgroundDeep = Color(0xFF003049);

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const OnePieceApp());
}

class OnePieceApp extends StatelessWidget {
  const OnePieceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Piece API App',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        primaryColor: primaryDarkBlue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          accentColor: accentGreenLime,
          backgroundColor: backgroundDeep,
        ),
        scaffoldBackgroundColor: backgroundDeep,
        appBarTheme: const AppBarTheme(
          color: primaryRed,
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
