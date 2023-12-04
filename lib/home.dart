import 'package:flutter/material.dart';
import './mainhome.dart';
import './recipe/recipe.dart';
import './fridge/fridge.dart';
import './profile/profile.dart';

class Home extends StatefulWidget {
  final String? userId;
  final String? userImage;
  final String? userName;
  final String? userEmail;

  Home({this.userId, this.userImage, this.userName, this.userEmail});

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
      MainhomePage(
        userId: widget.userId,
        userImage: widget.userImage,
        userName: widget.userName,
      ),
      RecipePage(
        userId: widget.userId,
      ),
      FridgePage(
        userId: widget.userId,
      ),
      ProfilePage(
        userId: widget.userId,
        userImage: widget.userImage,
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
