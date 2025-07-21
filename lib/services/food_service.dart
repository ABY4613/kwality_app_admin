import 'dart:io';
import 'package:deepuadmin/model/food_order.dart';
import 'package:deepuadmin/model/food_preorder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodService {
  static const String baseUrl = 'apiurl';

  static Future<Map<String, dynamic>> createFoodCategory({
    required String title,
    required String token,
    File? image,
  }) async {
    var uri = Uri.parse('$baseUrl/food/');
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      })
      ..fields['title'] = title;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return json.decode(responseData);
    } else {
      throw Exception('Failed to create food category: ${response.statusCode}\nResponse: $responseData');
    }
  }

  static Future<List<Map<String, dynamic>>> getFoodCategories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/food/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load food categories: ${response.statusCode}');
    }
  }

  static Future<void> deleteCategory(int categoryId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/food/$categoryId/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete food category: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> updateFoodCategory({
    required int categoryId,
    required String title,
    required String token,
    File? image,
  }) async {
    var uri = Uri.parse('$baseUrl/food/$categoryId/');
    var request = http.MultipartRequest('PATCH', uri)
      ..headers.addAll({
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      })
      ..fields['title'] = title;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return json.decode(responseData);
    } else {
      throw Exception('Failed to update food category: ${response.statusCode}\nResponse: $responseData');
    }
  }

  static Future<void> updatePreOrderStatus(int orderId, String newStatus, String token) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/preorder-food-orders/$orderId/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'status': newStatus}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update pre-order status: ${response.statusCode}');
    }
  }

  static Future<List<FoodPreOrder>> getPreOrderFoodOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/preorder-food-orders/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => FoodPreOrder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pre-orders: ${response.statusCode}');
    }
  }

  static Future<void> updateOrderStatus(int orderId, String newStatus, String token) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/food-orders/$orderId/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'status': newStatus}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order status: ${response.statusCode}');
    }
  }

  static Future<List<FoodOrder>> getFoodOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/food-orders/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => FoodOrder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  }
}
