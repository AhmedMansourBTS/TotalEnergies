import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/Profile/profile_page.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('username') ?? "";
      _emailController.text = prefs.getString('email') ?? "";
      _phoneController.text = prefs.getString('phoneno') ?? "";
      _genderController.text = prefs.getString('gender') ?? "";
    });
  }

  void saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('gender', _genderController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        // iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LogoRow(),
            Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: true, // ensures back arrow
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'edit_profile.name'.tr)),
            SizedBox(
              height: 20,
            ),
            TextField(
                controller: _emailController,
                decoration:
                    InputDecoration(labelText: 'edit_profile.email'.tr)),
            SizedBox(
              height: 20,
            ),
            // TextField(
            //     controller: _phoneController,
            //     decoration:
            //         InputDecoration(labelText: 'edit_profile.phone_number'.tr)),
            // SizedBox(
            //   height: 20,
            // ),
            // TextField(
            //     controller: _genderController,
            //     decoration: InputDecoration(labelText: "Gender")),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: saveChanges,
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
                child: Text('btn.save_change'.tr)),
          ],
        ),
      ),
    );
  }
}
