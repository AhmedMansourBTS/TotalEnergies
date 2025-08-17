// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/screens/Auth/loginPage.dart';
// import 'package:total_energies/screens/Promotions/old_promotions_page.dart';
// import 'package:total_energies/screens/Profile/account_info_page.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   String name = "";

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   void loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('username') ?? "";
//     });
//   }

//   void logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Two tabs (All & Current)
//       child: Scaffold(
//         backgroundColor: backgroundColor,
//         appBar: AppBar(
//           backgroundColor: backgroundColor,
//           title: Row(
//             children: [
//               // SizedBox(
//               //   height: kToolbarHeight - 25,
//               //   child: Image.asset(
//               //     "assets/images/logo1.1.png",
//               //     fit: BoxFit.contain,
//               //   ),
//               // ),
//               // SizedBox(
//               //   width: 10,
//               // ),
//               // SizedBox(
//               //   height: kToolbarHeight - 25,
//               //   child: Image.asset(
//               //     "assets/images/ADNOC logo1.1.png",
//               //     fit: BoxFit.contain,
//               //   ),
//               // ),
//               LogoRow(),
//               const Spacer(),
//               ElevatedButton(
//                 onPressed: logout,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       primaryColor, // Change this to your desired color
//                   foregroundColor: Colors.white, // Text color
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 20, vertical: 12), // Button padding
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10), // Rounded corners
//                   ),
//                 ),
//                 child: Text("btn.logout".tr),
//               ),
//             ],
//           ),
//           bottom: TabBar(
//             labelColor: primaryColor,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: primaryColor,
//             labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             unselectedLabelStyle: TextStyle(fontSize: 16),
//             tabs: [
//               Tab(text: 'profile_page.acc_info'.tr),
//               Tab(text: 'profile_page.acc_history'.tr),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             AccountInfoPage(),
//             OldPromotionsPage(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';
import 'package:total_energies/screens/Promotions/old_promotions_page.dart';
import 'package:total_energies/screens/Profile/account_info_page.dart';
import 'package:total_energies/screens/Profile/edit_profile_screen.dart'; // <-- added
import 'package:total_energies/widgets/Buttons/trnslt_btn.dart';
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

  Widget buildMenuItem(String text, IconData icon, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.transparent,
          leading: Icon(icon, color: primaryColor),
          title: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
        Divider(color: Colors.grey.shade300, thickness: 3, height: 3),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: LogoRow(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            name.isNotEmpty ? name : "Guest",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                buildMenuItem("Account Info", Icons.person, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AccountInfoPage()),
                  );
                }),
                buildMenuItem("Edit Profile", Icons.edit, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EditProfileScreen()), // <-- added
                  );
                }),
                buildMenuItem("History", Icons.history, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const OldPromotionsPage()),
                  );
                }),
                buildMenuItem("Change Language", Icons.language, () {
                  // Example translation trigger
                  setState(() {
                    if (Get.locale?.languageCode == 'en') {
                      Get.updateLocale(Locale('ar')); // Switch to Arabic
                    } else {
                      Get.updateLocale(Locale('en')); // Switch to English
                    }
                  });
                }),
                buildMenuItem("Logout", Icons.logout, logout),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
