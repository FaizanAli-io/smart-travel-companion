import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/app_providers.dart';
import '../widgets/app_drawer.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedShellTabProvider);
    final pages = const [HomeScreen(), MapScreen(), FavoritesScreen(), ProfileScreen()];

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(switch (selectedTab) {
          1 => 'Explore Places',
          2 => 'Favorites',
          3 => 'Profile',
          _ => 'Explore Places',
        }),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (selectedTab == 0)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => context.push('/search'),
            ),
          IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Offline Mode Indicator
            Consumer(
              builder: (context, ref, _) {
                final isOffline = ref.watch(isOfflineSessionProvider);
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isOffline
                      ? Container(
                          key: const ValueKey('offline-indicator'),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.wifi_off_rounded,
                                color: Theme.of(context).colorScheme.onErrorContainer,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Offline Mode',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('online-indicator')),
                );
              },
            ),
            // Main Content
            Expanded(
              child: IndexedStack(
                index: selectedTab,
                children: [
                  HeroMode(enabled: selectedTab == 0, child: pages[0]),
                  HeroMode(enabled: selectedTab == 1, child: pages[1]),
                  HeroMode(enabled: selectedTab == 2, child: pages[2]),
                  HeroMode(enabled: selectedTab == 3, child: pages[3]),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (sheetContext) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Actions', style: Theme.of(sheetContext).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.place_outlined),
                      title: const Text('Plan a trip'),
                      subtitle: const Text('Open the search screen and compare destinations.'),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        context.push('/search');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.download_outlined),
                      title: const Text('Offline cache'),
                      subtitle: const Text('Review the cached-place fallback experience.'),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        context.push('/offline');
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBarTheme(
        data: Theme.of(context).navigationBarTheme,
        child: BottomAppBar(
          height: 74,
          padding: EdgeInsets.zero,
          color: Theme.of(context).navigationBarTheme.backgroundColor,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () => ref.read(selectedShellTabProvider.notifier).state = 0,
                  icon: Icon(
                    Icons.home_rounded,
                    color: selectedTab == 0 ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () => ref.read(selectedShellTabProvider.notifier).state = 1,
                  icon: Icon(
                    Icons.map_rounded,
                    color: selectedTab == 1 ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
              ),
              const SizedBox(width: 72),
              Expanded(
                child: IconButton(
                  onPressed: () => ref.read(selectedShellTabProvider.notifier).state = 2,
                  icon: Icon(
                    Icons.favorite_rounded,
                    color: selectedTab == 2 ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () => ref.read(selectedShellTabProvider.notifier).state = 3,
                  icon: Icon(
                    Icons.person_rounded,
                    color: selectedTab == 3 ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
