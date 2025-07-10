import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/GetPostedProperty.dart';
import '../models/MyPostPropertyResponseDto.dart';
import '../models/MyUnlockProperty.dart';
import '../models/PropertyPostDto.dart';
import '../models/UpdateMyPostedPropertyDto.dart';
import 'package:mime/mime.dart';


class PropertyService {
  final String baseUrl = "http://10.0.2.2:8080";
  // final String propertyUnlockBaseUrl = "http://10.0.2.2:8080";

  Future<List<GetPostedProperty>> fetchPostedProperties() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/user/all/posted/properties"),
      //headers: {"Authorization": "Bearer $token"},
    );

    // print("Status: ${response.statusCode}");
    // print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded
            .map((e) => GetPostedProperty.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Expected List but got: ${decoded.runtimeType}");
      }
    } else {
      throw Exception("Failed to load properties: ${response.body}");
    }
  }

  Future<bool> unlockProperty(int propertyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    int? userId = prefs.getInt("id");

    if (token == null || token.isEmpty || userId == null) return false;

    final response = await http.post(
      Uri.parse("$baseUrl/api/user/property/unlock"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "userId": userId,
        "propertyPostId": propertyId,
      }),
    );

    return response.statusCode == 200;
  }

  Future<List<MyUnlockProperty>> fetchUnlockedProperties() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final userId = prefs.getInt("id");

    if (token == null || userId == null) {
      throw Exception("User not logged in.");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/api/user/property/unlock/me?id=$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      return jsonData.map((item) => MyUnlockProperty.fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch unlocked properties.");
    }
  }

  Future<bool> postProperty(PropertyPostDto property, List<File> imageFiles) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final uri = Uri.parse("$baseUrl/api/user/post/property");
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = "Bearer $token";

    // ✅ Convert the property JSON to a proper multipart "file" part with correct content-type
    request.files.add(
      http.MultipartFile.fromString(
        'property',
        jsonEncode(property.toJson()),
        contentType: MediaType('application', 'json'),
      ),
    );

    // ✅ Add image files
    for (var image in imageFiles) {
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      final parts = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image.path,
          contentType: MediaType(parts[0], parts[1]),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 201;
  }



  Future<List<MyPostPropertyResponseDto>> fetchMyPostedProperties(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("http://10.0.2.2:8080/api/user/property/posted/me?id=$userId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );


    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // Ensure it’s a list
      if (decoded is List) {
        return decoded
            .map((json) => MyPostPropertyResponseDto.fromJson(json))
            .toList();
      } else {
        throw Exception("❌ Invalid JSON format: expected a list.");
      }
    } else {
      throw Exception("❌ Failed to load posted properties: ${response.statusCode}");
    }
  }

  Future<bool> updateMyPostedProperty(UpdateMyPostedPropertyDto dto) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8080/api/user/property/posted/update"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(dto.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteMyPostedProperty(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final uri = Uri.parse("$baseUrl/api/user/property/posted/delete?id=$postId");

    final response = await http.delete(
      uri,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }
}
