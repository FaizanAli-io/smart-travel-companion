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
}

class TravelPlace {
  final int id;
  final String name;
  final String region;
  final String country;
  final String category;
  final String description;
  final String imageUrl;
  final WeatherSnapshot weather;
  final bool isFeatured;

  const TravelPlace({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.weather,
    this.isFeatured = false,
  });

  String get locationLabel => '$region, $country';

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
