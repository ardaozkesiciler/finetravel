import 'package:finetravel/models/social_models.dart';
import 'package:flutter/material.dart';

class SocialService extends ChangeNotifier {
  static final SocialService _instance = SocialService._internal();
  factory SocialService() => _instance;
  SocialService._internal() {
    _initializeMockData();
  }

  final List<SocialUser> _friends = [];
  final List<String> _blockedUserIds = [];
  final List<ChatMessage> _messages = [];
  final List<AppNotification> _notifications = [];
  final List<Post> _posts = [];

  List<SocialUser> get friends => List.unmodifiable(_friends);
  List<String> get blockedUserIds => List.unmodifiable(_blockedUserIds);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  List<Post> get posts => List.unmodifiable(_posts);
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

    _posts.addAll([
      Post(
        id: '1',
        userId: '1',
        userName: 'John Doe',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=1',
        content: 'Just arrived in Kyoto! The temples are breathtaking. ⛩️',
        imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1000',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        likes: 24,
        commentsCount: 2,
        comments: [
          Comment(id: 'c1', userName: 'Jane Smith', userAvatarUrl: 'https://i.pravatar.cc/150?u=2', text: 'Beautiful!', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
          Comment(id: 'c2', userName: 'Alex', userAvatarUrl: 'https://i.pravatar.cc/150?u=3', text: 'Enjoy!', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
        ],
      ),
      Post(
        id: '2',
        userId: '3',
        userName: 'Alex Johnson',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=3',
        content: 'Packing for my next adventure. Any recommendations for Iceland? 🇮🇸',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 12,
        commentsCount: 0,
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

  void likePost(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index].likes++;
      notifyListeners();
    }
  }

  void createPost(String content, {String? imageUrl}) {
    _posts.insert(
      0,
      Post(
        id: DateTime.now().toString(),
        userId: 'currentUser',
        userName: 'Explorer',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=arda',
        content: content,
        imageUrl: imageUrl,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void editPost(String id, String newContent) {
    final index = _posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final oldPost = _posts[index];
      _posts[index] = Post(
        id: oldPost.id,
        userId: oldPost.userId,
        userName: oldPost.userName,
        userAvatarUrl: oldPost.userAvatarUrl,
        content: newContent,
        imageUrl: oldPost.imageUrl,
        timestamp: oldPost.timestamp,
        likes: oldPost.likes,
        commentsCount: oldPost.commentsCount,
        comments: oldPost.comments,
        isArchived: oldPost.isArchived,
      );
      notifyListeners();
    }
  }

  void deletePost(String id) {
    _posts.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void archivePost(String id) {
    final index = _posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _posts[index].isArchived = !_posts[index].isArchived;
      notifyListeners();
    }
  }

  void addComment(String postId, String text) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final newComment = Comment(
        id: DateTime.now().toString(),
        userName: 'Explorer',
        userAvatarUrl: 'https://i.pravatar.cc/150?u=arda',
        text: text,
        timestamp: DateTime.now(),
      );
      
      final updatedComments = List<Comment>.from(post.comments)..add(newComment);
      
      _posts[index] = Post(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        userAvatarUrl: post.userAvatarUrl,
        content: post.content,
        imageUrl: post.imageUrl,
        timestamp: post.timestamp,
        likes: post.likes,
        commentsCount: updatedComments.length,
        comments: updatedComments,
        isArchived: post.isArchived,
      );
      notifyListeners();
    }
  }

  void markNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void removeFriend(String friendId) {
    _friends.removeWhere((f) => f.id == friendId);
    notifyListeners();
  }

  void blockUser(String userId) {
    if (!_blockedUserIds.contains(userId)) {
      _blockedUserIds.add(userId);
      _friends.removeWhere((f) => f.id == userId);
      notifyListeners();
    }
  }

  void unblockUser(String userId) {
    _blockedUserIds.remove(userId);
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

  void sendDestination(String friendId, String destinationName) {
    sendMessage(friendId, 'Hey! Take a look at this destination: $destinationName 🌍✈️');
  }
}
