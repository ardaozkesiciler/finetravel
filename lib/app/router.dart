import 'package:finetravel/pages/login_register.dart';
import 'package:finetravel/views/app_view.dart';
import 'package:finetravel/views/favorites_view/favorites.dart';
import 'package:finetravel/views/home_view/home.dart';
import 'package:finetravel/views/profile_view/profile.dart';
import 'package:finetravel/views/social_view/feed_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _routerKey = GlobalKey<NavigatorState>();

class AppRoutes {
  AppRoutes._();
  static const String Home = '/';
  static const String Feed = '/feed';
  static const String Favorites = '/favorites';
  static const String Profile = '/profile';
  static const String LoginRegister = '/login_register';
}

final router = GoRouter(
  navigatorKey: _routerKey,
  initialLocation: AppRoutes.Home,

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppView(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.Home,
              builder: (context, state) => const Home(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.Feed,
              builder: (context, state) => const FeedPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.Favorites,
              builder: (context, state) => const Favorites(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.Profile,
              builder: (context, state) => const Profile(),
            ),
          ],
        ),
      ],
    ),
  ],
);
