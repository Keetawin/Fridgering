import 'package:flutter/material.dart';
import './recipe/recipe.dart';
import './fridge/fridge.dart';
import './market/market.dart';
import './profile/profile.dart';
import './component/card.dart';
import './component/fridge_card.dart';

class Home extends StatefulWidget {
  final String? userId;
  final String? userImage;
  final String? userName; // Add this field

  Home({this.userId, this.userImage, this.userName});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0; // Index of the selected tab

  late List<Widget> _pages;

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
    // Add more fridge item titles as needed
  ];

  List<String> fridgeItemImages = [
    'assets/images/potato.jpg',
    'assets/images/egg.jpg',
    // Add more fridge item images as needed
  ];

  List<String> fridgeItemExpirationDates = [
    '31/08/21',
    '31/08/21',
    // Add more expiration dates as needed
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 48),
              Container(
                // User profile section
                padding: EdgeInsets.symmetric(horizontal: 36),
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
                                  fontWeight: FontWeight.w600,
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
                    Icon(
                      Icons.notifications,
                      size: 30,
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
                            '9 items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
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
                          imageUrl: fridgeItemImages[index],
                          expirationDate: fridgeItemExpirationDates[index],
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

class FridgeList extends StatelessWidget {
  final List<FridgeListItem> fridgeItems;

  FridgeList({required this.fridgeItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, // Adjust the height as needed
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
