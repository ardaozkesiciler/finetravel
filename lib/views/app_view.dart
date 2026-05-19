import 'dart:io';
import 'package:finetravel/services/auth.dart';
import 'package:finetravel/services/social_service.dart';
import 'package:finetravel/views/notifications_view/notifications_page.dart';
import 'package:finetravel/views/settings_view/settings_page.dart';
import 'package:finetravel/views/home_view/add_place_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppView({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Auth(),
      builder: (context, child) {
        final user = Auth().currentUser;
        final String displayName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Explorer';

        return Scaffold(
          appBar: _customAppBar(context, displayName, navigationShell.currentIndex),
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
            destinations: [
              _menuItem(
                context,
                index: 0,
                currentIndex: navigationShell.currentIndex,
                label: 'EXPLORE',
                icon: CupertinoIcons.compass_fill,
              ),
              _menuItem(
                context,
                index: 1,
                currentIndex: navigationShell.currentIndex,
                label: 'FEED',
                icon: CupertinoIcons.square_stack_3d_up_fill,
              ),
              _menuItem(
                context,
                index: 2,
                currentIndex: navigationShell.currentIndex,
                label: 'TRIPS',
                icon: CupertinoIcons.map_fill,
              ),
              _menuItem(
                context,
                index: 3,
                currentIndex: navigationShell.currentIndex,
                label: 'PROFILE',
                icon: CupertinoIcons.person_fill,
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _customAppBar(BuildContext context, String name, int currentIndex) {
    return AppBar(
      toolbarHeight: 80,
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: Auth().avatarPath != null
                    ? FileImage(File(Auth().avatarPath!)) as ImageProvider
                    : NetworkImage('https://i.pravatar.cc/150?u=${Auth().currentUser?.uid}'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${Auth().username.toUpperCase()}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Welcome back, $name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (currentIndex == 0)
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AddPlaceDialog(
                  onPlaceAdded: () {},
                ),
              );
            },
            child: _appBarAction(context, CupertinoIcons.add),
          ),
        if (currentIndex == 0)
          const SizedBox(width: 8),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          ),
          child: ListenableBuilder(
            listenable: SocialService(),
            builder: (context, child) {
              final unreadCount = SocialService().unreadNotificationsCount;
              return Stack(
                children: [
                  _appBarAction(context, CupertinoIcons.bell_fill),
                  if (unreadCount > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          ),
          child: _appBarAction(context, CupertinoIcons.settings_solid),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _appBarAction(BuildContext context, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required int index,
    required int currentIndex,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = currentIndex == index;
    return NavigationDestination(
      icon: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
      ),
      label: label,
    );
  }
}
