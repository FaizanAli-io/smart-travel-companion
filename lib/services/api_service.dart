import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/place.dart';
import '../models/photo.dart';

class ApiService {
  static const String _photosUrl = 'https://jsonplaceholder.typicode.com/photos';
  static const String _weatherUrl = 'https://api.open-meteo.com/v1/forecast';

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

  Future<WeatherSnapshot> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(_weatherUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current':
            'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code',
        'timezone': 'auto',
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final currentWeather = decoded['current'] as Map<String, dynamic>?;
        if (currentWeather == null) {
          throw Exception('Weather payload is missing current conditions');
        }

        return WeatherSnapshot.fromOpenMeteo(currentWeather);
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      throw Exception('Error loading weather: $e');
    }
  }
}
