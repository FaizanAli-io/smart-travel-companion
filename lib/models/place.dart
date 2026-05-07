class WeatherSnapshot {
  final double temperature;
  final String conditions;
  final double windSpeed;
  final int humidity;
  final double feelsLike;

  const WeatherSnapshot({
    required this.temperature,
    required this.conditions,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
  });

  factory WeatherSnapshot.fromOpenMeteo(Map<String, dynamic> currentWeather) {
    final temperature = (currentWeather['temperature_2m'] as num?)?.toDouble() ?? 0;
    final windSpeed = (currentWeather['wind_speed_10m'] as num?)?.toDouble() ?? 0;
    final humidity = (currentWeather['relative_humidity_2m'] as num?)?.round() ?? 0;
    final feelsLike = (currentWeather['apparent_temperature'] as num?)?.toDouble() ?? temperature;
    final weatherCode = (currentWeather['weather_code'] as num?)?.toInt() ?? 0;

    return WeatherSnapshot(
      temperature: temperature,
      conditions: _weatherConditionFromCode(weatherCode),
      windSpeed: windSpeed,
      humidity: humidity,
      feelsLike: feelsLike,
    );
  }
}

String _weatherConditionFromCode(int weatherCode) {
  switch (weatherCode) {
    case 0:
      return 'Clear sky';
    case 1:
    case 2:
    case 3:
      return 'Partly cloudy';
    case 45:
    case 48:
      return 'Foggy';
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return 'Drizzle';
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
      return 'Rainy';
    case 71:
    case 73:
    case 75:
    case 77:
      return 'Snowy';
    case 80:
    case 81:
    case 82:
      return 'Showers';
    case 95:
    case 96:
    case 99:
      return 'Stormy';
    default:
      return 'Variable conditions';
  }
}

class TravelPlace {
  final int id;
  final String name;
  final String region;
  final String country;
  final String category;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final bool isFeatured;

  const TravelPlace({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.isFeatured = false,
  });

  String get locationLabel => '$region, $country';

  String get aboutSummary =>
      '$name is a ${category.toLowerCase()} destination in $locationLabel, ideal for travelers who want a memorable scenic stop.';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'country': country,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'isFeatured': isFeatured,
    };
  }

  factory TravelPlace.fromJson(Map<String, dynamic> json) {
    return TravelPlace(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      region: json['region'] as String? ?? '',
      country: json['country'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  bool matchesQuery(String query) {
    if (query.isEmpty) {
      return true;
    }

    final normalizedQuery = query.toLowerCase();
    return name.toLowerCase().contains(normalizedQuery) ||
        region.toLowerCase().contains(normalizedQuery) ||
        country.toLowerCase().contains(normalizedQuery) ||
        category.toLowerCase().contains(normalizedQuery);
  }
}

enum PlaceSortOption { recommended, name, region }

extension PlaceSortOptionLabel on PlaceSortOption {
  String get label {
    switch (this) {
      case PlaceSortOption.recommended:
        return 'Recommended';
      case PlaceSortOption.name:
        return 'Name';
      case PlaceSortOption.region:
        return 'Region';
    }
  }
}
