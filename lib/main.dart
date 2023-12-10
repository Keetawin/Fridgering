import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './welcome/onboarding.dart';
import './firebase_options.dart';
import './navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<Map<String, dynamic>?> _checkLoginStatus() async {
    // Ensure that the user is signed in before attempting to get the userId
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the current user ID from Firebase
      String userId = user.uid;

      final response = await http.get(
        Uri.parse('https://fridgeringapi.fly.dev/user/$userId'),
      );

      if (response.statusCode == 200) {
        // User data is available
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // User not found
        return null;
      } else {
        throw Exception('Failed to check login status');
      }
    } else {
      // User is not signed in, return null
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor primaryColor = MaterialColor(
      0xFF3D77FC,
      <int, Color>{
        50: Color(0xFF3D77FC),
        100: Color(0xFF3D77FC),
        200: Color(0xFF3D77FC),
        300: Color(0xFF3D77FC),
        400: Color(0xFF3D77FC),
        500: Color(0xFF3D77FC),
        600: Color(0xFF3D77FC),
        700: Color(0xFF3D77FC),
        800: Color(0xFF3D77FC),
        900: Color(0xFF3D77FC),
      },
    );

    return FutureBuilder<Map<String, dynamic>?>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userData = snapshot.data;

          if (userData == null) {
            // User not found, navigate to Onboarding
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: primaryColor,
                fontFamily: 'Poppins',
                scaffoldBackgroundColor: Colors.white,
              ),
              home: Onbording(),
            );
          } else {
            // User found, navigate to Home
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: primaryColor,
                fontFamily: 'Poppins',
                scaffoldBackgroundColor: Colors.white,
              ),
              home: Navbar(
                userId: userData['data']['userID'],
                userImage: userData['data']['image'],
                userName: userData['data']['name'],
              ),
            );
          }
        }
      },
    );
  }
}
