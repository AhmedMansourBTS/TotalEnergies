// // class PromotionsModel {
// //   final int serial;
// //   final String eventTopic;
// //   final DateTime startDate;
// //   final DateTime endDate;
// //   final int maxParticipants;
// //   final String? imagePath;
// //   final String eventDescription;
// //   final String eventEnDescription;
// //   final String eventArDescription;
// //   final bool? happyHoursYN;
// //   final int? qrMaxUsage;
// //   final int? remainingUsage;
// //   final List<int>? stations;
// //   final List<PromotionDetail>? promotionDetails;

// //   PromotionsModel({
// //     required this.serial,
// //     required this.eventTopic,
// //     required this.startDate,
// //     required this.endDate,
// //     required this.maxParticipants,
// //     required this.imagePath,
// //     required this.eventDescription,
// //     required this.eventEnDescription,
// //     required this.eventArDescription,
// //     required this.happyHoursYN,
// //     required this.qrMaxUsage,
// //     required this.remainingUsage,
// //     required this.stations,
// //     required this.promotionDetails,
// //   });

// //   // factory PromotionsModel.fromJson(Map<String, dynamic> json) {
// //   //   return PromotionsModel(
// //   //     serial: json['serial'],
// //   //     eventTopic: json['eventTopic'],
// //   //     startDate: DateTime.parse(json['startDate']),
// //   //     endDate: DateTime.parse(json['endDate']),
// //   //     maxParticipants: json['maxParticipants'] ?? 0,
// //   //     imagePath: json["imagePath"],
// //   //     eventDescription: json['eventDescription'] ?? '',
// //   //     eventEnDescription: json['eventEnDescription'] ?? '',
// //   //     eventArDescription: json['eventArDescription'] ?? '',
// //   //     happyHoursYN: json['happyHoursYN'] ?? false,
// //   //     qrMaxUsage: json['qrMaxUsage'] ?? 0,
// //   //     remainingUsage: json['remainingUsage'] ?? 0,
// //   //     stations: json["stations"] != null
// //   //         ? List<int>.from(json["stations"].map((x) => x))
// //   //         : [],
// //   //     promotionDetails: json["promotionDetails"] != null
// //   //         ? List<PromotionDetail>.from(
// //   //             json["promotionDetails"].map((x) => PromotionDetail.fromJson(x)))
// //   //         : [],
// //   //   );
// //   // }

// //   factory PromotionsModel.fromJson(Map<String, dynamic> json) {
// //     // String baseUrl = "http://92.204.139.204:4335"; // Your API Base URL
// //     // String rawPath = json['imagePath'] ?? '';
// //     // String formattedPath = rawPath.replaceAll("\\", "/"); // Convert \ to /
// //     // // String fullImageUrl = rawPath.isNotEmpty ? "$baseUrl$formattedPath" : '';
// //     // String fullImageUrl = rawPath.isNotEmpty ? "$baseUrl" : '';

// //     return PromotionsModel(
// //       serial: json['serial'],
// //       eventTopic: json['eventTopic'],
// //       startDate: DateTime.parse(json['startDate']),
// //       endDate: DateTime.parse(json['endDate']),
// //       maxParticipants: json['maxParticipants'] ?? 0,
// //       // imagePath: fullImageUrl, // Store the corrected URL
// //       imagePath: json["imagePath"],
// //       eventDescription: json['eventDescription'] ?? '',
// //       eventEnDescription: json['eventEnDescription'] ?? '',
// //       eventArDescription: json['eventArDescription'] ?? '',
// //       happyHoursYN: json['happyHoursYN'] ?? false,
// //       qrMaxUsage: json['qrMaxUsage'] ?? 0,
// //       remainingUsage: json['remainingUsage'] ?? 0,
// //       stations: List<int>.from(json["stations"].map((x) => x)),
// //       promotionDetails: (json["promotionDetails"] as List)
// //           .map((e) => PromotionDetail.fromJson(e))
// //           .toList(),
// //     );
// //   }
// // }

// // // PromotionDetail Model
// // class PromotionDetail {
// //   final int serial;
// //   final int promotionEventSerial;
// //   final String promotionCode;
// //   final String description;
// //   final String descriptionArabic;

// //   PromotionDetail({
// //     required this.serial,
// //     required this.promotionEventSerial,
// //     required this.promotionCode,
// //     required this.description,
// //     required this.descriptionArabic,
// //   });

// //   factory PromotionDetail.fromJson(Map<String, dynamic> json) {
// //     return PromotionDetail(
// //       serial: json["serial"],
// //       promotionEventSerial: json["promotionEventSerial"],
// //       promotionCode: json["promotionCode"],
// //       description: json["description"],
// //       descriptionArabic: json["descriptionArabic"],
// //     );
// //   }
// // }

