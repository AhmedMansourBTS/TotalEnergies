import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/Promotions/all_promotions_page.dart';
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
              Column(
                children: [
                  Text('app_bar.hi_txt'.tr,
                      style: const TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                          fontWeight: FontWeight.bold)),
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18,
                          color: primaryColor,
                          fontWeight: FontWeight.bold))
                ],
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
              Tab(text: 'promotion_page.flt_all'.tr),
              Tab(text: 'promotion_page.flt_curr'.tr),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllPromotionsPage(),
            CurrentPromotionsPage(),
          ],
        ),
      ),
    );
  }
}
