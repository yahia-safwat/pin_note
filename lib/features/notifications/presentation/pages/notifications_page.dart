import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final IconData icon;

  NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    this.icon = Icons.notifications,
  });
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static final List<NotificationItem> mockNotifications = [
    NotificationItem(
      title: 'New Feature Alert',
      body: 'You can now color code your notes for better organization!',
      time: '2 hours ago',
      icon: Icons.star_outline,
    ),
    NotificationItem(
      title: 'Note Reminder',
      body: 'Review your "Grocery shopping" note.',
      time: '5 hours ago',
      isRead: true,
      icon: Icons.alarm,
    ),
    NotificationItem(
      title: 'System Update',
      body: 'PinNote version 1.0.1 is now available.',
      time: '1 day ago',
      isRead: true,
      icon: Icons.system_update,
    ),
    NotificationItem(
      title: 'Welcome!',
      body: 'Thanks for choosing PinNote. Start by creating a new note.',
      time: '2 days ago',
      isRead: true,
      icon: Icons.favorite_border,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
        actions: [
          TextButton(onPressed: () {}, child: const Text('Mark all read')),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: mockNotifications.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 72),
        itemBuilder: (context, index) {
          final notification = mockNotifications[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer.withValues(
                alpha: 0.3,
              ),
              child: Icon(
                notification.icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(notification.body),
                const SizedBox(height: 4),
                Text(
                  notification.time,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
