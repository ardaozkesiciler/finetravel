import 'package:finetravel/models/social_models.dart';
import 'package:finetravel/services/social_service.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = SocialService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => service.markNotificationsAsRead(),
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: service,
        builder: (context, child) {
          final notifications = service.notifications;

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[notifications.length - 1 - index];
              return Container(
                color: notification.isRead ? Colors.transparent : Colors.white.withOpacity(0.05),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getNotificationColor(notification.type).withOpacity(0.2),
                    child: Icon(_getNotificationIcon(notification.type), color: _getNotificationColor(notification.type)),
                  ),
                  title: Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(notification.body),
                  trailing: Text(
                    _formatTimestamp(notification.timestamp),
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.friendRequest:
        return Icons.person_add;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.friendRequest:
        return Colors.blue;
      case NotificationType.message:
        return Colors.green;
      case NotificationType.system:
        return Colors.orange;
    }
  }

  String _formatTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
