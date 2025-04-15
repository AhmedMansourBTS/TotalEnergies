import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/Profile/edit_profile_screen.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';
import 'package:total_energies/widgets/Buttons/editImg.dart';
import 'package:total_energies/widgets/Buttons/trnslt_btn.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundImageRow(
                imageUrl: 'assets/images/logo.png',
                text: 'profile_page.acc_inf'.tr,
                icon: Icons.edit,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('profile_page.name'.tr, style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: TextStyle(fontSize: 18)),
                      Icon(Icons.person_2_outlined)
                    ],
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                height: 3,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 15),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('profile_page.phone_number'.tr,
                      style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(phoneno, style: TextStyle(fontSize: 18)),
                      Icon(Icons.phone_outlined)
                    ],
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                height: 3,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 15),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('profile_page.email'.tr, style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(email, style: TextStyle(fontSize: 18))),
                      Icon(Icons.email_outlined)
                    ],
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                height: 3,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 15),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User Serial", style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$serial", style: TextStyle(fontSize: 18)),
                      Icon(Icons.security)
                    ],
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                height: 3,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 15),
              ),
              SizedBox(height: 20),
              // Container(
              //   alignment: Alignment.centerRight,
              //   child: TranslateButton(),
              // ),
              // SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "profile_page.change_lang".tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: TranslateButton(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                height: 3,
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 15),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen()),
                  );
                },
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
                child: Text('btn.edit_profile'.tr),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
