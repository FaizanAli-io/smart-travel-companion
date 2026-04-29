import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../data/sample_places.dart';
import '../models/place.dart';

enum HomeFeedMode { all, favorites, recent }

final placesProvider = Provider<List<TravelPlace>>((ref) => samplePlaces);

final searchQueryProvider = StateProvider<String>((ref) => 'Lake');
final homeFeedModeProvider = StateProvider<HomeFeedMode>((ref) => HomeFeedMode.all);
final selectedRegionProvider = StateProvider<String?>((ref) => null);
final selectedSortProvider = StateProvider<PlaceSortOption>((ref) => PlaceSortOption.recommended);
final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);
final offlineModeProvider = StateProvider<bool>((ref) => false);
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final selectedShellTabProvider = StateProvider<int>((ref) => 0);

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
