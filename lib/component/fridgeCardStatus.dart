import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IngredientCard extends StatelessWidget {
  final String title;
  final int quantity;
  final String unit;
  final String imageUrl;
  final Map<String, dynamic> addedDate;
  final Map<String, dynamic> expiredDate;
  final VoidCallback onTap;

  IngredientCard({
    required this.title,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
    required this.addedDate,
    required this.expiredDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateBuyDateTime =
        DateTime.fromMillisecondsSinceEpoch(addedDate["_seconds"] * 1000);
    DateTime expirationDate =
        DateTime.fromMillisecondsSinceEpoch(expiredDate["_seconds"] * 1000);

    DateTime currentDate = DateTime.now();
    int daysLeft = expirationDate.difference(currentDate).inDays;
    int period = expirationDate.difference(dateBuyDateTime).inDays;
    bool isExpired = daysLeft <= 0;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
          bottom: 8,
        ),
        child: Container(
          height: 190,
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
                SizedBox(height: 6.0),
                isExpired
                    ? QuantityBoxExpired(quantity: quantity, unit: unit)
                    : QuantityBox(quantity: quantity, unit: unit),
                SizedBox(height: 5.0),
                ClipRRect(
                  child: Image.network(
                    imageUrl,
                    height: 79,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5.0),
                ExpirationLifeBar(
                  daysLeft: daysLeft,
                  height: 5.0,
                  width: 120.0,
                  period: period,
                ),
                SizedBox(height: 4.0),
                Text(
                  daysLeft >= 0 ? '$daysLeft Day Left' : 'Expired',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 0.0),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(2.0),
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
                SizedBox(height: 0.0),
                Text(
                  DateFormat('dd/MM/yy').format(expirationDate),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
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

class ExpirationLifeBar extends StatelessWidget {
  final int daysLeft;
  final double height;
  final double width;
  final int period;

  ExpirationLifeBar({
    required this.daysLeft,
    this.height = 8.0,
    this.width = 100.0,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    double lifePercentage = daysLeft > 0
        ? ((daysLeft / period))
        : 0.0; // Calculate the percentage of time elapsed
    Color lifeBarColor = _getLifeBarColor(lifePercentage);

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

  Color _getLifeBarColor(double percentage) {
    if (1 >= percentage && percentage >= 0.6) {
      return Colors.green;
    } else if (0.6 > percentage && percentage >= 0.3) {
      return Colors.orange;
    } else if (0.3 > percentage && percentage >= 0.0) {
      return Colors.red;
    } else {
      return Colors.grey; // You can set this to any color for an empty state
    }
  }
}

class QuantityBox extends StatelessWidget {
  final int quantity;
  final String unit;

  const QuantityBox({
    Key? key,
    required this.quantity,
    required this.unit,
  }) : super(key: key);

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
        '$quantity ${unit.toUpperCase()}', // Make unit uppercase
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}

class QuantityBoxExpired extends StatelessWidget {
  final int quantity;
  final String unit;

  const QuantityBoxExpired({
    Key? key,
    required this.quantity,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFFFF6464), // ตั้งค่าสีเป็นสีแดง
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        '$quantity ${unit.toUpperCase()}',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}