// Hady Model
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

// Mesada2
// class PromotionsModel {
//   int? serial;
//   String? eventTopic;
//   String? startDate;
//   String? endDate;
//   int? maxParticipants;
//   String? imagePath;
//   String? eventDescription;
//   String? eventArDescription;
//   String? eventEnDescription;
//   dynamic fromTime;
//   dynamic toTime;
//   bool? happyHoursYN;
//   int? qrMaxUsage;
//   int? usedTimes;
//   int? remainingUsage;
//   int? categoryId;
//   List<int>? stations;
//   dynamic stationAddresses;
//   List<PromotionDetails>? promotionDetails;
//   dynamic promoGroupsRels;
//   dynamic file;

//   PromotionsModel({
//     this.serial,
//     this.eventTopic,
//     this.startDate,
//     this.endDate,
//     this.maxParticipants,
//     this.imagePath,
//     this.eventDescription,
//     this.eventArDescription,
//     this.eventEnDescription,
//     this.fromTime,
//     this.toTime,
//     this.happyHoursYN,
//     this.qrMaxUsage,
//     this.usedTimes,
//     this.remainingUsage,
//     this.categoryId,
//     this.stations,
//     this.stationAddresses,
//     this.promotionDetails,
//     this.promoGroupsRels,
//     this.file,
//   });

//   PromotionsModel.fromJson(Map<String, dynamic> json) {
//     serial = json['serial'];
//     eventTopic = json['eventTopic'];
//     startDate = json['startDate'];
//     endDate = json['endDate'];
//     maxParticipants = json['maxParticipants'];
//     imagePath = json['imagePath'];
//     eventDescription = json['eventDescription'];
//     eventArDescription = json['eventArDescription'];
//     eventEnDescription = json['eventEnDescription'];
//     fromTime = json['fromTime'];
//     toTime = json['toTime'];
//     happyHoursYN = json['happyHoursYN'];
//     qrMaxUsage = json['qrMaxUsage'];
//     usedTimes = json['usedTimes'];
//     remainingUsage = json['remainingUsage'];
//     categoryId = json['categoryId'];

//     // ✅ Fix: Safe casting of stations
//     if (json['stations'] != null) {
//       stations = List<int>.from(json['stations']);
//     }

//     stationAddresses = json['stationAddresses'];

//     // ✅ Fix: Safe parsing of promotionDetails
//     if (json['promotionDetails'] != null) {
//       promotionDetails = (json['promotionDetails'] as List)
//           .map((v) => PromotionDetails.fromJson(v))
//           .toList();
//     }

//     promoGroupsRels = json['promoGroupsRels'];
//     file = json['file'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['serial'] = serial;
//     data['eventTopic'] = eventTopic;
//     data['startDate'] = startDate;
//     data['endDate'] = endDate;
//     data['maxParticipants'] = maxParticipants;
//     data['imagePath'] = imagePath;
//     data['eventDescription'] = eventDescription;
//     data['eventArDescription'] = eventArDescription;
//     data['eventEnDescription'] = eventEnDescription;
//     data['fromTime'] = fromTime;
//     data['toTime'] = toTime;
//     data['happyHoursYN'] = happyHoursYN;
//     data['qrMaxUsage'] = qrMaxUsage;
//     data['usedTimes'] = usedTimes;
//     data['remainingUsage'] = remainingUsage;
//     data['categoryId'] = categoryId;
//     data['stations'] = stations;
//     data['stationAddresses'] = stationAddresses;

//     if (promotionDetails != null) {
//       data['promotionDetails'] =
//           promotionDetails!.map((v) => v.toJson()).toList();
//     }

//     data['promoGroupsRels'] = promoGroupsRels;
//     data['file'] = file;

//     return data;
//   }
// }

// class PromotionDetails {
//   int? serial;
//   int? promotionEventSerial;
//   String? promotionCode;
//   String? description;
//   String? descriptionArabic;

//   PromotionDetails({
//     this.serial,
//     this.promotionEventSerial,
//     this.promotionCode,
//     this.description,
//     this.descriptionArabic,
//   });

//   PromotionDetails.fromJson(Map<String, dynamic> json) {
//     serial = json['serial'];
//     promotionEventSerial = json['promotionEventSerial'];
//     promotionCode = json['promotionCode'];
//     description = json['description'];
//     descriptionArabic = json['descriptionArabic'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['serial'] = serial;
//     data['promotionEventSerial'] = promotionEventSerial;
//     data['promotionCode'] = promotionCode;
//     data['description'] = description;
//     data['descriptionArabic'] = descriptionArabic;
//     return data;
//   }
// }
