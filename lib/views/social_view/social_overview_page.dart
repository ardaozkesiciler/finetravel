import 'package:finetravel/models/social_models.dart';
import 'package:finetravel/services/social_service.dart';
import 'package:finetravel/views/social_view/chat_page.dart';
import 'package:flutter/material.dart';

class SocialOverviewPage extends StatelessWidget {
  const SocialOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = SocialService();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Social', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Friends'),
              Tab(text: 'Messages'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _FriendsList(service: service),
            _MessagesList(service: service),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddFriendDialog(context, service),
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context, SocialService service) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Friend',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect with other travelers around the world.',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter name or email',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    service.addFriend(SocialUser(
                      id: DateTime.now().toString(),
                      name: controller.text,
                      avatarUrl: 'https://i.pravatar.cc/150?u=${controller.text}',
                      isOnline: true,
                    ));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added ${controller.text} as friend!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Add Friend', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FriendsList extends StatelessWidget {
  final SocialService service;
  const _FriendsList({required this.service});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: service,
      builder: (context, child) {
        final friends = service.friends;
        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(friend.avatarUrl)),
                  if (friend.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(friend.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(friend.isOnline ? 'Online' : 'Offline'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatPage(friend: friend)),
                      );
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleFriendAction(context, value, friend, service),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'remove', child: Text('Remove Friend')),
                      const PopupMenuItem(value: 'block', child: Text('Block User', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleFriendAction(BuildContext context, String action, SocialUser friend, SocialService service) {
    if (action == 'remove') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Remove Friend'),
          content: Text('Are you sure you want to remove ${friend.name} from your friends?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                service.removeFriend(friend.id);
                Navigator.pop(context);
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else if (action == 'block') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Block User'),
          content: Text('Are you sure you want to block ${friend.name}? They will no longer be able to message you.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                service.blockUser(friend.id);
                Navigator.pop(context);
              },
              child: const Text('Block', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }
}

class _MessagesList extends StatelessWidget {
  final SocialService service;
  const _MessagesList({required this.service});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: service,
      builder: (context, child) {
        // Mocking a list of chats
        final chats = service.friends;
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final friend = chats[index];
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(friend.avatarUrl)),
              title: Text(friend.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Start a conversation...'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatPage(friend: friend)),
                );
              },
            );
          },
        );
      },
    );
  }
}
