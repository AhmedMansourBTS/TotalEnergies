class PromotionsModel {
  final int? serial;
  final String? eventTopic;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? maxParticipants;
  final String? imagePath;
  final String? eventDescription;
  final String? eventArDescription;
  final String? eventEnDescription;
  final String? fromTime;
  final String? toTime;
  final bool? happyHoursYN;
  final int? qrMaxUsage;
  final int? usedTimes;
  final int? remainingUsage;
  final int? categoryId;
  final List<int>? stations;
  final List<PromotionDetail> promotionDetails;

  PromotionsModel({
    required this.serial,
    required this.eventTopic,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    this.imagePath,
    required this.eventDescription,
    required this.eventArDescription,
    required this.eventEnDescription,
    this.fromTime,
    this.toTime,
    this.happyHoursYN,
    required this.qrMaxUsage,
    required this.usedTimes,
    required this.remainingUsage,
    required this.categoryId,
    required this.stations,
    required this.promotionDetails,
  });

  factory PromotionsModel.fromJson(Map<String, dynamic> json) {
    return PromotionsModel(
      serial: json['serial'],
      eventTopic: json['eventTopic'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxParticipants: json['maxParticipants'],
      imagePath: json['imagePath'],
      eventDescription: json['eventDescription'],
      eventArDescription: json['eventArDescription'],
      eventEnDescription: json['eventEnDescription'],
      fromTime: json['fromTime'],
      toTime: json['toTime'],
      happyHoursYN: json['happyHoursYN'],
      qrMaxUsage: json['qrMaxUsage'],
      usedTimes: json['usedTimes'],
      remainingUsage: json['remainingUsage'],
      categoryId: json['categoryId'],
      stations: List<int>.from(json['stations'] ?? []),
      promotionDetails: (json['promotionDetails'] as List)
          .map((e) => PromotionDetail.fromJson(e))
          .toList(),
    );
  }
}

class PromotionDetail {
  final int serial;
  final int promotionEventSerial;
  final String promotionCode;
  final String description;
  final String descriptionArabic;

  PromotionDetail({
    required this.serial,
    required this.promotionEventSerial,
    required this.promotionCode,
    required this.description,
    required this.descriptionArabic,
  });

  factory PromotionDetail.fromJson(Map<String, dynamic> json) {
    return PromotionDetail(
      serial: json['serial'],
      promotionEventSerial: json['promotionEventSerial'],
      promotionCode: json['promotionCode'],
      description: json['description'],
      descriptionArabic: json['descriptionArabic'],
    );
  }
}