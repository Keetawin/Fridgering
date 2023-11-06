import 'package:flutter/material.dart';

class FridgeListItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String expirationDate;

  FridgeListItem({
    required this.title,
    required this.imageUrl,
    required this.expirationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // Adjust the width as needed
      margin: EdgeInsets.only(right: 12), // Add spacing between items
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 160, // Adjust the width as needed
            height: 120, // Adjust the height as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 0.5,
              ),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            expirationDate,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
