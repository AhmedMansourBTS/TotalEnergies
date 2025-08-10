// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_field/phone_number.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/login_model.dart';
// import 'package:total_energies/screens/Auth/forget_pass.dart';
// import 'package:total_energies/screens/home_screen.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/screens/Auth/register_screen.dart';
// import 'package:total_energies/services/login_service.dart';
// import 'package:total_energies/widgets/auth/header.dart';
// import 'package:total_energies/widgets/auth/custPassField.dart';
// import 'package:total_energies/widgets/auth/phone.dart';
// import 'package:total_energies/widgets/Buttons/trnslt_btn.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final LoginService apiService = LoginService();

//   Future<void> requestLocationPermissionAndGetPosition() async {
//     PermissionStatus permission = await Permission.location.request();

//     if (permission == PermissionStatus.granted) {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       print("User location: ${position.latitude}, ${position.longitude}");
//     } else {
//       print("Location permission denied");
//     }
//   }

//   void login() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => LoadingScreen(),
//     );

//     LoginModel user = LoginModel(
//       userName: _usernameController.text,
//       password: _passwordController.text,
//     );

//     try {
//       var response = await apiService.loginuser(user);
//       Navigator.pop(context); // Hide loading screen

//       print("Response Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         var responseData = jsonDecode(response.body);

//         // Validate token presence
//         if (responseData['token'] == null || responseData['token'].isEmpty) {
//           throw Exception('No token received from server');
//         }

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('username', responseData['name'] ?? '');
//         await prefs.setString('phoneno', user.userName);
//         await prefs.setString('gender', responseData['gender'] ?? '');
//         await prefs.setString('email', responseData['email'] ?? '');
//         await prefs.setInt('serial', responseData['serial'] ?? 0);
//         await prefs.setString('token', responseData['token']);
//         await prefs.setString('expiresOn', responseData['expiresOn'] ?? '');

//         print('Saved token: ${prefs.getString('token')}');
//         print('Saved token expiry: ${prefs.getString('expiresOn')}');

