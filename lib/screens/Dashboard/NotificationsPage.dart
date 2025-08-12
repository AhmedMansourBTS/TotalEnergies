// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';

// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({super.key});

//   @override
//   State<NotificationsPage> createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends State<NotificationsPage> {
//   final List<String> _notifications = [
//     "Your fuel discount is expiring soon!",
//     "New car wash promo available.",
//     "Total Points: You've earned 100 points!",
//     "Reminder: Don't forget to rate your last service.",
//     "New station added near your area.",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: const Text(
//           'Notifications',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: _notifications.isEmpty
//           ? const Center(
//               child: Text("No notifications at the moment."),
//             )
//           : ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: _notifications.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 return Card(
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   color: Colors.white,
//                   child: ListTile(
//                     leading:
//                         const Icon(Icons.notifications, color: primaryColor),
//                     title: Text(
//                       _notifications[index],
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/NotificationModel.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/NotificationService.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationModel>> _notificationsFuture;
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _currentNotifications = []; // store current list

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _notificationService.fetchNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationModel>>(
      future: _notificationsFuture,
      builder: (context, snapshot) {
        bool showDeleteIcon = false;

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _currentNotifications = snapshot.data!;
          // show delete icon if there is at least one unread notification
          showDeleteIcon = _currentNotifications.any((n) => n.isRead == false);
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            title: const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              if (showDeleteIcon)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    await _notificationService.clearNotifications();
                    setState(() {
                      _notificationsFuture =
                          _notificationService.fetchNotifications(context);
                    });
                  },
                  tooltip: 'Clear all notifications',
                ),
            ],
          ),
          body: _buildBody(snapshot),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<List<NotificationModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: LoadingScreen());
    } else if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _notificationsFuture =
                      _notificationService.fetchNotifications(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              child: const Text(
                "Retry",
                style: TextStyle(color: btntxtColors, fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Text(
          'No notifications at the moment.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final notifications = snapshot.data!;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: notification.isRead ? Colors.grey[200] : Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.notifications,
              color: notification.isRead ? Colors.grey : primaryColor,
            ),
            title: Text(
              notification.message,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    notification.isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Text(
              _formatTimestamp(notification.timestamp),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () async {
              if (!notification.isRead) {
                await _notificationService
                    .markNotificationAsRead(notification.id);
                setState(() {
                  _notificationsFuture =
                      _notificationService.fetchNotifications(context);
                });
              }
            },
          ),
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
