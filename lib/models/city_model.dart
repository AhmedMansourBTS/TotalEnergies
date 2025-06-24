// class CityModel {
//   final int? cityId;
//   final String cityLatName;
//   final String cityName;

//   CityModel({
//     this.cityId,
//     required this.cityLatName,
//     required this.cityName,
//   });

//   // Convert JSON to CityModel
//   factory CityModel.fromJson(Map<String, dynamic> json) {
//     return CityModel(
//       cityId: json['cityId'],
//       cityLatName: json['cityLatName'],
//       cityName: json['cityName'],
//     );
//   }

//   // Convert CityModel to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'cityLatName': cityLatName,
//       'cityName': cityName,
//     };
//   }
// }

class CityModel {
  final int? cityId;
  final String cityLatName;
  final String cityName;
  final int? governorateId; // Added governorateId

  CityModel({
    this.cityId,
    required this.cityLatName,
    required this.cityName,
    this.governorateId, // Added to constructor
  });

  // Convert JSON to CityModel
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cityId: json['cityId'],
      cityLatName: json['cityLatName'],
      cityName: json['cityName'],
      governorateId: json['governorateId'], // Parse new field
    );
  }

  // Convert CityModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'cityLatName': cityLatName,
      'cityName': cityName,
      'governorateId': governorateId, // Include in JSON
    };
  }
}