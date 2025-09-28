class AdvertisementModel {
  final int advertisementCode;
  final String advertisementDescription;
  final String advertisementLatDescription;
  final DateTime advertisementDate;
  final bool isActive;
  final String photoPath;
  final int orderBy;

  AdvertisementModel({
    required this.advertisementCode,
    required this.advertisementDescription,
    required this.advertisementLatDescription,
    required this.advertisementDate,
    required this.isActive,
    required this.photoPath,
    required this.orderBy,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      advertisementCode: json['advertisementCode'] ?? 0,
      advertisementDescription: json['advertisementDescription'] ?? '',
      advertisementLatDescription: json['advertisementLatDescription'] ?? '',
      advertisementDate: DateTime.tryParse(json['advertisementDate'] ?? '') ??
          DateTime.now(),
      isActive: json['isActive'] ?? false,
      photoPath: json['photoPath'] ?? '',
      orderBy: json['orderBy'] ?? 0,
    );
  }
}
