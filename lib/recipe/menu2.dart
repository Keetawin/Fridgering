import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Menu extends StatefulWidget {
  final String recipeID;
  final String recipeName;
  final String recipeImage;
  final List<String> recipeTags;
  final int recipeTime;

  Menu({
    required this.recipeID,
    required this.recipeName,
    required this.recipeImage,
    required this.recipeTags,
    required this.recipeTime,
  });

  @override
  _MenuState createState() => _MenuState(
        recipeID: recipeID,
        recipeName: recipeName,
        recipeImage: recipeImage,
        recipeTags: recipeTags,
        recipeTime: recipeTime,

        // Pass the bookmark status
      );
}

class _MenuState extends State<Menu> {
  final String recipeID;
  final String recipeName;
  final String recipeImage;
  final List<String> recipeTags;
  final int recipeTime;
  List<Map<String, dynamic>> ingredient = [];
  // You can replace this with the actual image URL if available
  int count = 1;
  int currentStepIndex = 0;

  Future<void> _fetchRecipes() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://fridgeringapi.fly.dev/recipes/$recipeID/ingredients'),
      );

      if (response.statusCode == 200) {
        // Successfully fetched recipes
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> ingredientList = data['data'];
        setState(() {
          ingredient = List<Map<String, dynamic>>.from(ingredientList);
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

  List<String> cookingSteps = [
    'Step 1: Prepare the ingredients',
    'Step 2: Cook the proteins',
    'Step 3: Saute the vegetables',
    'Step 4: Make the sauce',
    'Step 5: Combine and serve'
    // เพิ่มขั้นตอนตามที่ต้องการ
  ];

  _MenuState({
    required this.recipeID,
    required this.recipeName,
    required this.recipeImage,
    required this.recipeTags,
    required this.recipeTime,
  });

  void incrementCount() {
    setState(() {
      if (count < 7) {
        count++;
      }
    });
  }

  void decrementCount() {
    setState(() {
      if (count > 1) {
        count--;
      }
    });
  }

  Map<String, Map<String, dynamic>> listIngredients = {
    'Chicken': {
      'image': 'assets/images/pic1.jpg',
      'quantity': 200,
      'unit': 'g'
    },
    'Beef': {'image': 'assets/images/pic1.jpg', 'quantity': 150, 'unit': 'g'},
    'Fish': {'image': 'assets/images/pic1.jpg', 'quantity': 180, 'unit': 'g'},
    // เพิ่มวัตถุดิบและรายละเอียดตามที่ต้องการ
  };

  Set<String> selectedIngredients = {};

  // Widget buildIngredientsList(Set<String> selectedIngredients,
  //     Map<String, Map<String, dynamic>> allIngredients) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: allIngredients.keys.map((ingredient) {
  //       Map<String, dynamic> ingredientDetails = allIngredients[ingredient]!;
  //       String imagePath =
  //           ingredientDetails['image'] ?? 'default_image_path/default.png';
  //       int quantity =
  //           int.tryParse(ingredientDetails['quantity'].toString()) ?? 0;
  //       String unit = ingredientDetails['unit'] ?? '';

  //       return ListTile(
  //         leading: Image.asset(
  //           imagePath,
  //           width: 36,
  //           height: 36,
  //         ),
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               ingredient,
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             Text(
  //               '${quantity * count} ${unit}',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //         tileColor: selectedIngredients.contains(ingredient)
  //             ? Colors.grey[300]
  //             : null,
  //         onTap: () {},
  //       );
  //     }).toList(),
  //   );
  // }

  // Widget buildCookingStepPage(String step) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Cooking Step'),
  //       // เพิ่มปุ่มย้อนกลับ
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back),
  //         onPressed: () {
  //           // ถ้าไม่ได้อยู่ที่ขั้นตอนแรก
  //           if (currentStepIndex > 0) {
  //             currentStepIndex--;
  //             // ย้อนกลับไปยังหน้าขั้นตอนก่อนหน้านี้
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) =>
  //                     buildCookingStepPage(cookingSteps[currentStepIndex]),
  //               ),
  //             );
  //           } else {
  //             // ถ้าอยู่ที่ขั้นตอนแรก กลับไปหน้าเมนู
  //             Navigator.pop(context);
  //           }
  //         },
  //       ),
  //     ),
  //     body: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     step,
  //                     style: TextStyle(fontSize: 24),
  //                   ),
  //                   SizedBox(height: 20),
  //                 ],
  //               ),
  //             ),
  //             // ปุ่ม "Next Step" ด้วยสไตล์
  //             Container(
  //               height: 60,
  //               margin: EdgeInsets.all(36),
  //               width: double.infinity,
  //               child: TextButton(
  //                 child: Text(
  //                   "Next Step",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w700,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   // ตรวจสอบว่ายังมีขั้นตอนถัดไปหรือไม่
  //                   if (currentStepIndex < cookingSteps.length - 1) {
  //                     currentStepIndex++;
  //                     // เปลี่ยนไปยังหน้าขั้นตอนถัดไป
  //                     Navigator.pushReplacement(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => buildCookingStepPage(
  //                             cookingSteps[currentStepIndex]),
  //                       ),
  //                     );
  //                   } else {
  //                     // ถ้าเป็นขั้นตอนสุดท้ายแล้ว กลับไปหน้าเมนู
  //                     Navigator.pop(context);
  //                   }
  //                 },
  //                 style: TextButton.styleFrom(
  //                   backgroundColor: Theme.of(context).primaryColor,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              recipeImage,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFFAFAFA),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(43.0)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipeName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2.5),
                                Text(
                                  recipeTags.isNotEmpty
                                      ? recipeTags[0]
                                      : 'Food',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   widget.isBookmarked = !widget.isBookmarked;
                                  // });
                                  // print('Bookmark tapped');
                                },
                                child: Icon(
                                  Icons.bookmark_border,
                                  // widget.isBookmarked
                                  //     ? Icons.bookmark
                                  //     : Icons.bookmark_border,
                                  // color: widget.isBookmarked
                                  //     ? Theme.of(context).primaryColor
                                  //     : Colors.grey,
                                  // size: 40.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.soup_kitchen_outlined,
                                  size: 36,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(height: 4),
                              Text(
                                recipeTags.isNotEmpty
                                    ? recipeTags[1]
                                    : 'No Data',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.schedule_outlined,
                                  size: 36,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(height: 4),
                              Text(
                                '${recipeTime} Min',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.local_fire_department_outlined,
                                  size: 36,
                                  color: Theme.of(context).primaryColor),
                              SizedBox(height: 4),
                              Text(
                                '300 Kcal',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ingredients',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'How many servings?',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: decrementCount,
                                ),
                                Text(
                                  '$count',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: incrementCount,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: [
                              ExpansionTile(
                                title: Text('Ingredient',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                initiallyExpanded: false,
                                children: [
                                  // buildIngredientsList(
                                  //     selectedIngredients, listIngredients)
                                ],
                              ),
                              // Vegetable Ingredients

                              // Sauce Ingredients
                            ],
                          )),
                      Container(
                        height: 60,
                        margin:
                            EdgeInsets.symmetric(horizontal: 36, vertical: 42),
                        width: double.infinity,
                        child: TextButton(
                          child: Text(
                            "Make this menu",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {
                            // // เปลี่ยนไปยังหน้าขั้นตอนการทำอาหารแรก
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => buildCookingStepPage(
                            //         cookingSteps[currentStepIndex]),
                            //   ),
                            // );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
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
      ),
    );
  }
}
