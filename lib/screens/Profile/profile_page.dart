
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/Auth/loginPage.dart';
import 'package:total_energies/screens/Profile/Promo_analysis.dart';
import 'package:total_energies/screens/Promotions/old_promotions_page.dart';
import 'package:total_energies/screens/Profile/account_info_page.dart';
import 'package:total_energies/screens/Profile/edit_profile_screen.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- added

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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
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
        Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
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
                        builder: (_) => const EditProfileScreen()),
                  );
                }),
                buildMenuItem("Promotion History", Icons.history, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const OldPromotionsPage()),
                  );
                }),
                buildMenuItem("Promotions Analysis", Icons.analytics_outlined,() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PromoAnalysis()),
                  );
                }),
                buildMenuItem("Change Language", Icons.language, () {
                  setState(() {
                    if (Get.locale?.languageCode == 'en') {
                      Get.updateLocale(const Locale('ar'));
                    } else {
                      Get.updateLocale(const Locale('en'));
                    }
                  });
                }),
                buildMenuItem("Logout", Icons.logout, logout),
              ],
            ),
          ),

          // ✅ Follow Us Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                  label: const Text("Facebook"),
                  onPressed: () {
                    _launchUrl("https://www.facebook.com/YourPageHere");
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt, color: Colors.purple),
                  label: const Text("Instagram"),
                  onPressed: () {
                    _launchUrl("https://www.instagram.com/YourPageHere");
                  },
                ),
              ],
            ),
          ),

          // ✅ Version
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Version 0.0.1",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
