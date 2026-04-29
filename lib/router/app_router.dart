import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/detail_screen.dart';
import '../models/photo.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final photo = state.extra as Photo;
        return DetailScreen(photo: photo);
      },
    ),
  ],
);
