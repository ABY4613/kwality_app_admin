import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class FoodItemService {
  static const String baseUrl = 'https://kwalityserver.bhaskaraengg.in/api';

  static Future<List<Map<String, dynamic>>> getFoodItems(int categoryId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/food-items/'),  // Get all items
        headers: {
          'Authorization': 'Token $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // Filter items where food field matches the categoryId
        return List<Map<String, dynamic>>.from(
          data.where((item) => item['food'] == categoryId)
        );
      } else {
        throw Exception('Failed to load food items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching food items: $e');
    }
  }

  static Future<Map<String, dynamic>> createFoodItem({
    required String title,
    required File image,
    required String amount,
    String? offerAmount,
    required String description,
    required int categoryId,
    required String token,
  }) async {
    var uri = Uri.parse('$baseUrl/food-items/');
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      })
      ..fields['title'] = title
      ..fields['amount'] = amount
      ..fields['description'] = description
      ..fields['food'] = categoryId.toString();

    if (offerAmount != null && offerAmount.isNotEmpty) {
      request.fields['offer_amount'] = offerAmount;
    }

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      image.path,
    ));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return json.decode(responseData);
    } else {
      throw Exception('Failed to create food item: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> updateFoodItem({
    required int itemId,
    required String title,
    File? image,
    required String amount,
    String? offerAmount,
    required String description,
    required int categoryId,
    required String token,
  }) async {
    var uri = Uri.parse('$baseUrl/food-items/$itemId/');
    
    var request = http.MultipartRequest('PATCH', uri)
      ..headers.addAll({
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      })
      ..fields['title'] = title
      ..fields['amount'] = amount
      ..fields['description'] = description
      ..fields['food'] = categoryId.toString();

    if (offerAmount != null && offerAmount.isNotEmpty) {
      request.fields['offer_amount'] = offerAmount;
    }

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
      throw Exception('Failed to update food item: ${response.statusCode}\nResponse: $responseData');
    }
  }

  static Future<void> deleteFoodItem(int itemId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/food-items/$itemId/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete food item');
    }
  }
}
