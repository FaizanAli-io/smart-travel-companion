import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/sample_places.dart';
import '../models/place.dart';

class ApiService {
  static const String _photosUrl = 'https://jsonplaceholder.typicode.com/photos';
  static const String _weatherUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _placesCacheKey = 'cached_places';
  static const int _offlineCacheSize = 8;

  Future<List<TravelPlace>> readCachedPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    return _readCachedPlaces(prefs);
  }

  Future<List<TravelPlace>> fetchPlaces({bool refresh = false, bool forceOffline = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedPlaces = _readCachedPlaces(prefs);

    try {
      if (forceOffline) {
        return cachedPlaces.isNotEmpty ? cachedPlaces : _seedOfflinePlaces();
      }

      if (refresh) {
        final freshPlaces = await _fetchRemotePlaces();
        if (freshPlaces.isNotEmpty) {
          final placesToCache = _trimPlacesForCache(freshPlaces);
          await prefs.setString(
            _placesCacheKey,
            jsonEncode(placesToCache.map((place) => place.toJson()).toList()),
          );
          return freshPlaces;
        }

        if (cachedPlaces.isNotEmpty) {
          return cachedPlaces;
        }

        return _seedOfflinePlaces();
      }

      final connectivityResults = await Connectivity().checkConnectivity();
      final isConnected = connectivityResults.any((result) => result != ConnectivityResult.none);

      if (!isConnected) {
        return cachedPlaces.isNotEmpty ? cachedPlaces : _seedOfflinePlaces();
      }

      final freshPlaces = await _fetchRemotePlaces();
      if (freshPlaces.isNotEmpty) {
        final placesToCache = _trimPlacesForCache(freshPlaces);
        await prefs.setString(
          _placesCacheKey,
          jsonEncode(placesToCache.map((place) => place.toJson()).toList()),
        );
        return freshPlaces;
      } else {
        return cachedPlaces.isNotEmpty ? cachedPlaces : _seedOfflinePlaces();
      }
    } catch (e) {
      if (cachedPlaces.isNotEmpty) {
        return cachedPlaces;
      }

      return _seedOfflinePlaces();
    }
  }

  List<TravelPlace> _readCachedPlaces(SharedPreferences prefs) {
    final cachedData = prefs.getString(_placesCacheKey);
    if (cachedData == null) {
      return const [];
    }

    final decoded = jsonDecode(cachedData) as List<dynamic>;
    return decoded.map((entry) => TravelPlace.fromJson(entry as Map<String, dynamic>)).toList();
  }

  Future<List<TravelPlace>> _fetchRemotePlaces() async {
    final response = await http.get(Uri.parse('$_photosUrl?_limit=1000'));
    if (response.statusCode != 200) {
      return const [];
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    final photoIds = decoded
        .map((entry) => (entry as Map<String, dynamic>)['id'])
        .whereType<num>()
        .map((id) => id.toInt())
        .toSet();

    final selectedPlaces = samplePlaces.where((place) => photoIds.contains(place.id)).toList();
    if (selectedPlaces.isEmpty) {
      return samplePlaces;
    }

    return selectedPlaces;
  }

  List<TravelPlace> _seedOfflinePlaces() {
    return samplePlaces.take(_offlineCacheSize).toList();
  }

  List<TravelPlace> _trimPlacesForCache(List<TravelPlace> places) {
    if (places.length <= _offlineCacheSize) {
      return places;
    }
    return places.take(_offlineCacheSize).toList();
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
