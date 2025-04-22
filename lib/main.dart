import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/controllers/translation_controller.dart';
import 'package:total_energies/screens/home_screen.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';

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
      locale: Locale('en', 'US'), // Default language
      fallbackLocale: Locale('en', 'US'),
      title: 'Total Energies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
