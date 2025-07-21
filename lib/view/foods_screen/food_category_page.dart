// import 'package:flutter/material.dart';
// import 'package:deepuadmin/services/food_service.dart';
// import 'package:deepuadmin/services/auth_service.dart';

// class FoodCategoryPage extends StatefulWidget {
//   const FoodCategoryPage({Key? key}) : super(key: key);

//   @override
//   _FoodCategoryPageState createState() => _FoodCategoryPageState();
// }

// class _FoodCategoryPageState extends State<FoodCategoryPage> {
//   final TextEditingController _categoryNameController = TextEditingController();
//   List<Map<String, dynamic>> _categories = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//   }

//   Future<void> _loadCategories() async {
//     setState(() => _isLoading = true);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) throw Exception('No token found');
      
//       final categories = await FoodService.getFoodCategories(token);
//       setState(() => _categories = categories);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading categories: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _showAddCategoryDialog() async {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Food Category'),
//         content: TextField(
//           controller: _categoryNameController,
//           decoration: const InputDecoration(
//             labelText: 'Category Name',
//             hintText: 'Enter category name',
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: _createCategory,
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _createCategory() async {
//     if (_categoryNameController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a category name')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);
//     try {
//       final token = await AuthService.getToken();
//       if (token == null) throw Exception('No token found');

//       await FoodService.createFoodCategory(
//         title: _categoryNameController.text.trim(),
//         token: token,
//       );

//       _categoryNameController.clear();
//       Navigator.pop(context);
//       await _loadCategories(); // Refresh the list

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Category created successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error creating category: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Food Categories'),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddCategoryDialog,
//         child: const Icon(Icons.add),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _categories.length,
//               itemBuilder: (context, index) {
//                 final category = _categories[index];
//                 return ListTile(
//                   title: Text(category['title']),
//                   trailing: Text('Items: ${category['items']?.length ?? 0}'),
//                 );
//               },
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     _categoryNameController.dispose();
//     super.dispose();
//   }
// }