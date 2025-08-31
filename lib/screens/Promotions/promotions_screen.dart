import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/Profile/account_info_page.dart';
import 'package:total_energies/screens/Promotions/all_promotions_page.dart';
import 'package:total_energies/screens/Promotions/categories_page.dart';
import 'package:total_energies/screens/Promotions/current_promotions_page.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  _PromotionsScreenState createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              LogoRow(),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.person_outline_outlined,
                        color: Colors.grey, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountInfoPage()),
                      );
                    },
                  ),
                  const SizedBox(width: 4), // space between icon and text
                  Text(
                    '${name.length > 4 ? name.substring(0, 4) : name}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
          bottom: TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 16),
            tabs: [
              Tab(text: 'promotion_page.flt_all'.tr),
              Tab(
                text: "Categories",
              ),
              Tab(text: 'promotion_page.flt_curr'.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const AllPromotionsPage(),
            CategoriesPage(),
            const CurrentPromotionsPage(),
          ],
        ),
      ),
    );
  }
}
