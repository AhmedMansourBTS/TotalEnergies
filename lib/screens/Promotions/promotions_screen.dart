import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/screens/Profile/account_info_page.dart';
import 'package:total_energies/screens/Promotions/all_promo_page.dart';
import 'package:total_energies/screens/Promotions/all_promotions_page.dart';
import 'package:total_energies/screens/Promotions/available_promo_page.dart';
import 'package:total_energies/screens/Promotions/categories_page.dart';
import 'package:total_energies/screens/Promotions/consumed_promo_page.dart';
import 'package:total_energies/screens/Promotions/current_promotions_page.dart';
import 'package:total_energies/screens/Promotions/old_promotions_page.dart';
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
      length: 5,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Row(
            children: [
              LogoRow(),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountInfoPage()),
                    );
                  },
                  child: Container(
                    width: 40, // same as 2 * radius
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white, // background white
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor, // border color
                        width: 1, // border thickness
                      ),
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty
                            ? name.substring(0, 2).toUpperCase()
                            : "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ))

              // Row(
              //   children: [
              //     IconButton(
              //       icon: Icon(Icons.person_outline_outlined,
              //           color: Colors.grey, size: 28),
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => AccountInfoPage()),
              //         );
              //       },
              //     ),
              //     const SizedBox(width: 4), // space between icon and text
              //     Text(
              //       '${name.length > 4 ? name.substring(0, 4) : name}',
              //       style: const TextStyle(
              //         fontSize: 18,
              //         color: primaryColor,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
          bottom: TabBar(
            isScrollable: true, // 👈 this makes it scrollable
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            labelStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            tabs: [
              Tab(text: 'promotion_page.flt_all'.tr),
              Tab(text: 'promotion_page.flt_curr'.tr),
              Tab(text: "Available"),
              Tab(text: "Categories"),
              Tab(text: "Consumed"), // 👈 you can add more now
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // const AllPromotionsPage(),
            AllPromoPage(),
            const CurrentPromotionsPage(),
            AvailablePromotionsPage(),
            CategoriesPage(),
            ConsumedPromotionsPage(),
          ],
        ),
      ),
    );
  }
}
