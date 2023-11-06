import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final int index;
  final String imageUrl;
  final String tagAndTitle;

  CardItem({
    required this.index,
    required this.imageUrl,
    required this.tagAndTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      margin: EdgeInsets.only(right: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              // Wrap the image with ClipRRect
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.asset(
                imageUrl,
                width: 270,
                height: 150, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 20.0,
                right: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tagAndTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Icon(Icons.bookmark_border),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  TagWithBorderRadius('FRIED'),
                  SizedBox(width: 8),
                  TagWithBorderRadius('THAI CUISINE'),
                  SizedBox(width: 8),
                  TagWithBorderRadius('+3'),
                ],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.schedule_outlined, size: 20, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('20 Min',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: 16),
                  Icon(Icons.article_outlined, size: 20, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('12',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TagWithBorderRadius extends StatelessWidget {
  final String tagText;

  TagWithBorderRadius(this.tagText);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor, // Use the primary color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tagText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          // Use white font color
        ),
      ),
    );
  }
}
