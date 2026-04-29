import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Light & Dark Theme')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Text(
            'Theme comparison',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'The app switches between a clean white surface and a deep charcoal/navy surface with the same purple accent system.',
            style: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 700) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: _ThemePreviewPane(title: 'Light Theme', isDark: false)),
                    SizedBox(width: 16),
                    Expanded(child: _ThemePreviewPane(title: 'Dark Theme', isDark: true)),
                  ],
                );
              }

              return const Column(
                children: [
                  _ThemePreviewPane(title: 'Light Theme', isDark: false),
                  SizedBox(height: 16),
                  _ThemePreviewPane(title: 'Dark Theme', isDark: true),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ThemePreviewPane extends StatelessWidget {
  final String title;
  final bool isDark;

  const _ThemePreviewPane({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final background = isDark ? AppColors.deepNavy : Colors.white;
    final surface = isDark ? const Color(0xFF1D2537) : const Color(0xFFF8F9FF);
    final textColor = isDark ? Colors.white : const Color(0xFF162033);
    final secondaryColor = isDark ? const Color(0xFFB4BDD5) : AppColors.mutedText;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(color: textColor, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lake Tekapo',
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Canterbury, New Zealand',
                  style: GoogleFonts.poppins(color: secondaryColor, fontSize: 12),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ThemeChip(label: 'All', isDark: isDark),
                    _ThemeChip(label: 'Favorites', isDark: isDark),
                    _ThemeChip(label: 'Recent', isDark: isDark),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF27324B), const Color(0xFF141A29)]
                          : [const Color(0xFFE7E9FF), const Color(0xFFD2D7FF)],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.landscape_rounded,
                      color: AppColors.primary,
                      size: isDark ? 42 : 40,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Primary'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(onPressed: () {}, child: const Text('Outline')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _ThemeChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: isDark ? const Color(0xFF283149) : const Color(0xFFEFF0FF),
      labelStyle: GoogleFonts.poppins(
        color: isDark ? Colors.white : const Color(0xFF162033),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
