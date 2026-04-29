import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/photo.dart';

class ApiService {
  static const String _photosUrl = 'https://jsonplaceholder.typicode.com/photos';

  Future<List<Photo>> fetchPhotos({bool refresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cached_photos';

    if (!refresh) {
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        return jsonList.map((json) => Photo.fromJson(json)).toList();
      }
    }

    try {
      final response = await http.get(Uri.parse('$_photosUrl?_limit=50'));
      if (response.statusCode == 200) {
        prefs.setString(cacheKey, response.body);
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        return jsonList.map((json) => Photo.fromJson(json)).toList();
      }
      throw Exception('Network error and no cached data available');
    }
  }

  Future<Map<String, dynamic>> fetchWeather() async {
    // Basic weather request for a fixed location (e.g., coordinates for a sample place)
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['current_weather'];
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Error loading weather: $e');
    }
  }
}
