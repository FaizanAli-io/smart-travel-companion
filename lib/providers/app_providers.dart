import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/photo.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final photosProvider = FutureProvider<List<Photo>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchPhotos();
});

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<int>>(FavoritesNotifier.new);

class FavoritesNotifier extends Notifier<List<int>> {
  @override
  List<int> build() => [];

  void toggleFavorite(int id) {
    if (state.contains(id)) {
      state = state.where((element) => element != id).toList();
    } else {
      state = [...state, id];
    }
  }

  bool isFavorite(int id) {
    return state.contains(id);
  }
}

final filteredPhotosProvider = Provider<AsyncValue<List<Photo>>>((ref) {
  final photos = ref.watch(photosProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return photos.whenData((photoList) {
    if (searchQuery.isEmpty) {
      return photoList;
    }
    return photoList
        .where((photo) => photo.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  });
});

final weatherProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchWeather();
});
