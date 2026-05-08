import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/place.dart';
import '../providers/app_providers.dart';

class InfoScreen extends ConsumerWidget {
  final String section;

  const InfoScreen({super.key, required this.section});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (section) {
      'downloaded' => _buildDownloaded(context, ref),
      'settings' => _buildSettings(context, ref),
      'help' => _buildHelp(context),
      _ => _buildAbout(context),
    };
  }

  Widget _buildScaffold({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(subtitle, style: GoogleFonts.poppins(height: 1.6)),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDownloaded(BuildContext context, WidgetRef ref) {
    final cachedPlacesAsync = ref.watch(cachedPlacesProvider);

    return _buildScaffold(
      context: context,
      title: 'Downloaded',
      subtitle: 'These places are already stored in local cache and stay available offline.',
      children: [
        cachedPlacesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => _InfoMessageCard(
            title: 'Cache unavailable',
            body: 'We could not read the local cache right now. $error',
            icon: Icons.cloud_off_rounded,
          ),
          data: (places) {
            if (places.isEmpty) {
              return _InfoMessageCard(
                title: 'No cached places yet',
                body: 'Open a few places while online and they will appear here automatically.',
                icon: Icons.download_done_rounded,
              );
            }

            return Column(
              children: places
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CachedPlaceCard(
                        place: entry.value,
                        index: entry.key,
                        onTap: () => context.push('/detail/${entry.value.id}'),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettings(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;
    final mapViewMode = ref.watch(mapViewModeProvider);
    final offlineMode = ref.watch(offlineModeProvider);

    return _buildScaffold(
      context: context,
      title: 'Settings',
      subtitle: 'Control appearance, map rendering, and offline behavior from one place.',
      children: [
        Card(
          child: Column(
            children: [
              SwitchListTile(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeModeProvider.notifier).state = value
                      ? ThemeMode.dark
                      : ThemeMode.light;
                },
                title: const Text('Dark mode'),
                subtitle: const Text('Use a darker palette for the entire app.'),
                secondary: const Icon(Icons.dark_mode_rounded),
              ),
              SwitchListTile(
                value: mapViewMode == MapViewMode.satellite,
                onChanged: (value) {
                  ref.read(mapViewModeProvider.notifier).state = value
                      ? MapViewMode.satellite
                      : MapViewMode.classic;
                },
                title: const Text('Satellite-style map view'),
                subtitle: const Text('Changes the look of the map tab.'),
                secondary: const Icon(Icons.map_rounded),
              ),
              SwitchListTile(
                value: offlineMode,
                onChanged: (value) => ref.read(offlineModeProvider.notifier).state = value,
                title: const Text('Offline mode'),
                subtitle: const Text('Use cached places and disable live refresh.'),
                secondary: const Icon(Icons.wifi_off_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _InfoMessageCard(
          title: 'What these toggles do',
          body:
              'Dark mode changes the app theme, map view updates the map screen styling, and offline mode forces cached content so the app stays usable without a connection.',
          icon: Icons.tune_rounded,
        ),
      ],
    );
  }

  Widget _buildHelp(BuildContext context) {
    return _buildScaffold(
      context: context,
      title: 'Help & Support',
      subtitle: 'Reach support, read answers, and find the quickest path to fixing common issues.',
      children: [
        _SectionCard(
          title: 'Contact support',
          icon: Icons.support_agent_rounded,
          children: const [
            _ContactLine(label: 'Email', value: 'support@travelyapp.example'),
            _ContactLine(label: 'Emergency hotline', value: '+1 (555) 014-2219'),
            _ContactLine(label: 'Business inquiries', value: 'partners@travelyapp.example'),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'FAQs',
          icon: Icons.quiz_outlined,
          children: const [
            _FaqTile(
              question: 'Why does weather show offline text?',
              answer:
                  'Live weather needs an internet connection. When you are offline, the app shows a message instead of trying to fetch data that cannot load.',
            ),
            _FaqTile(
              question: 'How do I save a place for later?',
              answer:
                  'Open any place and tap the heart icon. Saved places appear in Favorites and remain available for quick access.',
            ),
            _FaqTile(
              question: 'What happens in offline mode?',
              answer:
                  'The app switches to cached places only, which keeps downloaded destinations and previously fetched data available.',
            ),
            _FaqTile(
              question: 'How can I report a bug?',
              answer:
                  'Send a short report to support@travelyapp.example with the screen name, what happened, and any error message you saw.',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAbout(BuildContext context) {
    return _buildScaffold(
      context: context,
      title: 'About Us',
      subtitle:
          'Travely is a travel discovery app built around useful trip planning, saved places, and offline resilience.',
      children: [
        _InfoMessageCard(
          title: 'Our mission',
          body:
              'We help travelers discover destinations, save places for later, and keep useful trip details available when signal drops.',
          icon: Icons.travel_explore_rounded,
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(
              child: _StatPill(label: 'Curated places', value: '36+'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatPill(label: 'Support reply time', value: '24h'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: _StatPill(label: 'Regions covered', value: '12'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatPill(label: 'Offline-ready cache', value: '100%'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Contact us',
          icon: Icons.alternate_email_rounded,
          children: const [
            _ContactLine(label: 'General', value: 'hello@travelyapp.example'),
            _ContactLine(label: 'Media', value: 'press@travelyapp.example'),
            _ContactLine(label: 'Phone', value: '+1 (555) 018-4088'),
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: 'Common questions',
          icon: Icons.question_answer_rounded,
          children: const [
            _FaqTile(
              question: 'How often is the destination data updated?',
              answer:
                  'The app refreshes when connectivity returns, and cached content remains available between syncs.',
            ),
            _FaqTile(
              question: 'Can I use the app entirely offline?',
              answer:
                  'Yes, if the destinations you need are already cached. You will still see saved content, favorites, and offline-ready details.',
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  final String label;
  final String value;

  const _ContactLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.74),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      title: Text(question, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoMessageCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData icon;

  const _InfoMessageCard({required this.title, required this.body, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.74),
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CachedPlaceCard extends StatelessWidget {
  final TravelPlace place;
  final int index;
  final VoidCallback onTap;

  const _CachedPlaceCard({required this.place, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          child: Text(
            '${index + 1}',
            style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(place.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${place.locationLabel} • Cached on this device',
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.66),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ],
      ),
    );
  }
}
