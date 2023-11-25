import 'package:flutter/material.dart';
import './add.dart';
import '../notification/notification.dart';
import 'package:standard_searchbar/standard_searchbar.dart';

class Ingredient extends StatefulWidget {
  const Ingredient({Key? key}) : super(key: key);

  @override
  _FridgePageState createState() => _FridgePageState();
}

class _FridgePageState extends State<Ingredient> {
  String selectedFilter = 'all';
  String searchTerm = '';

  List<Map<String, String>> allIngredients = [
    {
      'quantity': '2 PCS',
      'image': 'assets/images/pic1.jpg',
      'name': 'Carrot',
      'category': 'vegetable',
      'datebuy': '18/11/23'
    },
    {
      'quantity': '4 PCS',
      'image': 'assets/images/pic2.jpg',
      'name': 'Apple',
      'category': 'fruit',
      'datebuy': '11/11/23'
    },
    {
      'quantity': '600 G',
      'image': 'assets/images/pic3.jpg',
      'name': 'Chicken',
      'category': 'meat',
      'datebuy': '9/11/23'
    },
    {
      'quantity': '600 G',
      'image': 'assets/images/pic1.jpg',
      'name': 'Tomato',
      'category': 'vegetable',
      'datebuy': '12/11/23'
    },
    // Add more ingredients as needed
  ];

  List<Map<String, String>> getFilteredIngredients() {
    List<Map<String, String>> filteredList;

    if (selectedFilter == 'all') {
      filteredList = allIngredients;
    } else {
      filteredList = allIngredients
          .where((ingredient) => ingredient['category'] == selectedFilter)
          .toList();
    }

    if (searchTerm.isNotEmpty) {
      filteredList = filteredList.where((ingredient) {
        String name = ingredient['name']?.toLowerCase() ?? '';
        return name.contains(searchTerm.toLowerCase());
      }).toList();
    }

    return filteredList;
  }

  void _navigateToNotiScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Ingredient')),
      body: Column(
        children: [
          SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 36.0,
            ),
            child: StandardSearchBar(
              onChanged: (query) {
                setState(() {
                  searchTerm = query;
                });
              },
              hintText: 'Search...',
            ),
          ),
          SizedBox(height: 24.0),
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
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 20.0,
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
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
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
    return GestureDetector(
      onTap: () {
        // Navigate to the IngredientPage when the box is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPage(ingredient: ingredient),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          height: 253,
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
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: Image.asset(
                    ingredient['image'] ?? 'assets/images/default_image.jpg',
                    height: 120,
                    fit: BoxFit.cover,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
