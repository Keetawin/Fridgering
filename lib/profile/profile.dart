import 'package:flutter/material.dart';

import '../component/fridgecard_status.dart';
import '../component/recipecard_bookmark.dart';
import '../auth/setting.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;
  final String? userImage;
  final String? userName;

  ProfilePage({this.userId, this.userImage, this.userName});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<int> bookmarkedRecipeIndices = [0, 2];


  List<List<String>> tagsList = [
    ['Fried', 'Thai cuisine', 'Spicy'],
    ['Hot', 'Japan cuisine', 'Soup'],
    ['Hot', 'Soup'],
  ];

  List<int> timeToCook = [20, 30, 40];
  List<int> numIngredients = [5, 6, 7];
  List<String> imageUrls = ['assets/images/pic2.jpg', 'assets/images/pic1.jpg', 'assets/images/pic3.jpg'];
  List<String> tagsAndTitles = ['Omelet', 'Wagyu A5', 'Tom Yum'];

  List<String> fridgeItemTitles = ['Potato', 'Egg(O)', 'Egg(A)'];
  List<String> fridgeItemQuantity = ['2 PCS', '3 PCS', '1PCS'];
  List<String> fridgeItemImages = ['assets/images/potato.jpg', 'assets/images/egg.jpg', 'assets/images/egg.jpg'];
  List<String> fridgeItemDates = ['31/08/21', '31/08/21', '31/08/21'];

  void toggleBookmark(int index) {
    setState(() {
      if (bookmarkedRecipeIndices.contains(index)) {
        bookmarkedRecipeIndices.remove(index);
      } else {
        bookmarkedRecipeIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 48),
            Container(
              // User profile section
              padding: EdgeInsets.symmetric(horizontal: 36),
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
                                fontWeight: FontWeight.w600,
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
                    icon: Icon(Icons.settings),
                    iconSize: 30, // Set the desired size for the icon
                    onPressed: () {
                      // Navigate to the settings page when the settings button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingPage(), // Use SettingPage instead of SettingsPage
                        ),
                      );
                    },
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
                        itemCount: bookmarkedRecipeIndices.length,
                        itemExtent: 290,
                        itemBuilder: (context, index) {
                          final int recipeIndex = bookmarkedRecipeIndices[index];

                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: CardItem(
                              index: recipeIndex,
                              imageUrl: imageUrls[recipeIndex],
                              tagAndTitle: tagsAndTitles[recipeIndex],
                              tags: tagsList[recipeIndex],
                              timeToCook: timeToCook[recipeIndex],
                              numIngredients: numIngredients[recipeIndex],
                              isBookmarked: true,
                              onTap: () {
                                setState(() {
                                  bookmarkedRecipeIndices.remove(recipeIndex);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // Fridge section
                padding: EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fridge List',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${fridgeItemTitles.length} items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                    child:FridgeList(
                      fridgeItems: List.generate(
                        fridgeItemTitles.length,
                        (index) => FridgeListItem(
                          title: fridgeItemTitles[index],
                          quantity: fridgeItemQuantity[index],
                          imageUrl: fridgeItemImages[index],
                          dateBuy: fridgeItemDates[index],
                        ),
                      ),
                    ),
                    
                    ),
                    
                    SizedBox(height: 16),
                  ],
                ),
              ),
          ],
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
      height: 200, // Adjust the height as needed
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