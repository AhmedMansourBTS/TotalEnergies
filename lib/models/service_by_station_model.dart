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
    this.imagePath,
    required this.validYN,
  });

  factory StationServiceModel.fromJson(Map<String, dynamic> json) {
    return StationServiceModel(
      serviceCode: json['serviceCode'] as int,
      serviceDescription: json['serviceDescription'] as String? ?? '',
      serviceLatDescription: json['serviceLatDescription'] as String? ?? '',
      imagePath: json['imagePath'] as String?,
      validYN: json['validYN'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceCode': serviceCode,
      'serviceDescription': serviceDescription,
      'serviceLatDescription': serviceLatDescription,
      'imagePath': imagePath,
      'validYN': validYN,
    };
  }
}