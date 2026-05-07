import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/place.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<int> _visiblePlaceIds = [];
  int _lastAnimatedCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateNearestPlaces());
  }

  Future<void> _animateNearestPlaces() async {
    final nearestPlacesAsync = ref.read(nearestPlacesProvider);
    final nearestPlaces = nearestPlacesAsync.maybeWhen(
      data: (places) => places,
      orElse: () => <TravelPlace>[],
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _visiblePlaceIds.clear();
      _lastAnimatedCount = nearestPlaces.length;
    });

    for (var index = 0; index < nearestPlaces.length; index++) {
      await Future<void>.delayed(const Duration(milliseconds: 70));
      if (!mounted) {
        return;
      }
      setState(() {
        _visiblePlaceIds.add(nearestPlaces[index].id);
      });
      _listKey.currentState?.insertItem(index, duration: const Duration(milliseconds: 260));
    }
  }

  Future<void> _handleRefresh() async {
    final refreshedPlaces = await ref.refresh(placesProvider.future);
    if (refreshedPlaces.isEmpty) {
      return;
    }
    await _animateNearestPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(karachiLocationProvider);
    final nearestPlacesAsync = ref.watch(nearestPlacesProvider);
    final selectedPlace = ref.watch(selectedMapPlaceProvider);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: nearestPlacesAsync.when(
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
          children: [
            Text(
              'Unable to load nearby places.',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(error.toString(), style: GoogleFonts.poppins(fontSize: 12)),
          ],
        ),
        data: (nearestPlaces) {
          if (_lastAnimatedCount != nearestPlaces.length && nearestPlaces.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _animateNearestPlaces());
          }

          TravelPlace? focusPlace = selectedPlace;
          if (focusPlace == null && nearestPlaces.isNotEmpty) {
            focusPlace = nearestPlaces.first;
          }

          final visibleMarkers = <TravelPlace>{...nearestPlaces};
          if (selectedPlace != null) {
            visibleMarkers.add(selectedPlace);
          }

          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? [const Color(0xFF20283A), const Color(0xFF111827)]
                        : [const Color(0xFFF1F4FF), const Color(0xFFDCE3FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your map view',
                              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentLocation.label,
                              style: GoogleFonts.poppins(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${nearestPlaces.length} nearest places',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _WorldMapPainter(
                                  gridColor: AppColors.primary,
                                  highlightColor: Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFF6E7BFF)
                                      : const Color(0xFF8290FF),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.04),
                                      Colors.black.withValues(alpha: 0.14),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ...visibleMarkers.map((place) {
                              final point = _projectPoint(
                                place.latitude,
                                place.longitude,
                                currentLocation.latitude,
                                currentLocation.longitude,
                              );
                              final isSelected = selectedPlace?.id == place.id;
                              return Positioned(
                                left: point.dx - 14,
                                top: point.dy - 14,
                                child: GestureDetector(
                                  onTap: () {
                                    ref.read(selectedMapPlaceIdProvider.notifier).state = place.id;
                                    context.push('/detail/${place.id}');
                                  },
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 200),
                                    scale: isSelected ? 1.12 : 1,
                                    child: _DestinationPin(isSelected: isSelected),
                                  ),
                                ),
                              );
                            }),
                            Positioned(
                              left:
                                  _projectPoint(
                                    currentLocation.latitude,
                                    currentLocation.longitude,
                                    currentLocation.latitude,
                                    currentLocation.longitude,
                                  ).dx -
                                  18,
                              top:
                                  _projectPoint(
                                    currentLocation.latitude,
                                    currentLocation.longitude,
                                    currentLocation.latitude,
                                    currentLocation.longitude,
                                  ).dy -
                                  18,
                              child: const _CurrentLocationPin(),
                            ),
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _MapOverlayChip(
                                      icon: Icons.my_location_rounded,
                                      label: currentLocation.label,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _MapOverlayChip(
                                      icon: Icons.place_rounded,
                                      label: focusPlace == null
                                          ? 'Tap a pin to focus'
                                          : focusPlace.name,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nearest recommendations',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Top five places ranked from Karachi, Pakistan.',
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.64),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedList(
                      key: _listKey,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      initialItemCount: _visiblePlaceIds.length,
                      itemBuilder: (context, index, animation) {
                        final place = nearestPlaces[index];
                        final distanceKm = distanceFromKarachiKm(place, currentLocation);
                        final isSelected = selectedPlace?.id == place.id;
                        return SizeTransition(
                          sizeFactor: animation,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.08)
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.4)
                                      : Theme.of(context).dividerColor.withValues(alpha: 0.24),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                                  child: Text(
                                    '${index + 1}',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  place.name,
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  '${place.locationLabel} • ${distanceKm.toStringAsFixed(0)} km away',
                                  style: GoogleFonts.poppins(),
                                ),
                                trailing: const Icon(Icons.chevron_right_rounded),
                                onTap: () {
                                  ref.read(selectedMapPlaceIdProvider.notifier).state = place.id;
                                  context.push('/detail/${place.id}');
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (focusPlace != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Focused destination',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        focusPlace.name,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        focusPlace.description,
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _WorldMapPainter extends CustomPainter {
  final Color gridColor;
  final Color highlightColor;

  _WorldMapPainter({required this.gridColor, required this.highlightColor});

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          highlightColor.withValues(alpha: 0.18),
          const Color(0xFF0F172A).withValues(alpha: 0.05),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, background);

    final linePaint = Paint()
      ..color = gridColor.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var x = 0; x <= size.width; x += 42) {
      canvas.drawLine(Offset(x.toDouble(), 0), Offset(x.toDouble(), size.height), linePaint);
    }
    for (var y = 0; y <= size.height; y += 42) {
      canvas.drawLine(Offset(0, y.toDouble()), Offset(size.width, y.toDouble()), linePaint);
    }

    final glowPaint = Paint()..color = highlightColor.withValues(alpha: 0.10);
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.52), 120, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _WorldMapPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor || oldDelegate.highlightColor != highlightColor;
  }
}

class _CurrentLocationPin extends StatelessWidget {
  const _CurrentLocationPin();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.34),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.my_location_rounded, color: AppColors.primary, size: 20),
    );
  }
}

class _DestinationPin extends StatelessWidget {
  final bool isSelected;

  const _DestinationPin({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSelected ? 30 : 26,
      width: isSelected ? 30 : 26,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isSelected ? Colors.white : AppColors.primary.withValues(alpha: 0.28),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.place_rounded,
        color: isSelected ? Colors.white : AppColors.primary,
        size: 16,
      ),
    );
  }
}

class _MapOverlayChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MapOverlayChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

Offset _projectPoint(
  double latitude,
  double longitude,
  double centerLatitude,
  double centerLongitude,
) {
  const width = 260.0;
  const height = 300.0;
  const longitudeScale = 360.0;
  const latitudeScale = 180.0;

  final longitudeOffset = ((longitude + 180.0) / longitudeScale) * width;
  final latitudeOffset = ((90.0 - latitude) / latitudeScale) * height;

  return Offset(longitudeOffset, latitudeOffset);
}
