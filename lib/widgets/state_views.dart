import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class EmptyStateView extends StatelessWidget {
  final VoidCallback onClearFilters;

  const EmptyStateView({super.key, required this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _EmptyIllustration(
              isDark: isDark,
              icon: Icons.search_off_rounded,
              accentIcon: Icons.folder_open_outlined,
            ),
            const SizedBox(height: 24),
            Text(
              'No places found',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Try adjusting your search, region, or favorites filter to discover more destinations.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.68),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onClearFilters, child: const Text('Clear Filters')),
          ],
        ),
      ),
    );
  }
}

class OfflineStateView extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineStateView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _EmptyIllustration(
              isDark: isDark,
              icon: Icons.wifi_off_rounded,
              accentIcon: Icons.phone_iphone_rounded,
            ),
            const SizedBox(height: 24),
            Text(
              'You’re offline',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The app is showing cached places while it tries to reconnect.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.68),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final IconData accentIcon;

  const _EmptyIllustration({required this.isDark, required this.icon, required this.accentIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF2A3150), AppColors.primary.withValues(alpha: 0.18)]
                    : [const Color(0xFFF1F2FF), AppColors.primary.withValues(alpha: 0.14)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: 36,
            left: 38,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF20283A) : Colors.white,
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
          Icon(accentIcon, size: 64, color: AppColors.primary),
          Positioned(
            right: 38,
            bottom: 44,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 42, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
