import 'package:flutter/material.dart';

class SocialUser {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;

  SocialUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });
}

enum NotificationType { friendRequest, message, system }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}
class Post {
  final String id;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  int likes;
  int commentsCount;
  final List<Comment> comments;
  bool isArchived;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.likes = 0,
    this.commentsCount = 0,
    this.comments = const [],
    this.isArchived = false,
  });
}

class Comment {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.text,
    required this.timestamp,
  });
}
