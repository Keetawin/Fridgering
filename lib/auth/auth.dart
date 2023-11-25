import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../dietary/dietary.dart';

import '../home.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String? userId; // Variable to store the user ID

  // Google Sign-In Logic
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // Google Sign-In canceled
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = authResult.user;

      if (user != null) {
        // Successfully signed in with Google

        // Make API request to check user data
        final response = await http
            .get(Uri.parse('https://fridgeringapi.fly.dev/user/${user.uid}'));
        final responseData = json.decode(response.body);

        if (response.statusCode == 200 && responseData['status'] == 'OK') {
          // User data exists, navigate to Home
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                userId: user.uid,
                userImage: user.photoURL,
                userName: responseData['data']['name'],
                userEmail: user.email,
              ),
            ),
          );
        } else {
          // User data not found, navigate to Dietary
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DietaryPage(
                userId: user.uid,
                userImage: user.photoURL,
                userName: user.displayName,
                userEmail: user.email,
              ),
            ),
          );
        }

        print('Google Sign-In Success: ${user.displayName}');
      } else {
        // Google Sign-In failed
        print('Google Sign-In Failed');
      }
    } catch (e) {
      print("Google Sign-In error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 56),
            Text(
              'Fridgering',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 56),
            // Facebook Login Button

            // Google Login Button
            Container(
              height: 64,
              margin: EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: TextButton(
                onPressed: _signInWithGoogle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: 20, // Adjust the size as needed
                    ),
                    SizedBox(
                        width: 8), // Add some spacing between the icon and text
                    Text(
                      "Sign In with Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFFF6464),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            // Apple Login Button
          ],
        ),
      ),
    );
  }
}
