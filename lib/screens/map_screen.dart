import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/place_card.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider).take(4).toList();
    final favoriteIds = ref.watch(favoritesProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Container(
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [const Color(0xFF20283A), const Color(0xFF111827)]
                  : [const Color(0xFFF0F2FF), const Color(0xFFDCE2FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.16,
                  child: CustomPaint(painter: _GridPainter(color: AppColors.primary)),
                ),
              ),
              Positioned(
                top: 24,
                left: 24,
                child: Text(
                  'Map preview',
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              const _MapPin(top: 88, left: 92),
              const _MapPin(top: 124, left: 162),
              const _MapPin(top: 156, left: 222),
              const _MapPin(top: 68, left: 250),
              Positioned(
                right: 24,
                bottom: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '5 destinations nearby',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Nearby places',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        ...places.map(
          (place) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: PlaceCard(
              place: place,
              compact: true,
              isFavorite: favoriteIds.contains(place.id),
              onTap: () => context.push('/detail/${place.id}'),
              onFavoriteToggle: () => ref.read(favoritesProvider.notifier).toggleFavorite(place.id),
            ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;

  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x.toDouble(), 0), Offset(x.toDouble(), size.height), paint);
    }
    for (var y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y.toDouble()), Offset(size.width, y.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapPin extends StatelessWidget {
  final double top;
  final double left;

  const _MapPin({required this.top, required this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.place_rounded, color: AppColors.primary, size: 20),
      ),
    );
  }
}
