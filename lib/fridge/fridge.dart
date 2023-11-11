import 'package:flutter/material.dart';

class FridgePage extends StatefulWidget {
  const FridgePage({Key? key}) : super(key: key);

  @override
  _FridgePageState createState() => _FridgePageState();
}
class _FridgePageState extends State<FridgePage> {
  String selectedFilter = 'all';

  List<Map<String, String>> allIngredients = [
    {'name': 'Carrot', 'category': 'vegetable'},
    {'name': 'Apple', 'category': 'fruit'},
    {'name': 'Chicken', 'category': 'meat'},
    {'name': 'Tomato', 'category': 'vegetable'},
    // Add more ingredients as needed
  ];


  List<Map<String, String>> getFilteredIngredients() {
    if (selectedFilter == 'all') {
      return allIngredients;
    } else {
      return allIngredients.where((ingredient) => ingredient['category'] == selectedFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 60.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Fridge',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),  
                  ),
                  Icon(
                    Icons.notifications,
                    color: Colors.black,
                    size: 40.0,
                  )
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ingredients',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),  
                    ),
                    Text(
                      '35 items',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey
                      ),  
                    ),
                  ],
                ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildFilterBox('All', 'all'),
                buildFilterBox('Vegetable', 'vegetable'),
                buildFilterBox('Fruit', 'fruit'),
                buildFilterBox('Meat', 'meat'),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 148 / 253,
                ),
                itemCount: getFilteredIngredients().length,
                itemBuilder: (context, index) {
                  return buildIngredientCard(getFilteredIngredients()[index]['name']!);
                },
              ),
            ),
            ),
          ],
      ),
    );
  }

  Widget buildFilterBox(String text, String filter) {
    bool isSelected = selectedFilter == filter;
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Adjust shadow color
                    spreadRadius: 2, // Increase or decrease the spread
                    blurRadius: 5, // Increase or decrease the blur
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.primaryColor,
            fontWeight: FontWeight.normal,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
    Widget buildIngredientCard(String ingredientName) {
  return AspectRatio(
    aspectRatio: 148 / 253, // Set the desired aspect ratio
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... (rest of the content remains the same)
        ],
      ),
    ),
  );
}
}
