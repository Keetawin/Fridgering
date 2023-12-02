import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ingredient.dart';
import '../ingredient/ingre.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FridgePage extends StatefulWidget {
  final String? userId;

  FridgePage({this.userId});

  @override
  _FridgePageState createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  List<Map<String, dynamic>> ingredients = [];
  List<String> ingredientsimage = [];

  void _navigateToNotiScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ingredient(
          userId: widget.userId,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadIngredient();
  }

  Future<void> _loadIngredient() async {
    try {
      final ingredientResponse = await http.get(Uri.parse('https://fridgeringapi.fly.dev/user/${widget.userId}/ingredients'));

      if (ingredientResponse.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(ingredientResponse.body);
        final List<dynamic> userIngredientsList = responseData['data'];

        for (var ingredients in responseData['data']) {
              final ingredientsId = ingredients['fcdId'];
              final imageResponse =
                  await http.get(Uri.parse('https://fridgeringapi.fly.dev/common_ingredient/$ingredientsId'));

              if (imageResponse.statusCode == 200) {
                Map<String, dynamic> ingredientsimgData = json.decode(imageResponse.body);
                final Map<String, dynamic> ingredientsData = ingredientsimgData['data'];

                final String ingredientsimg = ingredientsData['image'];

                setState(() {
                  ingredientsimage.add(ingredientsimg);
                });
              } else {
                print('Failed to load ingredients for recipe $ingredientsId. Status code: ${imageResponse.statusCode}');
              }
            }
        
        setState(() {
          ingredients = List<Map<String, dynamic>>.from(userIngredientsList);
        });

      } else {
        print('Failed to load ingredient data. Status code: ${ingredientResponse.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  void _updateIngredientData(int fdcId, int updatedAmount, String updatedUnit) async {
  try {
    // Create the updated ingredient data
    Map<String, dynamic> updatedIngredientData = {
      "amount": updatedAmount,
      "unit": updatedUnit,
    };

    // Make an HTTP PUT request to update the ingredient data
    final response = await http.put(
      Uri.parse('https://fridgeringapi.fly.dev/user/${widget.userId}/ingredients/$fdcId'),
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
      print('Failed to update ingredient data. Status code: ${response.statusCode}');
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
      Uri.parse('https://fridgeringapi.fly.dev/user/${widget.userId}/ingredients/$fcdId'),
    );

    if (response.statusCode == 200) {
      // Ingredient data deleted successfully
      print('Ingredient data deleted successfully.');
      // You can update the local state or perform any other actions as needed
      // For example, you might want to reload the ingredient data
      _loadIngredient();
    } else {
      // Failed to delete ingredient data
      print('Failed to delete ingredient data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Handle other errors
    print('Error: $e');
  }
}


void _showEditModal(BuildContext context, Map<String, dynamic> ingredient) {
  String quantity = ingredient['amount'].toString() ?? '';
  String selectedUnit = (ingredient['unit'] as String?)?.toUpperCase() ?? 'PCS';
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
                      int? updatedAmount = int.tryParse(quantityController.text);
                      if (updatedAmount != null) {
                        // Example: Call a function to update the data
                        _updateIngredientData(ingredient['fcdId'], updatedAmount, selectedUnit);
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
                    margin: EdgeInsets.symmetric(horizontal: 36, vertical: 18),
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



  // List<Map<String, String>> getFilteredIngredients() {
  //   if (selectedFilter == 'all') {
  //     return allIngredients;
  //   } else {
  //     List<Map<String, String>> filteredList = allIngredients
  //         .where((ingredient) => ingredient['category'] == selectedFilter)
  //         .toList();
  //     return filteredList;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 48.0),
          Container(
            padding: const EdgeInsets.only(
              right: 27.0,
              left: 36.0,
              top: 18.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fridge',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: _navigateToNotiScreen,
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 36.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ingredients',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  '${ingredients.length} items',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          // SizedBox(height: 20.0),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       buildFilterBox('All', 'all'),
          //       buildFilterBox('Vegetable', 'vegetable'),
          //       buildFilterBox('Fruit', 'fruit'),
          //       buildFilterBox('Meat', 'meat'),
          //     ],
          //   ),
          // ),
          SizedBox(height: 20.0),
          Expanded(
          child: ingredients.isEmpty
              ? Container(
                  height: 480, // Adjust the height as needed
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
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 148 / 240,
                    ),
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      return buildIngredientCard(
                        ingredients[index],
                        ingredientsimage[index],
                      );
                    },
                  ),
                ),
              ),
        ],
      ),
    );
  }

  // Widget buildFilterBox(String text, String filter) {
  //   bool isSelected = selectedFilter == filter;
  //   ThemeData theme = Theme.of(context);

  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedFilter = filter;
  //       });
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 18.0,
  //         vertical: 15.0,
  //       ),
  //       decoration: BoxDecoration(
  //         color: isSelected ? theme.primaryColor : Colors.white,
  //         borderRadius: BorderRadius.circular(15.0),
  //         boxShadow: isSelected
  //             ? [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.5),
  //                   spreadRadius: 3,
  //                   blurRadius: 7,
  //                   offset: Offset(0, 3),
  //                 ),
  //               ]
  //             : [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.5), // Adjust shadow color
  //                   spreadRadius: 2, // Increase or decrease the spread
  //                   blurRadius: 5, // Increase or decrease the blur
  //                   offset: Offset(0, 2),
  //                 ),
  //               ],
  //       ),
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //           color: isSelected ? Colors.white : theme.primaryColor,
  //           fontWeight: FontWeight.w500,
  //           fontSize: 16.0,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget buildIngredientCard(Map<String, dynamic> ingredient, String image) {
     DateTime dateBuyDateTime = DateTime.fromMillisecondsSinceEpoch(ingredient['addedDate']["_seconds"] * 1000);
    DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(ingredient['expiredDate']["_seconds"] * 1000);

    DateTime currentDate = DateTime.now();
    int daysLeft = expirationDate.difference(currentDate).inDays;
    int period = expirationDate.difference(dateBuyDateTime).inDays;

    return GestureDetector(
        onTap: () {
          _showEditModal(context, ingredient);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            height: 240,
            width: 150,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15.0),
                  QuantityBox(quantity: ingredient['amount'], unit: ingredient['unit']),
                  SizedBox(height: 10.0),
                  ClipRRect(
                    child: Image.network(
                      image,
                      height: 87,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ExpirationLifeBar(
                    daysLeft: daysLeft,
                    height: 5.0,
                    width: 120.0,
                    period: period,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    daysLeft >= 0 ? '$daysLeft Day Left' : 'Expired',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      ingredient['name'] ?? 'Unknown',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    DateFormat('dd/MM/yy').format(expirationDate),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
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

class ExpirationLifeBar extends StatelessWidget {
  final int daysLeft;
  final double height;
  final double width;
  final int period;

  ExpirationLifeBar(
      {required this.daysLeft,
      this.height = 8.0,
      this.width = 100.0,
      required this.period});

  @override
  Widget build(BuildContext context) {
    double lifePercentage = daysLeft >= 0 ? (daysLeft / period) : 0.0;
    Color lifeBarColor = _getLifeBarColor(lifePercentage);

    return Container(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2), // Make it circular
        child: LinearProgressIndicator(
          value: lifePercentage,
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(lifeBarColor),
          minHeight: height,
        ),
      ),
    );
  }

  Color _getLifeBarColor(double percentage) {
    if (1 > percentage && percentage >= 0.6) {
      return Colors.green;
    } else if (0.6 > percentage && percentage >= 0.3) {
      return Colors.orange;
    } else if (0.3 > percentage && percentage >= 0.0) {
      return Colors.red;
    } else {
      return Colors.grey; // You can set this to any color for an empty state
    }
  }
}

class QuantityBox extends StatelessWidget {
  final int quantity;
  final String unit;

  const QuantityBox({
    Key? key,
    required this.quantity,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.primaryColor, // Adjust color as needed
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Text(
        '$quantity ${unit.toUpperCase()}', // Make unit uppercase
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}

