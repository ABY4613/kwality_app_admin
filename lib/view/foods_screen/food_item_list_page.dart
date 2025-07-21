import 'package:flutter/material.dart';
import 'package:deepuadmin/services/food_item_service.dart';
import 'package:deepuadmin/services/auth_service.dart';
import 'package:deepuadmin/view/foods_screen/add_food_item_page.dart';
import 'package:deepuadmin/view/foods_screen/edit_food_item_page.dart';

class FoodItemListPage extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;

  const FoodItemListPage({
    Key? key,
    required this.categoryId,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  _FoodItemListPageState createState() => _FoodItemListPageState();
}

class _FoodItemListPageState extends State<FoodItemListPage> {
  List<Map<String, dynamic>> _foodItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  Future<void> _loadFoodItems() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No token found');
      
      // Get items filtered by category ID
      final items = await FoodItemService.getFoodItems(widget.categoryId, token);
      
      if (mounted) {
        setState(() {
          _foodItems = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading food items: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Food Item'),
        content: Text('Are you sure you want to delete "${item['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final token = await AuthService.getToken();
                if (token == null) throw Exception('No token found');
                
                await FoodItemService.deleteFoodItem(item['id'], token);
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Food item deleted successfully')),
                  );
                  _loadFoodItems(); // Reload the list
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting food item: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryTitle} Items'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFoodItemPage(
                    categoryId: widget.categoryId,
                    categoryTitle: widget.categoryTitle,
                  ),
                ),
              ).then((value) {
                if (value == true) {
                  _loadFoodItems();
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadFoodItems,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _foodItems.isEmpty
                ? const Center(
                    child: Text(
                      'No items in this category',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _foodItems.length,
                    itemBuilder: (context, index) {
                      final item = _foodItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item['image_url'] != null
                                ? Image.network(
                                    item['image_url'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.fastfood),
                                        ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.fastfood),
                                  ),
                          ),
                          title: Text(
                            item['title'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['description'] ?? ''),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '₹${item['amount']}',
                                    style: TextStyle(
                                      decoration: item['offer_amount'] != null
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: item['offer_amount'] != null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  if (item['offer_amount'] != null) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹${item['offer_amount']}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditFoodItemPage(
                                        foodItem: item,
                                      ),
                                    ),
                                  ).then((value) {
                                    if (value == true) {
                                      _loadFoodItems();
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => _showDeleteConfirmation(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
