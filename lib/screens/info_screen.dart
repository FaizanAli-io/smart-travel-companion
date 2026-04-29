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
        items: ['Lake Tekapo offline pack', 'Banff route notes', 'Amalfi photo cache'],
      ),
      'settings' => (
        title: 'Settings',
        subtitle: 'Adjust notifications, language, privacy, and map preferences.',
        items: ['Notifications', 'Language', 'Privacy', 'Map style'],
      ),
      'help' => (
        title: 'Help & Support',
        subtitle: 'Find answers or reach out if you need help planning your next trip.',
        items: ['FAQ', 'Contact support', 'Report a problem', 'Travel tips'],
      ),
      _ => (
        title: 'About Us',
        subtitle: 'Smart Travel Companion helps you discover, save, and compare memorable places.',
        items: ['Curated destinations', 'Offline-ready cache', 'Dark mode and personalization'],
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
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                tileColor: Theme.of(context).colorScheme.surface,
                leading: const Icon(Icons.arrow_right_rounded),
                title: Text(item, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
