class StationModel {
  final int? serial;
  final String? stationCode;
  final String stationName;
  final String stationArabicName;
  final int? classifficationCode;
  final String? stationAdress;
  final String? stationGovernment;
  final String? btCode;
  final bool? activeYN;

  double? distance;

  StationModel(
      {this.serial,
      this.stationCode,
      required this.stationName,
      required this.stationArabicName,
      this.classifficationCode,
      this.stationAdress,
      this.stationGovernment,
      this.btCode,
      this.activeYN,
      this.distance});

  // Convert JSON to StationModel
  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      serial: json['serial'],
      stationCode: json['stationCode'],
      stationName: json['stationName'],
      stationArabicName: json['stationArabicName'],
      classifficationCode: json['classifficationCode'],
      stationAdress: json['stationAdress'],
      stationGovernment: json['stationGovernment'],
      btCode: json['btCode'],
      activeYN: json['activeYN'],
      distance: json['distance'],
    );
  }

  // Convert StationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'stationCode': stationCode,
      'stationName': stationName,
      'stationArabicName': stationArabicName,
      'classifficationCode': classifficationCode,
      'stationAdress': stationAdress,
      'stationGovernment': stationGovernment,
      'btCode': btCode,
      'activeYN': activeYN,
      'distance': distance,
    };
  }
}
