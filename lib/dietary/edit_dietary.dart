import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../navbar.dart';

class EditDietaryPage extends StatefulWidget {
  final String? userId;
  final String? userImage;
  final String? userName;
  final String? userEmail;

  EditDietaryPage({this.userId, this.userImage, this.userName, this.userEmail});

  @override
  _EditDietaryPageState createState() => _EditDietaryPageState();
}

class _EditDietaryPageState extends State<EditDietaryPage> {
  @override
  void initState() {
    super.initState();
    // Call fetchData() when the widget is first created
    fetchData();
  }

  List<String> selectedRestrictions = [];
  TextEditingController expireNotificationController = TextEditingController();

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://fridgeringapi.fly.dev/user/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> userData = json.decode(response.body);

        // Check if the preferences and dietaryRestrictions are available
        if (userData.containsKey('data') &&
            userData['data'].containsKey('preferences') &&
            userData['data']['preferences'].containsKey('dietaryRestriction')) {
          // Extract dietaryRestrictions from the nested structure
          List<String> existingRestrictions = List<String>.from(
            userData['data']['preferences']['dietaryRestriction'],
          );

          // Initialize selectedRestrictions with existing restrictions
          setState(() {
            selectedRestrictions = existingRestrictions;
          });
        }

        // Log the fetched data
        print('Data fetched successfully: $userData');
      } else {
        // Handle failed response
        print('Failed to fetch data. Status code: ${response.statusCode}');
        // ... (rest of the error handling code remains the same)
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
      // ... (rest of the error handling code remains the same)
    }
  }

  Future<void> savePreferences() async {
    try {
      // Prepare the data to be sent in the PUT request
      Map<String, dynamic> postData = {
        "preferences": {
          "dietaryRestriction": selectedRestrictions,
          "expireNotification": int.parse(expireNotificationController.text),
        },
      };

      // Make the HTTP PUT request
      final response = await http.put(
        Uri.parse('https://fridgeringapi.fly.dev/user/${widget.userId}'),
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
            builder: (context) => Navbar(
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
        child: SingleChildScrollView(
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
                    FilteringTextInputFormatter.allow(RegExp(r'^[1-7]$')),
                    LengthLimitingTextInputFormatter(1),
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
          if (value != null) {
            selectedRestrictions = List<String>.from(selectedRestrictions);
            if (value) {
              selectedRestrictions.add(title);
            } else {
              selectedRestrictions.remove(title);
            }
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
