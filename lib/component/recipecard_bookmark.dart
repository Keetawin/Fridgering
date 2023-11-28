import 'package:flutter/material.dart';
import '../recipe/menu2.dart';

class CardItem extends StatelessWidget {
  final dynamic index;
  final dynamic imageUrl;
  final dynamic tagAndTitle;
  final List<dynamic> tags;
  final dynamic timeToCook;
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
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 270,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/default.png', // Replace with the path to your default image asset
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
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            tagAndTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
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
                    if (tags.isNotEmpty) ...tags.sublist(0, 1).map((tag) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TagWithBorderRadius(tag),
                    )),
                    if (tags.length > 1) ...[
                      SizedBox(width: 2),
                      TagWithBorderRadius('+${tags.length - 1}'),
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
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tagText.toUpperCase(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
