import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/photo.dart';
import '../providers/app_providers.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final Photo photo;

  const DetailScreen({Key? key, required this.photo}) : super(key: key);

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final weatherAsyncValue = ref.watch(weatherProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.photo.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              background: Hero(
                tag: 'photo_${widget.photo.id}',
                child: CachedNetworkImage(
                  imageUrl: widget.photo.url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.grey[400], child: const Icon(Icons.error, size: 50)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weather Info',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: weatherAsyncValue.when(
                      data: (weather) {
                        return Container(
                          key: const ValueKey('weather_data'),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.blueGrey[900] : Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.thermostat, color: Colors.blue, size: 40),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${weather['temperature']} °C',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Wind: ${weather['windspeed']} km/h'),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      loading: () => Container(
                        key: const ValueKey('weather_loading'),
                        padding: const EdgeInsets.all(16),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      error: (err, stack) => Container(
                        key: const ValueKey('weather_error'),
                        padding: const EdgeInsets.all(16),
                        child: Text('Failed to load weather: $err'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'This is a detailed description of the place represented by photo ${widget.photo.id}. ' *
                                  (_isExpanded ? 10 : 2),
                              style: const TextStyle(fontSize: 16),
                              maxLines: _isExpanded ? null : 3,
                              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isExpanded ? 'Show less' : 'Read more',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
    );
  }
}
