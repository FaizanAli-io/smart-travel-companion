import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/app_providers.dart';
import '../widgets/animated_entrance.dart';
import '../widgets/place_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritePlacesProvider);
    final favoriteIds = ref.watch(favoritesProvider);

    return favoritesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          AnimatedEntrance(
            child: Text(
              'Your saved destinations',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 24),
          Text('Favorites are unavailable right now.', style: GoogleFonts.poppins()),
        ],
      ),
      data: (favorites) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          AnimatedEntrance(
            child: Text(
              'Your saved destinations',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedEntrance(
            delay: const Duration(milliseconds: 45),
            child: Text(
              '${favorites.length} places bookmarked for later',
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (favorites.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart on a place card to save it here.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.68),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedEntrance(
                    delay: const Duration(milliseconds: 80),
                    child: ElevatedButton(
                      onPressed: () => ref.read(selectedShellTabProvider.notifier).state = 0,
                      child: const Text('Explore places'),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            ...favorites.asMap().entries.map(
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
    );
  }
}
