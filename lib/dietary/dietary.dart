import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../home.dart';

class DietaryPage extends StatefulWidget {
  final String? userId;
  final String? userImage;
  final String? userName;
  final String? userEmail;

  DietaryPage({this.userId, this.userImage, this.userName, this.userEmail});

  @override
  _DietaryPageState createState() => _DietaryPageState();
}

class _DietaryPageState extends State<DietaryPage> {
  List<String> selectedRestrictions = [];
  TextEditingController expireNotificationController = TextEditingController();
  Future<void> savePreferences() async {
    try {
      // Prepare the data to be sent in the POST request
      Map<String, dynamic> postData = {
        "userID": widget.userId,
        "name": widget.userName,
        "image": widget.userImage,
        "email": widget.userEmail,
        "preferences": {
          "dietaryRestriction": selectedRestrictions,
          "expireNotification": int.parse(expireNotificationController.text),
        },
      };

      // Make the HTTP POST request
      final response = await http.post(
        Uri.parse('https://fridgeringapi.fly.dev/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        // Successfully saved preferences
        print('Preferences saved successfully');

        // Navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              userId: widget.userId,
              userImage: widget.userImage,
              userName: widget.userName,
            ),
          ),
        );
      } else {
        // Handle errors
        print(
            'Failed to save preferences. Status code: ${response.statusCode}');

        // Show alert dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save preferences. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dietary Restrictions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 8),
            buildCheckbox("Vegetarian"),
            buildCheckbox("Vegan"),
            buildCheckbox("Pescatarian"),
            buildCheckbox("Flexitarian"),
            buildCheckbox("Gluten-Free"),
            buildCheckbox("Lactose-Free"),
            buildCheckbox("Halal"),
            buildCheckbox("Low-Carb"),
            buildCheckbox("High-Protein"),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expire Notification',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                controller: expireNotificationController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  LengthLimitingTextInputFormatter(
                      1), // Limit length to 1 digit
                  RangeTextInputFormatter(
                      min: 1, max: 7), // Custom formatter for range
                ],
                decoration: InputDecoration(
                  labelText: 'Expire Notification (1-7 days)',
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              child: TextButton(
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  savePreferences();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCheckbox(String title) {
    return CheckboxListTile(
      title: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      value: selectedRestrictions.contains(title),
      onChanged: (bool? value) {
        setState(() {
          if (value != null && value) {
            selectedRestrictions.add(title);
          } else {
            selectedRestrictions.remove(title);
          }
        });
      },
    );
  }
}

class RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      final int intValue = int.parse(newValue.text);
      if (intValue < min) {
        return TextEditingValue().copyWith(text: min.toString());
      } else if (intValue > max) {
        return TextEditingValue().copyWith(text: max.toString());
      }
      return newValue;
    } catch (e) {
      return oldValue;
    }
  }
}
