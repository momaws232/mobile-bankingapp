import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = _getNotifications();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications marked as read'),
                  backgroundColor: Color(0xFF00E676),
                ),
              );
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You\'re all caught up!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(notification: notification);
              },
            ),
    );
  }

  List<NotificationItem> _getNotifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        icon: Icons.celebration,
        iconColor: const Color(0xFF00E676),
        title: 'Welcome to Banking App!',
        message: 'Your account has been successfully created. Start managing your finances today.',
        time: now.subtract(const Duration(minutes: 5)),
        isRead: false,
        category: 'System',
      ),
      NotificationItem(
        icon: Icons.credit_card,
        iconColor: Colors.blue,
        title: 'Card Added Successfully',
        message: 'Your Visa card ending in 4821 has been added to your account.',
        time: now.subtract(const Duration(hours: 2)),
        isRead: false,
        category: 'Cards',
      ),
      NotificationItem(
        icon: Icons.arrow_upward,
        iconColor: Colors.red,
        title: 'Transaction Alert',
        message: 'You spent \$45.99 at Grocery Store',
        time: now.subtract(const Duration(hours: 5)),
        isRead: true,
        category: 'Transactions',
      ),
      NotificationItem(
        icon: Icons.security,
        iconColor: const Color(0xFF00E676),
        title: 'Security Update',
        message: 'Your account security has been enhanced with two-factor authentication.',
        time: now.subtract(const Duration(days: 1)),
        isRead: true,
        category: 'Security',
      ),
      NotificationItem(
        icon: Icons.trending_up,
        iconColor: Colors.orange,
        title: 'Monthly Report Ready',
        message: 'Your spending analysis for this month is now available.',
        time: now.subtract(const Duration(days: 2)),
        isRead: true,
        category: 'Analytics',
      ),
      NotificationItem(
        icon: Icons.arrow_downward,
        iconColor: const Color(0xFF00E676),
        title: 'Money Received',
        message: 'You received \$200.00 from John Doe',
        time: now.subtract(const Duration(days: 3)),
        isRead: true,
        category: 'Transactions',
      ),
      NotificationItem(
        icon: Icons.ac_unit,
        iconColor: Colors.blue,
        title: 'Card Frozen',
        message: 'Your Mastercard has been temporarily frozen for security.',
        time: now.subtract(const Duration(days: 5)),
        isRead: true,
        category: 'Cards',
      ),
    ];
  }
}

class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final String category;

  NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.category,
  });
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final timeAgo = _getTimeAgo(notification.time);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : const Color(0xFF00E676).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead ? Colors.grey.shade200 : const Color(0xFF00E676).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: notification.iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            notification.icon,
            color: notification.iconColor,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF00E676),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    notification.category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Mark as read
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification marked as read'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(time);
    }
  }
}
