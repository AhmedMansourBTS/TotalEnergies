import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/core/controllers/bottom_bar_controller.dart';
import 'package:total_energies/screens/Profile/profile_page.dart';
import 'package:total_energies/screens/Promotions/promotions_screen.dart';
import 'package:total_energies/screens/Dashboard/dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final BottomBarController controller = Get.put(BottomBarController());

  final List<Widget> _pages = [
    DashboardPage(),
    PromotionsScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _pages[controller.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: secondColors,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer_outlined),
                  label: 'bottom_bar.promotions'.tr),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'bottom_bar.profile'.tr),
            ],
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: const Color(0xFFED0000),
            unselectedItemColor: Colors.grey,
            onTap: (index) => controller.changeIndex(index),
            selectedFontSize: 16,
          ),
        ));
  }
}


// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     DashboardPage(),
//     PromotionsScreen(),
//     // StationListScreen(),
//     ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: secondColors,
//         items: [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.home_outlined), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.local_offer_outlined),
//               label: 'bottom_bar.promotions'.tr),
//           // BottomNavigationBarItem(
//           //     icon: Icon(Icons.local_gas_station),
//           //     label: 'bottom_bar.stations'.tr),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.person_outline), label: 'bottom_bar.profile'.tr),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: const Color(0xFFED0000),
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//         // showUnselectedLabels: false,
//         selectedFontSize: 16,
//       ),
//     );
//   }
// }
