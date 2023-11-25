import 'package:flutter/material.dart';
import './menu.dart';
import '../notification/notification.dart';
import 'package:standard_searchbar/standard_searchbar.dart';

class RecipePage extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> tagsAndTitles;
  final List<List<String>> tagsList; // Define tagsList
  final List<int> timeToCook; // Define timeToCook
  final List<int> numIngredients; // Define numIngredients

  RecipePage({
    required this.imageUrls,
    required this.tagsAndTitles,
    required this.tagsList,
    required this.timeToCook,
    required this.numIngredients,
  });

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<int> searchResultsIndices = [];

  void _navigateToNotiScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(),
      ),
    );
  }

  void _navigateToMenuScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Menu(
          imageUrl: widget.imageUrls[index],
          tagAndTitle: widget.tagsAndTitles[index],
          tags: widget.tagsList[index],
          timeToCook: widget.timeToCook[index],
          numIngredients: widget.numIngredients[index],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchResultsIndices =
        List.generate(widget.tagsAndTitles.length, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 36,
          right: 27,
          bottom: 16,
        ),
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recipe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: _navigateToNotiScreen,
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.only(right: 9),
              child: StandardSearchBar(
                onChanged: (query) {
                  setState(() {
                    searchResultsIndices = List.generate(
                      widget.tagsAndTitles.length,
                      (index) => index,
                    ).where((index) {
                      final title = widget.tagsAndTitles[index].toLowerCase();
                      final imageUrl = widget.imageUrls[index].toLowerCase();
                      return title.contains(query.toLowerCase()) ||
                          imageUrl.contains(query.toLowerCase());
                    }).toList();
                  });
                },
                hintText: 'Search...',
              ),
            ),

            // Search Field

            SizedBox(height: 12),

            // Display search results or recipes
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: searchResultsIndices.length,
                itemBuilder: (context, index) {
                  final recipeIndex = searchResultsIndices[index];
                  return GestureDetector(
                      onTap: () {
                        _navigateToMenuScreen(recipeIndex);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 9.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      widget.imageUrls[recipeIndex],
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      widget.tagsAndTitles[recipeIndex],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
