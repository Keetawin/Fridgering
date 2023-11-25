import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ingredient.dart';
import '../ingredient/ingre.dart';

class FridgePage extends StatefulWidget {
  const FridgePage({Key? key}) : super(key: key);

  @override
  _FridgePageState createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  String selectedFilter = 'all';

  List<Map<String, String>> allIngredients = [
    {
      'quantity': '2 PCS',
      'image': 'assets/images/pic1.jpg',
      'name': 'Carrot',
      'category': 'vegetable',
      'datebuy': '20/11/23',
      'expiredate': '30/12/23'
    },
    {
      'quantity': '4 PCS',
      'image': 'assets/images/pic2.jpg',
      'name': 'Apple',
      'category': 'fruit',
      'datebuy': '11/11/23',
      'expiredate': '17/11/23'
    },
    {
      'quantity': '600 G',
      'image': 'assets/images/pic3.jpg',
      'name': 'Chicken',
      'category': 'meat',
      'datebuy': '9/11/23',
      'expiredate': '17/11/23'
    },
    {
      'quantity': '600 G',
      'image': 'assets/images/pic1.jpg',
      'name': 'Tomato',
      'category': 'vegetable',
      'datebuy': '12/11/23',
      'expiredate': '17/11/23'
    },
    // Add more ingredients as needed
  ];

  void _navigateToNotiScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Ingredient(),
      ),
    );
  }

  List<Map<String, String>> getFilteredIngredients() {
    if (selectedFilter == 'all') {
      return allIngredients;
    } else {
      List<Map<String, String>> filteredList = allIngredients
          .where((ingredient) => ingredient['category'] == selectedFilter)
          .toList();
      return filteredList;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Selected Filter: $selectedFilter');
    print('Filtered Ingredients: ${getFilteredIngredients()}');
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
                  '${allIngredients.length} items',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildFilterBox('All', 'all'),
                buildFilterBox('Vegetable', 'vegetable'),
                buildFilterBox('Fruit', 'fruit'),
                buildFilterBox('Meat', 'meat'),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 148 / 240,
                ),
                itemCount: getFilteredIngredients().length,
                itemBuilder: (context, index) {
                  return buildIngredientCard(getFilteredIngredients()[index]);
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
          horizontal: 18.0,
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
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget buildIngredientCard(Map<String, String> ingredient) {
    DateTime dateBuy =
        DateFormat('dd/MM/yy').parse(ingredient['datebuy'] ?? '', true);

    DateTime expirationDate =
        DateFormat('dd/MM/yy').parse(ingredient['expiredate'] ?? '', true);

    DateTime currentDate = DateTime.now();
    int daysLeft = expirationDate.difference(currentDate).inDays;
    int period = expirationDate.difference(dateBuy).inDays;

    return GestureDetector(
        onTap: () {
          // Navigate to the IngredientPage when the box is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IngredientPage(ingredient: ingredient),
            ),
          );
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
                  QuantityBox(quantity: ingredient['quantity'] ?? 'Unknown'),
                  SizedBox(height: 10.0),
                  Image.asset(
                    ingredient['image'] ?? 'assets/images/default_image.jpg',
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10.0),
                  ExpirationLifeBar(
                      daysLeft: daysLeft,
                      height: 5.0,
                      width: 120.0,
                      period: period),
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
                  Text(
                    ingredient['name'] ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    ingredient['expiredate']!,
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
        ));
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
  final String quantity;

  const QuantityBox({Key? key, required this.quantity}) : super(key: key);

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
        '$quantity',
        style: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
      ),
    );
  }
}
