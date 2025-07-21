import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ServiceProviderService {
  static const String baseUrl = 'apiurl';

  static Future<List<Map<String, dynamic>>> getServiceProviders(String token) async {
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
      throw Exception('Failed to load service providers: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> createServiceProvider({
    required String title,
    required File image,
    required String description,
    required int serviceId,
    required String token,
  }) async {
    var uri = Uri.parse('$baseUrl/services-provided/');
    
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      })
      ..fields['title'] = title
      ..fields['description'] = description
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
      throw Exception('Failed to create service provider: ${response.statusCode}\nResponse: $responseData');
    }
  }

  static Future<void> deleteServiceProvider(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/services-provided/$id/'),
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete service provider: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> updateServiceProvider({
    required int id,
    required String token,
    String? title,
    File? image,
    String? description,
  }) async {
    var uri = Uri.parse('$baseUrl/services-provided/$id/');
    var request = http.MultipartRequest('PATCH', uri)
      ..headers.addAll({
        'Authorization': 'Token $token',
        'Accept': 'application/json',
      });

    if (title != null) request.fields['title'] = title;
    if (description != null) request.fields['description'] = description;
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
      throw Exception('Failed to update service provider: ${response.statusCode}\nResponse: $responseData');
    }
  }
}
