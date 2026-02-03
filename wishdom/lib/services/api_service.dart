import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    // For physical device, try localhost with 'adb reverse', or fallback to machine IP
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
       // return 'http://192.168.29.236:5000/api'; // Fallback if localhost fails
       return 'http://localhost:5000/api';
    }
    return 'http://localhost:5000/api';
  }

  static Future<List<Map<String, dynamic>>> getStories({String? search}) async {
    try {
      final uri = Uri.parse('$baseUrl/feed').replace(
        queryParameters: search != null && search.isNotEmpty ? {'search': search} : null,
      );
      print('Fetching stories from: $uri'); // Debug log
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load stories');
      }
    } catch (e) {
      throw Exception('Error fetching stories: $e');
    }
  }

  static Future<Map<String, dynamic>> createStory(Map<String, dynamic> storyData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/feed'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(storyData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create story');
      }
    } catch (e) {
      throw Exception('Error creating story: $e');
    }
  }
}
