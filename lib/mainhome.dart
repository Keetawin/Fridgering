import 'package:flutter/material.dart';
import '../notification/notification.dart';
import 'component/recipecard_bookmark.dart';
import './component/fridgecard_status.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainhomePage extends StatefulWidget {
  final String? userId;
  final String? userImage;
  final String? userName;

  MainhomePage({required this.userId,required this.userImage,required this.userName});

  @override
  MainhomePageState createState() => MainhomePageState();
}

class MainhomePageState extends State<MainhomePage> {
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> user = [];
  List<int> ingredientsLenght = [];

  void _navigateToNotiScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try{
      final userResponse = await http.get
        (Uri.parse('https://fridgeringapi.fly.dev/user/${widget.userId}'));
      
      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(userResponse.body);
        final Map<String, dynamic> userList = userData['data'];

        dynamic dietaryRestrictionsData = userList['preferences']['dietaryRestriction'];

        List<String> dietaryRestrictions = List<String>.from(dietaryRestrictionsData ?? []);

        // Check if there are dietary restrictions
        if (dietaryRestrictions.isNotEmpty) {

          for (String restriction in dietaryRestrictions) {
            
            final recipesResponse = await http.get(
                Uri.parse('https://fridgeringapi.fly.dev/recipes/search?tags=["$restriction"]&userID=${widget.userId}'));
            if (recipesResponse.statusCode == 200) {
              final Map<String, dynamic> recipesData = json.decode(recipesResponse.body);
              final List<dynamic> recipeList = recipesData['data'];

              for (var recipe in recipesData['data']) {
                final recipeId = recipe['recipeID'];
                final ingredientsResponse =
                    await http.get(Uri.parse('https://fridgeringapi.fly.dev/recipes/$recipeId/ingredients'));

                if (ingredientsResponse.statusCode == 200) {
                  Map<String, dynamic> ingredientsData = json.decode(ingredientsResponse.body);
                  final List<dynamic> ingredientsList = ingredientsData['data'];

                  int count = ingredientsList.length;
                  setState(() {
                    ingredientsLenght.add(count);
                  });

                } else {
                  print('Failed to load ingredients for recipe $recipeId. Status code: ${ingredientsResponse.statusCode}');
                }
              }
              setState(() {
                recipes.addAll(List<Map<String, dynamic>>.from(recipeList));
              });

            } else {
              print('Failed to load recipes for $restriction. Status code: ${recipesResponse.statusCode}');
            }
          }

          // Update the state once after the loop completes
          
        }
        setState(() {
          user = [userList];
        });
      } else {
        print('Failed to load user data. Status code: ${userResponse.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 48),
                Container(
                  // User profile section
                  padding: EdgeInsets.only(left: 36, right: 27),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                widget.userImage ?? 'URL_TO_DEFAULT_IMAGE',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi ${widget.userName?.split(' ')[0]} 💙',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Welcome to Fridgering',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                ),
                Container(
                  // Recipe section
                  padding: EdgeInsets.only(left: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Recipes you can make',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Horizontal ListView for recipe cards
                      Container(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recipes.length,
                          itemExtent: 290,
                          itemBuilder: (context, index) {
                            if (index < recipes.length && index < ingredientsLenght.length) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: CardItem(
                                  index: index,
                                  imageUrl: recipes[index]['image'][0],
                                  tagAndTitle: recipes[index]['name'],
                                  tags: recipes[index]['tags'],
                                  timeToCook: recipes[index]['cooktime'],
                                  numIngredients: ingredientsLenght[index],
                                  isBookmarked: false,
                                  onTap: () {
                                    setState(() {});
                                  },
                                ),
                              );
                            } else {
                              return SizedBox.shrink(); // Or some placeholder if data is not available
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                // Container(
                //   // Recipe section
                //   padding: EdgeInsets.symmetric(horizontal: 36),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SizedBox(height: 20),
                //       Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               'Fridge List',
                //               style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.w600,
                //                 color: Colors.black,
                //               ),
                //             ),
                //             Text(
                //               '${fridgeItemTitles.length} items',
                //               style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.w600,
                //                 color: Colors.grey,
                //               ),
                //             ),
                //           ]),
                //       SizedBox(height: 16),
                //     ],
                //   ),
                // ),
                // Container(
                //   // Recipe section
                //   padding: EdgeInsets.only(left: 36),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       FridgeList(
                //         fridgeItems: List.generate(
                //           fridgeItemTitles.length,
                //           (index) => FridgeListItem(
                //             title: fridgeItemTitles[index],
                //             quantity: fridgeItemQuantity[index],
                //             imageUrl: fridgeItemImages[index],
                //             dateBuy: fridgeItemDates[index],
                //             expireDate: fridgeItemExpirationDates[index],
                //           ),
                //         ),
                //       ),
                //       SizedBox(height: 16),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}

class FridgeList extends StatelessWidget {
  final List<FridgeListItem> fridgeItems;

  FridgeList({required this.fridgeItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fridgeItems.length,
        itemBuilder: (context, index) {
          return fridgeItems[index];
        },
      ),
    );
  }
}