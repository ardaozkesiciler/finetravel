import 'package:finetravel/models/social_models.dart';
import 'package:flutter/material.dart';

class SocialService extends ChangeNotifier {
  static final SocialService _instance = SocialService._internal();
  factory SocialService() => _instance;
  SocialService._internal() {
    _initializeMockData();
  }

  final List<SocialUser> _friends = [];
  final List<ChatMessage> _messages = [];
  final List<AppNotification> _notifications = [];

  List<SocialUser> get friends => List.unmodifiable(_friends);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  void _initializeMockData() {
    _friends.addAll([
      SocialUser(id: '1', name: 'John Doe', avatarUrl: 'https://i.pravatar.cc/150?u=1', isOnline: true),
      SocialUser(id: '2', name: 'Jane Smith', avatarUrl: 'https://i.pravatar.cc/150?u=2', isOnline: false),
      SocialUser(id: '3', name: 'Alex Johnson', avatarUrl: 'https://i.pravatar.cc/150?u=3', isOnline: true),
    ]);

    _notifications.addAll([
      AppNotification(
        id: '1',
        title: 'New Friend Request',
        body: 'Sarah Miller wants to be your friend.',
        type: NotificationType.friendRequest,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: '2',
        title: 'New Message',
        body: 'Alex: Are you coming to Bali next week?',
        type: NotificationType.message,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ]);
  }

  void addFriend(SocialUser user) {
    if (!_friends.any((f) => f.id == user.id)) {
      _friends.add(user);
      _notifications.add(AppNotification(
        id: DateTime.now().toString(),
        title: 'Friend Added',
        body: '${user.name} is now your friend.',
        type: NotificationType.system,
        timestamp: DateTime.now(),
      ));
      notifyListeners();
    }
  }

  void markNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  List<ChatMessage> getMessagesWith(String friendId) {
    return _messages.where((m) => m.senderId == friendId || m.receiverId == friendId).toList();
  }

  void sendMessage(String friendId, String text) {
    _messages.add(ChatMessage(
      id: DateTime.now().toString(),
      senderId: 'currentUser', // Mock current user
      receiverId: friendId,
      text: text,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }
}
