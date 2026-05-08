import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/place.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final int placeId;

  const DetailScreen({super.key, required this.placeId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> with TickerProviderStateMixin {
  bool _isAboutExpanded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentPlaceIdsProvider.notifier).markVisited(widget.placeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(placesProvider);

    return placesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error.toString())),
      ),
      data: (places) {
        TravelPlace? place;
        for (final candidate in places) {
          if (candidate.id == widget.placeId) {
            place = candidate;
            break;
          }
        }
        final currentPlace = place;
        final isFavorite = ref.watch(favoritesProvider).contains(widget.placeId);

        if (currentPlace == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Place not found.')),
          );
        }

        final placeData = currentPlace;

        final isOfflineSession = ref.watch(isOfflineSessionProvider);
        final weatherAsync = ref.watch(placeWeatherProvider(widget.placeId));

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 360,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: 'place_${placeData.id}',
                            child: CachedNetworkImage(
                              imageUrl: placeData.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: const Icon(Icons.image_not_supported_outlined, size: 42),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.08),
                                  Colors.black.withValues(alpha: 0.5),
                                ],
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _RoundActionButton(
                                    icon: Icons.arrow_back_rounded,
                                    onTap: () => context.pop(),
                                  ),
                                  _RoundActionButton(
                                    icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? AppColors.danger : Colors.white,
                                    onTap: () => ref
                                        .read(favoritesProvider.notifier)
                                        .toggleFavorite(placeData.id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    placeData.category,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  placeData.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  placeData.locationLabel,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withValues(alpha: 0.86),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 110),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About the place',
                            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeInOut,
                            child: Container(
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
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 42,
                                        width: 42,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: const Icon(
                                          Icons.info_outline_rounded,
                                          color: AppColors.primary,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          placeData.aboutSummary,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            height: 1.55,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isAboutExpanded = !_isAboutExpanded;
                                          });
                                        },
                                        icon: AnimatedRotation(
                                          duration: const Duration(milliseconds: 200),
                                          turns: _isAboutExpanded ? 0.5 : 0,
                                          child: const Icon(Icons.expand_more_rounded),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_isAboutExpanded) ...[
                                    const SizedBox(height: 14),
                                    Text(
                                      placeData.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        height: 1.7,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withValues(alpha: 0.78),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            'Current Weather',
                            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
                              ),
                            ),
                            child: isOfflineSession
                                ? const _WeatherOfflineNotice()
                                : AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    child: weatherAsync.when(
                                      loading: () =>
                                          const _WeatherLoading(key: ValueKey('weather-loading')),
                                      error: (error, _) => _WeatherError(
                                        key: const ValueKey('weather-error'),
                                        message: error.toString(),
                                        onRetry: () =>
                                            ref.invalidate(placeWeatherProvider(widget.placeId)),
                                      ),
                                      data: (weather) => _WeatherContent(
                                        key: const ValueKey('weather-content'),
                                        weather: weather,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(selectedMapPlaceIdProvider.notifier).state = placeData.id;
                        ref.read(selectedShellTabProvider.notifier).state = 1;
                        context.go('/');
                      },
                      icon: const Icon(Icons.map_rounded),
                      label: const Text('View on Map'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _RoundActionButton({required this.icon, required this.onTap, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.22),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  final String label;
  final String value;

  const _WeatherMetric({required this.label, required this.value});

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _WeatherOfflineNotice extends StatelessWidget {
  const _WeatherOfflineNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, color: AppColors.primary, size: 34),
          const SizedBox(height: 12),
          Text(
            'You are offline.',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Connect to the internet to load current weather for this destination.',
            style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.64),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WeatherLoading extends StatelessWidget {
  const _WeatherLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 170, child: Center(child: CircularProgressIndicator()));
  }
}

class _WeatherError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _WeatherError({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Unable to load live weather.',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final WeatherSnapshot weather;

  const _WeatherContent({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.thermostat_rounded, color: AppColors.primary, size: 34),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.temperature.toStringAsFixed(0)}°C',
                    style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather.conditions,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.64),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.9,
          children: [
            _WeatherMetric(label: 'Wind', value: '${weather.windSpeed.toStringAsFixed(0)} km/h'),
            _WeatherMetric(label: 'Humidity', value: '${weather.humidity}%'),
            _WeatherMetric(label: 'Feels like', value: '${weather.feelsLike.toStringAsFixed(0)}°C'),
            _WeatherMetric(label: 'Condition', value: weather.conditions),
          ],
        ),
      ],
    );
  }
}
