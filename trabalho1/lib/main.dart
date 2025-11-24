import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const OnePieceApp());
}

class OnePieceApp extends StatelessWidget {
  const OnePieceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Piece API App ',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          color: Colors.red[900],
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          )
        ),
        useMaterial3: true,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}