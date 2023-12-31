import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../navbar.dart';

class AddPage extends StatefulWidget {
  final String ingredientID;
  final String? ingredientName;
  final String? userId;
  final String? userImage;
  final String? userName;
  final String? userEmail;

  const AddPage({
    Key? key,
    required this.ingredientID,
    required this.ingredientName,
    required this.userId,
    required this.userImage,
    required this.userName,
    required this.userEmail,
  }) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool isPinned = false;
  String expirationDate = 'DD/MM/YYYY';
  String quantityValue = ' ';
  String selectedUnit = ' ';

  Future<Map<String, dynamic>>? _ingredientDataFuture;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _ingredientDataFuture = _fetchIngredientData();
  }

  Future<Map<String, dynamic>> _fetchIngredientData() async {
    final response = await http.get(
      Uri.parse(
          'https://fridgeringapi.fly.dev/common_ingredient/${widget.ingredientID}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception(
          'Failed to fetch ingredient details. Status code: ${response.statusCode}');
    }
  }

  Future<void> _togglePinStatus() async {
    try {
      final userId = widget.userId;
      final ingredientID = widget.ingredientID;
      final baseUrl =
          'https://fridgeringapi.fly.dev/user/$userId/pin_ingredients/$ingredientID';

      if (isPinned) {
        // If already pinned, send a DELETE request to unpin
        final response = await http.delete(Uri.parse(baseUrl));

        if (response.statusCode == 200) {
          setState(() {
            isPinned = false;
          });
        } else {
          print(
              'Failed to unpin ingredient. Status code: ${response.statusCode}');
        }
      } else {
        // If not pinned, send a POST request to pin
        final response = await http.post(Uri.parse(baseUrl));

        if (response.statusCode == 200) {
          setState(() {
            isPinned = true;
          });
        } else {
          print(
              'Failed to pin ingredient. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadUser() async {
    try {
      final userResponse = await http.get(
          Uri.parse('https://fridgeringapi.fly.dev/user/${widget.userId}'));

      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(userResponse.body);
        final Map<String, dynamic> userList = userData['data'];
        final int ingredientIdAsInt = int.parse(widget.ingredientID);

        setState(() {
          isPinned = (userList['pinnedIngredients'] as List?)
                  ?.contains(ingredientIdAsInt) ??
              false;
        });
      } else {
        print(
            'Failed to load user data. Status code: ${userResponse.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  Future<void> addToFridge() async {
    final String apiUrl =
        'https://fridgeringapi.fly.dev/user/${widget.userId}/ingredients';

    final Map<String, dynamic> postData = {
      'addedDate': DateTime.now().toIso8601String(),
      'amount': int.parse(quantityValue),
      'expiredDate': expirationDate.isEmpty
          ? null
          : DateFormat('dd/MM/yyyy').parse(expirationDate).toIso8601String(),
      'fcdId': int.parse(widget.ingredientID),
      'name': widget.ingredientName,
      'unit': selectedUnit,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      // Ingredient added successfully, show congratulatory alert
      print('Ingredient added successfully');

      // Show a congratulatory alert box
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ingredient Added'),
            content: Text('Ingredient added successfully!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate back to the first screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Navbar(
                              userId: widget.userId,
                              userImage: widget.userImage,
                              userName: widget.userName,
                              userEmail: widget.userEmail,
                            )),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Failed to add ingredient, show an error alert
      print('Failed to add ingredient. Status code: ${response.statusCode}');

      // Show an alert box for failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Ingredient Failed'),
            content: Text('Failed to add ingredient. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _ingredientDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still running, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If we run into an error, display an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If the Future is completed, display the data
            Map<String, dynamic>? ingredientData = snapshot.data;

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.network(
                    ingredientData?['image'] ??
                        'assets/images/default_image.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.7,
                  minChildSize: 0.7,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFFAFAFA),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(43.0)),
                        ),
                        padding: const EdgeInsets.all(31.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 10.0),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        (ingredientData?['description'] ??
                                            'Unknown'),
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: GestureDetector(
                                    onTap: _togglePinStatus,
                                    child: Icon(
                                      isPinned
                                          ? Icons.bookmark_rounded
                                          : Icons.bookmark_outline_rounded,
                                      color: isPinned
                                          ? theme.primaryColor
                                          : Colors.grey,
                                      size: 40.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSmallCircularProgressBar(
                                  // Set a placeholder percentage (100%)
                                  'Energy',
                                  'Energy',
                                  Icons.local_fire_department,

                                  ingredientData,
                                ),
                                _buildSmallCircularProgressBar(
                                  // Set a placeholder percentage (100%)
                                  'Protein',
                                  'Protein',
                                  Icons.food_bank,

                                  ingredientData,
                                ),
                                _buildSmallCircularProgressBar(
                                  // Set a placeholder percentage (100%)
                                  'Carbohydrate, by difference',
                                  'Carb',
                                  Icons.local_dining,

                                  ingredientData,
                                ),
                                _buildSmallCircularProgressBar(
                                  // Set a placeholder percentage (100%)
                                  'Total lipid (fat)',
                                  'Fat',
                                  Icons.local_pizza,

                                  ingredientData,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nutrition Facts',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    ingredientData?['foodCategory']
                                            ['description'] ??
                                        'Unknown',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 22.0),
                                  Text(
                                    'Add Ingredient to Fridge', // Replace with the actual description
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            initialValue: '',
                                            decoration: InputDecoration(
                                              labelText: 'Amount',
                                              hintText: '100, 200, ...',
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                            ),
                                            onChanged: (value) {
                                              // Handle the numeric input
                                              setState(() {
                                                quantityValue = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: selectedUnit.isEmpty
                                                ? selectedUnit
                                                : null,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedUnit = value!;
                                              });
                                            },
                                            items: [
                                              "cup",
                                              "cups",
                                              "tbsp",
                                              "tsp",
                                              "ounce",
                                              "oz",
                                              "g",
                                              "cc",
                                              "gram",
                                              "kg",
                                              "pound",
                                              "lb",
                                              "ea",
                                              "pcs",
                                              "ml",
                                              "L",
                                              "gallon",
                                              "handful",
                                              "splash",
                                              "pinch",
                                              "drop",
                                              "package",
                                              "can",
                                              "jar",
                                              "bottle",
                                              "bunch",
                                              "clove",
                                              "slice",
                                              "head",
                                              "dash",
                                              "sprig"
                                            ].map((unit) {
                                              return DropdownMenuItem<String>(
                                                value: unit,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(
                                                      left: 16.0),
                                                  child: Text(unit),
                                                ),
                                              );
                                            }).toList(),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              hintText: 'Unit',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expire',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 12.0),
                                  InkWell(
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2101),
                                      );

                                      if (pickedDate != null &&
                                          pickedDate != DateTime.now()) {
                                        setState(() {
                                          expirationDate =
                                              '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                          hintText: 'DD/MM/YYYY',
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 10),
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
                                        ),
                                        child: Text(
                                          expirationDate,
                                          style: expirationDate == 'DD/MM/YYYY'
                                              ? TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      16) // Set color to grey
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'suggession: ${ingredientData?["name"]} has 7 days life time.',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Container(
                              width: double.infinity,
                              height: 56.0,
                              child: ElevatedButton(
                                onPressed: addToFridge,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                child: Text(
                                  'Add to Fridge',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 40.0,
                  left: 16.0,
                  child: GestureDetector(
                    onTap: () {
                      // Pop the current screen to go back
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSmallCircularProgressBar(
    String label,
    String name,
    IconData iconData,
    Map<String, dynamic>? ingredientData,
  ) {
    ThemeData theme = Theme.of(context);

    // Extract the nutrient based on the label
    Map<String, dynamic>? nutrient =
        ingredientData?['foodNutritients']?.firstWhere(
      (nutrient) => nutrient['nutrient']['name'] == label,
      orElse: () => null,
    );

    // Extract the amount if found
    double? nutrientAmount = nutrient?['amount']?.toDouble();
    String unitName =
        nutrient?['nutrient']['unitName'] ?? ''; // Extract unitName

    // Calculate energy for each nutrient
    double energy;
    if (label == 'Energy') {
      energy = nutrientAmount ?? 0;
    } else {
      double proteinAmount = (ingredientData?['foodNutritients']
              ?.firstWhere(
                (nutrient) => nutrient['nutrient']['name'] == 'Protein',
                orElse: () => null,
              )?['amount']
              ?.toDouble()) ??
          0;
      double carbAmount = (ingredientData?['foodNutritients']
              ?.firstWhere(
                (nutrient) =>
                    nutrient['nutrient']['name'] ==
                    'Carbohydrate, by difference',
                orElse: () => null,
              )?['amount']
              ?.toDouble()) ??
          0;
      double fatAmount = (ingredientData?['foodNutritients']
              ?.firstWhere(
                (nutrient) =>
                    nutrient['nutrient']['name'] == 'Total lipid (fat)',
                orElse: () => null,
              )?['amount']
              ?.toDouble()) ??
          0;

      // Calculate energy
      energy = (proteinAmount * 4) + (carbAmount * 4) + (fatAmount * 9);
    }

    // Declare nutrientPercentage before the if conditions
    double nutrientPercentage;

    // Calculate percentage inside each condition
    if (label == 'Protein') {
      nutrientPercentage = nutrientAmount! * 4 / energy;
    } else if (label == 'Carbohydrate, by difference') {
      nutrientPercentage = nutrientAmount! * 4 / energy;
    } else if (label == 'Total lipid (fat)') {
      nutrientPercentage = nutrientAmount! * 9 / energy;
    } else {
      nutrientPercentage = nutrientAmount! / energy;
    }

    return Expanded(
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 4.0,
            percent: (label == 'Energy') ? 1.0 : nutrientPercentage,
            center: Icon(
              iconData,
              size: 30.0,
              color: theme.primaryColor,
            ),
            progressColor: theme.primaryColor,
            backgroundColor: Colors.grey,
          ),
          SizedBox(height: 8.0),
          Text(
            name,
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          SizedBox(height: 4.0),
          Text(
            '$nutrientAmount $unitName', // Display unitName or percentage
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
