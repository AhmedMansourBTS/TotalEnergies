class StationServiceModel {
  final int serviceCode;
  final String serviceDescription;
  final String serviceLatDescription;
  final String? imagePath;
  final bool validYN;

  StationServiceModel({
    required this.serviceCode,
    required this.serviceDescription,
    required this.serviceLatDescription,
    required this.imagePath,
    required this.validYN,
  });

  factory StationServiceModel.fromJson(Map<String, dynamic> json) {
    return StationServiceModel(
      serviceCode: json['serviceCode'],
      serviceDescription: json['serviceDescription'],
      serviceLatDescription: json['serviceLatDescription'],
      imagePath: json['imagePath'],
      validYN: json['validYN'],
    );
  }
}
