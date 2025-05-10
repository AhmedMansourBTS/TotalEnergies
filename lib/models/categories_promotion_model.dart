class CategoriesPromotionModel {
  final int serial;
  final String eventTopic;
  final String startDate;
  final String endDate;
  final int maxParticipants;
  final String imagePath;
  final String eventDescription;
  final String eventArDescription;
  final String eventEnDescription;
  final bool happyHoursYN;
  final int qrMaxUsage;
  final int usedTimes;
  final int remainingUsage;
  final int categoryId;
  final List<int> stations;
  final List<CategoryPromotionDetail> promotionDetails;

  CategoriesPromotionModel({
    required this.serial,
    required this.eventTopic,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    required this.imagePath,
    required this.eventDescription,
    required this.eventArDescription,
    required this.eventEnDescription,
    required this.happyHoursYN,
    required this.qrMaxUsage,
    required this.usedTimes,
    required this.remainingUsage,
    required this.categoryId,
    required this.stations,
    required this.promotionDetails,
  });

  factory CategoriesPromotionModel.fromJson(Map<String, dynamic> json) {
    return CategoriesPromotionModel(
      serial: json['serial'],
      eventTopic: json['eventTopic'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      maxParticipants: json['maxParticipants'] ?? 0,
      imagePath: json['imagePath'] ?? '',
      eventDescription: json['eventDescription'] ?? '',
      eventArDescription: json['eventArDescription'] ?? '',
      eventEnDescription: json['eventEnDescription'] ?? '',
      happyHoursYN: json['happyHoursYN'] ?? false,
      qrMaxUsage: json['qrMaxUsage'] ?? 0,
      usedTimes: json['usedTimes'] ?? 0,
      remainingUsage: json['remainingUsage'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      stations: List<int>.from(json['stations'] ?? []),
      promotionDetails: (json['promotionDetails'] as List<dynamic>?)
              ?.map((e) => CategoryPromotionDetail.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CategoryPromotionDetail {
  final int serial;
  final int promotionEventSerial;
  final String promotionCode;
  final String description;
  final String descriptionArabic;

  CategoryPromotionDetail({
    required this.serial,
    required this.promotionEventSerial,
    required this.promotionCode,
    required this.description,
    required this.descriptionArabic,
  });

  factory CategoryPromotionDetail.fromJson(Map<String, dynamic> json) {
    return CategoryPromotionDetail(
      serial: json['serial'],
      promotionEventSerial: json['promotionEventSerial'],
      promotionCode: json['promotionCode'] ?? '',
      description: json['description'] ?? '',
      descriptionArabic: json['descriptionArabic'] ?? '',
    );
  }
}
