import 'package:flutter/material.dart';
import './recipe/recipe.dart';
import './fridge/fridge.dart';
import './market/market.dart';
import './profile/profile.dart';

class Home extends StatefulWidget {
  final String? userId; // Add this field

  Home({this.userId});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0; // Index of the selected tab

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Center(
        child: Text(
            'User ID: ${widget.userId ?? 'No User ID'}'), // Display the user ID
      ),
      RecipePage(), // Use the RecipePage class
      FridgePage(), // Use the FridgePage class
      MarketPage(), // Use the MarketPage class
      ProfilePage(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: 'Fridge',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
