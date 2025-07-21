import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ServiceManagementService {
  static const String baseUrl = 'https://kwalityserver.bhaskaraengg.in/api';

  static Future<List<Map<String, dynamic>>> getServices(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services-provided/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load services: ${response.statusCode}\nResponse: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> createService({
    required String title,
    required String description,
    required File image,
    required int serviceId,
    required String token,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/services-provided/');
      
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Token $token',
          'Accept': 'application/json',
        })
        ..fields['title'] = title.trim()
        ..fields['description'] = description.trim()
        ..fields['service'] = serviceId.toString();

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to create service: ${response.statusCode}\nResponse: $responseData');
      }
    } catch (e) {
      throw Exception('Service creation failed: $e');
    }
  }

  static Future<void> deleteService(int serviceId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/services-provided/$serviceId/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete service: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> updateService({
    required int id,
    required String token,
    required String title,
    required String description,
    File? image,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/services-provided/$id/');
      var request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll({
          'Authorization': 'Token $token',
          'Accept': 'application/json',
        })
        ..fields['title'] = title.trim()
        ..fields['description'] = description.trim();

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
        throw Exception('Failed to update service: ${response.statusCode}\nResponse: $responseData');
      }
    } catch (e) {
      throw Exception('Service update failed: $e');
    }
  }
}
