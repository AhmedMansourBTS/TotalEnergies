import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/NotificationModel.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/models/exp_promo_model.dart';
import 'package:total_energies/screens/Dashboard/ads_section.dart';
import 'package:total_energies/screens/Dashboard/available_services_section.dart';
import 'package:total_energies/screens/Dashboard/latest_promo_section.dart';
import 'package:total_energies/screens/Dashboard/news_section.dart';
import 'package:total_energies/screens/Dashboard/welcome_banner.dart';
import 'package:total_energies/models/news_model.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Dashboard/NotificationsPage.dart';
import 'package:total_energies/services/NotificationService.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
import 'package:total_energies/services/get_exp_promo_service.dart';
import 'package:total_energies/services/get_news_service.dart';
import 'package:total_energies/services/promotions_service.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class DashboardPage extends StatefulWidget {
  final double adsHeight;
  final double newsHeight;

  const DashboardPage({
    super.key,
    this.adsHeight = 180,
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

  late Future<List<NewsModel>> _newsFuture;

  String name = "";
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _allPromosFuture = PromotionsService().getPromotions(context);
    _redeemedPromosFuture = GetCurrPromoService().getCurrPromotions(context);
    _expiredPromosFuture = GetExpPromoService().getExpPromotions(context);
    _notificationsFuture = _notificationService.fetchNotifications(context);
    _newsFuture = GetNewsService.fetchNews();
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
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        title: Row(
          children: [
            LogoRow(),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsPage(),
                  ),
                ).then((_) {
                  _loadNotifications();
                });
              },
              child: SizedBox(
                height: kToolbarHeight,
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topRight,
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        size: 30,
                        color: primaryColor,
                      ),
                      if (_unreadNotificationCount > 0)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: primaryColor,
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
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          // Reload all data on pull-to-refresh
          setState(() {
            _allPromosFuture = PromotionsService().getPromotions(context);
            _redeemedPromosFuture =
                GetCurrPromoService().getCurrPromotions(context);
            _expiredPromosFuture =
                GetExpPromoService().getExpPromotions(context);
            _notificationsFuture =
                _notificationService.fetchNotifications(context);
            _newsFuture = GetNewsService.fetchNews();
          });

          // Execute the actual async reload for lists
          await Future.wait([
            _allPromosFuture.then((value) => _allPromos = value),
            _redeemedPromosFuture.then((value) => _redeemedPromos = value),
            _expiredPromosFuture.then((value) => _expiredPromos = value),
            _notificationsFuture.then((notifications) {
              _unreadNotificationCount =
                  notifications.where((n) => !n.isRead).length;
            }),
            _newsFuture,
          ]);
        },
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Required for RefreshIndicator
          child: Column(
            children: [
              const SizedBox(height: 20),
              WelcomeBanner(name: name, height: 30),
              const SizedBox(height: 20),
              AdsSection(adsHeight: widget.adsHeight),
              const SizedBox(height: 20),
              const AvailableServices(),
              const SizedBox(height: 20),
              NewsSection(
                  newsFuture: _newsFuture, newsHeight: widget.newsHeight),
              const SizedBox(height: 20),
              LatestPromos(
                allPromos: _allPromos,
                redeemedPromos: _redeemedPromos,
                expiredPromos: _expiredPromos,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
