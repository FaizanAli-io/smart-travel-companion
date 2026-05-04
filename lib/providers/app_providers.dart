import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../data/sample_places.dart';
import '../models/place.dart';
import '../services/api_service.dart';

enum HomeFeedMode { all, favorites, recent }

class MapLocationData {
  final String label;
  final double latitude;
  final double longitude;

  const MapLocationData({required this.label, required this.latitude, required this.longitude});
}

final placesProvider = Provider<List<TravelPlace>>((ref) => samplePlaces);
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final karachiLocationProvider = Provider<MapLocationData>(
  (ref) => const MapLocationData(label: 'Karachi, Pakistan', latitude: 24.8607, longitude: 67.0011),
);

final searchQueryProvider = StateProvider<String>((ref) => '');
final homeFeedModeProvider = StateProvider<HomeFeedMode>((ref) => HomeFeedMode.all);
final selectedRegionProvider = StateProvider<String?>((ref) => null);
final selectedSortProvider = StateProvider<PlaceSortOption>((ref) => PlaceSortOption.recommended);
final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);
final offlineModeProvider = StateProvider<bool>((ref) => false);
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final selectedShellTabProvider = StateProvider<int>((ref) => 0);
final selectedMapPlaceIdProvider = StateProvider<int?>((ref) => null);

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(FavoritesNotifier.new);

class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {1, 4, 7};

  void toggleFavorite(int id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
      return;
    }

    state = {...state, id};
  }

  bool isFavorite(int id) => state.contains(id);
}

final recentPlaceIdsProvider = NotifierProvider<RecentPlacesNotifier, List<int>>(
  RecentPlacesNotifier.new,
);

class RecentPlacesNotifier extends Notifier<List<int>> {
  @override
  List<int> build() => [1, 2, 4];

  void markVisited(int placeId) {
    final nextIds = <int>[placeId, ...state.where((id) => id != placeId)];
    state = nextIds.take(5).toList();
  }

  void clearRecent() {
    state = [];
  }
}

final availableRegionsProvider = Provider<List<String>>((ref) {
  final regions = ref.watch(placesProvider).map((place) => place.region).toSet().toList();
  regions.sort();
  return regions;
});

final placeByIdProvider = Provider.family<TravelPlace?, int>((ref, id) {
  final places = ref.watch(placesProvider);
  for (final place in places) {
    if (place.id == id) {
      return place;
    }
  }
  return null;
});

final placeWeatherProvider = FutureProvider.family<WeatherSnapshot, int>((ref, placeId) async {
  final place = ref.watch(placeByIdProvider(placeId));
  if (place == null) {
    throw Exception('Place not found');
  }

  final apiService = ref.watch(apiServiceProvider);
  return apiService.fetchWeather(latitude: place.latitude, longitude: place.longitude);
});

List<TravelPlace> _sortPlaces(List<TravelPlace> places, PlaceSortOption sortOption) {
  final sortedPlaces = [...places];
  switch (sortOption) {
    case PlaceSortOption.recommended:
      sortedPlaces.sort((left, right) {
        if (left.isFeatured == right.isFeatured) {
          return left.name.compareTo(right.name);
        }
        return left.isFeatured ? -1 : 1;
      });
      break;
    case PlaceSortOption.name:
      sortedPlaces.sort((left, right) => left.name.compareTo(right.name));
      break;
    case PlaceSortOption.region:
      sortedPlaces.sort((left, right) {
        final regionCompare = left.region.compareTo(right.region);
        if (regionCompare != 0) {
          return regionCompare;
        }
        return left.name.compareTo(right.name);
      });
      break;
  }

  return sortedPlaces;
}

