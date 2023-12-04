import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../welcome/onboarding.dart';
import '../dietary/edit_dietary.dart';

class SettingPage extends StatelessWidget {
  final String? userId;
  final String? userImage;
  final String? userName;
  final String? userEmail;

  SettingPage({this.userId, this.userImage, this.userName, this.userEmail});

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Modal
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // ทำการ Logout จากระบบ Firebase
                await FirebaseAuth.instance.signOut();

                // ทำการ Logout จากระบบ Google Sign-In
                await GoogleSignIn().signOut();

                // ปิด Modal
                Navigator.of(context).pop();

                // ตัวอย่างการ navigate ไปยังหน้า Auth()
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Onbording()));
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Preference Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              onTap: () {
                // Navigate to the settings page when the settings button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDietaryPage(
                      userId: userId,
                      userImage: userImage,
                      userName: userName,
                      userEmail: userEmail,
                    ), // Use SettingPage instead of SettingsPage
                  ),
                );
              },
            ),
            Divider(), // Add a divider for visual separation
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
