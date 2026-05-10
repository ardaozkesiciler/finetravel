import 'package:finetravel/models/social_models.dart';
import 'package:finetravel/services/social_service.dart';
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Friend'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                service.addFriend(SocialUser(
                  id: DateTime.now().toString(),
                  name: controller.text,
                  avatarUrl: 'https://i.pravatar.cc/150?u=${controller.text}',
                  isOnline: true,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
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
              trailing: IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {},
              ),
            );
          },
        );
      },
    );
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
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
