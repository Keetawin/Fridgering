import 'package:flutter/material.dart';
import '../recipe/menu2.dart';

class CardItem extends StatefulWidget {
  final dynamic index;
  final Map<String, dynamic> user;
  final dynamic recipeId;
  final dynamic imageUrl;
  final dynamic tagAndTitle;
  final List<dynamic> tags;
  final dynamic timeToCook;
  final int numIngredients;
  final VoidCallback onTap;

  CardItem({
    required this.index,
    required this.user,
    required this.recipeId,
    required this.imageUrl,
    required this.tagAndTitle,
    required this.tags,
    required this.timeToCook,
    required this.numIngredients,
    required this.onTap,
  });

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool isPinned = false;

  @override
  void initState() {
  super.initState();
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    if (widget.user.isNotEmpty) {
      // Check if the current recipeId is in the list of pinnedRecipes
      bool isRecipePinned = widget.user['pinnedRecipes']?.contains(widget.recipeId) ?? false;

      setState(() {
        isPinned = isRecipePinned;
      });
    }
  });
}

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(
              userID: widget.user['userID'] ?? '',
              recipeID: widget.recipeId,
              recipeName: widget.tagAndTitle,
              recipeImage: widget.imageUrl,
              recipeTags: widget.tags.cast<String>(),
              recipeTime: widget.timeToCook,
              isPinned: isPinned,
            ),
          ),
        );

        // Update the state based on the result
        if (result != null && result is bool) {
          setState(() {
            isPinned = result;
          });
        }
        widget.onTap();
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
                child: widget.imageUrl.isNotEmpty
                    ? Image.network(
                        widget.imageUrl,
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
                            widget.tagAndTitle,
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
                      isPinned ? Icons.bookmark : Icons.bookmark_border,
                      color: isPinned ? Theme.of(context).primaryColor : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    if (widget.tags.isNotEmpty) ...widget.tags.sublist(0, 1).map((tag) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TagWithBorderRadius(tag),
                    )),
                    if (widget.tags.length > 1) ...[
                      SizedBox(width: 2),
                      TagWithBorderRadius('+${widget.tags.length - 1}'),
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
                    Text('${widget.timeToCook} Min',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    SizedBox(width: 16),
                    Icon(Icons.article_outlined, size: 20, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${widget.numIngredients}',
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