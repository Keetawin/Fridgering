import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final String imageUrl;
  final String tagAndTitle;
  final List<String> tags;
  final int timeToCook;
  final int numIngredients;
  bool isBookmarked;


  Menu({
    required this.imageUrl,
    required this.tagAndTitle,
    required this.tags,
    required this.timeToCook,
    required this.numIngredients,
    required this.isBookmarked,
  });

  @override
  _MenuState createState() => _MenuState(
        imageUrl: imageUrl,
        tagAndTitle: tagAndTitle,
        tags: tags,
        timeToCook: timeToCook,
        isBookmarked: isBookmarked,
        numIngredients: numIngredients, // Pass the bookmark status
      );
}

class _MenuState extends State<Menu> {
  final String imageUrl;
  final String tagAndTitle;
  final List<String> tags;
  final int timeToCook;
  final bool isBookmarked;
  final int numIngredients;
  int count = 1;
  int currentStepIndex = 0;

  List<String> cookingSteps = [
    'Step 1: Prepare the ingredients',
    'Step 2: Cook the proteins',
    'Step 3: Saute the vegetables',
    'Step 4: Make the sauce',
    'Step 5: Combine and serve'
    // เพิ่มขั้นตอนตามที่ต้องการ
  ];

  _MenuState({
    required this.imageUrl,
    required this.tagAndTitle,
    required this.tags,
    required this.timeToCook,
    required this.isBookmarked,
    required this.numIngredients,
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

  Map<String, Map<String, dynamic>> proteinIngredients = {
    'Chicken': {
      'image': 'assets/images/pic1.jpg',
      'quantity': 200,
      'unit': 'g'
    },
    'Beef': {'image': 'assets/images/pic1.jpg', 'quantity': 150, 'unit': 'g'},
    'Fish': {'image': 'assets/images/pic1.jpg', 'quantity': 180, 'unit': 'g'},
    // เพิ่มวัตถุดิบและรายละเอียดตามที่ต้องการ
  };

  Map<String, Map<String, dynamic>> vegetableIngredients = {
    'Carrot': {'image': 'assets/images/pic1.jpg', 'quantity': 100, 'unit': 'g'},
    'Broccoli': {
      'image': 'assets/images/pic1.jpg',
      'quantity': 120,
      'unit': 'g'
    },
    'Spinach': {'image': 'assets/images/pic1.jpg', 'quantity': 80, 'unit': 'g'},
    // เพิ่มวัตถุดิบและรายละเอียดตามที่ต้องการ
  };

  Map<String, Map<String, dynamic>> sauceIngredients = {
    'Soy Sauce': {
      'image': 'assets/images/pic1.jpg',
      'quantity': 2,
      'unit': 'tbsp'
    },
    'Tomato Sauce': {
      'image': 'assets/images/pic1.jpg',
      'quantity': 3,
      'unit': 'tbsp'
    },
    'Olive Oil': {
      'image': 'assets/images/pic1.jpg',
      'quantity': 1,
      'unit': 'tbsp'
    },
    // เพิ่มวัตถุดิบและรายละเอียดตามที่ต้องการ
  };

  Set<String> selectedProteinIngredients = {};
  Set<String> selectedVegetableIngredients = {};
  Set<String> selectedSauceIngredients = {};

  void toggleIngredient(String ingredient, String category) {
    setState(() {
      Set<String> selectedIngredients;

      switch (category) {
        case 'Protein':
          selectedIngredients = selectedProteinIngredients;
          break;
        case 'Vegetable':
          selectedIngredients = selectedVegetableIngredients;
          break;
        case 'Sauce':
          selectedIngredients = selectedSauceIngredients;
          break;
        default:
          return;
      }

      if (selectedIngredients.contains(ingredient)) {
        selectedIngredients.remove(ingredient);
      } else {
        selectedIngredients.add(ingredient);
      }
    });
  }

  Widget buildIngredientsList(Set<String> selectedIngredients,
      Map<String, Map<String, dynamic>> allIngredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: allIngredients.keys.map((ingredient) {
        Map<String, dynamic> ingredientDetails = allIngredients[ingredient]!;
        String imagePath =
            ingredientDetails['image'] ?? 'default_image_path/default.png';
        int quantity =
            int.tryParse(ingredientDetails['quantity'].toString()) ?? 0;
        String unit = ingredientDetails['unit'] ?? '';

        return ListTile(
          leading: Image.asset(
            imagePath,
            width: 36,
            height: 36,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ingredient,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${quantity * count} ${unit}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          tileColor: selectedIngredients.contains(ingredient)
              ? Colors.grey[300]
              : null,
          onTap: () {
            toggleIngredient(ingredient, 'Protein');
          },
        );
      }).toList(),
    );
  }

  Widget buildCookingStepPage(String step) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cooking Step'),
        // เพิ่มปุ่มย้อนกลับ
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // ถ้าไม่ได้อยู่ที่ขั้นตอนแรก
            if (currentStepIndex > 0) {
              currentStepIndex--;
              // ย้อนกลับไปยังหน้าขั้นตอนก่อนหน้านี้
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      buildCookingStepPage(cookingSteps[currentStepIndex]),
                ),
              );
            } else {
              // ถ้าอยู่ที่ขั้นตอนแรก กลับไปหน้าเมนู
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      step,
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              // ปุ่ม "Next Step" ด้วยสไตล์
              Container(
                height: 60,
                margin: EdgeInsets.all(36),
                width: double.infinity,
                child: TextButton(
                  child: Text(
                    "Next Step",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    // ตรวจสอบว่ายังมีขั้นตอนถัดไปหรือไม่
                    if (currentStepIndex < cookingSteps.length - 1) {
                      currentStepIndex++;
                      // เปลี่ยนไปยังหน้าขั้นตอนถัดไป
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => buildCookingStepPage(
                              cookingSteps[currentStepIndex]),
                        ),
                      );
                    } else {
                      // ถ้าเป็นขั้นตอนสุดท้ายแล้ว กลับไปหน้าเมนู
                      Navigator.pop(context);
                    }
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 320,
              child: Stack(
                children: [
                  // Image
                  Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Back button
                  Positioned(
                    top: 48,
                    left: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  // Rounded bottom border
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(400),
                        ),
                        color: Color(0xFFFAFAFA),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Align the text to the left
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tagAndTitle,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.5),
                    Text(
                      tags[1],
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
                      setState(() {
                        widget.isBookmarked = !widget.isBookmarked;
                      });
                      print('Bookmark tapped');
                    },
                    child: Icon(
                      widget.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: widget.isBookmarked
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      size: 40.0,
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
                        size: 36, color: Theme.of(context).primaryColor),
                    SizedBox(height: 4),
                    Text(
                      '${tags[0]}',
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
                        size: 36, color: Theme.of(context).primaryColor),
                    SizedBox(height: 4),
                    Text(
                      '${timeToCook} Min',
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
                        size: 36, color: Theme.of(context).primaryColor),
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
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(children: [
                ExpansionTile(
                  title: Text('Protein',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  initiallyExpanded: false,
                  children: [
                    buildIngredientsList(
                        selectedProteinIngredients, proteinIngredients)
                  ],
                ),
                // Vegetable Ingredients
                ExpansionTile(
                  title: Text('Vegetable',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  initiallyExpanded: false,
                  children: [
                    buildIngredientsList(
                        selectedVegetableIngredients, vegetableIngredients)
                  ],
                ),
                // Sauce Ingredients
                ExpansionTile(
                  title: Text('Sauce',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  initiallyExpanded: false,
                  children: [
                    buildIngredientsList(
                        selectedSauceIngredients, sauceIngredients)
                  ],
                ),

                Container(
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 36, vertical: 42),
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
                      // เปลี่ยนไปยังหน้าขั้นตอนการทำอาหารแรก
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => buildCookingStepPage(
                              cookingSteps[currentStepIndex]),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
