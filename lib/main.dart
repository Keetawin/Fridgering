import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './welcome/onboarding.dart';
import './home.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<User?> _checkLoginStatus() async {
    return FirebaseAuth.instance.currentUser;
  }

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

    return FutureBuilder<User?>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // You can show a loading indicator here.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          User? user = snapshot.data; // Get the user object
          print(
              'User is logged in: ${user?.uid}'); // Print the user's display name (replace with the relevant user data)
          // The user is logged in, so navigate to the Home screen.
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: primaryColor,
              fontFamily: 'Poppins',
            ),
            home: Home(userId: user?.uid), // Use the Home widget
          );
        } else {
          // The user is not logged in, so show the Onboarding screen.
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: primaryColor,
              fontFamily: 'Poppins',
            ),
            home: Onbording(),
          );
        }
      },
    );
  }
}
