import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';
import 'package:total_energies/screens/Promotions/old_promotions_page.dart';
import 'package:total_energies/screens/Profile/account_info_page.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('username') ?? "";
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs (All & Current)
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              // SizedBox(
              //   height: kToolbarHeight - 25,
              //   child: Image.asset(
              //     "assets/images/logo1.1.png",
              //     fit: BoxFit.contain,
              //   ),
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              // SizedBox(
              //   height: kToolbarHeight - 25,
              //   child: Image.asset(
              //     "assets/images/ADNOC logo1.1.png",
              //     fit: BoxFit.contain,
              //   ),
              // ),
              LogoRow(),
              const Spacer(),
              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      primaryColor, // Change this to your desired color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text("btn.logout".tr),
              ),
            ],
          ),
          bottom: TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 16),
            tabs: [
              Tab(text: 'profile_page.acc_info'.tr),
              Tab(text: 'profile_page.acc_history'.tr),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AccountInfoPage(),
            OldPromotionsPage(),
          ],
        ),
      ),
    );
  }
}
