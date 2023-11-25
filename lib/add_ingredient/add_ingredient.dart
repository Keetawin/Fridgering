import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';

List<Map<String, String>> allIngredients = [
  {
    'image': 'assets/images/pic1.jpg',
    'name': 'Carrot',
    'category': 'vegetable',
  },
  {
    'image': 'assets/images/pic2.jpg',
    'name': 'Apple',
    'category': 'fruit',
  },
  {
    'image': 'assets/images/pic3.jpg',
    'name': 'Chicken',
    'category': 'meat',
  },
  {
    'image': 'assets/images/pic1.jpg',
    'name': 'Tomato',
    'category': 'vegetable',
  },
  // Add more ingredients as needed
];

class AddIngredientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Ingredient'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage<Map<String, String>>(
                  items: allIngredients, // Pass your ingredient list here
                  searchLabel: 'Search Ingredients',
                  suggestion: Center(
                    child: Text('Filter ingredient by name, category, etc.'),
                  ),
                  failure: Center(
                    child: Text('No ingredient found :('),
                  ),
                  filter: (ingredient) => [
                    ingredient['name'] ?? '',
                    ingredient['category'] ?? '',
                  ],
                  builder: (ingredient) => ListTile(
                    title: Text(ingredient['name'] ?? ''),
                    subtitle: Text(ingredient['category'] ?? ''),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Add Ingredient Page Content'),
      ),
    );
  }
}
