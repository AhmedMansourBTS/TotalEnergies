class PromotionsModel {
  final int serial;
  final String eventTopic;
  final DateTime startDate;
  final DateTime endDate;
  final int maxParticipants;
  final String? imagePath;
  final String eventDescription;
  final String eventEnDescription;
  final String eventArDescription;
  final bool? happyHoursYN;
  final int? qrMaxUsage;
  final int? remainingUsage;
  final List<int>? stations;
  final List<PromotionDetail> promotionDetails;

  PromotionsModel({
    required this.serial,
    required this.eventTopic,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    required this.imagePath,
    required this.eventDescription,
    required this.eventEnDescription,
    required this.eventArDescription,
    required this.happyHoursYN,
    required this.qrMaxUsage,
    required this.remainingUsage,
    required this.stations,
    required this.promotionDetails,
  });

  factory PromotionsModel.fromJson(Map<String, dynamic> json) {
    // String baseUrl = "http://92.204.139.204:4335"; // Your API Base URL
    // String rawPath = json['imagePath'] ?? '';
    // String formattedPath = rawPath.replaceAll("\\", "/"); // Convert \ to /
    // // String fullImageUrl = rawPath.isNotEmpty ? "$baseUrl$formattedPath" : '';
    // String fullImageUrl = rawPath.isNotEmpty ? "$baseUrl" : '';

    return PromotionsModel(
      serial: json['serial'],
      eventTopic: json['eventTopic'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxParticipants: json['maxParticipants'] ?? 0,
      // imagePath: fullImageUrl, // Store the corrected URL
      imagePath: json["imagePath"],
      eventDescription: json['eventDescription'] ?? '',
      eventEnDescription: json['eventEnDescription'] ?? '',
      eventArDescription: json['eventArDescription'] ?? '',
      happyHoursYN: json['happyHoursYN'] ?? false,
      qrMaxUsage: json['qrMaxUsage'] ?? 0,
      remainingUsage: json['remainingUsage'] ?? 0,
      stations: List<int>.from(json["stations"].map((x) => x)),
      promotionDetails: (json["promotionDetails"] as List)
          .map((e) => PromotionDetail.fromJson(e))
          .toList(),
    );
  }
}

// PromotionDetail Model
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
      serial: json["serial"],
      promotionEventSerial: json["promotionEventSerial"],
      promotionCode: json["promotionCode"],
      description: json["description"],
      descriptionArabic: json["descriptionArabic"],
    );
  }
}
