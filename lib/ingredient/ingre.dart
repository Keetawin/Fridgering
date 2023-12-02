import 'package:flutter/material.dart';
import './add.dart';
import 'package:standard_searchbar/standard_searchbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Ingredient extends StatefulWidget {
  final String? userId;

  Ingredient({this.userId});

  @override
  _FridgePageState createState() => _FridgePageState();
}

class _FridgePageState extends State<Ingredient> {
  String searchTerm = '';
  Timer? _debounce;
  String? userId;

  List<Map<String, dynamic>> ingredients = [];

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://fridgeringapi.fly.dev/common_ingredient/search?name=$searchTerm'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> recipeList = data['data'];
        setState(() {
          ingredients = List<Map<String, dynamic>>.from(recipeList);
        });
      } else {
        print(
          'Failed to fetch ingredients. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onSearchChanged(String query) {
    // Debounce the search to reduce the number of requests
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchTerm = query;
      });
      _fetchIngredients();
    });
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
              onChanged: _onSearchChanged,
              hintText: 'Search...',
            ),
          ),
          SizedBox(height: 24.0),
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

  List<Map<String, dynamic>> getFilteredIngredients() {
    return ingredients.where((ingredient) {
      // Check if foodNutritients is not empty and has at least one element
      if (ingredient['description'] != null &&
          ingredient['description'].isNotEmpty) {
        String name = ingredient['description'] ?? '';
        return name.toLowerCase().contains(searchTerm.toLowerCase());
      }
      // If foodNutritients is empty or null, exclude this ingredient
      return false;
    }).toList();
  }

  Widget buildIngredientCard(Map<String, dynamic> ingredient) {
    return GestureDetector(
      onTap: () {
        // Navigate to the AddPage with the ingredient
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPage(
                ingredientID: ingredient['fdcId'].toString(),
                userId: widget.userId,
                ingredientName: ingredient['description']),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 9.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      ingredient['image'] ?? 'https://via.placeholder.com/150',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      ingredient['description'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
