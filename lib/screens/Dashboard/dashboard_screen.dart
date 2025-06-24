// import 'package:flutter/material.dart';
// import 'package:total_energies/core/constant/colors.dart';
// import 'package:total_energies/models/promotions_model.dart';
// import 'package:total_energies/models/service_model.dart';
// import 'package:total_energies/screens/Dashboard/NotificationsPage.dart';
// import 'package:total_energies/screens/Stations/stations_screen.dart';
// import 'package:total_energies/screens/loading_screen.dart';
// import 'package:total_energies/services/promotions_service.dart';
// import 'package:total_energies/services/service_service.dart';
// import 'package:total_energies/widgets/global/app_bar_logos.dart';

// class DashboardPage extends StatelessWidget {

//   final double adsHeight;
//   final double newsHeight;

//   const DashboardPage({
//     super.key,
//     this.adsHeight = 150,
//     this.newsHeight = 120,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         title: Row(
//           children: [
//             LogoRow(),
//             const Spacer(),
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const NotificationsPage()),
//                 );
//               },
//               child: Icon(
//                 Icons.notifications,
//                 size: 28,
//                 color: primaryColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             const SizedBox(height: 20),
//             // Part 1 - Ads
//             _buildAdsSection(),

//             const SizedBox(height: 20),

//             // Part 2 - News
//             _buildNewsSection(),

//             const SizedBox(height: 20),

//             // Part 3 - Available Services
//             _buildAvailableServices(),

//             const SizedBox(height: 20),

//             // Part 4 - Latest Promotions
//             _buildLatestPromos(),
//           ],
//         ),
//       ),
//     );
//   }

