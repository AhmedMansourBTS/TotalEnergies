class NotificationModel {
  final int id; // Unique ID for the notification
  final int promotionSerial; // Serial of the related promotion
  final String message; // Notification message
  final DateTime timestamp; // When the notification was created
  final bool isRead; // Whether the notification has been read

  NotificationModel({
    required this.id,
    required this.promotionSerial,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  // Convert to JSON for storage in SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promotionSerial': promotionSerial,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Parse from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      promotionSerial: json['promotionSerial'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }
}