import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FridgeListItem extends StatelessWidget {
  final String title;
  final String quantity;
  final String imageUrl;
  final String dateBuy;

  FridgeListItem({
    required this.title,
    required this.quantity,
    required this.imageUrl,
    required this.dateBuy,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateBuyDateTime = DateFormat('dd/MM/yy').parse(dateBuy, true);
    DateTime expirationDate = dateBuyDateTime.add(Duration(days: 7));

    DateTime currentDate = DateTime.now();
    int daysLeft = expirationDate.difference(currentDate).inDays;

    return Container(
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
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            QuantityBox(quantity: quantity),

            SizedBox(height: 5.0),
            Image.asset(
              imageUrl,
              height: 50,
              fit: BoxFit.cover,
            ),

            SizedBox(height: 5.0),
            ExpirationLifeBar(daysLeft: daysLeft, height: 5.0, width: 120.0),

            SizedBox(height: 4.0),

            Text(
              '${daysLeft >= 0 ? daysLeft : 'Expired'} DAY LEFT',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 4.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 4.0),

            Text(
              dateBuy,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpirationLifeBar extends StatelessWidget {
  final int daysLeft;
  final double height;
  final double width;

  ExpirationLifeBar({required this.daysLeft, this.height = 8.0, this.width = 100.0});

  @override
  Widget build(BuildContext context) {
    double lifePercentage = daysLeft >= 0 ? (daysLeft / 7) : 0.0;
    Color lifeBarColor = _getLifeBarColor();

    return Container(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2), // Make it circular
        child: LinearProgressIndicator(
          value: lifePercentage,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(lifeBarColor),
          minHeight: height,
        ),
      ),
    );
  }

  Color _getLifeBarColor() {
    if (daysLeft >= 5 && daysLeft <= 7) {
      return Colors.green;
    } else if (daysLeft >= 3 && daysLeft <= 4) {
      return Colors.orange;
    } else if (daysLeft >= 1 && daysLeft <= 2) {
      return Colors.red;
    } else {
      return Colors.grey; // You can set this to any color for an empty state
    }
  }
}

class QuantityBox extends StatelessWidget {
  final String quantity;

  const QuantityBox({Key? key, required this.quantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.primaryColor, // Adjust color as needed
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        '$quantity',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}
