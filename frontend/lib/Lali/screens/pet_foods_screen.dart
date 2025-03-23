import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';

class PetFoodsScreen extends StatefulWidget {
  @override
  _PetFoodsScreenState createState() => _PetFoodsScreenState();
}

class _PetFoodsScreenState extends State<PetFoodsScreen> {
  List<Map<String, dynamic>> petFoods = [
    {
      'name': 'Premium Dog Food',
      'brand': 'Royal Canin',
      'price': 29.99,
      'image': 'assets/images/pet_foods/royal_canin_dog.png',
      'category': 'Dog Food',
    },
    {
      'name': 'Kitten Special',
      'brand': 'Whiskas',
      'price': 24.99,
      'image': 'assets/images/pet_foods/whiskas_kitten.jpeg',
      'category': 'Cat Food',
    },
    {
      'name': 'Adult Cat Food',
      'brand': 'Purina ONE',
      'price': 27.99,
      'image': 'assets/images/pet_foods/purina_cat.jpg',
      'category': 'Cat Food',
    },
    {
      'name': 'Puppy Growth Formula',
      'brand': 'Hill\'s Science Diet',
      'price': 32.99,
      'image': 'assets/images/pet_foods/hills_puppy.jpg',
      'category': 'Dog Food',
    },
    {
      'name': 'Senior Dog Food',
      'brand': 'Blue Buffalo',
      'price': 34.99,
      'image': 'assets/images/pet_foods/blue_buffalo_senior.png',
      'category': 'Dog Food',
    },
    {
      'name': 'Indoor Cat Formula',
      'brand': 'Iams',
      'price': 26.99,
      'image': 'assets/images/pet_foods/iams_indoor.jpg',
      'category': 'Cat Food',
    }
  ];

  List<Map<String, dynamic>> filteredPetFoods = [];

  @override
  void initState() {
    super.initState();
    filteredPetFoods = petFoods;
  }

  void _handleSearch(String query) {
    setState(() {
      filteredPetFoods = petFoods
          .where((food) =>
              food['name'].toLowerCase().contains(query.toLowerCase()) ||
              food['brand'].toLowerCase().contains(query.toLowerCase()) ||
              food['category'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Foods'),
        backgroundColor: const Color(0xFF6BA8A9),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              onSearch: _handleSearch,
              hintText: 'Search pet foods...',
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredPetFoods.length,
              itemBuilder: (context, index) {
                final food = filteredPetFoods[index];
                return Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(food['image']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food['brand'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${food['price'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6BA8A9),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_shopping_cart),
                                  onPressed: () {
                                    // Add to cart logic
                                  },
                                  color: const Color(0xFF6BA8A9),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 