import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_entrance.dart';
import '../widgets/place_card.dart';
import '../widgets/state_views.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placesAsync = ref.watch(homePlacesProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final homeFeedMode = ref.watch(homeFeedModeProvider);
    final offlineMode = ref.watch(isOfflineSessionProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(placesProvider);
        await Future<void>.delayed(const Duration(milliseconds: 450));
      },
      child: placesAsync.when(
        loading: () => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: const [
            SizedBox(height: 120),
            Center(child: CircularProgressIndicator()),
          ],
        ),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [OfflineStateView(onRetry: () => ref.invalidate(placesProvider))],
        ),
        data: (places) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            AnimatedEntrance(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: offlineMode
                    ? Container(
                        key: const ValueKey('offline-banner'),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off_rounded, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Offline mode is active. Only cached places are visible.',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('online-banner')),
              ),
            ),
            if (offlineMode) const SizedBox(height: 18),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 40),
              child: GestureDetector(
                onTap: () => context.push('/search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.55),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search places',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.58),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Icon(Icons.tune_rounded),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 70),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ModeChip(
                      label: 'All',
                      selected: homeFeedMode == HomeFeedMode.all,
                      onTap: () => ref.read(homeFeedModeProvider.notifier).state = HomeFeedMode.all,
                    ),
                    const SizedBox(width: 10),
                    _ModeChip(
                      label: 'Favorites',
                      selected: homeFeedMode == HomeFeedMode.favorites,
                      onTap: () =>
                          ref.read(homeFeedModeProvider.notifier).state = HomeFeedMode.favorites,
                    ),
                    const SizedBox(width: 10),
                    _ModeChip(
                      label: 'Recent',
                      selected: homeFeedMode == HomeFeedMode.recent,
                      onTap: () =>
                          ref.read(homeFeedModeProvider.notifier).state = HomeFeedMode.recent,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            if (places.isEmpty)
              EmptyStateView(
                onClearFilters: () {
                  ref.read(searchQueryProvider.notifier).state = '';
                  ref.read(homeFeedModeProvider.notifier).state = HomeFeedMode.all;
                },
              )
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    homeFeedMode == HomeFeedMode.recent ? 'Recently viewed' : 'Discover places',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${places.length} results',
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...places.asMap().entries.map(
                (entry) => AnimatedEntrance(
                  delay: Duration(milliseconds: 50 + entry.key * 35),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: PlaceCard(
                      place: entry.value,
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

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(label: Text(label), selected: selected, onSelected: (_) => onTap());
  }
}
