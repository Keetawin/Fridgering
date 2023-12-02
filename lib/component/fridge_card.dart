import 'package:flutter/material.dart';
import '../ingredient/add.dart';
import 'package:intl/intl.dart';

class FridgeListItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String ingredientID;
  final String? userId;
  final VoidCallback onTap;

  FridgeListItem({
    required this.title,
    required this.imageUrl,
    required this.ingredientID,
    required this.userId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPage(
              ingredientID: ingredientID.toString(),
              userId: userId,
              ingredientName: title,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
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
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 90,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}

}