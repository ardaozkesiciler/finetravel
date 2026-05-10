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
