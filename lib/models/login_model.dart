class LoginModel {
  final String userName;
  final String password;
  String? token; // Added token field

  LoginModel({
    required this.userName,
    required this.password,
    this.token,
  });

  // Convert LoginModel to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
    };
  }

  // Parse API response to LoginModel (if needed for response handling)
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      userName: json['phoneNumber'] ?? '',
      password: '', // Password is not returned in response
      token: json['token'],
    );
  }
}