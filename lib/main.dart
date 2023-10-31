import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './welcome/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create a MaterialColor from a Color
    MaterialColor primaryColor = MaterialColor(
      0xFF3D77FC, // Primary color's hexadecimal value
      <int, Color>{
        50: Color(0xFF3D77FC), // You can customize shades if needed
        100: Color(0xFF3D77FC),
        200: Color(0xFF3D77FC),
        300: Color(0xFF3D77FC),
        400: Color(0xFF3D77FC),
        500: Color(0xFF3D77FC), // Your primary color
        600: Color(0xFF3D77FC),
        700: Color(0xFF3D77FC),
        800: Color(0xFF3D77FC),
        900: Color(0xFF3D77FC),
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: primaryColor,
          fontFamily: 'Poppins' // Use the custom MaterialColor
          ),
      home: Onbording(),
    );
  }
}