//         await requestLocationPermissionAndGetPosition();

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       } else {
//         var responseData = jsonDecode(response.body);
//         String errorMessage = responseData['message'] ?? 'Invalid credentials.';

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.redAccent,
//             content: Text(
//               errorMessage,
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       print("Login Error: $e");
//       Navigator.pop(context); // Ensure loading screen is dismissed
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.redAccent,
//           content: Text(
//             'Login failed: ${e.toString()}',
//             style: TextStyle(fontSize: 18, color: Colors.white),
//           ),
//         ),
//       );
//     }
//   }

//   String? _validatePhone(PhoneNumber? phone) {
//     if (phone == null || phone.number.isEmpty) {
//       return 'login_page.empty_verification'.tr;
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'login_page.pass_verification'.tr;
//     } else if (value.length < 6) {
//       return 'login_page.pass_verification1'.tr;
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Row(
//           children: [
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterScreen()),
//                 );
//               },
//               child: Text(
//                 'btn.login_page_reg_btn'.tr,
//                 style: TextStyle(
//                   color: inputTextColor,
//                   fontSize: 18,
//                   decoration: TextDecoration.underline,
//                   decorationColor: inputTextColor,
//                   decorationThickness: 2.0,
//                 ),
//               ),
//             ),
//             Spacer(),
//             TranslateButton(),
//           ],
//         ),
//       ),

//       backgroundColor: backgroundColor,
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Header(Title: 'login_page.title'.tr),
//               CustPhoneField(
//                 controller: _usernameController,
//                 labelText: 'login_page.phone_no'.tr,
//                 hintText: 'login_page.phone_no_hint'.tr,
//                 initialCountryCode: "EG",
//                 validator: _validatePhone,
//               ),
//               CustPasswordField(
//                 controller: _passwordController,
//                 labelText: 'login_page.password'.tr,
//                 hintText: 'login_page.password_hint'.tr,
//                 validator: _validatePassword,
//               ),
//               Container(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ForgetPass()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     'btn.forget_btn'.tr,
//                     style: TextStyle(
//                       color: inputTextColor,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: login,
//                 style: ButtonStyle(
//                   backgroundColor: WidgetStatePropertyAll(primaryColor),
//                 ),
//                 child: Text(
//                   'btn.login_btn'.tr,
//                   style: TextStyle(color: btntxtColors, fontSize: 20),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Tamam Aug 2025
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_field/phone_number.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/login_model.dart';
// import 'package:total_energies/screens/Auth/forget_pass.dart';
// import 'package:total_energies/screens/home_screen.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/screens/Auth/register_screen.dart';
// import 'package:total_energies/services/login_service.dart';
// import 'package:total_energies/widgets/auth/header.dart';
// import 'package:total_energies/widgets/auth/custPassField.dart';
// import 'package:total_energies/widgets/auth/phone.dart';
// import 'package:total_energies/widgets/Buttons/trnslt_btn.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
//       GlobalKey<ScaffoldMessengerState>();

//   final LoginService apiService = LoginService();

//   Future<void> requestLocationPermissionAndGetPosition() async {
//     try {
//       PermissionStatus permission = await Permission.location.request();
//       if (permission == PermissionStatus.granted) {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         print("User location: ${position.latitude}, ${position.longitude}");
//       } else {
//         print("Location permission denied");
//       }
//     } catch (e) {
//       print("Location error: $e");
//     }
//   }

//   void login() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const LoadingScreen(),
//     );

//     LoginModel user = LoginModel(
//       userName: _usernameController.text,
//       password: _passwordController.text,
//     );

//     try {
//       var response = await apiService.loginuser(user).timeout(
//             const Duration(seconds: 30),
//             onTimeout: () => throw Exception('Request timed out'),
//           );

//       // Ensure loading screen is dismissed
//       if (mounted) {
//         Navigator.pop(context);
//       }

//       print("Response Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//       print("Response Headers: ${response.headers}");

//       if (response.statusCode == 200) {
//         Map<String, dynamic>? responseData;
//         try {
//           responseData = jsonDecode(response.body) as Map<String, dynamic>;
//           print("Parsed Response Data: $responseData");
//         } catch (e) {
//           print("JSON decode error: $e");
//           throw Exception('Invalid response format: Unable to parse JSON');
//         }

//         // Validate token presence
//         if (responseData['token'] == null || responseData['token'].isEmpty) {
//           throw Exception('No token received from server');
//         }

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString(
//             'username', responseData['name']?.toString() ?? '');
//         await prefs.setString('phoneno', user.userName);
//         await prefs.setString(
//             'gender', responseData['gender']?.toString() ?? '');
//         await prefs.setString('email', responseData['email']?.toString() ?? '');
//         await prefs.setInt('serial',
//             responseData['serial'] is int ? responseData['serial'] : 0);
//         await prefs.setString('token', responseData['token'].toString());
//         await prefs.setString(
//             'expiresOn', responseData['expiresOn']?.toString() ?? '');

//         print('Saved token: ${prefs.getString('token')}');
//         print('Saved token expiry: ${prefs.getString('expiresOn')}');

//         await requestLocationPermissionAndGetPosition();

//         if (mounted) {
//           Get.offAll(() => const HomeScreen());
//         }
//       } else {
//         Map<String, dynamic>? responseData;
//         String errorMessage = 'Wrong user or password';

//         try {
//           if (response.body.isNotEmpty) {
//             responseData = jsonDecode(response.body) as Map<String, dynamic>;
//             print("Parsed Error Response Data: $responseData");
//             if (responseData['message'] != null &&
//                 responseData['message'].toString().isNotEmpty) {
//               errorMessage = responseData['message'].toString();
//             }
//           }
//         } catch (e) {
//           print("JSON decode error for error response: $e");
//         }

//         // Show "Wrong user or password" for any non-200 response
//         if (mounted) {
//           SchedulerBinding.instance.addPostFrameCallback((_) {
//             _scaffoldKey.currentState?.showSnackBar(
//               SnackBar(
//                 backgroundColor: Colors.redAccent,
//                 content: Text(
//                   errorMessage,
//                   style: const TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 duration: const Duration(seconds: 3),
//               ),
//             );
//           });
//         }
//       }
//     } catch (e) {
//       print("Login Error: $e");
//       if (mounted) {
//         Navigator.pop(context); // Ensure loading screen is dismissed
//         String errorMessage = 'Wrong user or password';

//         if (e.toString().contains('SocketException') ||
//             e.toString().contains('Timeout')) {
//           errorMessage =
//               'Network error. Please check your connection and try again.';
//         } else if (e.toString().contains('Invalid response format')) {
//           errorMessage = 'Server error: Invalid response format.';
//         }

//         SchedulerBinding.instance.addPostFrameCallback((_) {
//           _scaffoldKey.currentState?.showSnackBar(
//             SnackBar(
//               backgroundColor: Colors.redAccent,
//               content: Text(
//                 errorMessage,
//                 style: const TextStyle(fontSize: 18, color: Colors.white),
//               ),
//               duration: const Duration(seconds: 3),
//             ),
//           );
//         });
//       }
//     }
//   }

//   String? _validatePhone(PhoneNumber? phone) {
//     if (phone == null || phone.number.isEmpty) {
//       return 'login_page.empty_verification'.tr;
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'login_page.pass_verification'.tr;
//     } else if (value.length < 6) {
//       return 'login_page.pass_verification1'.tr;
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Row(
//           children: [
//             TextButton(
//               onPressed: () {
//                 Get.to(() => const RegisterScreen());
//               },
//               child: Text(
//                 'btn.login_page_reg_btn'.tr,
//                 style: TextStyle(
//                   color: inputTextColor,
//                   fontSize: 18,
//                   decoration: TextDecoration.underline,
//                   decorationColor: inputTextColor,
//                   decorationThickness: 2.0,
//                 ),
//               ),
//             ),
//             const Spacer(),
//             const TranslateButton(),
//           ],
//         ),
//       ),
//       backgroundColor: backgroundColor,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Header(Title: 'login_page.title'.tr),
//               CustPhoneField(
//                 controller: _usernameController,
//                 labelText: 'login_page.phone_no'.tr,
//                 hintText: 'login_page.phone_no_hint'.tr,
//                 initialCountryCode: "EG",
//                 validator: _validatePhone,
//               ),
//               CustPasswordField(
//                 controller: _passwordController,
//                 labelText: 'login_page.password'.tr,
//                 hintText: 'login_page.password_hint'.tr,
//                 validator: _validatePassword,
//               ),
//               Container(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Get.to(() => const ForgetPass());
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     'btn.forget_btn'.tr,
//                     style: TextStyle(
//                       color: inputTextColor,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: login,
//                 style: const ButtonStyle(
//                   backgroundColor: WidgetStatePropertyAll(primaryColor),
//                 ),
//                 child: Text(
//                   'btn.login_btn'.tr,
//                   style: const TextStyle(color: btntxtColors, fontSize: 20),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  String? _errorMessage;

  Future<void> requestLocationPermissionAndGetPosition() async {
    try {
      PermissionStatus permission = await Permission.location.request();
      if (permission == PermissionStatus.granted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        print("User location: ${position.latitude}, ${position.longitude}");
      } else {
        print("Location permission denied");
      }
    } catch (e) {
      print("Location error: $e");
    }
  }

  void login() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = 'Please fill in all fields correctly.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoadingScreen(),
    );

    LoginModel user = LoginModel(
      userName: _usernameController.text,
      password: _passwordController.text,
    );

    try {
      var response = await apiService.loginuser(user).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timed out'),
          );

      if (mounted) {
        Navigator.pop(context);
      }

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Response Headers: ${response.headers}");

      if (response.statusCode == 200) {
        Map<String, dynamic>? responseData;
        try {
          responseData = jsonDecode(response.body) as Map<String, dynamic>;
          print("Parsed Response Data: $responseData");
        } catch (e) {
          print("JSON decode error: $e");
          throw Exception('Invalid response format: Unable to parse JSON');
        }

        if (responseData['token'] == null || responseData['token'].isEmpty) {
          throw Exception('No token received from server');
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'username', responseData['name']?.toString() ?? '');
        await prefs.setString('phoneno', user.userName);
        await prefs.setString(
            'gender', responseData['gender']?.toString() ?? '');
        await prefs.setString('email', responseData['email']?.toString() ?? '');
        await prefs.setInt('serial',
            responseData['serial'] is int ? responseData['serial'] : 0);
        await prefs.setString('token', responseData['token'].toString());
        await prefs.setString(
            'expiresOn', responseData['expiresOn']?.toString() ?? '');

        print('Saved token: ${prefs.getString('token')}');
        print('Saved token expiry: ${prefs.getString('expiresOn')}');

        await requestLocationPermissionAndGetPosition();

        if (mounted) {
          Get.offAll(() => const HomeScreen());
        }
      } else {
        String errorMessage;
        switch (response.statusCode) {
          case 401:
            errorMessage = 'Invalid username or password.';
            break;
          case 404:
            errorMessage = 'Server not found. Please try again later.';
            break;
          case 500:
            errorMessage = 'Internal server error. Please try again later.';
            break;
          default:
            try {
              final responseData =
                  jsonDecode(response.body) as Map<String, dynamic>;
              errorMessage = responseData['message']?.toString() ??
                  'Login failed. Please try again.';
            } catch (e) {
              errorMessage = 'Unexpected server error.';
            }
        }

        if (mounted) {
          setState(() {
            _errorMessage = errorMessage;
          });
        }
      }
    } catch (e) {
      print("Login Error: $e");
      if (mounted) {
        Navigator.pop(context);
        String errorMessage;

        if (e.toString().contains('SocketException')) {
          errorMessage = 'Network error. Please check your connection.';
        } else if (e.toString().contains('Timeout')) {
          errorMessage = 'Request timed out. Please try again.';
        } else if (e.toString().contains('Invalid response format')) {
          errorMessage = 'Server error: Invalid response format.';
        } else {
          errorMessage = 'An unexpected error occurred.';
        }

        setState(() {
          _errorMessage = errorMessage;
        });
      }
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
        title: Row(
          children: [
            TextButton(
              onPressed: () {
                Get.to(() => const RegisterScreen());
              },
              child: Text(
                'btn.login_page_reg_btn'.tr,
                style: TextStyle(
                  color: inputTextColor,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  decorationColor: inputTextColor,
                  decorationThickness: 2.0,
                ),
              ),
            ),
            const Spacer(),
            const TranslateButton(),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                    Get.to(() => const ForgetPass());
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: login,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor),
                ),
                child: Text(
                  'btn.login_btn'.tr,
                  style: const TextStyle(color: btntxtColors, fontSize: 20),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
