import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AddPage extends StatefulWidget {
  final Map<String, String> ingredient;

  const AddPage({Key? key, required this.ingredient}) : super(key: key);

  @override
  _IngredientPageState createState() => _IngredientPageState();
}

class _IngredientPageState extends State<AddPage> {
  bool isBookmarked = false;

  String expirationDate = 'DD/MM/YYYY';
  String quantityValue = ' ';
  String selectedUnit = ' ';

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String fdcId = widget.ingredient['fdcId'] ?? '';

    double caloriePercentage = 100.0;
    double proteinPercentage = 40.0;
    double carbPercentage = 30.0;
    double fatPercentage = 30.0;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Image.asset(
              widget.ingredient['image'] ?? 'assets/images/default_image.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFFAFAFA),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(43.0)),
                  ),
                  padding: const EdgeInsets.all(31.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 10.0),
                              Text(
                                widget.ingredient['name'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                widget.ingredient['category'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isBookmarked = !isBookmarked;
                                });
                                print('Bookmark tapped');
                              },
                              child: Icon(
                                isBookmarked
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_outline_rounded,
                                color: isBookmarked
                                    ? theme.primaryColor
                                    : Colors.grey,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSmallCircularProgressBar(
                              caloriePercentage,
                              'Calories',
                              Icons.local_fire_department,
                              'Kcal',
                              widget.ingredient['calories'] ?? '1000'),
                          _buildSmallCircularProgressBar(
                              proteinPercentage,
                              'Protein',
                              Icons.food_bank,
                              'gm',
                              widget.ingredient['calories'] ?? '1000'),
                          _buildSmallCircularProgressBar(
                              carbPercentage,
                              'Carbs',
                              Icons.local_dining,
                              'gm',
                              widget.ingredient['calories'] ?? '1000'),
                          _buildSmallCircularProgressBar(
                              fatPercentage,
                              'Fat',
                              Icons.local_pizza,
                              'gm',
                              widget.ingredient['calories'] ?? '1000'),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nutrition Facts',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Serving Size: 1 portion',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat.', // Replace with the actual description
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: TextFormField(
                                      initialValue: '',
                                      decoration: InputDecoration(
                                        labelText: 'Amount',
                                        hintText: '100,200,...',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          quantityValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: selectedUnit.isEmpty
                                          ? selectedUnit
                                          : null,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedUnit = value!;
                                        });
                                      },
                                      items: ['g', 'kg', 'ml', 'L'].map((unit) {
                                        return DropdownMenuItem<String>(
                                          value: unit,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                            child: Text(unit),
                                          ),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        hintText: 'Unit',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expire',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 12.0),
                            InkWell(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2101),
                                );

                                if (pickedDate != null &&
                                    pickedDate != DateTime.now()) {
                                  setState(() {
                                    expirationDate =
                                        '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    hintText: 'DD/MM/YYYY',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10),
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  child: Text(
                                    expirationDate,
                                    style: expirationDate == 'DD/MM/YYYY'
                                        ? TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16) // Set color to grey
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'suggession: ${widget.ingredient["name"]} has 7 days life time.',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        width: double.infinity, // Make the button full-width
                        height: 56.0, // Adjust the height as needed
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .primaryColor, // Use the primary color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16.0), // Circular border radius
                            ),
                          ),
                          child: Text(
                            'Add to Fridge',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40.0,
            left: 16.0,
            child: GestureDetector(
              onTap: () {
                // Pop the current screen to go back
                Navigator.pop(context);
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCircularProgressBar(double percentage, String label,
      IconData iconData, String unit, String value) {
    ThemeData theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 4.0,
            percent: percentage / 100,
            center: Icon(
              iconData,
              size: 30.0,
              color: theme.primaryColor,
            ),
            progressColor: theme.primaryColor,
            backgroundColor: Colors.grey,
          ),
          SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          SizedBox(height: 4.0),
          Text(
            '1000 $unit',
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
