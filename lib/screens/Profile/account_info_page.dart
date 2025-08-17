import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/Profile/edit_profile_screen.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';
import 'package:total_energies/widgets/Buttons/editImg.dart';
import 'package:total_energies/widgets/Buttons/trnslt_btn.dart';
import 'package:total_energies/widgets/profile/acc_info.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  String name = "";
  String phoneno = "";
  String gender = "";
  String email = "";
  int serial = 0;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('username') ?? "";
      phoneno = prefs.getString('phoneno') ?? "";
      gender = prefs.getString('gender') ?? "";
      email = prefs.getString('email') ?? "";
      serial = prefs.getInt('serial') ?? 0;
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LogoRow(),
            Text(
              "Account info",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: true, // ensures back arrow
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfoTile(
                labelText: 'profile_page.name'.tr,
                valueText: name,
                icon: Icons.person_2_outlined,
              ),
              ProfileInfoTile(
                labelText: 'profile_page.phone_number'.tr,
                valueText: phoneno,
                icon: Icons.phone_outlined,
              ),
              ProfileInfoTile(
                labelText: 'profile_page.email'.tr,
                valueText: email,
                icon: Icons.email_outlined,
              ),
              ProfileInfoTile(
                labelText: "User Serial",
                valueText: "$serial",
                icon: Icons.security,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
