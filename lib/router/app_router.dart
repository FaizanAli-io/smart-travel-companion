import 'package:go_router/go_router.dart';

import '../screens/app_shell_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/info_screen.dart';
import '../screens/offline_screen.dart';
import '../screens/search_screen.dart';
import '../screens/theme_preview_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppShellScreen()),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final placeId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return DetailScreen(placeId: placeId);
      },
    ),
    GoRoute(path: '/offline', builder: (context, state) => const OfflineScreen()),
    GoRoute(path: '/theme-preview', builder: (context, state) => const ThemePreviewScreen()),
    GoRoute(
      path: '/info/:section',
      builder: (context, state) {
        final section = state.pathParameters['section'] ?? 'about';
        return InfoScreen(section: section);
      },
    ),
  ],
);
