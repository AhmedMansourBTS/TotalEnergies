class CurrPromoModel {
  final int serial;
  final String eventTopic;
  final String? imagePath;
  final String eventDescription;
  final String eventArDescription;
  final String eventEnDescription;
  final DateTime startDate;
  final DateTime endDate;
  final int maxParticipants;
  final bool happyHoursYN;
  final int qrMaxUsage;
  final int remainingUsage;
  final List<int> stations;
  final List<PromotionDetail> promotionDetails;

  CurrPromoModel({
    required this.serial,
    required this.eventTopic,
    this.imagePath,
    required this.eventDescription,
    required this.eventArDescription,
    required this.eventEnDescription,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    required this.happyHoursYN,
    required this.qrMaxUsage,
    required this.remainingUsage,
    required this.stations,
    required this.promotionDetails,
  });

  factory CurrPromoModel.fromJson(Map<String, dynamic> json) {
    return CurrPromoModel(
      serial: json['serial'],
      eventTopic: json['eventTopic'],
      imagePath: json['imagePath'],
      eventDescription: json['eventDescription'],
      eventArDescription: json['eventArDescription'],
      eventEnDescription: json['eventEnDescription'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxParticipants: json['maxParticipants'],
      happyHoursYN: json['happyHoursYN'],
      qrMaxUsage: json['qrMaxUsage'],
      remainingUsage: json['remainingUsage'],
      stations: List<int>.from(json['stations']),
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
