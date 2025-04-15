class ExpiredPromoModel {
  final int serial;
  final String eventTopic;
  final DateTime startDate;
  final DateTime endDate;
  final int maxParticipants;
  final String? imagePath;
  final String eventDescription;
  final String eventArDescription;
  final String eventEnDescription;
  final int qrMaxUsage;
  final int remainingUsage;

  ExpiredPromoModel({
    required this.serial,
    required this.eventTopic,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    this.imagePath,
    required this.eventDescription,
    required this.eventArDescription,
    required this.eventEnDescription,
    required this.qrMaxUsage,
    required this.remainingUsage,
  });

  factory ExpiredPromoModel.fromJson(Map<String, dynamic> json) {
    return ExpiredPromoModel(
      serial: json['serial'],
      eventTopic: json['eventTopic'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxParticipants: json['maxParticipants'],
      imagePath: json['imagePath'],
      eventDescription: json['eventDescription'],
      eventArDescription: json['eventArDescription'],
      eventEnDescription: json['eventEnDescription'],
      qrMaxUsage: json['qrMaxUsage'],
      remainingUsage: json['remainingUsage'],
    );
  }
}
