import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<String> _notifications = [
    "Your fuel discount is expiring soon!",
    "New car wash promo available.",
    "Total Points: You've earned 100 points!",
    "Reminder: Don't forget to rate your last service.",
    "New station added near your area.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Text("No notifications at the moment."),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    leading:
                        const Icon(Icons.notifications, color: primaryColor),
                    title: Text(
                      _notifications[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
