import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoScreen extends StatelessWidget {
  final String section;

  const InfoScreen({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final details = switch (section) {
      'downloaded' => (
        title: 'Downloaded',
        subtitle: 'Your saved cache and offline-ready destinations live here.',
        items: [
          ('Lake Tekapo offline pack', 'Offline photos, notes, and map context for Lake Tekapo.'),
          ('Banff route notes', 'Trail ideas and saved trip details for Banff National Park.'),
          ('Amalfi photo cache', 'Cached imagery and travel notes for the Amalfi Coast.'),
        ],
      ),
      'settings' => (
        title: 'Settings',
        subtitle: 'Adjust notifications, language, privacy, and map preferences.',
        items: [
          ('Notifications', 'Control alerts for favorites, downloads, and trip reminders.'),
          ('Language', 'Change the app language from the profile and drawer controls.'),
          ('Privacy', 'Manage location access, analytics, and cached history preferences.'),
          ('Map style', 'Switch between light, dark, and satellite-style map views.'),
        ],
      ),
      'help' => (
        title: 'Help & Support',
        subtitle: 'Find answers or reach out if you need help planning your next trip.',
        items: [
          ('FAQ', 'Quick answers to common questions about search, favorites, and offline mode.'),
          ('Contact support', 'Email the support team for account or trip-planning help.'),
          ('Report a problem', 'Share a bug report if something does not load or behaves oddly.'),
          ('Travel tips', 'Get ideas for planning, saving, and comparing destinations.'),
        ],
      ),
      _ => (
        title: 'About Us',
        subtitle: 'Smart Travel Companion helps you discover, save, and compare memorable places.',
        items: [
          (
            'Curated destinations',
            'A handpicked set of places with rich imagery and trip details.',
          ),
          ('Offline-ready cache', 'Saved data stays available when the connection is unavailable.'),
          (
            'Dark mode and personalization',
            'Theme controls and saved preferences tailor the experience.',
          ),
        ],
      ),
    };

    return Scaffold(
      appBar: AppBar(title: Text(details.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Text(
            details.title,
            style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(details.subtitle, style: GoogleFonts.poppins(height: 1.6)),
          const SizedBox(height: 18),
          ...details.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                backgroundColor: Theme.of(context).colorScheme.surface,
                collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
                leading: const Icon(Icons.arrow_right_rounded),
                title: Text(item.$1, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.$2,
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                        height: 1.6,
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
