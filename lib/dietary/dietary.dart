import 'package:flutter/material.dart';

class DietaryPage extends StatefulWidget {
  @override
  _DietaryPageState createState() => _DietaryPageState();
}

class _DietaryPageState extends State<DietaryPage> {
  List<String> selectedRestrictions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dietary Restriction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            Container(
              height: 60,
              margin: EdgeInsets.all(40),
              width: double.infinity,
              child: TextButton(
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                onPressed: () {},
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
