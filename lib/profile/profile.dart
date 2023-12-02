import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../component/fridge_card.dart';
import '../component/recipecard_bookmark.dart';
import 'dart:convert';
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
  List<String> pinnedRecipes = [];
  List<int> pinnedIngredients = [];
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> ingredients = [];
  List<Map<String, dynamic>> user = [];
  List<int> ingredientsLenght = [];

  @override
  void initState() {
    super.initState();
    refreshProfilePage();
  }
  void refreshProfilePage() {
    _loadUser();
    pinnedIngredients = [];
    pinnedRecipes = [];
    recipes = [];
    ingredients = [];
    user = [];
    ingredientsLenght = [];
  }

  Future<void> _loadUser() async {
    try {
      final userResponse = await http.get(Uri.parse('https://fridgeringapi.fly.dev/user/${widget.userId}'));

      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(userResponse.body);
        final Map<String, dynamic> userList = userData['data'];

        List<String> pinnedRecipesData = List<String>.from(userList['pinnedRecipes'] ?? []);
        List<int> pinnedIngredientData = List<int>.from(userList['pinnedIngredients'] ?? []);
        print(pinnedIngredientData);

        setState(() {
          pinnedIngredients = pinnedIngredientData;
          pinnedRecipes = pinnedRecipesData;
          user = [userList];
        });
        _loadRecipes();
        _loadIngredient();
      } else {   
        print('Failed to load user data. Status code: ${userResponse.statusCode}');
        _loadRecipes();
        _loadIngredient();
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

Future<void> _loadRecipes() async {
  try {  
    final List<String> restrictions = pinnedRecipes.isNotEmpty ? pinnedRecipes : [''];

    for (String restriction in restrictions) {
      final recipesResponse = await http.get(
          Uri.parse('https://fridgeringapi.fly.dev/recipes/$restriction'));
      
      if (recipesResponse.statusCode == 200) {
        final Map<String, dynamic> recipesData = json.decode(recipesResponse.body);
        final Map<String, dynamic> oneRecipes = recipesData['data'];

          setState(() {
            recipes.add(oneRecipes);
          });
      } else {
        print('Failed to load recipes for $restriction. Status code: ${recipesResponse.statusCode}');
      } 

      final ingredientsResponse = await http.get(Uri.parse('https://fridgeringapi.fly.dev/recipes/$restriction/ingredients'));

      if (ingredientsResponse.statusCode == 200) {
        Map<String, dynamic> ingredientsData = json.decode(ingredientsResponse.body);
        final List<dynamic> ingredientsList = ingredientsData['data'];

        int count = ingredientsList.length;
        setState(() {
          ingredientsLenght.add(count);
        });
      } else {
        print('Failed to load ingredients for recipe $restriction. Status code: ${ingredientsResponse.statusCode}');
      }         
    }
  } catch (e) {
    // Handle other errors
    print('Error: $e');
  }
}



  Future<void> _loadIngredient() async {
    try {
      final List<int> restrictions = pinnedIngredients.isNotEmpty ? pinnedIngredients : [];
      print('pinnedIngredients: $pinnedIngredients');

      for (int restriction in restrictions) {
        final ingredientResponse = await http.get(
            Uri.parse('https://fridgeringapi.fly.dev/common_ingredient/$restriction'));
        
        if (ingredientResponse.statusCode == 200) {
          final Map<String, dynamic> IngredientData = json.decode(ingredientResponse.body);
          final Map<String, dynamic> oneIngredient = IngredientData['data'];
          print(oneIngredient);
            setState(() {
              ingredients.add(oneIngredient);
            });
        } else {
          print('Failed to load ingredient data. Status code: ${ingredientResponse.statusCode}');
        }
      }
    }
    catch (e) {
      // Handle other errors
      print('Error: $e');
    }
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
                          builder: (context) =>
                              SettingPage(), // Use SettingPage instead of SettingsPage
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
                      'Bookmarked Recipe',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  //Horizontal ListView for recipe cards
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
                              user: user.isNotEmpty ? user[0] : {},
                              recipeId: recipes[index]['recipeID'],
                              imageUrl: recipes[index]['image'][0],
                              tagAndTitle: recipes[index]['name'],
                              tags: recipes[index]['tags'],
                              timeToCook: recipes[index]['cookTime'],
                              numIngredients: ingredientsLenght[index],
                              onTap: refreshProfilePage,
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
            Container(
              // Fridge section
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    // Add padding to the Row
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 36),
                        child: Text(
                          'Bookmarked Ingredients',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 36),
                        child: Text(
                          '${ingredients.length} items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Padding(
                    // Add padding to the FridgeList
                    padding: EdgeInsets.only(left: 36),
                    child: FridgeList(
                      fridgeItems: List.generate(
                        ingredients.length,
                        (index) => FridgeListItem(
                          title: ingredients[index]['description'],
                          imageUrl: ingredients[index]['image'],
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
      height: 180, // Adjust the height as needed
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
