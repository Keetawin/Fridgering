import 'package:flutter/material.dart';
import './home.dart';
import './recipe/recipe.dart';
import './fridge/fridge.dart';
import './profile/profile.dart';

class Navbar extends StatefulWidget {
  final String? userId;
  final String? userImage;
  final String? userName;
  final String? userEmail;

  Navbar({this.userId, this.userImage, this.userName, this.userEmail});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0; // Index of the selected tab

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomePage(
        userId: widget.userId,
        userImage: widget.userImage,
        userName: widget.userName,
      ),
      RecipePage(
        userId: widget.userId,
      ),
      FridgePage(
        userId: widget.userId,
        userImage: widget.userImage,
        userName: widget.userName,
        userEmail: widget.userEmail,
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