//   // PART 1: Ads Section
//   Widget _buildAdsSection() {
//     final List<String> ads = [
//       'assets/images/logo.png',
//       'assets/images/logo.png',
//       'assets/images/logo.png',
//       'assets/images/logo.png',
//     ];

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: SizedBox(
//         height: adsHeight,
//         child: ListView.separated(
//           scrollDirection: Axis.horizontal,
//           itemCount: ads.length,
//           separatorBuilder: (context, index) => const SizedBox(width: 12),
//           itemBuilder: (context, index) {
//             return ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: primaryColor, // Change to your desired border color
//                     width: 1.0, // Change to your desired border width
//                   ),
//                   borderRadius: BorderRadius.circular(
//                       10), // Match the ClipRRect border radius
//                 ),
//                 child: Image.asset(
//                   ads[index],
//                   width: 250,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // PART 2: News Section
//   Widget _buildNewsSection() {
//     final List<String> newsList = [
//       'Breaking News 1',
//       'Event Announcement 2',
//       'Important Update 3',
//     ];

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Latest News',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           SizedBox(
//             height: newsHeight,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: newsList.length,
//               separatorBuilder: (context, index) => const SizedBox(width: 12),
//               itemBuilder: (context, index) {
//                 return Container(
//                   width: 250,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.lightBlue,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Center(
//                     child: Text(
//                       newsList[index],
//                       style: const TextStyle(fontSize: 16, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Part 3
//   Widget _buildAvailableServices() {
//     return FutureBuilder<List<ServiceModel>>(
//       future: GetAllServicesService.fetchAllServices(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             height: 160,
//             padding: const EdgeInsets.all(16),
//             alignment: Alignment.center,
//             child: const LoadingScreen(), // your loading widget
//           );
//         } else if (snapshot.hasError) {
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text('Failed to load services: ${snapshot.error}'),
//           );
//         }

//         final services = snapshot.data!.where((s) => s.activeYN).toList();

//         if (services.isEmpty) {
//           return const Padding(
//             padding: EdgeInsets.all(16),
//             child: Text('No active services available.'),
//           );
//         }

//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Available Services',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 120,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: services.length,
//                   separatorBuilder: (context, index) =>
//                       const SizedBox(width: 20),
//                   itemBuilder: (context, index) {
//                     final service = services[index];
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => StationListScreen(service: service),
//                           ),
//                         );
//                       },
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 30,
//                             backgroundColor: primaryColor,
//                             child: const Icon(
//                               Icons.miscellaneous_services,
//                               color: Colors.white,
//                               size: 30,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             service.serviceLatDescription,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildLatestPromos() {

//     final List<Map<String, dynamic>> promoStats = [
//       {'title': 'Total Promos', 'value': '36', 'icon': Icons.local_offer},
//       {'title': 'Active', 'value': '14', 'icon': Icons.check_circle},
//       {'title': 'Expired', 'value': '18', 'icon': Icons.cancel},
//       {'title': 'Redeemed', 'value': '4', 'icon': Icons.redeem},
//     ];

//     return Container(
//       padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Promotions Analysis',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 1.4,
//             children: promoStats.map((promo) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       blurRadius: 6,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       promo['icon'],
//                       color: primaryColor,
//                       size: 28,
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       promo['value'],
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       promo['title'],
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.black54,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/models/exp_promo_model.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/models/service_model.dart';
import 'package:total_energies/screens/Dashboard/NotificationsPage.dart';
import 'package:total_energies/screens/Stations/stations_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/curr_promo_service.dart';
import 'package:total_energies/services/get_exp_promo_service.dart';
import 'package:total_energies/services/promotions_service.dart';
import 'package:total_energies/services/service_service.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class DashboardPage extends StatefulWidget {
  final double adsHeight;
  final double newsHeight;

  const DashboardPage({
    super.key,
    this.adsHeight = 150,
    this.newsHeight = 120,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<PromotionsModel>> _allPromosFuture;
  List<PromotionsModel> _allPromos = [];

  late Future<List<CurrPromoModel>> _redeemedPromosFuture;
  List<CurrPromoModel> _redeemedPromos = [];

  late Future<List<ExpiredPromoModel>> _expiredPromosFuture;
  List<ExpiredPromoModel> _expiredPromos = [];

  @override
  void initState() {
    super.initState();
    _allPromosFuture = PromotionsService().getPromotions();
    _redeemedPromosFuture = GetCurrPromoService().getCurrPromotion();
    _expiredPromosFuture = GetExpPromoService().getExpPromotions();
    _loadPromotions();
    _loadRedeemedPromotions();
    _loadExpiredPromotions();
  }

  void _loadPromotions() async {
    try {
      final promos = await PromotionsService().getPromotions();
      setState(() {
        _allPromos = promos;
      });
    } catch (e) {
      print("Error loading promotions: $e");
    }
  }

  void _loadRedeemedPromotions() async {
    try {
      final redeemed = await GetCurrPromoService().getCurrPromotion();
      setState(() {
        _redeemedPromos = redeemed;
      });
    } catch (e) {
      print("Error loading redeemed promotions: $e");
    }
  }

  void _loadExpiredPromotions() async {
    try {
      final expired = await GetExpPromoService().getExpPromotions();
      setState(() {
        _expiredPromos = expired;
      });
    } catch (e) {
      print("Error loading redeemed promotions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            LogoRow(),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
              child: Icon(
                Icons.notifications,
                size: 28,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAdsSection(),
            const SizedBox(height: 20),
            _buildNewsSection(),
            const SizedBox(height: 20),
            _buildAvailableServices(),
            const SizedBox(height: 20),
            _buildLatestPromos(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdsSection() {
    final List<String> ads = [
      'assets/images/logo.png',
      'assets/images/logo.png',
      'assets/images/logo.png',
      'assets/images/logo.png',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: widget.adsHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: ads.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  ads[index],
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewsSection() {
    final List<String> newsList = [
      'Breaking News 1',
      'Event Announcement 2',
      'Important Update 3',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest News',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: widget.newsHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: newsList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  width: 250,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      newsList[index],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableServices() {
    return FutureBuilder<List<ServiceModel>>(
      future: GetAllServicesService.fetchAllServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 160,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: const LoadingScreen(),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Failed to load services: ${snapshot.error}'),
          );
        }

        final services = snapshot.data!.where((s) => s.activeYN).toList();

        if (services.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No active services available.'),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StationListScreen(service: service),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: primaryColor,
                            child: const Icon(
                              Icons.miscellaneous_services,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.serviceLatDescription,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLatestPromos() {
    final int total = _allPromos.length;
    final int expired = _expiredPromos.length;
    final int redeemed = _redeemedPromos.length;
    final int active = total - redeemed;

    final List<Map<String, dynamic>> promoStats = [
      {'title': 'Total Promos', 'value': '$total', 'icon': Icons.local_offer},
      {'title': 'Active', 'value': '$active', 'icon': Icons.check_circle},
      {'title': 'Expired', 'value': '$expired', 'icon': Icons.cancel},
      {'title': 'Redeemed', 'value': '$redeemed', 'icon': Icons.redeem},
    ];

    return Container(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promotions Analysis',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: promoStats.map((promo) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      promo['icon'],
                      color: primaryColor,
                      size: 28,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      promo['value'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      promo['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
