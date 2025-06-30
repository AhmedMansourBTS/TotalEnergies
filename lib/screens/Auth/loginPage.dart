import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/login_model.dart';
import 'package:total_energies/screens/Auth/forget_pass.dart';
import 'package:total_energies/screens/home_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/screens/Auth/register_screen.dart';
import 'package:total_energies/screens/testing.dart';
import 'package:total_energies/services/login_service.dart';
import 'package:total_energies/widgets/auth/header.dart';
import 'package:total_energies/widgets/auth/custPassField.dart';
import 'package:total_energies/widgets/auth/phone.dart';
import 'package:total_energies/widgets/Buttons/trnslt_btn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final LoginService apiService = LoginService();

  Future<void> requestLocationPermissionAndGetPosition() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission == PermissionStatus.granted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("User location: ${position.latitude}, ${position.longitude}");
    } else {
      print("Location permission denied");
    }
  }

  void login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingScreen(),
    );

    LoginModel user = LoginModel(
      userName: _usernameController.text,
      password: _passwordController.text,
    );

    try {
      var response = await apiService.loginuser(user);
      Navigator.pop(context); // Hide loading screen

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        // Validate token presence
        if (responseData['token'] == null || responseData['token'].isEmpty) {
          throw Exception('No token received from server');
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', responseData['name'] ?? '');
        await prefs.setString('phoneno', user.userName);
        await prefs.setString('gender', responseData['gender'] ?? '');
        await prefs.setString('email', responseData['email'] ?? '');
        await prefs.setInt('serial', responseData['serial'] ?? 0);
        await prefs.setString('token', responseData['token']);
        await prefs.setString('expiresOn', responseData['expiresOn'] ?? '');

        print('Saved token: ${prefs.getString('token')}');
        print('Saved token expiry: ${prefs.getString('expiresOn')}');

        await requestLocationPermissionAndGetPosition();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        var responseData = jsonDecode(response.body);
        String errorMessage = responseData['message'] ?? 'Invalid credentials.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              errorMessage,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      print("Login Error: $e");
      Navigator.pop(context); // Ensure loading screen is dismissed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'Login failed: ${e.toString()}',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }
  }

  String? _validatePhone(PhoneNumber? phone) {
    if (phone == null || phone.number.isEmpty) {
      return 'login_page.empty_verification'.tr;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'login_page.pass_verification'.tr;
    } else if (value.length < 6) {
      return 'login_page.pass_verification1'.tr;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Directionality.of(context) != TextDirection.rtl
            ? Container(
                alignment: Alignment.centerRight,
                child: TranslateButton(),
              )
            : Container(
                alignment: Alignment.centerLeft,
                child: TranslateButton(),
              ),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Header(Title: 'login_page.title'.tr),
              CustPhoneField(
                controller: _usernameController,
                labelText: 'login_page.phone_no'.tr,
                hintText: 'login_page.phone_no_hint'.tr,
                initialCountryCode: "EG",
                validator: _validatePhone,
              ),
              CustPasswordField(
                controller: _passwordController,
                labelText: 'login_page.password'.tr,
                hintText: 'login_page.password_hint'.tr,
                validator: _validatePassword,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgetPass()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Text(
                    'btn.forget_btn'.tr,
                    style: TextStyle(
                      color: inputTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: login,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor),
                ),
                child: Text(
                  'btn.login_btn'.tr,
                  style: TextStyle(color: btntxtColors, fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
                child: Text(
                  'btn.login_page_reg_btn'.tr,
                  style: TextStyle(
                    color: inputTextColor,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    decorationColor: inputTextColor,
                    decorationThickness: 2.0,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Testing()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
                child: Text(
                  "Testing",
                  style: TextStyle(
                    color: Colors.transparent,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
