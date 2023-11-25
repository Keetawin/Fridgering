import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FridgeListItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  FridgeListItem({
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8,top: 8,bottom: 8), // Add padding values here
      child: Container(
        height: 200,
        width: 140,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.0),
              Image.asset(
                imageUrl,
                height: 100,
                fit: BoxFit.cover,
              ),

              SizedBox(height: 10.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
