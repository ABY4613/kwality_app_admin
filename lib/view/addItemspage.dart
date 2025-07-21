

import 'package:deepuadmin/view/banner_screen/bannerpage.dart';
import 'package:deepuadmin/view/foods_screen/foodpage.dart';

import 'package:flutter/material.dart';
import 'package:deepuadmin/view/foods_screen/food_category_list_page.dart';

class AddItemsPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Foods',
      'color': Colors.orange,
      'icon': Icons.fastfood,
      'page': const FoodCategoryListPage(),
    },
    
    {
      'name': 'Add Banner',
      'color': Colors.pink,
      'icon': Icons.image_aspect_ratio_rounded,
      'page': const BannerPage(),
    },
  ];

  AddItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => category['page']),
            );
          },
          child: Card(
            color: category['color'],
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category['icon'], size: 48, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  category['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
