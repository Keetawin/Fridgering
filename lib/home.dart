import 'package:flutter/material.dart';
import './recipe/recipe.dart';
import './fridge/fridge.dart';
import './profile/profile.dart';
import 'component/recipecard_bookmark.dart';
import './component/fridgecard_status.dart';
import './notification/notification.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  final String? userId;
  final String? userImage;
  final String? userName;
  final String? userEmail;
  // Add this field

  Home({this.userId, this.userImage, this.userName, this.userEmail});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0; // Index of the selected tab

  void _navigateToNotiScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(),
      ),
    );
  }

  late List<Widget> _pages;

  List<List<String>> tagsList = [
    ['Fried', 'Thai cuisine', 'Spicy'],
    ['Hot', 'Japan cuisine', 'Soup'],
    ['Hot', 'Soup'],
    // เพิ่ม List ของ tag ในแต่ละ card ตามต้องการ
  ];

  List<int> timeToCook = [
    20,
    30,
    40,
    // เพิ่มเวลาในการทำอาหารของแต่ละ card ตามต้องการ
  ];

  List<int> numIngredients = [
    5,
    6,
    7,
  ];

  List<String> imageUrls = [
    'assets/images/pic2.jpg',
    'assets/images/pic1.jpg',
    'assets/images/pic3.jpg',
    // เพิ่ม URL รูปภาพอื่น ๆ ตามต้องการ
  ];

  List<String> tagsAndTitles = [
    'Omelet',
    'Wagyu A5',
    'Tom Yum',
    // เพิ่ม tag และหัวข้ออื่น ๆ ตามต้องการ
  ];

  List<String> fridgeItemTitles = [
    'Potato',
    'Egg',
    'Egg',
    // Add more fridge item titles as needed
  ];

  List<String> fridgeItemQuantity = ['2 PCS', '3 PCS', '1PCS'];

  List<String> fridgeItemImages = [
    'assets/images/potato.jpg',
    'assets/images/egg.jpg',
    'assets/images/egg.jpg',
    // Add more fridge item images as needed
  ];

  List<String> fridgeItemDates = ['25/11/23', '20/11/23', '21/11/23'];

  List<String> fridgeItemExpirationDates = [
    '29/11/23',
    '27/11/23',
    '27/11/23',
    // Add more expiration dates as needed
  ];

  List<bool> isBookmarked = [true, false, true];

  @override
  void initState() {
    super.initState();

    _pages = [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 48),
                Container(
                  // User profile section
                  padding: EdgeInsets.only(left: 36, right: 27),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                widget.userImage ?? 'URL_TO_DEFAULT_IMAGE',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi ${widget.userName?.split(' ')[0]} 💙',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Welcome to Fridgering',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _navigateToNotiScreen,
                        icon: Icon(
                          Icons.notifications,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Recipe section
                  padding: EdgeInsets.only(left: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Recipes you can make',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Horizontal ListView for recipe cards
                      Container(
                        height: 300, // Adjust the height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemExtent: 290,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: CardItem(
                                index: index,
                                imageUrl: imageUrls[index],
                                tagAndTitle: tagsAndTitles[index],
                                tags: tagsList[index],
                                timeToCook: timeToCook[index],
                                numIngredients: numIngredients[index],
                                isBookmarked: isBookmarked[index],
                                onTap: () {
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  // Recipe section
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fridge List',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${fridgeItemTitles.length} items',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ]),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                Container(
                  // Recipe section
                  padding: EdgeInsets.only(left: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FridgeList(
                        fridgeItems: List.generate(
                          fridgeItemTitles.length,
                          (index) => FridgeListItem(
                            title: fridgeItemTitles[index],
                            quantity: fridgeItemQuantity[index],
                            imageUrl: fridgeItemImages[index],
                            dateBuy: fridgeItemDates[index],
                            expireDate: fridgeItemExpirationDates[index],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      RecipePage(
        userId: widget.userId,
      ), // Use the RecipePage class
      FridgePage(), // Use the FridgePage class
      ProfilePage(
        userId: widget.userId,
        userImage: widget.userImage,
        userName: widget.userName,
      ),
    ];
  }

  void _loadRecipes() async {
    // Load data from mock.json and append to existing lists
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/mock/recommend_recipe.json');
    Map<String, dynamic> jsonData = json.decode(data);

    List<dynamic> recipesData = jsonData['recipes'];

    List<String> newImageUrls =
        recipesData.map((json) => json['imageUrl']).cast<String>().toList();
    List<String> newTagsAndTitles =
        recipesData.map((json) => json['tagAndTitle']).cast<String>().toList();

    setState(() {
      imageUrls.addAll(newImageUrls);
      tagsAndTitles.addAll(newTagsAndTitles);
    });
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

class FridgeList extends StatelessWidget {
  final List<FridgeListItem> fridgeItems;

  FridgeList({required this.fridgeItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fridgeItems.length,
        itemBuilder: (context, index) {
          return fridgeItems[index];
        },
      ),
    );
  }
}
