import 'package:flutter/material.dart';
import '../recipe/menu2.dart';

class CardItem extends StatelessWidget {
  final int index;
  final String imageUrl;
  final String tagAndTitle;
  final List<String> tags;
  final int timeToCook;
  final int numIngredients;
  final bool isBookmarked;
  final VoidCallback onTap;

  CardItem({
    required this.index,
    required this.imageUrl,
    required this.tagAndTitle,
    required this.tags,
    required this.timeToCook,
    required this.numIngredients,
    required this.isBookmarked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Menu(
        //       imageUrl: imageUrl,
        //       tagAndTitle: tagAndTitle,
        //       tags: tags,
        //       timeToCook: timeToCook,
        //       numIngredients: numIngredients,
        //       isBookmarked: isBookmarked, // Use ternary operator here
        //     ),
        //   ),
        // );
      },
      child: Container(
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Image.asset(
                  imageUrl,
                  width: 270,
                  height: 150,
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
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Colors.blue : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    ...tags.sublist(0, 2).map((tag) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: TagWithBorderRadius(tag),
                        )),
                    if (tags.length > 2) ...[
                      SizedBox(width: 6),
                      TagWithBorderRadius('+${tags.length - 2}'),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.schedule_outlined, size: 20, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${timeToCook} Min',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    SizedBox(width: 16),
                    Icon(Icons.article_outlined, size: 20, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${numIngredients}',
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
        tagText.toUpperCase(), // ทำให้ข้อความเป็นตัวพิมพ์ใหญ่ทั้งหมด
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
