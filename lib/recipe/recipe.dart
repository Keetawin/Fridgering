import 'package:flutter/material.dart';
import './menu2.dart';
import '../notification/notification.dart';
import 'package:standard_searchbar/standard_searchbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipePage extends StatefulWidget {
  final String? userId;

  RecipePage({required this.userId});

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> searchResults = [];
  bool match = false;

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
          userID: 'userID=${widget.userId ?? ''}&match=false',
          recipeID: searchResults[index]['recipeID'].toString(),
          recipeName: searchResults[index]['name'],
          recipeImage: searchResults[index]['image'][0],
          recipeTags:
              (searchResults[index]['tags'] as List<dynamic>).cast<String>(),
          recipeTime: searchResults[index]['cookTime'] as int,
          isPinned: false,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes([String? nameQuery]) async {
    try {
      String apiUrl =
          'https://fridgeringapi.fly.dev/recipes/search?userID=${widget.userId}&match=$match';

      if (nameQuery != null) {
        apiUrl += '&name=$nameQuery';
      }

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Successfully fetched recipes
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> recipeList = data['data'];
        setState(() {
          recipes = List<Map<String, dynamic>>.from(recipeList);
          searchResults = List<Map<String, dynamic>>.from(recipeList);
        });
      } else {
        // Handle errors
        print('Failed to fetch recipes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
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

            // Search Field
            Padding(
              padding: EdgeInsets.only(right: 9),
              child: StandardSearchBar(
                onChanged: (query) {
                  setState(() {
                    searchResults = recipes.where((recipe) {
                      final title = recipe['name'].toLowerCase();
                      final imageUrl = recipe['image'][0].toLowerCase();
                      return title.contains(query.toLowerCase()) ||
                          imageUrl.contains(query.toLowerCase());
                    }).toList();
                  });
                  _fetchRecipes(query); // Fetch recipes based on the name query
                },
                hintText: 'Search...',
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.only(right: 9),
              child: Row(
                children: [
                  Checkbox(
                    value: match,
                    onChanged: (value) {
                      setState(() {
                        match = value!;
                        _fetchRecipes(); // Fetch recipes without a name query
                      });
                    },
                  ),
                  SizedBox(width: 16),
                  Text('Match ingredient in fridge'),
                ],
              ),
            ),

            // Display search results or recipes
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _navigateToMenuScreen(index);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 9.0, right: 12.0),
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
                                  child: Image.network(
                                    searchResults[index]['image'][0],
                                    height: 150,
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
                                    searchResults[index]['name'],
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