List<TravelPlace> _filterPlaces(
  List<TravelPlace> places, {
  String query = '',
  String? region,
  bool favoritesOnly = false,
  HomeFeedMode? homeFeedMode,
  Set<int> favoriteIds = const {},
  List<int> recentIds = const [],
  PlaceSortOption sortOption = PlaceSortOption.recommended,
}) {
  Iterable<TravelPlace> filteredPlaces = places.where((place) => place.matchesQuery(query));

  if (region != null && region.isNotEmpty) {
    filteredPlaces = filteredPlaces.where((place) => place.region == region);
  }

  if (favoritesOnly || homeFeedMode == HomeFeedMode.favorites) {
    filteredPlaces = filteredPlaces.where((place) => favoriteIds.contains(place.id));
  }

  if (homeFeedMode == HomeFeedMode.recent) {
    final orderedRecentPlaces = recentIds
        .map((recentId) => places.where((place) => place.id == recentId))
        .expand((place) => place)
        .where((place) => place.matchesQuery(query))
        .toList();

    if (region != null && region.isNotEmpty) {
      return orderedRecentPlaces.where((place) => place.region == region).toList();
    }

    return orderedRecentPlaces;
  }

  return _sortPlaces(filteredPlaces.toList(), sortOption);
}

final homePlacesProvider = Provider<List<TravelPlace>>((ref) {
  final places = ref.watch(placesProvider);
  final query = ref.watch(searchQueryProvider);
  final favoriteIds = ref.watch(favoritesProvider);
  final recentIds = ref.watch(recentPlaceIdsProvider);
  final homeFeedMode = ref.watch(homeFeedModeProvider);

  return _filterPlaces(
    places,
    query: query,
    favoriteIds: favoriteIds,
    recentIds: recentIds,
    homeFeedMode: homeFeedMode,
  );
});

final advancedSearchResultsProvider = Provider<List<TravelPlace>>((ref) {
  final places = ref.watch(placesProvider);
  final query = ref.watch(searchQueryProvider);
  final favoriteIds = ref.watch(favoritesProvider);
  final region = ref.watch(selectedRegionProvider);
  final sortOption = ref.watch(selectedSortProvider);
  final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);

  return _filterPlaces(
    places,
    query: query,
    region: region,
    favoritesOnly: showFavoritesOnly,
    favoriteIds: favoriteIds,
    sortOption: sortOption,
  );
});

final favoritePlacesProvider = Provider<List<TravelPlace>>((ref) {
  final places = ref.watch(placesProvider);
  final favoriteIds = ref.watch(favoritesProvider);
  return places.where((place) => favoriteIds.contains(place.id)).toList();
});

double _degreesToRadians(double degrees) => degrees * math.pi / 180;

double distanceKmBetweenPoints(
  double latitude1,
  double longitude1,
  double latitude2,
  double longitude2,
) {
  const earthRadiusKm = 6371.0;

  final latitudeDelta = _degreesToRadians(latitude2 - latitude1);
  final longitudeDelta = _degreesToRadians(longitude2 - longitude1);
  final latitude1Radians = _degreesToRadians(latitude1);
  final latitude2Radians = _degreesToRadians(latitude2);

  final haversine =
      math.sin(latitudeDelta / 2) * math.sin(latitudeDelta / 2) +
      math.cos(latitude1Radians) *
          math.cos(latitude2Radians) *
          math.sin(longitudeDelta / 2) *
          math.sin(longitudeDelta / 2);
  final arc = 2 * math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine));
  return earthRadiusKm * arc;
}

double distanceFromKarachiKm(TravelPlace place, MapLocationData location) {
  return distanceKmBetweenPoints(
    location.latitude,
    location.longitude,
    place.latitude,
    place.longitude,
  );
}

final nearestPlacesProvider = Provider<List<TravelPlace>>((ref) {
  final places = ref.watch(placesProvider);
  final location = ref.watch(karachiLocationProvider);

  final sortedPlaces = [...places]
    ..sort(
      (left, right) =>
          distanceFromKarachiKm(left, location).compareTo(distanceFromKarachiKm(right, location)),
    );

  return sortedPlaces.take(5).toList();
});

final selectedMapPlaceProvider = Provider<TravelPlace?>((ref) {
  final selectedId = ref.watch(selectedMapPlaceIdProvider);
  if (selectedId == null) {
    return null;
  }

  return ref.watch(placeByIdProvider(selectedId));
});
