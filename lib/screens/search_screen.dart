import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/place.dart';
import '../providers/app_providers.dart';
import '../widgets/animated_entrance.dart';
import '../widgets/place_card.dart';
import '../widgets/state_views.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 180), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(advancedSearchResultsProvider);
    final regionsAsync = ref.watch(availableRegionsProvider);
    final regions = regionsAsync.when(
      data: (value) => value,
      loading: () => const <String>[],
      error: (_, __) => const <String>[],
    );
    final sortOption = ref.watch(selectedSortProvider);
    final region = ref.watch(selectedRegionProvider);
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final favoriteIds = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [OfflineStateView(onRetry: () => ref.invalidate(placesProvider))],
        ),
        data: (results) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            AnimatedEntrance(
              child: TextField(
                controller: _controller,
                onChanged: _onQueryChanged,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  hintText: 'Lake',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 40),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<PlaceSortOption>(
                      initialValue: sortOption,
                      items: PlaceSortOption.values
                          .map(
                            (option) => DropdownMenuItem(value: option, child: Text(option.label)),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(selectedSortProvider.notifier).state = value;
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Sort By'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      initialValue: region,
                      items: [
                        const DropdownMenuItem<String?>(value: null, child: Text('All regions')),
                        ...regions.map(
                          (value) => DropdownMenuItem<String?>(value: value, child: Text(value)),
                        ),
                      ],
                      onChanged: (value) => ref.read(selectedRegionProvider.notifier).state = value,
                      decoration: const InputDecoration(labelText: 'Region'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Show',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(16),
                    isSelected: [!showFavoritesOnly, showFavoritesOnly],
                    onPressed: (index) {
                      ref.read(showFavoritesOnlyProvider.notifier).state = index == 1;
                    },
                    children: const [
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('All')),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Favorites'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (results.isEmpty)
              EmptyStateView(
                onClearFilters: () {
                  _controller.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                  ref.read(selectedRegionProvider.notifier).state = null;
                  ref.read(selectedSortProvider.notifier).state = PlaceSortOption.recommended;
                  ref.read(showFavoritesOnlyProvider.notifier).state = false;
                },
              )
            else ...[
              Text(
                '${results.length} places found',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ...results.asMap().entries.map(
                (entry) => AnimatedEntrance(
                  delay: Duration(milliseconds: 50 + entry.key * 35),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: PlaceCard(
                      place: entry.value,
                      compact: true,
                      isFavorite: favoriteIds.contains(entry.value.id),
                      onTap: () => context.push('/detail/${entry.value.id}'),
                      onFavoriteToggle: () =>
                          ref.read(favoritesProvider.notifier).toggleFavorite(entry.value.id),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
