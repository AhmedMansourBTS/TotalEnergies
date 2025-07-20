class ServiceStationModel {
  final int serial;
  final String stationCode;
  final String stationName;
  final String stationArabicName;
  final int classifficationCode;
  final int governorateId;
  final int cityId;
  final String? stationAddress;
  final String? stationGovernment;
  final String? btCode;
  final bool activeYN;
  final String? imagePath;
  final List<dynamic>? stationServices;
  double? distance;

  ServiceStationModel({
    required this.serial,
    required this.stationCode,
    required this.stationName,
    required this.stationArabicName,
    required this.classifficationCode,
    required this.governorateId,
    required this.cityId,
    this.stationAddress,
    this.stationGovernment,
    this.btCode,
    required this.activeYN,
    this.imagePath,
    this.stationServices,
    this.distance,
  });

  factory ServiceStationModel.fromJson(Map<String, dynamic> json) {
    return ServiceStationModel(
      serial: json['serial'] ?? 0,
      stationCode: json['stationCode'] ?? '',
      stationName: json['stationName'] ?? '',
      stationArabicName: json['stationArabicName'] ?? '',
      classifficationCode: json['classifficationCode'] ?? 0,
      governorateId: json['governorateId'] ?? 0,
      cityId: json['cityId'] ?? 0,
      stationAddress: json['stationAdress'],
      stationGovernment: json['stationGovernment'],
      btCode: json['btCode'],
      activeYN: json['activeYN'] ?? false,
      imagePath: json['imagePath'],
      stationServices: json['stationServices'],
      distance: json['distance']?.toDouble(),
    );
  }
}