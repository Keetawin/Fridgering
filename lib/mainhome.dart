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

  MainhomePage(
      {required this.userId, required this.userImage, required this.userName});

  @override
  MainhomePageState createState() => MainhomePageState();
}

class MainhomePageState extends State<MainhomePage> {
  List<String> dietaryRestrictions = [];
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> ingredients = [];
  List<Map<String, dynamic>> user = [];
  List<String> ingredientsimage = [];
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
    _loadUser();
    _loadIngredient();
  }

  Future<void> _loadUser() async {
    try {
      final userResponse = await http.get(
          Uri.parse('https://fridgeringapi.fly.dev/user/${widget.userId}'));

      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(userResponse.body);
        final Map<String, dynamic> userList = userData['data'];

        // Use 'List<String>' explicitly to ensure correct typing
        List<String> dietaryRestrictionsData = List<String>.from(
            userList['preferences']['dietaryRestriction'] ?? []);
        print('Dietary Restrictions: $dietaryRestrictionsData');

        setState(() {
          dietaryRestrictions = dietaryRestrictionsData;
          user = [userList];
        });
        _loadRecipes();
      } else {
        print(
            'Failed to load user data. Status code: ${userResponse.statusCode}');
        _loadRecipes();
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  Future<void> _loadRecipes() async {
    try {
      final List<String> restrictions =
          dietaryRestrictions.isNotEmpty ? dietaryRestrictions : [''];

      for (String restriction in restrictions) {
        final recipesResponse = await http.get(Uri.parse(
            'https://fridgeringapi.fly.dev/recipes/search?tags=["$restriction"]&userID=${widget.userId}'));
        if (recipesResponse.statusCode == 200) {
          final Map<String, dynamic> recipesData =
              json.decode(recipesResponse.body);
          final List<dynamic> allRecipes = recipesData['data'];

          allRecipes.shuffle();

          // Take the first 5 recipes
          final List<dynamic> randomRecipes = allRecipes.take(5).toList();

          for (var recipe in randomRecipes) {
            final recipeId = recipe['recipeID'];
            final ingredientsResponse = await http.get(Uri.parse(
                'https://fridgeringapi.fly.dev/recipes/$recipeId/ingredients'));

            if (ingredientsResponse.statusCode == 200) {
              Map<String, dynamic> ingredientsData =
                  json.decode(ingredientsResponse.body);
              final List<dynamic> ingredientsList = ingredientsData['data'];

              int count = ingredientsList.length;
              setState(() {
                ingredientsLenght.add(count);
              });
            } else {
              print(
                  'Failed to load ingredients for recipe $recipeId. Status code: ${ingredientsResponse.statusCode}');
            }
          }
          setState(() {
            recipes.addAll(List<Map<String, dynamic>>.from(randomRecipes));
          });
        } else {
          print(
              'Failed to load recipes for $restriction. Status code: ${recipesResponse.statusCode}');
        }
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  Future<void> _loadIngredient() async {
    try {
      final ingredientResponse = await http.get(Uri.parse(
          'https://fridgeringapi.fly.dev/user/${widget.userId}/ingredients'));

      if (ingredientResponse.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(ingredientResponse.body);
        final List<dynamic> userIngredientsList = responseData['data'];

        for (var ingredients in responseData['data']) {
          final ingredientsId = ingredients['fcdId'];
          final imageResponse = await http.get(Uri.parse(
              'https://fridgeringapi.fly.dev/common_ingredient/$ingredientsId'));

          if (imageResponse.statusCode == 200) {
            Map<String, dynamic> ingredientsimgData =
                json.decode(imageResponse.body);
            final Map<String, dynamic> ingredientsData =
                ingredientsimgData['data'];

            final String ingredientsimg = ingredientsData['image'];

            setState(() {
              ingredientsimage.add(ingredientsimg);
            });
          } else {
            print(
                'Failed to load ingredients for recipe $ingredientsId. Status code: ${imageResponse.statusCode}');
          }
        }

        setState(() {
          ingredients = List<Map<String, dynamic>>.from(userIngredientsList);
        });
      } else {
        print(
            'Failed to load ingredient data. Status code: ${ingredientResponse.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  void _showEditModal(BuildContext context, Map<String, dynamic> ingredient) {
    String quantity = ingredient['amount'].toString() ?? '';
    String selectedUnit =
        (ingredient['unit'] as String?)?.toUpperCase() ?? 'PCS';
    List<String> parts = quantity.split(' ');

    TextEditingController quantityController =
        TextEditingController(text: parts.isNotEmpty ? parts[0] : '');
    bool isDeleting = false;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Edit Ingredient',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: quantityController,
                    onChanged: (value) {
                      setState(() {
                        // Update the variable isDeleting based on the text field content
                        isDeleting = value == '0';
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      suffixText: selectedUnit,
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedUnit,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedUnit = newValue;
                        });
                      }
                    },
                    items: <String>['PCS', 'G', 'KG', 'L']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () {
                      if (isDeleting || quantityController.text.isEmpty) {
                        _deleteIngredientData(ingredient['fcdId']);
                      } else {
                        int? updatedAmount =
                            int.tryParse(quantityController.text);
                        if (updatedAmount != null) {
                          // Example: Call a function to update the data
                          _updateIngredientData(
                              ingredient['fcdId'], updatedAmount, selectedUnit);
                        } else {
                          // Handle the case where parsing fails (e.g., non-numeric input)
                          print('Invalid quantity input');
                          return;
                        }
                      }

                      Navigator.pop(context); // Close the modal
                    },
                    style: ElevatedButton.styleFrom(
                      primary: isDeleting || quantityController.text.isEmpty
                          ? Color(0xFFFF6464)
                          : Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      textStyle: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        isDeleting || quantityController.text.isEmpty
                            ? 'Delete'
                            : 'Save',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _updateIngredientData(
      int fdcId, int updatedAmount, String updatedUnit) async {
    try {
      // Create the updated ingredient data
      Map<String, dynamic> updatedIngredientData = {
        "amount": updatedAmount,
        "unit": updatedUnit,
      };

      // Make an HTTP PUT request to update the ingredient data
      final response = await http.put(
        Uri.parse(
            'https://fridgeringapi.fly.dev/user/${widget.userId}/ingredients/$fdcId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedIngredientData),
      );

      if (response.statusCode == 200) {
        // Ingredient data updated successfully
        print('Ingredient data updated successfully.');
        // You can update the local state or perform any other actions as needed
        // For example, you might want to reload the ingredient data
        _loadIngredient();
      } else {
        // Failed to update ingredient data
        print(
            'Failed to update ingredient data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  void _deleteIngredientData(int fcdId) async {
    try {
      // Make an HTTP DELETE request to delete the ingredient data
      final response = await http.delete(
        Uri.parse(
            'https://fridgeringapi.fly.dev/user/${widget.userId}/ingredients/$fcdId'),
      );

      if (response.statusCode == 200) {
        // Ingredient data deleted successfully
        print('Ingredient data deleted successfully.');
        // You can update the local state or perform any other actions as needed
        // For example, you might want to reload the ingredient data
        _loadIngredient();
      } else {
        // Failed to delete ingredient data
        print(
            'Failed to delete ingredient data. Status code: ${response.statusCode}');
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
                      Center(
                        child: recipes.isEmpty
                            ? Container(
                                height: 290,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'You don\'t have any recipes.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Explore and add recipes to your collection!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 290,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      recipes.length > 5 ? 5 : recipes.length,
                                  itemExtent: 290,
                                  itemBuilder: (context, index) {
                                    if (index < recipes.length &&
                                        index < ingredientsLenght.length) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: CardItem(
                                          index: index,
                                          user: user.isNotEmpty ? user[0] : {},
                                          recipeId: recipes[index]['recipeID'],
                                          imageUrl: recipes[index]['image'][0],
                                          tagAndTitle: recipes[index]['name'],
                                          tags: recipes[index]['tags'],
                                          timeToCook: recipes[index]
                                              ['cookTime'],
                                          numIngredients:
                                              ingredientsLenght[index],
                                          onTap: () {
                                            setState(() {});
                                          },
                                        ),
                                      );
                                    } else {
                                      return SizedBox
                                          .shrink(); // Or some placeholder if data is not available
                                    }
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Recipe section
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
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
                              '${ingredients.length} items',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ]),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                Container(
                  // Recipe section
                  padding: EdgeInsets.only(left: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ingredients.isEmpty
                          ? Container(
                              height: 190, // Adjust the height as needed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'You don\'t have any ingredients.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Add some to get started!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : FridgeList(
                              fridgeItems: List.generate(
                                ingredients.length,
                                (index) => FridgeListItem(
                                  title: ingredients[index]['name'],
                                  quantity: ingredients[index]['amount'],
                                  unit: ingredients[index]['unit'],
                                  imageUrl: ingredientsimage[index],
                                  addedDate: ingredients[index]['addedDate'],
                                  expiredDate: ingredients[index]
                                      ['expiredDate'],
                                  onTap: () => _showEditModal(
                                      context, ingredients[index]),
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
    return Directionality(
      textDirection: TextDirection
          .ltr, // or TextDirection.rtl, depending on your app's direction
      child: Container(
        height: 250, // Adjust the height as needed
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: fridgeItems.length,
          itemBuilder: (context, index) {
            return fridgeItems[index];
          },
        ),
      ),
    );
  }
}
