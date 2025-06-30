import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/models/NotificationModel.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';

class NotificationService {
  // Fetch notifications, checking for promotions with 1 usage remaining
  Future<List<NotificationModel>> fetchNotifications(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var expiresOn = prefs.getString('expiresOn');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      throw Exception('Token not found in SharedPreferences');
    }

    // Check token expiry
    if (expiresOn != null && expiresOn.isNotEmpty) {
      final expiryDate = DateTime.tryParse(expiresOn);
      if (expiryDate != null && DateTime.now().isAfter(expiryDate)) {
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        throw Exception('Session expired. Please log in again.');
      }
    }

    try {
      // Fetch current promotions
      final currPromos = await GetCurrPromoService().getCurrPromotions(context);

      // Load existing notifications from SharedPreferences
      final existingNotifications = await _loadNotificationsFromStorage();
      final existingSerials = existingNotifications.map((n) => n.promotionSerial).toSet();

      // Generate new notifications for promotions with 1 usage remaining
      final newNotifications = <NotificationModel>[];
      for (var promo in currPromos) {
        if (promo.remainingUsage == 1 && !existingSerials.contains(promo.serial)) {
          newNotifications.add(
            NotificationModel(
              id: DateTime.now().millisecondsSinceEpoch, // Unique ID
              promotionSerial: promo.serial,
              message: 'Your promotion "${promo.eventTopic}" has only 1 usage remaining!',
              timestamp: DateTime.now(),
            ),
          );
        }
      }

      // Combine existing and new notifications
      final allNotifications = [...existingNotifications, ...newNotifications];

      // Save updated notifications to SharedPreferences
      await _saveNotificationsToStorage(allNotifications);

      return allNotifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Failed to load notifications: $e');
    }
  }

  // Load notifications from SharedPreferences
  Future<List<NotificationModel>> _loadNotificationsFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString('notifications');
    if (notificationsJson == null) return [];

    final List<dynamic> jsonList = jsonDecode(notificationsJson);
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }

  // Save notifications to SharedPreferences
  Future<void> _saveNotificationsToStorage(List<NotificationModel> notifications) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final notificationsJson = jsonEncode(notifications.map((n) => n.toJson()).toList());
    await prefs.setString('notifications', notificationsJson);
  }

  // Mark a notification as read
  Future<void> markNotificationAsRead(int notificationId) async {
    final notifications = await _loadNotificationsFromStorage();
    final updatedNotifications = notifications.map((n) {
      if (n.id == notificationId) {
        return NotificationModel(
          id: n.id,
          promotionSerial: n.promotionSerial,
          message: n.message,
          timestamp: n.timestamp,
          isRead: true,
        );
      }
      return n;
    }).toList();

    await _saveNotificationsToStorage(updatedNotifications);
  }

  // Clear all notifications
  Future<void> clearNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
  }
}