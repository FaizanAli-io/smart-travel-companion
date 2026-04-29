import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/app_providers.dart';
import '../widgets/place_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritePlacesProvider);
    final favoriteIds = ref.watch(favoritesProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Text(
          'Your saved destinations',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          '${favorites.length} places bookmarked for later',
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                ElevatedButton(
                  onPressed: () => ref.read(selectedShellTabProvider.notifier).state = 0,
                  child: const Text('Explore places'),
                ),
              ],
            ),
          )
        else ...[
          ...favorites.map(
            (place) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: PlaceCard(
                place: place,
                compact: true,
                isFavorite: favoriteIds.contains(place.id),
                onTap: () => context.push('/detail/${place.id}'),
                onFavoriteToggle: () =>
                    ref.read(favoritesProvider.notifier).toggleFavorite(place.id),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
