// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/controllers/translation_controller.dart';
// import 'package:total_energies/screens/home_screen.dart';
// import 'package:total_energies/screens/Auth/loginPage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool isLoggedIn = prefs.getString('username') != null;

//   runApp(MyApp(isLoggedIn: isLoggedIn));
// }

// class MyApp extends StatelessWidget {
//   final bool isLoggedIn;
//   const MyApp({super.key, required this.isLoggedIn});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       translations: TranslationController(),
//       locale: Locale('en', 'US'), // Default language
//       fallbackLocale: Locale('en', 'US'),
//       title: 'Total Energies',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
//         useMaterial3: true,
//       ),
//       home: isLoggedIn ? HomeScreen() : LoginScreen(),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/controllers/translation_controller.dart';
import 'package:total_energies/screens/home_screen.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';
import 'package:total_energies/widgets/global/SessionManager.dart';
import 'package:total_energies/core/constant/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getString('username') != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: TranslationController(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      title: 'Total Energies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: SplashScreen(isLoggedIn: isLoggedIn),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds before navigating
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.isLoggedIn
              ? SessionManager(child: HomeScreen())
              : SessionManager(child: LoginScreen()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width *
                  0.7, // 30% of screen width
              height: MediaQuery.of(context).size.height *
                  0.35, // 15% of screen height
              fit: BoxFit.contain,
            )
            // const SizedBox(height: 20),
            // const Text(
            //   "Welcome to Total Energies",
            //   style: TextStyle(
            //       color: primaryColor,
            //       fontSize: 22,
            //       fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
