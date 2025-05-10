// class CurrPromoModel {
//   final int serial;
//   final String eventTopic;
//   final String? imagePath;
//   final String eventDescription;
//   final String eventArDescription;
//   final String eventEnDescription;
//   final DateTime startDate;
//   final DateTime endDate;
//   final int maxParticipants;
//   final bool happyHoursYN;
//   final int qrMaxUsage;
//   final int remainingUsage;
//   final int usedTimes;
//   final List<int> stations;
//   final List<String> stationAddresses;
//   final List<PromotionDetail> promotionDetails;
//   final String? fromTime;
//   final String? toTime;
//   final int? categoryId;
//   final dynamic
//       promoGroupsRels; // If you don't know the structure, keep it dynamic
//   final dynamic file; // Same here

//   CurrPromoModel({
//     required this.serial,
//     required this.eventTopic,
//     this.imagePath,
//     required this.eventDescription,
//     required this.eventArDescription,
//     required this.eventEnDescription,
//     required this.startDate,
//     required this.endDate,
//     required this.maxParticipants,
//     required this.happyHoursYN,
//     required this.qrMaxUsage,
//     required this.remainingUsage,
//     required this.usedTimes,
//     required this.stations,
//     required this.stationAddresses,
//     required this.promotionDetails,
//     this.fromTime,
//     this.toTime,
//     this.categoryId,
//     this.promoGroupsRels,
//     this.file,
//   });

//   factory CurrPromoModel.fromJson(Map<String, dynamic> json) {
//     return CurrPromoModel(
//       serial: json['serial'],
//       eventTopic: json['eventTopic'],
//       imagePath: json['imagePath'],
//       eventDescription: json['eventDescription'],
//       eventArDescription: json['eventArDescription'],
//       eventEnDescription: json['eventEnDescription'],
//       startDate: DateTime.parse(json['startDate']),
//       endDate: DateTime.parse(json['endDate']),
//       maxParticipants: json['maxParticipants'],
//       happyHoursYN: json['happyHoursYN'],
//       qrMaxUsage: json['qrMaxUsage'],
//       remainingUsage: json['remainingUsage'],
//       usedTimes: json['usedTimes'],
//       stations: List<int>.from(json['stations']),
//       stationAddresses: List<String>.from(json['stationAddresses']),
//       promotionDetails: (json['promotionDetails'] as List)
//           .map((e) => PromotionDetail.fromJson(e))
//           .toList(),
//       fromTime: json['fromTime'],
//       toTime: json['toTime'],
//       categoryId: json['categoryId'],
//       promoGroupsRels: json['promoGroupsRels'],
//       file: json['file'],
//     );
//   }
// }

// class PromotionDetail {
//   final int serial;
//   final int promotionEventSerial;
//   final String promotionCode;
//   final String description;
//   final String descriptionArabic;

//   PromotionDetail({
//     required this.serial,
//     required this.promotionEventSerial,
//     required this.promotionCode,
//     required this.description,
//     required this.descriptionArabic,
//   });

//   factory PromotionDetail.fromJson(Map<String, dynamic> json) {
//     return PromotionDetail(
//       serial: json['serial'],
//       promotionEventSerial: json['promotionEventSerial'],
//       promotionCode: json['promotionCode'],
//       description: json['description'],
//       descriptionArabic: json['descriptionArabic'],
//     );
//   }
// }

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
  final int usedTimes;
  final List<int> stations;
  // final List<String>? stationAddresses;
  final List<PromotionDetail> promotionDetails;
  final String? fromTime;
  final String? toTime;
  final int? categoryId;
  final dynamic promoGroupsRels;
  final dynamic file;

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
    required this.usedTimes,
    required this.stations,
    // required this.stationAddresses,
    required this.promotionDetails,
    this.fromTime,
    this.toTime,
    this.categoryId,
    this.promoGroupsRels,
    this.file,
  });

  factory CurrPromoModel.fromJson(Map<String, dynamic> json) {
    return CurrPromoModel(
      serial: json['serial'],
      eventTopic: json['eventTopic'],
      imagePath: json['imagePath'],
      eventDescription: json['eventDescription'],
      eventArDescription: json['eventArDescription'],
      eventEnDescription: json['eventEnDescription'],
      startDate: DateTime.tryParse(json['startDate']) ?? DateTime(0),
      endDate: DateTime.tryParse(json['endDate']) ?? DateTime(0),
      maxParticipants: json['maxParticipants'],
      happyHoursYN: json['happyHoursYN'],
      qrMaxUsage: json['qrMaxUsage'],
      remainingUsage: json['remainingUsage'],
      usedTimes: json['usedTimes'],
      stations: List<int>.from(json['stations']),
      // stationAddresses: json['stationAddresses'] != null
      //     ? List<String>.from(json['stationAddresses'])
      //     : null,
      promotionDetails: (json['promotionDetails'] as List)
          .map((e) => PromotionDetail.fromJson(e))
          .toList(),
      fromTime: json['fromTime'],
      toTime: json['toTime'],
      categoryId: json['categoryId'],
      promoGroupsRels: json['promoGroupsRels'],
      file: json['file'],
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
