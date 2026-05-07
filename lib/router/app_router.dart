import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';

import '../screens/app_shell_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/info_screen.dart';
import '../screens/offline_screen.dart';
import '../screens/search_screen.dart';
import '../screens/theme_preview_screen.dart';

Page<dynamic> _animatedPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<dynamic>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0.03, 0.03),
        end: Offset.zero,
      ).animate(fadeAnimation);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _animatedPage(state, const AppShellScreen()),
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) => _animatedPage(state, const SearchScreen()),
    ),
    GoRoute(
      path: '/detail/:id',
      pageBuilder: (context, state) {
        final placeId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return _animatedPage(state, DetailScreen(placeId: placeId));
      },
    ),
    GoRoute(
      path: '/offline',
      pageBuilder: (context, state) => _animatedPage(state, const OfflineScreen()),
    ),
    GoRoute(
      path: '/theme-preview',
      pageBuilder: (context, state) => _animatedPage(state, const ThemePreviewScreen()),
    ),
    GoRoute(
      path: '/info/:section',
      pageBuilder: (context, state) {
        final section = state.pathParameters['section'] ?? 'about';
        return _animatedPage(state, InfoScreen(section: section));
      },
    ),
  ],
);
