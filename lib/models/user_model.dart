class UserModel {
  final int? serial;
  final String name;
  final String phoneNumber;
  final String email;
  final String birthDate;
  final String carModel;
  final String gender;
  final int cityCode;
  final int carModelYear;
  String? password;

  UserModel({
    this.serial,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.birthDate,
    required this.carModel,
    required this.gender,
    required this.cityCode,
    required this.carModelYear,
    required this.password,
  });

  // Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      serial: json['serial'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      birthDate: json['birthDate'],
      carModel: json['carModel'],
      gender: json['gender'],
      cityCode: json['cityCode'],
      carModelYear: json['carModelYear'],
      password: json['password'],
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'birthDate': birthDate,
      'carModel': carModel,
      'gender': gender,
      'cityCode': cityCode,
      'carModelYear': carModelYear,
      'password': password,
    };
  }

  factory UserModel.from(UserModel user) {
    return UserModel(
        name: user.name,
        phoneNumber: user.phoneNumber,
        email: user.email,
        birthDate: user.birthDate,
        carModel: user.carModel,
        gender: user.gender,
        cityCode: user.cityCode,
        carModelYear: user.carModelYear,
        password: user.password);
  }

  void setPass(String pass){
    this.password = pass;
  }
}
