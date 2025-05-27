class ServiceModel {
  final int serviceCode;
  final String serviceDescription;
  final String serviceLatDescription;
  final bool activeYN;
  final String? imagePath;

  ServiceModel({
    required this.serviceCode,
    required this.serviceDescription,
    required this.serviceLatDescription,
    required this.activeYN,
    this.imagePath,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceCode: json['serviceCode'],
      serviceDescription: json['serviceDescription'] ?? '',
      serviceLatDescription: json['serviceLatDescription'] ?? '',
      activeYN: json['activeYN'] ?? false,
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceCode': serviceCode,
      'serviceDescription': serviceDescription,
      'serviceLatDescription': serviceLatDescription,
      'activeYN': activeYN,
      'imagePath': imagePath,
    };
  }
}
