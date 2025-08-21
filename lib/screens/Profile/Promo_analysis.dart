import 'package:flutter/material.dart';
import 'package:total_energies/core/constant/colors.dart';
import 'package:total_energies/models/curr_promo_model.dart';
import 'package:total_energies/models/exp_promo_model.dart';
import 'package:total_energies/models/promotions_model.dart';
import 'package:total_energies/screens/Profile/Latest_promo_profile.dart';
import 'package:total_energies/services/get_curr_promo_service.dart';
import 'package:total_energies/services/get_exp_promo_service.dart';
import 'package:total_energies/services/promotions_service.dart';
import 'package:total_energies/widgets/global/app_bar_logos.dart';

class PromoAnalysis extends StatefulWidget {
  const PromoAnalysis({super.key});

  @override
  _PromoAnalysisState createState() => _PromoAnalysisState();
}

class _PromoAnalysisState extends State<PromoAnalysis> {
  late Future<List<PromotionsModel>> _allPromosFuture;
  List<PromotionsModel> _allPromos = [];

  late Future<List<CurrPromoModel>> _redeemedPromosFuture;
  List<CurrPromoModel> _redeemedPromos = [];

  late Future<List<ExpiredPromoModel>> _expiredPromosFuture;
  List<ExpiredPromoModel> _expiredPromos = [];

  @override
  void initState() {
    super.initState();
    _allPromosFuture = PromotionsService().getPromotions(context);
    _redeemedPromosFuture = GetCurrPromoService().getCurrPromotions(context);
    _expiredPromosFuture = GetExpPromoService().getExpPromotions(context);
    _loadPromotions();
    _loadRedeemedPromotions();
    _loadExpiredPromotions();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LogoRow(),
            Text(
              "Promotions Analysis",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: true, // ensures back arrow
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: LatestPromoProfile(
            allPromos: _allPromos,
            redeemedPromos: _redeemedPromos,
            expiredPromos: _expiredPromos,
          ),
        ),
      ),
    );
  }
}
