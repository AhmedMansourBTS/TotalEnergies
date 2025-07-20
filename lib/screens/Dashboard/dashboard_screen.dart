import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/NotificationModel.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/models/exp_promo_model.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/models/service_model.dart';
import 'package:total_energies/screens/Dashboard/NotificationsPage.dart';
import 'package:total_energies/screens/Dashboard/news_detail_page.dart';
import 'package:total_energies/screens/Stations/stations_screen.dart';
import 'package:total_energies/screens/loading_screen.dart';
import 'package:total_energies/services/NotificationService.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
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

  late Future<List<NotificationModel>> _notificationsFuture;
  int _unreadNotificationCount = 0;

  String name = "";
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _allPromosFuture = PromotionsService().getPromotions(context);
    _redeemedPromosFuture = GetCurrPromoService().getCurrPromotions(context);
    _expiredPromosFuture = GetExpPromoService().getExpPromotions(context);
    _notificationsFuture = _notificationService.fetchNotifications(context);
    _loadPromotions();
    _loadRedeemedPromotions();
    _loadExpiredPromotions();
    _loadNotifications();
    loadUserData();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('username') ?? "";
    });
  }

  void _loadPromotions() async {
    try {
      final promos = await PromotionsService().getPromotions(context);
      setState(() {
        _allPromos = promos;
      });
    } catch (e) {
      print("Error loading promotions: $e");
    }
  }

  void _loadRedeemedPromotions() async {
    try {
      final redeemed = await GetCurrPromoService().getCurrPromotions(context);
      setState(() {
        _redeemedPromos = redeemed;
      });
    } catch (e) {
      print("Error loading redeemed promotions: $e");
    }
  }

  void _loadExpiredPromotions() async {
    try {
      final expired = await GetExpPromoService().getExpPromotions(context);
      setState(() {
        _expiredPromos = expired;
      });
    } catch (e) {
      print("Error loading expired promotions: $e");
    }
  }

  void _loadNotifications() async {
    try {
      final notifications =
          await _notificationService.fetchNotifications(context);
      setState(() {
        _unreadNotificationCount = notifications.where((n) => !n.isRead).length;
      });
    } catch (e) {
      print("Error loading notifications: $e");
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
                ).then((_) {
                  // Refresh notifications when returning from NotificationsPage
                  _loadNotifications();
                });
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(
                    Icons.notifications,
                    size: 35,
                    color: primaryColor,
                  ),
                  if (_unreadNotificationCount > 0)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        _unreadNotificationCount > 9
                            ? '9+'
                            : '$_unreadNotificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildWelcomeBanner(30),
            const SizedBox(height: 20),
            _buildAdsSection(),
            const SizedBox(height: 20),
            _buildNewsSection(),
            const SizedBox(height: 20),
            _buildAvailableServices(),
            const SizedBox(height: 20),
            _buildLatestPromos(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(double height) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: height,
      child: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            'Welcome $name',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
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

  // Widget _buildNewsSection() {
  //   final List<String> newsList = [
  //     'Breaking News 1',
  //     'Event Announcement 2',
  //     'Important Update 3',
  //   ];

  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Latest News',
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 10),
  //         SizedBox(
  //           height: widget.newsHeight,
  //           child: ListView.separated(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: newsList.length,
  //             separatorBuilder: (context, index) => const SizedBox(width: 12),
  //             itemBuilder: (context, index) {
  //               return Container(
  //                 width: 250,
  //                 padding: const EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   color: Colors.lightBlue,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     newsList[index],
  //                     style: const TextStyle(fontSize: 16, color: Colors.white),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailPage(title: newsList[index]),
                      ),
                    );
                  },
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        newsList[index],
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Check internet connection',
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      GetAllServicesService.fetchAllServices();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(color: btntxtColors, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
          // return Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Text('Failed to load services: ${snapshot.error}'),
          // );
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
                        Navigator.pushReplacement(
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

  Widget _buildLatestPromos(BuildContext context) {
    final int total = _allPromos.length;
    final int expired = _expiredPromos.length;
    final int redeemed = _redeemedPromos.length;
    final int active = total - redeemed;

    final List<Map<String, dynamic>> promoStats = [
      {'title': 'Active', 'value': '$total', 'icon': Icons.local_offer},
      {'title': 'Not Applied', 'value': '$active', 'icon': Icons.check_circle},
      {'title': 'Consumed', 'value': '$expired', 'icon': Icons.cancel},
      {'title': 'Ongoing', 'value': '$redeemed', 'icon': Icons.redeem},
    ];

    // Get screen dimensions for responsive sizing
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = (screenWidth * 0.03)
        .clamp(8.0, 12.0); // 3% of screen width, min 8px, max 12px
    final double iconSize = (screenWidth * 0.06)
        .clamp(18.0, 24.0); // 6% of screen width, min 18px, max 24px
    final double fontSizeTitle = (screenWidth * 0.035)
        .clamp(12.0, 14.0); // 3.5% of screen width, min 12px, max 14px
    final double fontSizeValue = (screenWidth * 0.05)
        .clamp(14.0, 18.0); // 5% of screen width, min 14px, max 18px
    final double gridItemHeight = (screenHeight * 0.15)
        .clamp(100.0, 120.0); // 15% of screen height, min 100px, max 120px

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Promotions Analysis',
            style: TextStyle(
              fontSize: (screenWidth * 0.05).clamp(
                  16.0, 20.0), // Responsive title font size, min 16px, max 20px
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: padding),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxCrossAxisExtent = (screenWidth < 360)
                  ? 140.0
                  : 150.0; // Smaller extent for very small screens
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                      maxCrossAxisExtent, // Max 140-150px per item
                  crossAxisSpacing: padding,
                  mainAxisSpacing: padding,
                  mainAxisExtent:
                      gridItemHeight, // Dynamic height based on screen
                ),
                itemCount: promoStats.length,
                itemBuilder: (context, index) {
                  final promo = promoStats[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          8), // Smaller radius for small screens
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(padding *
                        0.8), // Slightly reduced padding inside container
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          promo['icon'],
                          color: primaryColor,
                          size: iconSize,
                        ),
                        SizedBox(height: padding * 0.5),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            promo['value'],
                            style: TextStyle(
                              fontSize: fontSizeValue,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Fallback for extreme cases
                          ),
                        ),
                        SizedBox(height: padding * 0.3),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            promo['title'],
                            style: TextStyle(
                              fontSize: fontSizeTitle,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow
                                .ellipsis, // Fallback for extreme cases
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
