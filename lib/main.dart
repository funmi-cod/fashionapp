import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:designapp/auth.dart';

void main() {
  runApp(FashionApp());
}

class FashionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fashion Hub App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.mPlusRounded1cTextTheme(),
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      ),
      home: Auth(),
    );
  }
}
