import 'package:flutter/material.dart';
import 'package:deepuadmin/services/food_service.dart';
import 'package:deepuadmin/services/auth_service.dart';
import 'package:deepuadmin/view/foods_screen/food_item_list_page.dart';
import 'package:deepuadmin/view/foods_screen/edit_food_category_page.dart';
import 'package:deepuadmin/view/foods_screen/add_food_category_page.dart';

class FoodCategoryListPage extends StatefulWidget {
  const FoodCategoryListPage({Key? key}) : super(key: key);

  @override
  _FoodCategoryListPageState createState() => _FoodCategoryListPageState();
}

class _FoodCategoryListPageState extends State<FoodCategoryListPage> {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No token found');
      
      final categories = await FoodService.getFoodCategories(token);
      // Filter out categories with null titles or duplicates
      final filteredCategories = categories.where((category) => 
        category['title'] != null && 
        categories.indexOf(category) == categories.lastIndexWhere(
          (c) => c['title'] == category['title']
        )
      ).toList();
      
      setState(() => _categories = filteredCategories);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteCategory(Map<String, dynamic> category) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No token found');
      
      await FoodService.deleteCategory(category['id'], token);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category deleted successfully')),
        );
        _loadCategories(); // Refresh the list after deletion
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting category: $e')),
        );
      }
    }
  }

  void _showDeleteConfirmation(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCategory(category);
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
        title: const Text('Food Categories'),
        backgroundColor: Colors.amber,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFoodCategoryPage(),
            ),
          ).then((_) => _loadCategories());
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCategories,
              child: _categories.isEmpty
                  ? const Center(
                      child: Text('No categories found'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: category['image_url'] != null
                                  ? Image.network(
                                      category['image_url'],
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                            width: 56,
                                            height: 56,
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.restaurant_menu,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    )
                                  : Container(
                                      width: 56,
                                      height: 56,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.restaurant_menu,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                            title: Text(
                              category['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${(category['items'] as List).length} items',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
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
                                        builder: (context) => EditFoodCategoryPage(
                                          category: category,
                                        ),
                                      ),
                                    ).then((updated) {
                                      if (updated == true) {
                                        _loadCategories(); // Refresh the list if category was updated
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () => _showDeleteConfirmation(category),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FoodItemListPage(
                                    categoryId: category['id'],
                                    categoryTitle: category['title'],
                                  ),
                                ),
                              ).then((_) => _loadCategories());
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
